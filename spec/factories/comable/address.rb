FactoryGirl.define do
  factory :address, class: 'Comable::Address' do
    family_name 'foo'
    first_name 'bar'
    zip_code '123-4567'
    state_name '東京都'
    city '渋谷区'
    detail '恵比寿'
    phone_number '03-1234-4567'
  end
end
