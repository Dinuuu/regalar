require 'spec_helper'

describe Organization do
  let!(:user) { create :user }
  let!(:organization) { create :organization }
  let!(:organization2) { create :organization }
  describe '#create' do
    context 'Creating an invalid organization' do
      it 'validates the name' do
        organization.name = nil
        expect(organization.valid?).to be false
        expect(organization.errors[:name]).not_to be_nil
      end
      it 'validates the description' do
        organization.description = nil
        expect(organization.valid?).to be false
        expect(organization.errors[:description]).not_to be_nil
      end
      it 'validates the locality' do
        organization.locality = nil
        expect(organization.valid?).to be false
        expect(organization.errors[:locality]).not_to be_nil
      end
      it 'validates the email' do
        organization.email = nil
        expect(organization.valid?).to be false
        expect(organization.errors[:email]).not_to be_nil
      end
      it 'validates the logo' do
        organization.remove_logo!
        expect(organization.valid?).to be false
        expect(organization.errors[:logo]).not_to be_nil
      end
      it 'validates the website' do
        organization.website = 'InvalidWebsite'
        expect(organization.valid?).to be false
        expect(organization.errors[:website]).not_to be_nil
      end
    end
    context 'Creating a valid organization' do
      it 'creates the organization' do
        expect(organization.valid?).to be true
      end
    end
  end
  describe '#pending_donations' do
    context 'when user belongs to organization' do
      before :each do
        organization.users << user
      end
      let!(:wish_item) { create :wish_item, organization: organization, quantity: 10 }
      let!(:wish_item2) { create :wish_item, organization: organization2, quantity: 10 }
      let!(:donations_done) do
        create_list :donation, 5, wish_item: wish_item, user: user,
                                  organization: organization, done: true
      end
      let!(:donations_undone) do
        create_list :donation, 3, wish_item: wish_item, user: user,
                                  organization: organization, done: false
      end
      let!(:donations_done2) do
        create_list :donation, 9, wish_item: wish_item2, user: user,
                                  organization: organization2, done: true
      end
      let!(:donations_undone2) do
        create_list :donation, 7, wish_item: wish_item2, user: user,
                                  organization: organization2, done: false
      end
      context 'asking for pending donations' do
        it 'returns donations that are pending' do
          expect(organization.pending_donations.all? { |donation| donation[:done] }).to be false
        end
        it 'returns donations of organization' do
          expect(organization.pending_donations
            .all? { |donation| donation[:organization_id] == organization.id }).to be true
        end
        it 'has to be 3' do
          expect(organization.pending_donations.count).to eq 3
        end
      end
    end
  end
  describe '#confirmed_donations' do
    let!(:wish_item) { create :wish_item, organization: organization, quantity: 10 }
    let!(:wish_item2) { create :wish_item, organization: organization2, quantity: 10 }
    let!(:donations_done) do
      create_list :donation, 5, wish_item: wish_item, user: user,
                                organization: organization, done: true
    end
    let!(:donations_undone) do
      create_list :donation, 3, wish_item: wish_item, user: user,
                                organization: organization, done: false
    end
    let!(:donations_done2) do
      create_list :donation, 9, wish_item: wish_item2, user: user,
                                organization: organization2, done: true
    end
    let!(:donations_undone2) do
      create_list :donation, 7, wish_item: wish_item2, user: user,
                                organization: organization2, done: false
    end
    context 'asking for confirmed donations' do
      it 'returns donations that are confirmed' do
        expect(organization.confirmed_donations.all? { |donation| donation[:done] }).to be true
      end
      it 'returns donations of organization' do
        expect(organization.confirmed_donations
          .all? { |donation| donation[:organization_id] == organization.id }).to be true
      end
      it 'has to be 5' do
        expect(organization.confirmed_donations.count).to eq 5
      end
    end
  end
  describe '#search' do
    let!(:medicos_sin_fronteras) do
      create :organization, name: 'Medicos sin fronteras'
    end
    let!(:mediicos_sin_fronteras) do
      create :organization, name: 'Mediicos sin fronteras', description: 'mediicos'
    end
    let!(:hospital_publico) do
      create :organization, description: 'medicos para todos'
    end
    let!(:perros) do
      create :organization, name: 'Huellitas', description: 'Hogar para perros'
    end
    context 'When searching medico' do
      it 'returns 2 results' do
        expect(Organization.search('medico').count).to eq 2
      end
    end
  end
end
