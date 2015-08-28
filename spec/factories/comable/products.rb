FactoryGirl.define do
  factory :product, class: Comable::Product do
    sequence(:name) { |n| "test_product#{n.next}" }
    published_at Date.today

    variants { [build(:variant)] }

    trait :with_stock do
      stocks { [create(:stock, :stocked, variant: variants.first)] }
    end

    trait :sku do
      after(:build) do |product|
        product.save!

        color = create(:option_type, product: product, name: 'Color')
        size = create(:option_type, product: product, name: 'Size')

        color_red = color.option_values.build(name: 'Red')
        size_s = size.option_values.build(name: 'S')
        size_m = size.option_values.build(name: 'M')
        size_l = size.option_values.build(name: 'L')
        product.variants = [
          build(:variant, option_values: [color_red, size_s], stock: build(:stock, :stocked)),
          build(:variant, option_values: [color_red, size_m], stock: build(:stock, :stocked)),
          build(:variant, option_values: [color_red, size_l], stock: build(:stock, :stocked))
        ]
      end
    end

    trait :sku_h do
      after(:build) do |product|
        product.save!

        color = create(:option_type, product: product, name: 'Color')

        color_red = color.option_values.build(name: 'Red')
        product.variants = [build(:variant, option_values: [color_red])]
      end
    end
  end
end
