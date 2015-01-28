describe Comable::Product do
  it { should be_truthy }

  describe 'associations' do
    it { is_expected.to have_many(:stocks).class_name(Comable::Stock.name) }
    it { is_expected.to have_many(:images).class_name(Comable::Image.name) }
    it { is_expected.to have_and_belong_to_many(:categories).class_name(Comable::Category.name) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:price) }

    it { is_expected.to ensure_length_of(:name).is_at_most(255) }
    it { is_expected.to ensure_length_of(:code).is_at_most(255) }
    it { is_expected.to ensure_length_of(:sku_h_item_name).is_at_most(255) }
    it { is_expected.to ensure_length_of(:sku_v_item_name).is_at_most(255) }

    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end

  it 'where' do
    expect { described_class.where(id: [1, 2]) }.not_to raise_error
  end
end
