Comable::Sample.import('products')

suede_dress = Comable::Product.where(name: Comable::Sample.t(:suede_dress)).first!
girly_coat = Comable::Product.where(name: Comable::Sample.t(:girly_coat)).first!
fur_gloves = Comable::Product.where(name: Comable::Sample.t(:fur_gloves)).first!
leather_boots = Comable::Product.where(name: Comable::Sample.t(:leather_boots)).first!

suede_dress_size = suede_dress.option_types.create!(name: Comable::Sample.t(:size))
suede_dress_color = suede_dress.option_types.create!(name: Comable::Sample.t(:color))

girly_coat_size = girly_coat.option_types.create!(name: Comable::Sample.t(:size))
girly_coat_color = girly_coat.option_types.create!(name: Comable::Sample.t(:color))

leather_boots_size = leather_boots.option_types.create!(name: Comable::Sample.t(:size))

default_stock_attributes = {
  quantity: 10
}

variants_attributes = [
  {
    product: suede_dress,
    option_values_attributes: [option_type: suede_dress_size, name: 'S'] + [option_type: suede_dress_color, name: Comable::Sample.t(:navy)],
    stock_attributes: default_stock_attributes,
    sku: 'SUEDE-DRESS-SN'
  },
  {
    product: suede_dress,
    option_values_attributes: [option_type: suede_dress_size, name: 'M'] + [option_type: suede_dress_color, name: Comable::Sample.t(:navy)],
    stock_attributes: default_stock_attributes,
    sku: 'SUEDE-DRESS-MN'
  },
  {
    product: girly_coat,
    option_values_attributes: [option_type: girly_coat_size, name: 'S'] + [option_type: girly_coat_color, name: Comable::Sample.t(:beige)],
    stock_attributes: default_stock_attributes,
    sku: 'GIRLY-COAT-SB'
  },
  {
    product: girly_coat,
    option_values_attributes: [option_type: girly_coat_size, name: 'M'] + [option_type: girly_coat_color, name: Comable::Sample.t(:beige)],
    stock_attributes: default_stock_attributes,
    sku: 'GIRLY-COAT-MB'
  },
  {
    product: girly_coat,
    option_values_attributes: [option_type: girly_coat_size, name: 'S'] + [option_type: girly_coat_color, name: Comable::Sample.t(:navy)],
    stock_attributes: default_stock_attributes,
    sku: 'GIRLY-COAT-SN'
  },
  {
    product: girly_coat,
    option_values_attributes: [option_type: girly_coat_size, name: 'M'] + [option_type: girly_coat_color, name: Comable::Sample.t(:navy)],
    stock_attributes: default_stock_attributes,
    sku: 'GIRLY-COAT-MN'
  },
  {
    product: fur_gloves,
    stock_attributes: default_stock_attributes,
    sku: 'FUR-GLOVES'
  },
  {
    product: leather_boots,
    option_values_attributes: [option_type: leather_boots_size, name: 'S'],
    stock_attributes: { quantity: 0 },
    sku: 'LEATHER-BOOTS-S'
  },
  {
    product: leather_boots,
    option_values_attributes: [option_type: leather_boots_size, name: 'M'],
    stock_attributes: { quantity: 1 },
    sku: 'LEATHER-BOOTS-M'
  },
  {
    product: leather_boots,
    option_values_attributes: [option_type: leather_boots_size, name: 'L'],
    stock_attributes: default_stock_attributes,
    sku: 'LEATHER-BOOTS-L'
  }
]

variants_attributes.each do |attributes|
  Comable::Variant.create!(attributes)
end
