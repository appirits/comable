Comable::Sample.import('products')

suede_dress = Comable::Product.find_by!(name: Comable::Sample.t(:suede_dress))
girly_coat = Comable::Product.find_by!(name: Comable::Sample.t(:girly_coat))
fur_gloves = Comable::Product.find_by!(name: Comable::Sample.t(:fur_gloves))
leather_boots = Comable::Product.find_by!(name: Comable::Sample.t(:leather_boots))

def image(name, suffix: '.jpg')
  image_path = File.join(File.dirname(__FILE__), 'images', name + suffix)
  File.open(image_path)
end

images_attributes = [
  {
    product: suede_dress,
    file: image('suede_dress')
  },
  {
    product: suede_dress,
    file: image('suede_dress_full')
  },
  {
    product: girly_coat,
    file: image('girly_coat')
  },
  {
    product: fur_gloves,
    file: image('fur_gloves')
  },
  {
    product: leather_boots,
    file: image('leather_boots')
  },
  {
    product: leather_boots,
    file: image('leather_boots_front')
  },
  {
    product: leather_boots,
    file: image('leather_boots_back')
  }
]

images_attributes.each do |attributes|
  Comable::Image.create!(attributes)
end
