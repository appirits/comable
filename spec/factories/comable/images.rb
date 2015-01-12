FactoryGirl.define do
  factory :image, class: Comable::Image do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/dummy/public/favicon.ico')) }
  end
end
