can_use_comable_theme_editor = ->
  return false unless $('#comable-theme-editor').length
  return false unless $('#comable-theme-editor-form').length
  true

can_use_comable_file_tree = ->
  return false unless $('#comable-file-tree').length
  true

comable_theme_editor_window = ->
  editor_element = $('#comable-theme-editor').find('.comable-theme-editor-window').get(0)
  ace.edit(editor_element)

initializa_comable_theme_editor = ->
  editor = comable_theme_editor_window()
  editor.setTheme('ace/theme/monokai')
  editor.session.setMode('ace/mode/liquid')
  $(window).bind('beforeunload', ->
    window.beforeunload_message unless editor.session.getUndoManager().isClean()
  )
  $(document).on('page:before-change', ->
    confirm(window.beforeunload_message) unless editor.session.getUndoManager().isClean()
  )

add_comable_theme_editor_form_event = ->
  $form = $('#comable-theme-editor-form')
  $form.submit(->
    editor = comable_theme_editor_window()
    text = editor.getValue()
    $(this).find('[name=code]').val(text)
  )

add_comable_file_tree_event = ->
  $comable_file_tree = $('#comable-file-tree')
  $comable_file_tree.find('a').click((event) ->
    event.preventDefault()
    path = $(this).attr('href')
    page_before_change = jQuery.Event('page:before-change')
    $(document).trigger(page_before_change)
    Turbolinks.visit(path) unless page_before_change.isDefaultPrevented()
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
    add_comable_file_tree_event()
)

$(window).resize(->
  return unless can_use_comable_file_tree()
  resize_forms_height()
)
