describe Comable::Stock do
  it { expect { described_class.new }.to_not raise_error }

  context 'belongs_to' do
    let(:stock) { FactoryGirl.create(:stock, :with_product) }

    describe 'product' do
      subject { stock.product }
      it { should be }
      its(:name) { should be }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:product) }
    it { is_expected.to validate_presence_of(:code) }

    it { is_expected.to ensure_length_of(:code).is_at_most(255) }
    it { is_expected.to ensure_length_of(:sku_h_choice_name).is_at_most(255) }
    it { is_expected.to ensure_length_of(:sku_v_choice_name).is_at_most(255) }

    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
  end
end
