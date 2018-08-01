json.(@statement, :id, :category_id, :asset_id, :description, :type)
json.category_name @statement.category.try(:name)
json.asset_name @statement.asset.try(:name)
json.date @statement.date.strftime("%Y-%m-%d")
json.time @statement.hour_s
json.amount money_format(@statement.amount)
