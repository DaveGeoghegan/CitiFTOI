json.array!(@simulations) do |simulation|
  json.extract! simulation, :id, :name, :number_of_rounds
  json.url simulation_url(simulation, format: :json)
end
