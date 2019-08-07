User.create(username: 'admin', email: 'admin@gmail.com', password: '111111', role: 1)

10.times{
  u = FactoryBot.create(:user)
  task = rand 0..10
  task.times{
    FactoryBot.create(:task, user_id: u.id)
  }
}