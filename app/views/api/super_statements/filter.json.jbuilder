json.filter do
  json.time do
    json.years @years
    json.months @months
  end

  json.categories do
    json.array! @categories do |category|
      json.(category, :id, :name)
    end
  end

  json.assets do
    json.array! @assets do |asset|
      json.(asset, :id, :name)
    end
  end
end