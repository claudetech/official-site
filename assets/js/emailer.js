$(document).ready(function(){
  Parse.initialize("h5DF4rVG05uGcFJZBxlqXT2BYhc8DTSpOIVRAhzA", "ReV9PENI6IgFvlprtlLGj5HICo3EmVWTC227mIby");

  $('#contact-form').submit(function(e){
    e.preventDefault();

    var data = {
      name: document.getElementById('name').value,
      email: document.getElementById('email').value,
      message: document.getElementById('message').value
    };

    Parse.Cloud.run("sendEmail", data, {
      success: function(object) {
        $('#submit').hide();
        $('#response').html('Message sent!').addClass('success').fadeIn('fast');
      },

      error: function(object, error) {
        console.log(error);
        $('#response').html('Error! Message not sent!').addClass('error').fadeIn('fast');
      }
    });
  });

});
