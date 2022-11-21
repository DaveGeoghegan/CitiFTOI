class InputScreensController < ApplicationController
  before_action :set_input_screen, only: [:show, :edit, :update, :destroy]

  def show_input_screen
    @input_screen = InputScreen.find_by_id(params[:input_screen_id])
    @teamRound = TeamRound.find(params[:round_id])
    @round = @teamRound.round
    @next_input_screen = @round.get_next_input_screen(@input_screen)
    @previous_input_screen = @round.get_prev_input_screen(@input_screen)
    screen_name = 'input_screens/screen_' + @input_screen.identifier.squish.downcase.tr(" ","_")
    render  screen_name
  end

  def update_input_screen_info
    puts "Here I am"
    puts params
    render :json => true
  end
  # GET /input_screens
  # GET /input_screens.json
  def index
    @input_screens = InputScreen.all
  end

  # GET /input_screens/1
  # GET /input_screens/1.json
  def show
  end

  # GET /input_screens/new
  def new
    @input_screen = InputScreen.new
  end

  # GET /input_screens/1/edit
  def edit
  end

  # POST /input_screens
  # POST /input_screens.json
  def create
    @input_screen = InputScreen.new(input_screen_params)

    respond_to do |format|
      if @input_screen.save
        format.html { redirect_to @input_screen, notice: 'Input screen was successfully created.' }
        format.json { render :show, status: :created, location: @input_screen }
      else
        format.html { render :new }
        format.json { render json: @input_screen.errors, status: :unprocessable_entity }
      end
    end
  end

  def submit_decision
    puts " Update Decision"
    ap params
    team_round = current_team_round
    input_screen = Round.find(params[:input_screen_id])
    params[:fields].each do |f|
      obj= f[1]
      input_item = InputItem.where(:identifier => obj[:input_item_id]).first
      cur = Decision.where(team_round_id: team_round.id , input_item_id: input_item.id ).first_or_initialize
      theValue = obj[:value]
      if theValue.end_with? "%" then
        theValue = theValue[0..theValue.length-2]
      end
      cur.value = theValue
      cur.save!

      puts "next.."
      ap f[1]
    end

    render :json  => :true
  end

  # PATCH/PUT /input_screens/1
  # PATCH/PUT /input_screens/1.json
  def update
    respond_to do |format|
      if @input_screen.update(input_screen_params)
        format.html { redirect_to @input_screen, notice: 'Input screen was successfully updated.' }
        format.json { render :show, status: :ok, location: @input_screen }
      else
        format.html { render :edit }
        format.json { render json: @input_screen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /input_screens/1
  # DELETE /input_screens/1.json
  def destroy
    @input_screen.destroy
    respond_to do |format|
      format.html { redirect_to input_screens_url, notice: 'Input screen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_input_screen
      @input_screen = InputScreen.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def input_screen_params
      params.require(:input_screen).permit(:name, :navigation_label, :identifier)
    end
end
