module InputScreensHelper

	include ApplicationHelper

	def get_value_for_input_item(id, add_percent=true)
		team_round = current_team_round
		puts "Getting a Value"
		puts team_round.id

		input_item = InputItem.find_by_identifier(id)
		ap input_item.id
		cur = Decision.where(:team_round => team_round).where(:input_item_id => input_item.id).first
		ap cur
		theValue = nil
		if cur.nil?
			puts "Cur is nil"
			prev_round = previous_team_round
			ap prev_round
			if prev_round.nil?
				puts "Prev Round is Nil"
				theValue = input_item.default_value.to_s
			else
				puts prev_round.id
				prev_value = Decision.where(:team_round => prev_round).where(:input_item_id => input_item.id).first
				puts prev_value.id
				if prev_value.nil? then
					theValue = input_item.default_value.to_s
				else
					theValue = prev_value.value
				end

			end
		else
			theValue = cur.value
		end
		if add_percent then
			theValue = theValue + "%"
		end
		return theValue
	end

	def get_starting_value_for_input_item(id, add_percent=true)
		team_round = current_team_round
		puts "Getting a Value"
		puts team_round.id

		input_item = InputItem.find_by_identifier(id)
		ap input_item.id
		cur = Decision.where(:team_round => previous_team_round).where(:input_item_id => input_item.id).first
		ap cur
		theValue = nil
		if cur.nil?
			theValue = input_item.default_value
		else
			theValue = cur.value
		end
		return theValue.to_s
	end


	def get_label_for_slider_input_item(id)
		team_round = current_team_round
		input_item = InputItem.find_by_identifier(id)
		cur = Decision.where(:team_round => team_round).where(:input_item_id => input_item.id).first
		if cur.nil?
			return ''
		else
			puts "Cur is "
			ap cur
			puts cur.value
			puts "___"
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
		return 'Hi'
	end


end
