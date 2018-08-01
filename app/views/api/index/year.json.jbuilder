json.header @surplus
json.list do
  json.array! @statements do |st|
    json.header do
      json.index st[:header][:index]
      json.income money_format(st[:header][:income])
      json.expend money_format(st[:header][:expend])
    end
    json.statements st[:statements] do |st|
      json.partial! 'statement', statement: st
    end
  end
end