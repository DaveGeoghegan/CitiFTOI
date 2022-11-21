class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)
    Round.all.each do |round|
      @team.rounds << round
    end
    respond_to do |format|
      if @team.save

        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def is_slider?(d)
    if d.identifier == "input_item_9" then
      return true
    end
    if d.identifier == "input_item_10" then
      return true
    end
    if d.identifier == "input_item_11" then
      return true
    end
    if d.identifier == "input_item_12" then
      return true
    end
    if d.identifier == "input_item_13" then
      return true
    end
    if d.identifier == "input_item_14" then
      return true
    end
    return false
  end

  def get_slider_value(cur)
    if cur.value == "0" then
      return "Very Conservative"
    end
    if cur.value == "1" then
      return "Conservative"
    end
    if cur.value == "2" then
      return "Neutral"
    end
    if cur.value == "3" then
      return "Liberal"
    end
    if cur.value == "4" then
      puts "Returning VL"
      return "Very Liberal"
    end
  end

  def get_decision_export_value(d)
    if is_slider?(d.input_item)
      return get_slider_value(d)
    else
      return d.value.gsub(/%/,'').strip
    end
  end

  def export_old
    team_round = TeamRound.find_by_id(params[:team_round_id])
    team = team_round.team
    output_string = ","
    csv_string = CsvShaper::Shaper.encode do |csv|
      csv.headers :team_name, :round_name, :input_name, :value
      team_round.decisions.order(:id).each do |d|
        csv.row do |row|
          row.cell :team_name, team.name
          row.cell :round_name, team_round.round.name
          row.cell :input_name, d.input_item.name
          row.cell :value, get_decision_export_value(d)
        end
      end
    end
    filename = team.name + "_" + transliterate(team_round.round.name) + "_report"
    send_data csv_string, :type => Mime::CSV,
              :disposition => "attachment; filename=#{filename}.csv"
  end

  def export
    team_round = TeamRound.find_by_id(params[:team_round_id])
    team = team_round.team
    csv_string = ""
    team_round.decisions.order(:input_item_id).each do |d|
      csv_string = csv_string + ","  + get_decision_export_value(d)
    end
    filename = team.name + "_" + transliterate(team_round.round.name) + "_report"
    send_data csv_string, :type => Mime::CSV,
              :disposition => "attachment; filename=#{filename}.dat"
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(:name, :password, :team_rounds_attributes => [:is_finished, :id, :report , :debrief])
  end

  def transliterate(str)
    # Based on permalink_fu by Rick Olsen
    s = str

    # Downcase string
    s.downcase!

    # Remove apostrophes so isn't changes to isnt
    s.gsub!(/'/, '')

    # Replace any non-letter or non-number character with a space
    s.gsub!(/[^A-Za-z0-9]+/, ' ')

    # Remove spaces from beginning and end of string
    s.strip!

    # Replace groups of spaces with single hyphen
    s.gsub!(/\ +/, '_')

    return s
  end
end
