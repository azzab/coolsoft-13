function add_notification_event_handlers() {
  notification_click('div.invite-committee-notification', '/redirect_expertise');
  notification_click('div.approve-committee-notification', '/redirect_review');
  notification_click('div.idea-notification', '/redirect_idea');
  notification_click('div.delete-notification', '/set_read');
  notification_click('div.competition-notification', '/redirect_competition');
}

$(document).ready(add_notification_event_handlers);

function notification_click(select, redirect){
  $(select).click(function(){
    var notification = $(this).data('notification');
    $.getScript(redirect + ".js?&notification=" + notification);
  });
}