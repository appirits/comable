describe Comable::Able::Productable do
  it { should be_truthy }

  it 'where' do
    expect { Comable::Product.where(id: [1, 2]) }.not_to raise_error
  end
end
