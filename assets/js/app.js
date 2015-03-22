$(document).on('scroll', function(){
  skrollr.init();

  if($(document).scrollTop() > 15){
    $('header').addClass('scrolled');
  } else {
    $('header').removeClass('scrolled');
  }
});
