describe Comable::Store, type: :model do
  describe 'validations' do
    it { is_expected.to ensure_length_of(:name).is_at_most(255) }
    it { is_expected.to ensure_length_of(:meta_keywords).is_at_most(255) }
    it { is_expected.to ensure_length_of(:meta_description).is_at_most(255) }
    it { is_expected.to ensure_length_of(:email_sender).is_at_most(255) }
  end
end
