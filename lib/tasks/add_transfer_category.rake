task :add_transfer_category => :environment do
  User.each do |user|
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
  puts 'end'
end