describe Order do
  it { expect { described_class.new }.to_not raise_error }

  let(:title) { 'sample product' }
  let(:order) { FactoryGirl.build(:order) }

  describe 'attributes' do
    subject { order }

    context '#save' do
      before { subject.save }
      its(:ordered_at) { should be }
      its(:code) { should be }
    end
  end
end
