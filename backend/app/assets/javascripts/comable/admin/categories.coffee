window.add_comable_jstree_node = ($node = '#') ->
  jstree = $('#comable-jstree').jstree(true)
  new_node = jstree.create_node($node)
  jstree.open_node($node) unless jstree.is_open($node)
  jstree.rename_node(new_node, comable_new_node_label)
  jstree.set_icon(new_node, 'fa fa-bars')

can_comable_jstree = ->
  return false unless comable_jstree_json?
  return false unless comable_new_node_label?
  return false unless comable_action_new?
  return false unless comable_action_edit?
  return false unless comable_action_destroy?
  return false unless comable_destroied_nodes?
  return false unless $('#comable-jstree').length
  true

initializa_comable_jstree = ->
  return unless can_comable_jstree()

  $comable_jstree = $('#comable-jstree')
  $comable_jstree.jstree({
    core: {
      check_callback: true,
      data: comable_jstree_json,
      strings : { new_node: comable_new_node_label, icon: 'fa fa-bars' }
    },
    contextmenu: {
      items: ($node) ->
        _this = $comable_jstree.jstree(true)
        {
          create: {
            label: comable_action_new,
            action: -> create_new_node($node)
          }
          edit: {
            label: comable_action_edit,
            action: -> _this.edit($node)
          }
          destory: {
            label: comable_action_destroy,
            action: ->
              comable_destroied_nodes.push { _destroy: $node.id }
              _this.delete_node($node)
          }
        }
    },
    plugins: ['dnd', 'wholerow', 'contextmenu']
  })

  $('form').submit(->
    json = $comable_jstree.jstree(true).get_json().concat(comable_destroied_nodes)
    json_string = JSON.stringify(json)
    $(this).find('#jstree_json').val(json_string)
  )

$(document).ready(->
  initializa_comable_jstree()
)
