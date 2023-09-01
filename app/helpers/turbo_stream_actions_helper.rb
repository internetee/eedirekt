module TurboStreamActionsHelper
  def poll_message_mark_as_read(target, item_id:)
    turbo_stream_action_tag(:poll_message_mark_as_read, target:, item_id:)
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamActionsHelper)
