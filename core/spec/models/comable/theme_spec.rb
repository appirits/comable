describe Comable::Theme, type: :model do
  subject { build(:theme) }

  it { is_expected.to have_one(:store).class_name(Comable::Store.name) }

  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:version) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:version) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
  it { is_expected.to validate_length_of(:version).is_at_most(255) }
  it { is_expected.to validate_length_of(:display).is_at_most(255) }
  it { is_expected.to validate_length_of(:description).is_at_most(255) }
  it { is_expected.to validate_length_of(:homepage).is_at_most(255) }
  it { is_expected.to validate_length_of(:author).is_at_most(255) }

  describe '#default_version' do
    it 'returns the string' do
      expect(subject.default_version).to be_a(String)
    end
  end

  describe '#to_param' do
    it 'returns #name' do
      expect(subject.to_param).to eq(subject.name)
    end
  end

  describe '#display_name' do
    it 'returns #display when #display is present' do
      subject.display = 'Sample Theme'
      expect(subject.display_name).to eq(subject.display)
    end

    it 'returns #name when #display is blank' do
      subject.display = ''
      expect(subject.display_name).to eq(subject.name)
    end
  end
end
