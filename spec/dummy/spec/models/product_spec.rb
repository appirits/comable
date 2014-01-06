require 'spec_helper'

describe Product do
  it { expect { described_class.new }.to_not raise_error }

  context "attributes" do
    let (:title) { 'sample product' }

    subject { described_class.new(title: title) }

    its (:name) { should eq(title) }
  end
end
