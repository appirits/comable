class @ThemeTree
  constructor: ->
    $(window).resize(@resize_forms_height)
    @resize_forms_height()
    @add_comable_file_tree_event()

  add_comable_file_tree_event: ->
    $comable_file_tree = $('#comable-file-tree')
    $comable_file_tree.find('a').click((event) ->
      event.preventDefault()
      path = $(this).attr('href')
      page_before_change = jQuery.Event('page:before-change')
      $(document).trigger(page_before_change)
      Turbolinks.visit(path) unless page_before_change.isDefaultPrevented()
    )

  resize_forms_height: ->
    header_height = parseInt($('.comable-page-body').css('padding-top'))
    footer_height = $('footer').outerHeight(true)
    main_height = $(window).height() - header_height - footer_height
    $comable_file_tree = $('#comable-file-tree')
    $comable_file_tree.css('height', main_height + 'px') if $comable_file_tree.length
    $comable_theme_editor = $('#comable-theme-editor')
    $comable_theme_editor.css('height', main_height + 'px') if $comable_theme_editor.length

class @ThemeEditor
  constructor: ->
    @initializa_comable_theme_editor()
    @add_comable_theme_editor_form_event()

  initializa_comable_theme_editor: ->
    editor = @comable_theme_editor_window()
    editor.setTheme('ace/theme/monokai')
    editor.session.setMode('ace/mode/liquid')
    $(window).bind('beforeunload', ->
      window.beforeunload_message unless editor.session.getUndoManager().isClean()
    )
    $(document).on('page:before-change', ->
      confirm(window.beforeunload_message) unless editor.session.getUndoManager().isClean()
    )

  add_comable_theme_editor_form_event: ->
    _this = @
    $form = $('#comable-theme-editor-form')
    $form.submit( ->
      editor = _this.comable_theme_editor_window()
      text = editor.getValue()
      $(this).find('[name=code]').val(text)
    )

  comable_theme_editor_window: ->
    editor_element = $('#comable-theme-editor').find('.comable-theme-editor-window').get(0)
    ace.edit(editor_element)
