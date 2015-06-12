can_use_comable_theme_editor = ->
  return false unless $('#comable-theme-editor').length
  return false unless $('#comable-theme-editor-form').length
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

$(document).ready(->
  return unless can_use_comable_theme_editor()
  initializa_comable_theme_editor()
  add_comable_theme_editor_form_event()
)
