FactoryGirl.define do
  factory :customer, class: 'Comable::Customer::Mapper' do
    family_name 'foo'
    first_name 'bar'
  end
end
