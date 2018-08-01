json.array! @categories.parent_list do |ct|
  json.partial! 'category', category: ct
  json.childs do
    json.array! @categories.where('parent_id = ?', ct.id) do |child_ct|
      json.partial! 'category', category: child_ct
    end
  end
end