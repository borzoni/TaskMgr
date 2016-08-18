module ApplicationHelper
  def error_aware_field(object, field)
    capture do
      div_classes = 'form-group has-feedback'
      unless object.errors[field].empty?
        div_classes << ' has-error'
        span = content_tag(:span, "#{field.to_s.humanize} #{object.errors[field].join(', ')}", class: 'help_block')
      end
      concat("<div class='#{div_classes}'>".html_safe)
      yield if block_given?
      concat('</div>'.html_safe)
      concat(span.html_safe) if span
    end
  end
end
