module ApplicationHelper
  def body_class
    @body_classes ||= ["#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"]
    @body_classes
  end

  def list_total
    List.all.count
  end

  def stack_total
    Stack.all.count
  end
end
