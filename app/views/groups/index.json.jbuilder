json.array!(@groups) do |group|
  json.extract! group, :id
  json.url group_url(group, format: :json)
end
