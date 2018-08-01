json.array! @frequents do |frequent|
  json.(frequent, :id, :name)
  json.icon_path frequent.icon_url
end