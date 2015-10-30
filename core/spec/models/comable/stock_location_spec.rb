describe Comable::StockLocation do
  it { is_expected.to have_many(:shipments).class_name(Comable::Shipment.name) }
  it { is_expected.to have_many(:stocks).class_name(Comable::Stock.name).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for(:address) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }

  it { is_expected.to scope(:active) { where(active: true) } }
end
