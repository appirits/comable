#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require jquery-ui
#= require bootstrap-sprockets
#= require raphael
#= require morris
#= require nprogress
#= require nprogress-turbolinks
#= require gritter
#= require awesome_admin_layout
#= require ace/ace
#= require ace/worker-html
#= require ace/mode-liquid
#= require comable/admin/dispatcher
#= require_tree .
#= require_self
#= require turbolinks

# ---
# variables
# ---

# TODO: Install 'i18n-js' gem
window.beforeunload_message = 'The changes not saved. Are you sure you want to move from this page?'

# ---
# functions
# ---

add_beforeunload_event = ->
  $form = $('form[method!="get"]')
  $form.change(->
    $(window).bind('beforeunload', ->
      window.beforeunload_message
    )
    $(document).on('page:before-change', ->
      confirm(window.beforeunload_message)
    )
  )
  remove_beforeunload_function = ->
    $(window).unbind('beforeunload')
    $(document).off('page:before-change')
  $form.submit(remove_beforeunload_function)
  $(document).on('page:change', remove_beforeunload_function)

window.add_fields = (_this, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp('new_' + association, 'g')
  $(_this).parent().before(content.replace(regexp, new_id))

# ---
# main
# ---

$(document).ready(->
  add_beforeunload_event()

  $('.btn-file :file').change(->
    $(this).closest('form').submit()
  )

  $('[data-toggle="tooltip"]').tooltip()
)


NProgress.configure(
  showSpinner: false,
  ease: 'ease',
  speed: 500,
  parent: '#wrapper'
)
