RSpec.describe Comable::Shipment do
  it { is_expected.to belong_to(:order).class_name(Comable::Order.name).inverse_of(:shipment) }
  it { is_expected.to belong_to(:shipment_method).class_name(Comable::ShipmentMethod.name) }

  it { is_expected.to validate_presence_of(:order) }
  it { is_expected.to validate_presence_of(:shipment_method) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:fee) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
  it { is_expected.to validate_length_of(:tracking_number).is_at_most(255) }
  it { is_expected.to validate_numericality_of(:fee).is_greater_than_or_equal_to(0) }
end
