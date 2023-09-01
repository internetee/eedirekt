import { StreamActions } from "@hotwired/turbo"

StreamActions.poll_message_mark_as_read = function() {  
  let itemId = this.getAttribute("item_id");
  let item = document.querySelector(`#poll_message_${itemId}`);

  item.classList.add('animated-fill');

  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      setTimeout(() => {
        item.remove();
      }, 700);
    });
  });
}
