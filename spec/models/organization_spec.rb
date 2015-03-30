require 'spec_helper'

describe Organization do
  let!(:organization) { build(:organization) }
  describe '#create' do
    context 'Creating an invalid organization' do
      it 'validates the name' do
        organization.name = nil
        expect(organization.valid?).to be false
        expect(organization.errors).not_to be_nil
      end
      it 'validates the description' do
        organization.description = nil
        expect(organization.valid?).to be false
        expect(organization.errors).not_to be_nil
      end
      it 'validates the locality' do
        organization.locality = nil
        expect(organization.valid?).to be false
        expect(organization.errors).not_to be_nil
      end
      it 'validates the email' do
        organization.email = nil
        expect(organization.valid?).to be false
        expect(organization.errors).not_to be_nil
      end
    end
    context 'Creating a valid organization' do
      it 'creates the organization' do
        expect(organization.valid?).to be true
      end
    end
  end
end
