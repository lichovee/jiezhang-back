json.array! @assets.parent_list do |ct|
  json.partial! 'asset', asset: ct
  json.childs do
    json.array! @assets.where('parent_id = ?', ct.id) do |child_ct|
      json.partial! 'asset', asset: child_ct
    end
  end
end