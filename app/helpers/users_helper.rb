module UsersHelper
  def error_message(item)
    if @user.errors.any?
      if @user.errors.messages[item.to_sym].present?
        '* ' + @user.errors.messages[item.to_sym].join(',')
      end
    end
  end
end