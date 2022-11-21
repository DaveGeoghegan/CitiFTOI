json.array!(@input_screens) do |input_screen|
  json.extract! input_screen, :id, :name, :navigation_label
  json.url input_screen_url(input_screen, format: :json)
end
