(function() {
  $(function() {
    $('.logo').click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      return $('.back, .header, .content').removeClass('opened');
    });
    return $('.menu a').click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      $('.back, .header').addClass('opened');
      $('.content').removeClass('opened');
      return $('.content.' + $(this).attr('href')).addClass('opened');
    });
  });

}).call(this);
