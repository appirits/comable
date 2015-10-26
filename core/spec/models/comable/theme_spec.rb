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

  it { is_expected.to scope(:by_newest) { reorder(created_at: :desc) } }

  describe '.dir' do
    it 'returns the dirctory path for themes' do
      expect(described_class.dir).to eq(Rails.root.join('themes'))
    end
  end

  describe '#dir' do
    it 'returns the dirctory path of the theme' do
      name = 'example'
      subject.name = name
      expect(subject.dir).to eq(Rails.root.join('themes', name))
    end
  end

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
