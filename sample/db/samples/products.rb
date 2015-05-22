Comable::Sample.import('categories')

clothing = Comable::Category.find_by!(name: Comable::Sample.t(:clothing))

products_attributes = [
  {
    name: Comable::Sample.t(:suede_dress),
    price: 6_990,
    categories: [clothing]
  },
  {
    name: Comable::Sample.t(:girly_coat),
    price: 9_000,
    categories: [clothing]
  },
  {
    name: Comable::Sample.t(:fur_gloves),
    price: 5_292,
    categories: [clothing]
  },
  {
    name: Comable::Sample.t(:leather_boots),
    price: 28_080,
    categories: [clothing]
  }
]

next_id = (Comable::Product.maximum(:id) || 0).next

products_attributes.each.with_index(next_id) do |attributes, index|
  code = format('%05d', index)
  Comable::Product.create!(attributes.merge(code: code))
end
