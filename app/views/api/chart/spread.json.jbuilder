json.array! @statements do |statement|
  json.partial! 'api/index/statement', statement: statement
end