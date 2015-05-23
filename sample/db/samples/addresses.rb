# Billing address
Comable::Address.create!(
  family_name: Comable::Sample::Name.family_name,
  first_name: Comable::Sample::Name.first_name,
  zip_code: Comable::Sample::Address.zip_code,
  state_name: Comable::Sample::Address.state_name,
  city: Comable::Sample::Address.city,
  detail: Comable::Sample::Address.detail,
  phone_number: Comable::Sample::PhoneNumber.phone_number
)

# Shipping address
Comable::Address.create!(
  family_name: Comable::Sample::Name.family_name,
  first_name: Comable::Sample::Name.first_name,
  zip_code: Comable::Sample::Address.zip_code,
  state_name: Comable::Sample::Address.state_name,
  city: Comable::Sample::Address.city,
  detail: Comable::Sample::Address.detail,
  phone_number: Comable::Sample::PhoneNumber.phone_number
)
