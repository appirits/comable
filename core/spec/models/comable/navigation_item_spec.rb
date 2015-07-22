describe Comable::NavigationItem do
  subject { create(:navigation_item) }

  describe 'associations' do
    it { is_expected.to belong_to(:navigation).class_name(Comable::Navigation.name) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:position).scoped_to(:navigation_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_length_of(:url).is_at_most(255) }

    context 'if navigation_id?' do
      before { allow(subject).to receive(:navigation_id?).and_return(true) }
      it { is_expected.to validate_presence_of(:navigation) }
    end

    context 'if linkable_id?' do
      before { allow(subject).to receive(:linkable_id?).and_return(true) }
      it { is_expected.to validate_presence_of(:linkable) }
    end

    context 'unless linkable_type?' do
      before { allow(subject).to receive(:linkable_type?).and_return(false) }
      it { is_expected.to validate_presence_of(:url) }
    end
  end
end
