user = User.find_or_create_by(email: 'admin@gmail.com') do |u|
  u.username = 'admin'
  u.password = '111111'
  u.password_confirmation = '111111'
  u.role = 1
end

10.times{
  email_check = Faker::Internet.email
  if User.find_by(email: email_check).nil?
    u = FactoryBot.create(:user, email: email_check)
    task = rand 0..10
    task.times{
      FactoryBot.create(:task, user_id: u.id)
    }
  end
}