describe Comable::Admin::TrackersController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { attributes_for(:tracker) }
  let(:invalid_attributes) { valid_attributes.merge(tracker_id: 'x' * 1024) }

  describe 'GET index' do
    it 'assigns all trackers as @trackers' do
      tracker = create(:tracker)
      get :index
      expect(assigns(:trackers)).to eq([tracker])
    end
  end

  describe 'GET show' do
    it 'assigns the requested tracker as @tracker' do
      tracker = create(:tracker)
      get :show, id: tracker.to_param
      expect(assigns(:tracker)).to eq(tracker)
    end
  end

  describe 'GET new' do
    it 'assigns a new tracker as @tracker' do
      get :new
      expect(assigns(:tracker)).to be_a_new(Comable::Tracker)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested tracker as @tracker' do
      tracker = create(:tracker)
      get :edit, id: tracker.to_param
      expect(assigns(:tracker)).to eq(tracker)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Comable::Tracker' do
        expect { post :create, tracker: valid_attributes }.to change(Comable::Tracker, :count).by(1)
      end

      it 'assigns a newly created tracker as @tracker' do
        post :create, tracker: valid_attributes
        expect(assigns(:tracker)).to be_a(Comable::Tracker)
        expect(assigns(:tracker)).to be_persisted
      end

      it 'redirects to the created tracker' do
        post :create, tracker: valid_attributes
        expect(response).to redirect_to([comable, :admin, Comable::Tracker.last])
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved tracker as @tracker' do
        post :create, tracker: invalid_attributes
        expect(assigns(:tracker)).to be_a_new(Comable::Tracker)
      end

      it "re-renders the 'new' template" do
        post :create, tracker: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    let!(:tracker) { create(:tracker) }

    describe 'with valid params' do
      let(:new_attributes) { { tracker_id: "NEW: #{tracker.tracker_id}" } }

      it 'updates the requested tracker' do
        put :update, id: tracker.to_param, tracker: new_attributes
        tracker.reload
        expect(tracker).to have_attributes(new_attributes)
      end

      it 'assigns the requested tracker as @tracker' do
        put :update, id: tracker.to_param, tracker: valid_attributes
        expect(assigns(:tracker)).to eq(tracker)
      end

      it 'redirects to the tracker' do
        put :update, id: tracker.to_param, tracker: valid_attributes
        expect(response).to redirect_to([comable, :admin, tracker])
      end
    end

    describe 'with invalid params' do
      it 'assigns the tracker as @tracker' do
        put :update, id: tracker.to_param, tracker: invalid_attributes
        expect(assigns(:tracker)).to eq(tracker)
      end

      it "re-renders the 'edit' template" do
        put :update, id: tracker.to_param, tracker: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested tracker' do
      tracker = create(:tracker)
      expect { delete :destroy, id: tracker.to_param }.to change(Comable::Tracker, :count).by(-1)
    end

    it 'redirects to the trackers list' do
      tracker = create(:tracker)
      delete :destroy, id: tracker.to_param
      expect(response).to redirect_to([comable, :admin, :trackers])
    end
  end
end
