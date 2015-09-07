require 'rails_helper'

RSpec.describe Asset, type: :model do
  before { delete_db }

  describe '.authorized_for' do
    let(:user) { create(:user) }
    let(:asset_is_private) { false }
    let(:asset_properties) { {private: asset_is_private} }
    let!(:asset) { create(:asset, asset_properties) }
    subject { Asset.authorized_for(user) }

    it { should match_array([asset]) }

    let_context user: nil do
      it { should match_array([asset]) }
    end

    let_context asset_is_private: true do
      it { should match_array([]) }

      context 'user has access to asset' do
        before { asset.allowed_users << user }

        it { should match_array([asset]) }
      end

      context 'asset has category' do
        let(:category) { create(:category) }
        before { asset.categories << category }

        context 'user has access to category' do
          before { category.allowed_users << user }

          it { should match_array([asset]) }
        end
      end
    end
  end
end
