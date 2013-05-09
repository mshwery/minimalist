module ApplicationHelper
  def body_class
    @body_classes ||= ["#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"]
    @body_classes
  end

  def list_total
    Stat.any? ? Stat.first().lists_count : 0
  end

  def task_total
    Stat.any? ? Stat.first().tasks_count : 0
  end

  def css_design_awards_nominee_tag
    link_to image_tag("css-design-awards-nominee-right-black.png"), "http://www.cssdesignawards.com/css-web-design-award-nominees.php", :target => "_blank", :class => "desktop-only", :style => 'position: fixed; right: 0px; top: 50px;'
  end
end
