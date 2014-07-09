json.array!(@activities) do |activity|
  json.extract! activity, :id, :uid, :reason, :delta, :created_at, :updated_at
end
