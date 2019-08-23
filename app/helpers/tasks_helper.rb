module TasksHelper
  def task_error_message(item)
    if @errors.present?
      '* ' + @errors[item.to_sym].join(',')
    end
  end
end