json.single do
  json.surplus do
    json.income @income
    json.expend @expend
    json.surplus @income - @expend
  end

  json.list do
    json.array! @singles do |statement|
      json.(statement, :id, :description, :type, :day)
      json.category statement.category.name
      json.amount money_format(statement.amount)
      json.time statement.date.strftime("%H:%M")
      json.created_at statement.created_at.strftime("%Y-%m-%d %H:%M")
      json.wallet statement.asset.name
      json.category_icon statement.category.icon_url
      json.detail_day weekday(statement.created_at.wday)
    end
  end
end

json.categories do
  json.array! @categories do |c|
    json.(c, :id, :name)
    json.hidden c.hidden.to_i == 1
  end
end