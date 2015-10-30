FactoryGirl.define do
  factory :stock_location, class: Comable::StockLocation do
    sequence(:name) { |n| "Stock Location ##{n.next}" }
  end
end
