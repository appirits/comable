can_comable_tagit = ->
  return false unless comable_morris_data?
  return false unless comable_morris_keys?
  return false unless comable_morris_labels?
  return false unless $('#comable-morris').length
  true

initializa_comable_morris = ->
  return unless can_comable_tagit()

  new Morris.Line({
    # ID of the element in which to draw the chart.
    element: 'comable-morris',
    # Chart data records -- each entry in this array corresponds to a point on
    # the chart.
    data: comable_morris_data,
    # The name of the data record attribute that contains x-values.
    xkey: 'date',
    # A list of names of data record attributes that contain y-values.
    ykeys: comable_morris_keys,
    # Labels for the ykeys -- will be displayed when you hover over the
    # chart.
    labels: comable_morris_labels,
    xLabelAngle: 45,
    xLabels: ['day'],
    lineColors: ['#00acac', '#348fe2'],
    hideHover: 'auto'
  })

$(document).ready(->
  initializa_comable_morris()
)
