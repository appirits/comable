can_use_comable_theme_editor = ->
  return false unless $('#comable-theme-editor').length
  return false unless $('#comable-theme-editor-form').length
  true

can_use_comable_file_tree = ->
  return false unless $('#comable-file-tree').length
  true

initializa_comable_theme_editor = ->
  editor = ace.edit('comable-theme-editor')
  editor.setTheme('ace/theme/monokai')
  editor.getSession().setMode('ace/mode/liquid')

add_comable_theme_editor_form_event = ->
  $form = $('#comable-theme-editor-form')
  $form.submit(->
    editor = ace.edit('comable-theme-editor')
    text = editor.getValue()
    $(this).find('[name=code]').val(text)
  )

resize_forms_height = ->
  header_height = parseInt($('.comable-page-body').css('padding-top'))
  footer_height = $('footer').outerHeight(true)
  main_height = $(window).height() - header_height - footer_height
  $comable_file_tree = $('#comable-file-tree')
  $comable_file_tree.css('height', main_height + 'px') if $comable_file_tree.length
  $comable_theme_editor = $('#comable-theme-editor')
  $comable_theme_editor.css('height', main_height + 'px') if $comable_theme_editor.length

$(document).ready(->
  if can_use_comable_theme_editor()
    initializa_comable_theme_editor()
    add_comable_theme_editor_form_event()
  if can_use_comable_file_tree()
    resize_forms_height()
)

$(window).resize(->
  return unless can_use_comable_file_tree()
  resize_forms_height()
)
