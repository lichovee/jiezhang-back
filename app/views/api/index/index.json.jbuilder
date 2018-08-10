json.array! @statements do |st|
	if st.is_a?(Statement)
		json.partial! 'statement', statement: st
	else
		json.partial! 'asset_log', asset_log: st
	end
end