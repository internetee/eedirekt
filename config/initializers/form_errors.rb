ActionView::Base.field_error_proc = lambda { |html_tag, instance|
  if html_tag =~ /^<label/
    error_message_markup = <<~HTML
    <span class='text-red-500'>
      #{sanitize(instance.error_message.to_sentence)}
    </span>
  HTML

  html = Nokogiri::HTML::DocumentFragment.parse(html_tag)
  html.children.remove_class('border-[#DAAA63]')
  html.children.add_class('border-red-500')

  tag.div do
    "#{html}#{error_message_markup}".html_safe
  end
  else
    html_tag
  end
}
