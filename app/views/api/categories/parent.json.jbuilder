json.array! @categories.parent_list do |ct|
  json.(ct, :id, :name, :order, :icon_path, :parent_id, :type)
end