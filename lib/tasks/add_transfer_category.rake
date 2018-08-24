task :add_transfer_category => :environment do
  User.all.each do |user|
    category = user.categories.find_by_name('转账')
    if category.blank?
      user.categories.create(
        name: '转账',
        icon_path: '/transfer-icon.png',
        type: 'transfer',
        lock: 1
      )
    end
  end

  AssetLog.all.each do |asset_log|
    user = asset_log.user
    category = user.categories.find_by_name('转账')
    user.statements.create!(
      title: "#{asset_log.source.name} -> #{asset_log.target.name}",
      type: 'transfer',
      category_id: category.id,
      asset_id: asset_log.from,
      target_asset_id: asset_log.to,
      amount: asset_log.amount,
      residue: asset_log.residue,
      description: asset_log.description,
      year: asset_log.created_at.year,
      month: asset_log.created_at.month,
      day: asset_log.created_at.day,
      created_at: asset_log.created_at,
      updated_at: asset_log.updated_at
    )
  end
  puts 'end'
end