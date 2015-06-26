$(document).ready( ->
  # 公開/非公開の制御
  disp_published_at_by_published()

  # 日付を空にされたら非公開にする
  swicth_unpublished_by_page_published_at()

  # ページタイトルの制御
  set_page_title()

  # メタディスクリプションの制御
  set_meta_description()
)

# 公開/非公開の制御
disp_published_at_by_published = ->
  # 初期状態
  if $('#published_true').prop('checked') is true
    published_action()
  if $('#published_false').prop('checked') is true
    unpublished_action()

  # 公開がチェックされた時
  $('#published_true').click( ->
    published_action()
  )

  # 非公開がチェックされた時
  $('#published_false').click( ->
    unpublished_action()
  )

# 公開の際の制御
published_action = ->
  $('#page_published_at').show()
  if $('#page_published_at').val() == ''
    $('#page_published_at').val(moment().format("YYYY-MM-DD HH:mm"))

# 非公開の際の制御
unpublished_action = ->
  $('#page_published_at').hide()
  $('#page_published_at').val('')

# 日付を空にされたら非公開にする
swicth_unpublished_by_page_published_at = ->
  $('#page_published_at').blur( ->
    if $(this).val() == ''
      $('#published_false').click()
      $(this).hide()
      $(this).val('')
  )

# ページタイトルの制御
set_page_title = ->
  # タイトルを入力した時にページタイトルが空だったらタイトルの値を入れる
  $('#page_title').blur( ->
    if $('#page_page_title').val() == ''
      $('#page_page_title').val($(this).val())
  )

  # ページタイトルが空にされたらタイトルの値を入れる
  $('#page_page_title').blur( ->
    if $(this).val() == ''
      $(this).val($('#page_title').val())
  )

# メタディスクリプションの制御
set_meta_description = ->
  # 内容を入力した時にページタイトルが空だったら内容の値を入れる
  $('#page_content').blur( ->
    if $('#page_meta_description').val() == ''
      $('#page_meta_description').val($($(this).val()).text())
  )

  # メタディスクリプションが空にされたら内容の値を入れる
  $('#page_meta_description').blur( ->
    if $(this).val() == ''
      $html = $($('#page_content').val())
      $(this).val($html.text())
  )
