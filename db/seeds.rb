user = User.find_or_create_by(email: 'admin@gmail.com') do |u|
  u.username = 'admin'
  u.password = '111111'
  u.password_confirmation = '111111'
  u.role = 1
end

10.times{
  u = FactoryBot.create(:user, password_confirmation: '111111')
  task = rand 0..10
  task.times{
    FactoryBot.create(:task, user_id: u.id)
  }
}