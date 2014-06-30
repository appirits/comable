require 'spec_helper'

describe Product do
  it { expect { described_class.new }.to_not raise_error }

  let(:title) { 'sample product' }
  let(:product) { FactoryGirl.create(:product, title: title, comable_stocks: [stock]) }
  let(:stock) { FactoryGirl.create(:stock) }

  context 'attributes' do
    subject { product }
    its(:name) { should eq(title) }
  end

  context 'where' do
    before { product }

    it 'name => title: success' do
      expect(Comable::Product.where(name: title).count).to eq(1)
    end

    it 'name => title: fail' do
      expect { Product.where(name: title).count }.to raise_error
    end
  end

  context 'has_many' do
    subject { product }
    its(:stocks) { should be_any }
  end
end
