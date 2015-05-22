Comable::Sample.import('categories')

clothing = Comable::Category.find_by!(name: 'Colothing')

products_attributes = [
  {
    name: 'Suede Dress',
    price: 6_990,
    categories: [clothing]
  },
  {
    name: 'Double Button Girly Coat',
    price: 9_000,
    categories: [clothing]
  },
  {
    name: 'Fur Gloves with Side Stitching',
    price: 5_292,
    categories: [clothing]
  },
  {
    name: 'Leather Boots',
    price: 28_080,
    categories: [clothing]
  }
]

next_id = (Comable::Product.maximum(:id) || 0).next

products_attributes.each.with_index(next_id) do |attributes, index|
  code = format('%05d', index)
  Comable::Product.create!(attributes.merge(code: code))
end
