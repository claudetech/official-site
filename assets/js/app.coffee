$ ->
  hash = window.location.hash.substr(1)
  if(hash != '')
    $('.back, .header').addClass('opened')
    $(".content.#{hash}, .back").addClass('opened')

  $('.logo').click (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('.back, .header, .content').removeClass('opened')

  $('.menu a').click (e) ->
    $('.back, .header').addClass('opened')
    $('.content').removeClass('opened')
    $('.content.' + $(this).attr('href').substr(1)).addClass('opened')
    
  $('#send').click (e) ->
    if( $("#name").val() && $("#email").val() && $("#body").val() )
      $('#send').hide()
      $('#send').after('<span>送信中...</span>')
      name = $("#name").val()
      email = $("#email").val()
      body = $("#body").val()
      $.ajax
        url: '/mail.php'
        type: "POST"
        data: "name=" + name + "&email=" + email + "&body=" + body
        success: ->
          $('#send + span').text('メッセージを送信しました。')
        error: ->
          $('#send + span').text('メッセージを送信できませんでした。')
