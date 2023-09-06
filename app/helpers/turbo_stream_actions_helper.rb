module TurboStreamActionsHelper
  def poll_message_mark_as_read(target, item_id:)
    turbo_stream_action_tag(:poll_message_mark_as_read, target:, item_id:)
  end

  def poll_message_dequeue(target, element_id:)
    turbo_stream_action_tag(:poll_message_dequeue, target:, element_id:)
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamActionsHelper)
