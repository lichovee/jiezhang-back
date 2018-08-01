json.(asset_log, :id, :type, :description)
json.money money_format(asset_log.amount)
json.date asset_log.created_at.strftime("%Y-%m-%d")
json.source asset_log.source.name
json.target asset_log.target.name
json.time asset_log.created_at.strftime("%H:%M")
json.month_day asset_log.created_at.strftime("%m-%d")
json.timeStr asset_log.created_at.strftime("%m-%d %H:%M")
json.week weekday(asset_log.created_at.wday)