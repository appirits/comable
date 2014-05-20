require 'spec_helper'

describe Product do
  it { expect { described_class.new }.to_not raise_error }

  context 'attributes' do
    subject { Comable::Product.first }

    let(:title) { 'sample product' }
    let!(:product) { FactoryGirl.create(:product, title: title) }

    its(:name) { should eq(title) }
  end
end
