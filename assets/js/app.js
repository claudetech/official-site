$(document).ready(function(){
  skrollr.init({forceHeight: false});
  $(document).foundation();
});

$(document).on('scroll', function(){
  if($(document).scrollTop() > 15){
    $('header').addClass('scrolled');
  } else {
    $('header').removeClass('scrolled');
  }
});
