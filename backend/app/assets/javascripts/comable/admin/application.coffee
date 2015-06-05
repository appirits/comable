#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require jquery-ui
#= require bootstrap-sprockets
#= require raphael
#= require morris
#= require pace/pace
#= require nprogress
#= require nprogress-turbolinks
#= require gritter
#= require_tree .
#= require_self
#= require turbolinks

# ---
# functions
# ---

initialize_beforeunload_event = ->
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

initialize_vertical_navigation = ->
  $vnavigation = $('.vnavigation').find('ul')

  $('.vnavigation ul li ul').each( ->
    $target_navitem = $(this).parent()
    $target_navitem.addClass('parent')
  )

  $('.vnavigation ul li ul li.active').each( ->
    $target_navitem_children = $(this).parent()
    $target_navitem_children.css(display: 'block')
    $target_navitem_children.parent().addClass('open')
  )

  $vnavigation.delegate('.parent > a', 'click', (event) ->
    $target_navitem = $(this).parent()
    $target_navitem_children = $target_navitem.find('ul')

    $vnavigation.find('.parent.open > ul').not($target_navitem_children).slideUp(300, 'swing', ->
      $target_navitem.removeClass('open')
    )

    $target_navitem_children.slideToggle(300, 'swing', ->
      $target_navitem.toggleClass('open')
      #$('#cl-wrapper .nscroller').nanoScroller(preventPageScrolling: true)
    )

    event.preventDefault()
  )

initialize_comable_affix = ->
  $affix = $('#comable-affix')
  $affix_top = $affix.offset().top
  $affix.affix({
    offset: {
      top: ->
        if $affix.hasClass('affix-top')
          $affix_top - $('header').height() - 20
        else
          $affix_top
    }
  })

resize_comable_affix = ->
  $affix = $('#comable-affix')
  $affix.css('width', $affix.parent().width())

window.add_fields = (_this, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp('new_' + association, 'g')
  $(_this).parent().before(content.replace(regexp, new_id))

# ---
# main
# ---

# Show the bar after Turbolinks added the page into the dom
# from: https://github.com/HubSpot/pace/issues/47
$(document).on('page:change', ->
  Pace.restart()
)

$(document).ready(->
  initialize_vertical_navigation()

  $(document).on('change', '.btn-file :file', ->
    $(this).closest('form').submit()
  )
)

initialize_beforeunload_event()

if $('#comable-affix').length != 0
  initialize_comable_affix()
  resize_comable_affix()
  $(window).on('resize', resize_comable_affix)

$('[data-toggle="tooltip"]').tooltip()
