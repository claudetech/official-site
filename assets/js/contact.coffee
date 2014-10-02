$ ->
  new Vue
    el: '.contact'
    data:
      form: {}
      status: 'initial'
      text:
        inProgress: '送信中...'
        done: 'メッセージを送信しました。'
        failed: 'メッセージを送信できませんでした。'
    methods:
      submit: (e) ->
        return if @submitted() || @isInvalid()
        @status = 'inProgress'
        $.post('/mail.php', @form)
         .done(=> @status = 'done')
         .fail(=> @status = 'failed')
      submitted: -> @status != 'initial' && @status != 'failed'
      isInvalid: ->
        _.isEmpty(@form.name) || _.isEmpty(@form.email) || _.isEmpty(@form.body)
