require 'rails_helper'

describe ProfilesController do
  login_admin

  let!(:user) { create(:user, username: 'molly', email: 'molly-rspec@zoeoberon.com') }

  describe '#edit' do
    before do
      xhr :post, :edit, id: user.id
    end
    it 'sets @user' do
      expect(assigns(:user)).to_not be_nil
    end
    it 'renders the edit partial' do
      expect(response).to render_template(partial: 'profiles/partials/_edit')
    end
  end

  describe '#create' do
    describe 'with valid params' do
      it 'saves new user' do
        expect do
          xhr :post, :create, user: attributes_for(:user, username: 'fred', email: 'fred-rspec@zoeoberon.com')
        end.to change(User, :count)
      end
      it 'renders admin/partials/users partial' do
        xhr :post, :create, user: attributes_for(:user, username: 'fred', email: 'fred-rspec@zoeoberon.com')
        expect(response).to render_template(partial: 'admin/partials/_users')
      end
    end
    describe 'with invalid params' do
      it 'does not save user and displays an error message' do
        expect do
          xhr :post, :create, user: attributes_for(:user, username: nil, email: nil)
        end.to_not change(User, :count)
        expect(response.body).to match(/alert_box/)
      end
    end
  end

  describe '#update' do
    describe 'with valid params' do
      before do
        xhr :post, :update, user: {username: 'janet'}, id: user.id
      end
      it 'update the user' do
        user.reload
        expect(user.username).to eq('janet')
      end
      it 'sets a list of users' do
        expect(assigns(:users).count).to eq(2)
      end
      it 'renders admin/partials/users partial' do
        expect(response).to render_template(partial: 'admin/partials/_users')
      end
    end
    describe 'with invalid params' do
      it 'does not update user and stay on edit form' do
        expect do
          xhr :post, :update, user: {username: nil, email: nil}, id: user.id
        end.to_not change(User, :count)
        expect(response).to render_template(partial: 'profiles/partials/_edit')
      end
    end
  end

  describe '#destroy' do
    let!(:another_user) { create(:user, username: 'fred', email: 'fred@example.com') }
    it 'deletes the user' do
      expect do
        xhr :delete, :destroy, id: another_user, format: 'js'
      end.to change(User, :count).by(-1)
    end
    it 'sets list of users' do
      xhr :delete, :destroy, id: another_user, format: 'js'
      expect(assigns(:users).count).to eq(2)
    end
    it 'renders admin/partials/users partial' do
      xhr :delete, :destroy, id: another_user, format: 'js'
      expect(response).to render_template(partial: 'admin/partials/_users')
    end
  end

end
