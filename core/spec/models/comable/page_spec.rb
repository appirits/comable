describe Comable::Page do
  subject { create(:page) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
    it do
      subject.title = nil
      is_expected.to validate_presence_of(:slug)
    end

    it { is_expected.to validate_length_of(:title).is_at_most(255) }
    it { is_expected.to validate_length_of(:page_title).is_at_most(255) }
    it { is_expected.to validate_length_of(:slug).is_at_most(255) }
    it { is_expected.to validate_length_of(:meta_keywords).is_at_most(255) }
    it { is_expected.to validate_length_of(:meta_description).is_at_most(255) }
  end
end
