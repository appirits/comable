describe Comable::PaymentMethod do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:payment_provider_type) }
    it { is_expected.to validate_presence_of(:payment_provider_kind) }
    it { is_expected.to validate_presence_of(:fee) }

    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_length_of(:payment_provider_type).is_at_most(255) }

    it { is_expected.to validate_numericality_of(:payment_provider_kind).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:fee).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:enable_price_from).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:enable_price_to).is_greater_than_or_equal_to(0) }
  end
end
