user = User.find_or_create_by(email: 'admin@gmail.com') do |u|
  u.username = 'admin'
  u.password = '111111'
  u.password_confirmation = '111111'
  u.role = 1
end

tags = []
30.times{
  label = Faker::Lorem.word
  tag = Tag.find_or_create_by(label: label)
  tags << tag.id
}

10.times{
  email_check = Faker::Internet.email
  if User.find_by(email: email_check).nil?
    u = FactoryBot.create(:user, email: email_check)
    tasks = rand 0..10

    tasks.times{
      task = FactoryBot.create(:task, user_id: u.id)
      task.create_sort_list(sort: 0)

      tag_count = rand 0..4
      if tag_count >= 1
        tag_count.times{
          task.task_tags.find_or_create_by(task_id: task.id, tag_id: tags.sample)
        }
      end
    }
  end
}