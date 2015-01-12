describe Comable::Product do
  it { should be_truthy }

  describe 'associations' do
    it { is_expected.to have_many(:stocks).class_name(Comable::Stock.name) }
    it { is_expected.to have_many(:images).class_name(Comable::Image.name) }
    it { is_expected.to have_and_belong_to_many(:categories).class_name(Comable::Category.name) }
  end

  it 'where' do
    expect { described_class.where(id: [1, 2]) }.not_to raise_error
  end
end
