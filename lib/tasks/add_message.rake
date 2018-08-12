task :add_message => :environment do
  content = File.read(File.join('log/test.md'))
  title = '8月账单'
  count = User.count
  User.all.each_with_index do |user, index|
    puts "#{index}/#{count}"
    user.messages.create(
      title: title,
      target_id: user.id,
      target_type: 0,
      content: content,
      content_type: 'md',
      page_url: '/pages/message/message_detail'
    )
  end
  puts 'end'
end