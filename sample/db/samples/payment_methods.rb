Comable::PaymentMethod.create!(
  name: Comable::Sample.t(:credit_card),
  fee: 200,
  payment_provider_type: Comable::PaymentProvider::General.name,
  payment_provider_kind: 1
)
