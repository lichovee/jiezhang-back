json.header do
	json.total_asset money_format(@current_user.total_asset)
	json.net_worth money_format(@current_user.net_worth)
	json.total_liability money_format(@current_user.total_liability)
	json.yesterday_balance money_format(@current_user.yesterday_balance)
	json.sevent_day_consumption money_format(@current_user.last_sevent_day_consumption)
	json.last_month_consumption money_format(@current_user.last_month_consumption)
end
json.list do 
	json.array! @assets.parent_list do |asset|
		json.name asset.name
		json.amount money_format(@assets.where('parent_id = ?', asset.id).sum(:amount))
		json.childs do
			json.array! @assets.where('parent_id = ?', asset.id) do |child_asset|
				json.id child_asset.id
				json.name child_asset.name
				json.amount money_format(child_asset.amount)
				json.icon_path child_asset.icon_url
			end
		end
	end
end