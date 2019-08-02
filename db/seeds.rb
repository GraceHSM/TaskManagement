user = FactoryBot.create(:user, role: 0)

100.times{
  FactoryBot.create(:task, user_id:user.id)
}