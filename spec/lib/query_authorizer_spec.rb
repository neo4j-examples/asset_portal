require 'rails_helper'
require './lib/query_authorizer'

RSpec.describe QueryAuthorizer do
  before { delete_db }

  let(:query) { Query.new }
  let(:query_authorizer) { QueryAuthorizer.new(query) }

  let(:asset_is_private) { false }
  let!(:asset) { create(:asset, private: asset_is_private) }
  let(:user_is_admin) { false }
  let(:user) { create(:user, admin: user_is_admin) }

  let(:query) { Asset.as(:a) }

  describe '#authorized_query' do
    let(:authorized_query) { query_authorizer.authorized_query(:a, user) }
    subject { authorized_query }

    describe 'level result' do
      subject { authorized_query.pluck(:level) }

      it { should match_array(['read']) }

      let_context user_is_admin: true do
        it { should match_array(['write']) }
      end

      let_context asset_is_private: true do
        it { should match_array([]) }

        let_context user_is_admin: true do
          it { should match_array(['write']) }
        end

        context 'user is creator of assets' do
          before { asset.creators << user }
          it { should match_array(['write']) }
        end

        context 'user has permission to read' do
          before { asset.allowed_users.create(user, level: 'read') }
          it { should match_array(['read']) }
        end

        context 'user has permission to write' do
          before { asset.allowed_users.create(user, level: 'write') }
          it { should match_array(['write']) }
        end
      end
    end
  end
  describe '#authorized_pluck' do
    subject { query_authorizer.authorized_pluck(:a, user).to_a }

    let_context query: nil do
      it { expect { subject }.to raise_error(ArgumentError, /Expected query_object to be queryish/) }
    end
    let_context query: 'test' do
      it { expect { subject }.to raise_error(ArgumentError, /Expected query_object to be queryish/) }
    end

    it { should match_array([asset]) }

    let_context asset_is_private: true do
      it { should match_array([]) }

      let_context user_is_admin: true do
        it { should match_array([asset]) }
      end

      context 'user is creator of assets' do
        before { asset.creators << user }
        it { should match_array([asset]) }
      end

      context 'user has permission to view' do
        before { asset.allowed_users.create(user, level: 'read') }
        it { should match_array([asset]) }
      end



      context 'user is a member of a group' do
        let(:group) { Group.create }
        before { user.groups << group }

        it { should match_array([]) }

        context 'asset is explictly assigned to group' do
          before { asset.allowed_groups.create(group, level: 'read') }

          it { should match_array([asset]) }
        end

        context 'assign is explicitly assign to another group' do
          let(:other_group) { Group.create }
          before { asset.allowed_groups.create(other_group, level: 'read') }

          it { should match_array([]) }
        end

        context 'the group has a subgroup' do
          let(:sub_group) { Group.create }
          before { sub_group.parent = group }

          it { should match_array([]) }

          context 'asset is implicitly assigned via the subgroup' do
            before { asset.allowed_groups.create(sub_group, level: 'read') }

            it { should match_array([asset]) }
          end
        end

        context 'the group has a parent' do
          let(:parent) { Group.create }
          before { group.parent = parent }

          context 'the asset is explictly assigned to another sub group' do
            let(:other_sub_group) { Group.create }
            before { other_sub_group.parent = parent }
            before { asset.allowed_groups.create(other_sub_group, level: 'read') }

            it { should match_array([]) }
          end
        end
      end
    end
  end
end
