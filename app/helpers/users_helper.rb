module UsersHelper
  def error_message(item)
    if @user.errors.any?
      '* ' + @user.errors.messages[item.to_sym].join(',')
    end
  end
end