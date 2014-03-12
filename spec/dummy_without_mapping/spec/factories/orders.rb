FactoryGirl.define do
  factory :order, class: Comable::Order do
    family_name "foo"
    first_name "bar"
    comable_customer { FactoryGirl.build_stubbed(:customer) }
  end
end
