module ApplicationHelper
  def body_class
    @body_classes ||= ["#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"]
    @body_classes
  end
end
