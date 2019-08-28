module TasksHelper
  def task_error_message(item)
    if @errors.present?
      if @errors[item.to_sym].present?
        '* ' + @errors[item.to_sym].join(',')
      end
    end
  end

  def task_author?(task)
    task.id == current.user
  end
end