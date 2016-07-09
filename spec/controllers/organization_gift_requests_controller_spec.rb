require 'spec_helper'

describe OrganizationGiftRequestsController do
  let!(:user) { create :user }
  let!(:user2) { create :user }
  let!(:organization) { create :organization, users: [user] }
  let!(:organization2) { create :organization }
  let!(:gift_item) { create :gift_item, user: user2, quantity: 30 }
  let!(:gift_request) do
    build :gift_request, organization: organization, user: user2,
                         gift_item: gift_item, quantity: 20
  end
  before(:each) do
    request.env['HTTP_REFERER'] = organizations_url
  end
  describe '#create' do
    context 'When logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'when creating a valid gift_request' do
        it 'increments the gift_requests by one' do
          (expect do
            post :create, user_id: user2.id,
                          gift_item_id: gift_item.id, gift_request: gift_request.attributes
          end).to change(GiftRequest, :count).by(1)
        end
        it 'returns http redirect' do
          post :create, user_id: user2.id,
                        gift_item_id: gift_item.id, gift_request: gift_request.attributes
          expect(response.status).to eq 302
        end
        it 'sends two email' do
          (expect do
            post :create, user_id: user2.id, gift_item_id: gift_item.id,
                          gift_request: gift_request.attributes
          end).to change { ActionMailer::Base.deliveries.count }.by(2)
        end
      end
      context 'when trying to create a request for a organization that you do not belongs to' do
        before :each do
          gift_request.organization = organization2
        end
        it 'does not change the amount of gift request' do
          (expect do
            post :create, user_id: user2.id, gift_item_id: gift_item.id,
                          gift_request: gift_request.attributes
          end).not_to change { GiftRequest.count }
        end
        it 'returns 403' do
          post :create, user_id: user2.id,
                        gift_item_id: gift_item.id, gift_request: gift_request.attributes
          expect(response.status).to eq 403
        end
        it 'does not send an email' do
          (expect do
            post :create, user_id: user2.id, gift_item_id: gift_item.id,
                          gift_request: gift_request.attributes
          end).not_to change { ActionMailer::Base.deliveries.count }
        end
      end
      context 'when trying to create a request for item with
               quantity greater of what it has to offer' do
        before :each do
          gift_request.quantity = gift_item.quantity - gift_item.given + 1
        end
        it 'does not change the amount of gift request' do
          (expect do
            post :create, user_id: user2.id, gift_item_id: gift_item.id,
                          gift_request: gift_request.attributes
          end).not_to change { GiftRequest.count }
        end
        it 'renders new' do
          post :create, user_id: user2.id,
                        gift_item_id: gift_item.id, gift_request: gift_request.attributes
          expect(response).to render_template :new
        end
      end
    end
  end
  describe '#destroy' do
    context 'When logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'when a gift item request exists and its not confirmed' do
        before :each do
          gift_request.save
        end
        let!(:reason) { { reason: Faker::Lorem.paragraph } }
        it 'decrements the amount of gift request by 1' do
          expect { delete :destroy, id: gift_request.id, donation: reason }
            .to change(GiftRequest, :count).by(-1)
        end
        it 'sends two emails' do
          (expect do
            delete :destroy, id: gift_request.id, donation: reason
          end).to change { ActionMailer::Base.deliveries.count }.by(2)
        end
        it 'redirects' do
          delete :destroy, id: gift_request.id, donation: reason
          expect(response.status).to eq 302
        end
      end
      context 'when a gift item exists but it is confirmed' do
        before :each do
          gift_request.done = true
          gift_request.save
        end
        it 'does not change the amount of gift request' do
          expect { delete :destroy, id: gift_request.id }
            .not_to change { GiftRequest.count }
        end
        it 'returns 403' do
          delete :destroy, id: gift_request.id
          expect(response.status).to eq 403
        end
        it 'does not send an email' do
          (expect do
            delete :destroy, id: gift_request.id
          end).not_to change { ActionMailer::Base.deliveries.count }
        end
      end
    end
    context 'When logged with a user that does not belongs to the
             organization that owns the gift request' do
      before :each do
        sign_in user2
        user2.reload
      end
      context 'when the gift item exists and that not belongs to the org' do
        before :each do
          gift_request.save
        end
        it 'does not change the amount of gift request' do
          expect { delete :destroy, id: gift_request.id }
            .not_to change { GiftRequest.count }
        end
        it 'returns 403' do
          delete :destroy, id: gift_request.id
          expect(response.status).to eq 403
        end
        it 'does not send an email' do
          (expect do
            delete :destroy, id: gift_request.id
          end).not_to change { ActionMailer::Base.deliveries.count }
        end
      end
    end
  end

  describe '#confirm' do
    context 'When logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'When the organization owns the gift request' do
        let!(:gift_request) do
          create :gift_request, organization: organization, user: user, gift_item: gift_item
        end
        context 'When confirming a gift_request' do
          context 'When gift_request done is false' do
            it 'changes done' do
              expect { post :confirm, id: gift_request.id }.to change { gift_request.reload.done }
            end
            it 'changes done to true' do
              post :confirm, id: gift_request.id
              gift_request.reload
              expect(gift_request.done).to be true
            end
            it 'redirects' do
              post :confirm, id: gift_request.id
              expect(response.status).to eq 302
            end
            it 'sends an email' do
              (expect do
                post :confirm, id: gift_request.id
              end).to change { ActionMailer::Base.deliveries.count }.by(1)
            end
          end
          context 'When gift_request done is true' do
            before(:each) do
              gift_request.update_attributes(done: true)
            end
            it 'responds status forbidden' do
              post :confirm, id: gift_request.id
              expect(response.status).to eq 403
            end
            it 'does not send an email' do
              (expect do
                post :confirm, id: gift_request.id
              end).not_to change { ActionMailer::Base.deliveries.count }
            end
          end
          context 'When nothing to give left' do
            before(:each) do
              gift_item.update_attributes(given: gift_item.quantity)
            end
            it 'responds status forbidden' do
              post :confirm, id: gift_request.id
              expect(response.status).to eq 403
            end
            it 'does not change done status' do
              expect { post :confirm, id: gift_request.id }
                .not_to change { gift_request.reload.done }
            end
            it 'does not change given of gift_item' do
              expect { post :confirm, id: gift_request.id }
                .not_to change { gift_item.reload.given }
            end
            it 'does not send an email' do
              (expect do
                post :confirm, id: gift_request.id
              end).not_to change { ActionMailer::Base.deliveries.count }
            end
          end
          context 'When asking more than what is left' do
            before(:each) do
              gift_request.update_attributes(quantity: 6)
            end
            context 'When having something to give' do
              before(:each) do
                gift_item.update_attributes(given: 5, quantity: 10)
              end
              it 'increments given to quantity' do
                post :confirm, id: gift_request.id
                gift_item.reload
                expect(gift_item.given).to eq gift_item.quantity
              end
            end
            context 'When asking less that what is left' do
              before(:each) do
                gift_request.update_attributes(quantity: 5)
              end
              it 'increments given gift_request.quantity' do
                expect { post :confirm, id: gift_request.id }
                  .to change { gift_item.reload.given }.by gift_request.reload.quantity
              end
            end
          end
        end
      end
      context 'When organization does not own the gift request' do
        let!(:gift_request) do
          create :gift_request, organization: organization2, user: user, gift_item: gift_item
        end
        context 'When trying to confirm a request' do
          it 'responds status forbidden' do
            post :confirm, id: gift_request.id
            expect(response.status).to eq 403
          end
          it 'does not change done status' do
            expect { post :confirm, id: gift_request.id }
              .not_to change { gift_request.reload.done }
          end
          it 'does not change given of gift_item' do
            expect { post :confirm, id: gift_request.id }.not_to change { gift_item.reload.given }
          end
          it 'does not send an email' do
            (expect do
              post :confirm, id: gift_request.id
            end).not_to change { ActionMailer::Base.deliveries.count }
          end
        end
      end
    end
    context 'When user is unlogged' do
      before :each do
        gift_item.update_attributes(user: user)
      end
      let!(:gift_request) do
        create :gift_request, organization: organization, user: user, gift_item: gift_item
      end
      it 'should render login page' do
        post :confirm, id: gift_request.id
        expect(response).to redirect_to '/users/sign_in'
      end
      it 'does not send an email' do
        (expect do
          post :confirm, id: gift_request.id
        end).not_to change { ActionMailer::Base.deliveries.count }
      end
    end
  end
end
