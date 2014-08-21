(function() {
  $(function() {
    return $('.menu a').click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      $('.back, .header').addClass('opened');
      $('.content').removeClass('opened');
      return $('.content.' + $(this).attr('href')).addClass('opened');
    });
  });

}).call(this);
