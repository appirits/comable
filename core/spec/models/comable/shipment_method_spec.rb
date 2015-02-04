describe Comable::ShipmentMethod do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:fee) }

    it { is_expected.to ensure_length_of(:name).is_at_most(255) }
    it { is_expected.to ensure_length_of(:traking_url).is_at_most(255) }

    it { is_expected.to validate_numericality_of(:fee).is_greater_than_or_equal_to(0) }
  end
end
