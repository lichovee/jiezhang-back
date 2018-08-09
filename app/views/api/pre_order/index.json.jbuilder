json.array! @pre_orders do |pre_order|
  json.(pre_order, :id, :name, :amount, :remark)
  json.created_at pre_order.created_at.strftime("%Y-%m-%d %H:%M")
  json.amount pre_order.amount.to_i.zero? ? '' : money_format(pre_order.amount)
end