require 'spec_helper'

describe GiftItem do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:gift_item) { create :gift_item }

  describe '#create' do
    context 'Creating an invalid gift_item' do
      it 'validates the title' do
        gift_item.title = nil
        expect(gift_item.valid?).to be false
        expect(gift_item.errors[:title]).not_to be_nil
      end
      it 'validates the quantity' do
        gift_item.quantity = nil
        expect(gift_item.valid?).to be false
        expect(gift_item.errors[:quantity]).not_to be_nil
      end
      it 'validates the unit' do
        gift_item.unit = nil
        expect(gift_item.valid?).to be false
        expect(gift_item.errors[:unit]).not_to be_nil
      end
      it 'validates the description' do
        gift_item.description = nil
        expect(gift_item.valid?).to be false
        expect(gift_item.errors[:description]).not_to be_nil
      end
      it 'validates the used_time' do
        gift_item.used_time = nil
        expect(gift_item.valid?).to be false
        expect(gift_item.errors[:used_time]).not_to be_nil
      end
      it 'validates the status' do
        gift_item.status = nil
        expect(gift_item.valid?).to be false
        expect(gift_item.errors[:status]).not_to be_nil
      end
    end
    context 'Creating a valid gift_item' do
      it 'creates the gift_item' do
        expect(gift_item.valid?).to be true
      end
    end
    context 'Creating a valid gift item with images' do
      it 'is valid' do
        expect(GiftItem.new(gift_item.attributes
                            .merge(gift_item_images_attributes: [file: Rack::Test::UploadedFile
                            .new(File.open(File.join(Rails.root,
                                                     '/spec/fixtures/images/default_pic.png')
                            ))]).to_h)).to be_valid
      end
    end
  end
  describe '#search' do
    let!(:gift_items_silla) do
      create_list :gift_item, 2, title: 'sillas'
    end
    let!(:gift_items_silla_caps) do
      create_list :gift_item, 2, title: 'SILLA'
    end
    let!(:gift_items_sillas) do
      create_list :gift_item, 3, description: 'Se regalan asillas de interior'
    end
    let!(:gift_items_sillas_caps) do
      create_list :gift_item, 3, description: 'SE regalan AASILLASSSS'
    end
    let!(:gift_items_witout_sillas) do
      create_list :gift_item, 4, title: 'mesas', description: 'Mesas para comer de madera'
    end
    context 'When searching silla' do
      it 'returns 10 results' do
        expected_size = gift_items_silla.count + gift_items_silla_caps.count +
                        gift_items_sillas.count + gift_items_sillas_caps.count
        expect(GiftItem.search('silla').count).to eq expected_size
      end
    end
  end
end
