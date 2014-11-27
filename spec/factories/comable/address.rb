FactoryGirl.define do
  factory :address, class: 'Comable::Address' do
    sequence(:family_name) { |n| "foo#{n.next}" }
    sequence(:first_name) { |n| "bar#{n.next}" }
    zip_code '123-4567'
    state_name '東京都'
    city '渋谷区'
    detail '恵比寿'
    phone_number '03-1234-4567'
  end
end
