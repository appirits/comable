describe Comable::Page do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:slug) }

    it { is_expected.to validate_length_of(:title).is_at_most(255) }
    it { is_expected.to validate_length_of(:page_title).is_at_most(255) }
    it { is_expected.to validate_length_of(:slug).is_at_most(255) }
    it { is_expected.to validate_length_of(:meta_keywords).is_at_most(255) }
    it { is_expected.to validate_length_of(:meta_description).is_at_most(255) }
  end
end
