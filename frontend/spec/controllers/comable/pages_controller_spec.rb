describe Comable::PagesController do
  render_views

  context '通常商品' do
    let!(:page) { create(:page) }
    describe "GET 'show'" do
      before { get :show, id: page.slug }

      it { expect(response).to be_success }
      it { expect(assigns(:page)).to eq page }
    end

    describe "GET 'show(preview)'" do
      before do
        allow(page).to receive(:published?).and_return(false)
        session[Comable::Page::PREVIEW_SESSION_KEY] = {}
        session[Comable::Page::PREVIEW_SESSION_KEY][page.slug]
        get :show, id: page.slug
      end

      it { expect(response).to be_success }
      it { expect(assigns(:page)).to eq page }
    end
  end
end
