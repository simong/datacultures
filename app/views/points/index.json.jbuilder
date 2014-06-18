json.array!(@points) do |point|
  json.extract! point, :id
  json.url point_url(point, format: :json)
end
