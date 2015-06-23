can_comable_tagit = ->
  return false unless comable_tagit_available_tags?
  return false unless $("#comable-tagit").length
  true

initializa_comable_tagit = ->
  return unless can_comable_tagit()

  $("#comable-tagit").tagit({
    fieldName: 'product[category_path_names][]',
    availableTags: comable_tagit_available_tags,
    autocomplete: { delay: 0, minLength: 0 },
    showAutocompleteOnFocus: true,
    removeConfirmation: true,
    # Only allow available tags
    beforeTagAdded: (event, ui) -> (comable_tagit_available_tags.indexOf(ui.tagLabel) != -1)
  })

$(document).ready(->
  initializa_comable_tagit()
)
