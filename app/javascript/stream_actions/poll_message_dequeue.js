import { StreamActions } from "@hotwired/turbo"

StreamActions.poll_message_dequeue = function() {  
  let elementId = this.getAttribute("element_id");
  let item = document.querySelector(`#${elementId}`);

  item.classList.add('message-box-animate-out');
  
  item.addEventListener("animationend", function() {
    item.remove();
  });
}
