describe Comable::Product do
  it { should be_truthy }

  it 'where' do
    expect { described_class.where(id: [1, 2]) }.not_to raise_error
  end
end
