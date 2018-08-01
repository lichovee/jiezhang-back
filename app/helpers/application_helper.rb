module ApplicationHelper
	include ActionView::Helpers::NumberHelper
	# 货币格式化
	# 1000 -> 1000.00
	# 13000 -> 13,000.00
	def money_format(amount)
		number_to_currency(amount, unit: '')
	end

	def weekday(idx)
    case idx.to_i
    when 0 then '周日'
    when 1 then '周一'
    when 2 then '周二'
    when 3 then '周三'
    when 4 then '周四'
    when 5 then '周五'
    when 6 then '周六'
    end
  end
end
