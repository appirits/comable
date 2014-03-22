require 'spec_helper'

describe Comable::Customer do
  it { expect { described_class.new }.to_not raise_error }

  it "モデルマッピングが正常に行われていること" do
    expect(described_class.table_name).to eq("comable_customers")
  end
end
