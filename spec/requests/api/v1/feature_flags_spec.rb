# frozen_string_literal: true

describe 'GET admin/feature-flags' do
  subject(:request) { get '/admin/feature-flags' }

  context 'with an admin_user account' do
    let(:user) { create(:admin_user) }

    context 'with a valid session' do
      before { sign_in user }

      it 'shows the feature flags page' do
        expect(request).to redirect_to('/admin/feature-flags/features')
      end
    end

    context 'without a valid session' do
      it 'redirects the user to the admin login page' do
        expect(request).to redirect_to('/admin/login')
      end
    end
  end

  context 'with a user account' do
    let(:user) { create(:user) }

    context 'with a valid session' do
      before { sign_in user }

      it 'blocks user access to the feature flags page' do
        expect(request).not_to redirect_to('/admin/feature-flags/features')
      end
    end
  end
end
