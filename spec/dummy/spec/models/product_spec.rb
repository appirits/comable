require 'spec_helper'

describe Product do
  it { expect { described_class.new }.to_not raise_error }

  context 'attributes' do
    let(:title) { 'sample product' }
    let(:product) { FactoryGirl.create(:product, title: title) }

    subject { product }

    its(:name) { should eq(title) }
  end
end
