FactoryGirl.define do
  factory :order, class: Comable::Order do
    family_name 'foo'
    first_name 'bar'
    email 'test@example.com'
    customer { FactoryGirl.build_stubbed(:customer) }
    payment { FactoryGirl.build_stubbed(:payment) }
  end
end
