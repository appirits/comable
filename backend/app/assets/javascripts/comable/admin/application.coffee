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
#= require_tree .
#= require_self
#= require turbolinks

# ---
# functions
# ---

add_beforeunload_event = ->
  $form = $('form[method!="get"]')
  $form.change(->
    $(window).on('beforeunload', (event) ->
      # TODO: Install 'i18n-js' gem
      confirmation_message = 'The changes not saved. Are you sure you want to move from this page?'
      (event || window.event).returnValue = confirmation_message # for Gecko and Trident
      confirmation_message                                       # for Gecko and WebKit
    )
  )
  $form.submit(->
    $(window).off('beforeunload')
  )

window.add_fields = (_this, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp('new_' + association, 'g')
  $(_this).parent().before(content.replace(regexp, new_id))

# ---
# main
# ---

$(document).ready(->
  $(document).on('change', '.btn-file :file', ->
    $(this).closest('form').submit()
  )
)

add_beforeunload_event()

$('[data-toggle="tooltip"]').tooltip()

NProgress.configure(
  showSpinner: false,
  ease: 'ease',
  speed: 500,
  parent: '#wrapper'
)
