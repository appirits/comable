#= require jquery
#= require bootstrap-sprockets
#= require_tree .

$( ->
  # ---
  # functions
  # ---

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

  # ---
  # main
  # ---

  initialize_vertical_navigation()
)
