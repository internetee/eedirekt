ActionView::Base.field_error_proc = -> (html_tag, instance) {

  unless html_tag =~ /^<label/
    error_message_markup = <<~HTML
      <div class='text-red-500'>
        #{sanitize(instance.error_message.to_sentence)}
      </div>
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
