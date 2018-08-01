json.(statement, :id, :type, :description)
json.money money_format(statement.amount)
json.date statement.date.strftime("%Y-%m-%d")
json.category statement.category.name
json.icon_path statement.category.icon_url
json.asset statement.asset.name
json.time statement.hour_s
json.location statement.location
json.province statement.province
json.city statement.city
json.street statement.street
json.month_day statement.date.strftime("%m-%d")
json.timeStr statement.date.strftime("%m-%d %H:%M")
json.week weekday(statement.date.wday)