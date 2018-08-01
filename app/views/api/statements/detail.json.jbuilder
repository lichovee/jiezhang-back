json.(@statement, :id, :type, :location, :description)
json.amount money_format(@statement.amount)
json.title_category @statement.category.name
json.category_icon @statement.category.icon_url
json.category "#{@statement.category.parent.name} / #{@statement.category.name}"
json.asset "#{@statement.asset.parent.name} / #{@statement.asset.name}"
json.residue money_format(@statement.residue)
json.time @statement.created_at.strftime("%Y/%m/%d %H:%M:%S")
