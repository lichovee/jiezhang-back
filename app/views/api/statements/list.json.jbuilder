json.frequent do
  json.array! @frequents do |frequent|
    json.(frequent, :id, :name)
    json.icon_path frequent.icon_url
  end
end

json.categories do
  json.array! @list do |asset|
    json.(asset, :id, :name)
    json.icon_path asset.icon_url
    json.childs do 
      json.array! asset.children do |child|
        json.(child, :id, :name)
        json.icon_path child.icon_url
      end
    end
  end
end