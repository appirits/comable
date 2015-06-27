class @Page
  constructor: ->
    $(document).ready(@ready)

  ready: =>
    @radio_published = $('#page_published_at_published')
    @radio_unpublished = $('#page_published_at_unpublished')
    @published_at = $('#page_published_at')

    @initialize_visibility()
    @add_event_to_set_visibility()
    @add_event_to_set_page_title()
    @add_event_to_set_meta_description()

  # 公開/非公開の制御
  initialize_visibility: ->
    if @radio_published.is(':checked')
      @published()
    if @radio_unpublished.is(':checked')
      @unpublished()

  # 公開の際の制御
  published: =>
    @published_at.show()
    @published_at.val(moment().format('YYYY-MM-DD HH:mm')) unless @published_at.val()

  # 非公開の際の制御
  unpublished: =>
    @published_at.hide()
    @published_at.val('')

  add_event_to_set_visibility: ->
    @radio_published.click(@published)
    @radio_unpublished.click(@unpublished)

    # 日付を空にされたら非公開にする
    @published_at.blur( =>
      @radio_unpublished.click() unless @published_at.val()
    )

  # ページタイトルの制御
  add_event_to_set_page_title: ->
    $title = $('#page_title')
    $page_title = $('#page_page_title')

    # タイトルを入力した時にページタイトルが空だったらタイトルの値を入れる
    $title.blur( ->
      $page_title.val($(this).val()) unless $page_title.val()
    )

    # ページタイトルが空にされたらタイトルの値を入れる
    $page_title.blur( ->
      $(this).val($title.val()) unless $(this).val()
    )

  # メタディスクリプションの制御
  add_event_to_set_meta_description: ->
    $content = $('#page_content')
    $meta_description = $('#page_meta_description')

    # 内容を入力した時にメタディスクリプションが空だったら内容の値を入れる
    $content.blur( ->
      $meta_description.val($($(this).val()).text()) unless $meta_description.val()
    )

    # メタディスクリプションが空にされたら内容の値を入れる
    $meta_description.blur( ->
      $(this).val($($content.val()).text()) unless $(this).val()
    )
