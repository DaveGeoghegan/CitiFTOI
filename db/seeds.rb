# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
sim = Simulation.create({name: 'CitiBank Bank Sim'})
defaults = [
    7.9,15,20.5,6.6,10,15.5,9.5,15,2,2,2,2,2,2,3.9
]
team = Team.create({
                       name: 'psi',
                       password: 'psi'
                   })

is1 = InputScreen.create({
                             name: 'Capital Allocation',
                             navigation_label: 'Capital Allocation',
                             identifier: 'capital_allocation'
                         })
for j in 1..8 do
  input_item = InputItem.create({
                                    name: 'Value ' + j.to_s,
                                    identifier: "input_item_" + j.to_s,
                                    default_value: defaults[j-1]
                                })
  is1.input_items << input_item
end
is2 = InputScreen.create({
                             name: 'Credit Quality Standards',
                             navigation_label: 'Credit Quality Standards',
                             identifier: 'credit_quality_standards'
                         })
for j in 9..14 do
  input_item = InputItem.create({
                                    name: 'Value ' + j.to_s,
                                    identifier: "input_item_" + j.to_s,
                                    default_value: defaults[j-1]
                                })
  is2.input_items << input_item
end

  is3 = InputScreen.create({
                               name: 'Dividend Payout Ratio',
                               navigation_label: 'Dividend Payout Ratio',
                               identifier: 'dividend_payout_ratio'
                           })
  input_item = InputItem.create({
                                    name: 'Value 15',
                                    identifier: "input_item_15",
                                    default_value: defaults[j-1]
                                })
  is3.input_items << input_item
  for i in 1..4 do
    round = Round.create({
                             name: 'Round ' + i.to_s,
                             round_number: i,
                             simulation: sim,
                         })
    team.rounds << round
    round.input_screens << is1
    round.input_screens << is2
    round.input_screens << is3
  end
