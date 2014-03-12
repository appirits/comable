require 'spec_helper'

describe Comable::Product do
  it { expect { described_class.new }.to_not raise_error }

  context "attributes" do
    let (:name) { 'sample product' }
    let! (:product) { FactoryGirl.create(:product, name: name) }

    subject { Comable::Product.first }

    its (:name) { should eq(title) }
  end
end
