$(function(){

  skrollr.init({forceHeight: false});

  $('.hamburger-icon a').click(function(){
    $('._menu').toggle();
  });

});

$(document).on('scroll', function(){

  if($(document).scrollTop() > 15){
    $('header').addClass('scrolled');
  } else {
    $('header').removeClass('scrolled');
  }

});
