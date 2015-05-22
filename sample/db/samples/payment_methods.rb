Comable::PaymentMethod.create!(
  name: 'Credit Card',
  fee: 200,
  payment_provider_type: Comable::PaymentProvider::General.name,
  payment_provider_kind: 1
)
