var ready = function() {
  var $phoneIcon = $('#two_factor_phone');
  if ($phoneIcon.length > 0) {
    var title = 'Why do you need my phone number?';
    var content = 'We use your phone number for two-factor authentication. Two-factor authentication provides an extra layer of security when logging in to secure systems. If you provide a phone number here, you will receive a text message with a pin number to access your account. To skip two-factor authentication and login with just a username and password, leave this field blank. US numbers only. Two-factor authentication is currently disabled for this application.';

    $phoneIcon.attr("title", title);
    $phoneIcon.attr("data-toggle", "popover");
    $phoneIcon.attr("data-content", content);

    $phoneIcon.popover({ trigger: 'hover' });
    // $phoneIcon.on('click', function(e) {
    //   e.preventDefault();
    //   e.stopPropagation();
    // });
  }
}

$(document).ready(ready);
$(document).on('turbolinks:load', ready);
