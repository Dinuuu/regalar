require 'spec_helper'

describe User do
  let!(:user) { create :user }
  let!(:organization) { create :organization }
  let!(:wish_item) { create :wish_item, organization: organization }
  let!(:donations) do
    create_list :donation, 10, user: user, wish_item: wish_item,
                               organization: organization, done: true
  end
  let!(:level1) { create :level, level: 1, from: 0, to: 10 }
  let!(:level2) { create :level, level: 2, from: 10, to: 20 }
  let!(:level3) { create :level, level: 3, from: 20, to: 30 }
  describe '#level' do
    context 'When asking for the level of the user' do
      it 'returns the second level' do
        expect(user.level).to eq level2
      end
    end
  end
end
