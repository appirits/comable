RSpec.describe Comable::ShipmentItem do
  it { is_expected.to belong_to(:shipment).class_name(Comable::Shipment.name) }
  it { is_expected.to belong_to(:stock).class_name(Comable::Stock.name) }

  it { is_expected.to validate_presence_of(:shipment) }
  it { is_expected.to validate_presence_of(:stock) }
end
