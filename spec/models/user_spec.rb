require 'rails_helper'

describe 'User' do
  describe '#accessible_assets' do
    before { delete_db }

    let(:user) { User.create }
    subject { user.accessible_assets }

    context 'a public asset' do
      let(:asset) { Asset.create(public: true) }

      it { should include(asset) }
    end

    context 'a private asset' do
      let(:asset) { Asset.create(public: false) }

      context 'asset is not explictly assigned' do
        it { should_not include(asset) }
      end

      context 'asset is explictly assigned to user' do
        before { asset.allowed_users << user }
        it { should include(asset) }
      end

      context 'user is a member of a group' do
        let(:group) { Group.create }
        before { user.groups << group }

        it { should_not include(asset) }

        context 'asset is explictly assigned to group' do
          before { asset.allowed_groups << group }

          it { should include(asset) }
        end

        context 'assign is explicitly assign to another group' do
          let(:other_group) { Group.create }
          before { asset.allowed_groups << other_group }

          it { should_not include(asset) }
        end

        context 'the group has a subgroup' do
          let(:sub_group) { Group.create }
          before { sub_group.parent = group }

          it { should_not include(asset) }

          context 'asset is implicitly assigned parent group via the subgroup' do
            before { asset.allowed_groups << sub_group }

            it { should include(asset) }
          end
        end

        context 'the group has a parent' do
          let(:parent) { Group.create }
          before { group.parent = parent }

          context 'the asset is explictly assigned to another sub group' do
            let(:other_sub_group) { Group.create }
            before { other_sub_group.parent = parent }
            before { asset.allowed_groups << other_sub_group }

            it { should_not include(asset) }
          end
        end
      end

    end
  end
end
