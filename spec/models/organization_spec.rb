require 'spec_helper'

describe Organization do

  let(:organization) { build(:organization) }

  describe '#create' do

    context 'Creating an invalid organization' do

      it 'validates the name' do
        organization.name = nil
        expect(organization.valid?).to be false
        expect(organization).to have(1).error_on(:name)
      end

      it 'validates the description' do
        organization.description = nil
        expect(organization.valid?).to be false
        expect(organization).to have(1).error_on(:description)
      end

      it 'validates the locality' do
        organization.locality = nil
        expect(organization.valid?).to be false
        expect(organization).to have(1).error_on(:locality)
      end

    end

    context 'Creating a valid organization' do

      it 'creates the organization' do
        expect(organization.valid?).to be true
      end

    end

  end

end
