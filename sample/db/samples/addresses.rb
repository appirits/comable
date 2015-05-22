# Billing address
Comable::Address.create!(
  family_name: FFaker::Name.last_name,
  first_name: FFaker::Name.first_name,
  zip_code: FFaker::AddressUS.zip_code,
  state_name: FFaker::AddressUS.state,
  city: FFaker::AddressUS.city,
  detail: FFaker::AddressUS.street_address,
  phone_number: FFaker::PhoneNumber.phone_number
)

# Shipping address
Comable::Address.create!(
  family_name: FFaker::Name.last_name,
  first_name: FFaker::Name.first_name,
  zip_code: FFaker::AddressUS.zip_code,
  state_name: FFaker::AddressUS.state,
  city: FFaker::AddressUS.city,
  detail: FFaker::AddressUS.street_address,
  phone_number: FFaker::PhoneNumber.phone_number
)
