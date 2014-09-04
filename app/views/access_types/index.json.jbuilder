json.array!(@access_types) do |access_type|
  json.extract! access_type, :id, :name, :description
  json.url access_type_url(access_type, format: :json)
end
