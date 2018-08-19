json.status 200
json.data do
  json.partial! 'api/index/statement', statement: @statement
end