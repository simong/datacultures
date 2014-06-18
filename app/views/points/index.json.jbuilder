json.array!(@points) do |point|
  json.extract! point, :id, :uid, :reason, :delta, :created_at, :updated_at
end
