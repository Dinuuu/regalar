require 'spec_helper'

describe UserGiftRequestsController do
  let!(:user) { create :user }
  let!(:organization) { create :organization }
  let!(:organization2) { create :organization }
  let!(:gift_item) { build :gift_item }
  describe '#confirm' do
    context 'When logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'When user owns the gift item' do
        before :each do
          gift_item.update_attributes(user: user)
        end
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
              expect(gift_request.reload.done).to be true
            end
            it 'redirects' do
              post :confirm, id: gift_request.id
              expect(response.status).to eq 302
            end
            it 'redirects to gift_item' do
              post :confirm, id: gift_request.id
              expect(response).to redirect_to user_gift_item_path(user, gift_item)
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
          end
          context 'When having something to give' do
            before(:each) do
              gift_item.update_attributes(given: 0, quantity: 10)
            end
            context 'When asking more than what is left' do
              before(:each) do
                gift_request.update_attributes(quantity: 15)
              end
              it 'increments given to quantity' do
                post :confirm, id: gift_request.id
                expect(gift_item.reload.given).to eq gift_item.quantity
              end
            end
            context 'When asking less that what is left' do
              before(:each) do
                gift_request.update_attributes(quantity: 5)
              end
              it 'increments given gift_request.quantity' do
                expect { post :confirm, id: gift_request.id }
                  .to change { gift_item.reload.given }.by gift_request.quantity
              end
            end
          end
        end
      end
      context 'When user does not own the gift item' do
        let!(:user2) { create :user }
        before :each do
          gift_item.update_attributes(user: user2)
        end
        let!(:gift_request) do
          create :gift_request, organization: organization, user: user2, gift_item: gift_item
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
        end
      end
    end
  end
  describe '#cancel' do
    context 'When logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'When user owns the gift item' do
        before :each do
          gift_item.update_attributes(user: user)
        end
        let!(:gift_request) do
          create :gift_request, organization: organization, user: user, gift_item: gift_item
        end
        it 'destroys the gift request' do
          expect { delete :cancel, id: gift_request }.to change { GiftRequest.count }.by(-1)
        end
        it 'redirects to gift_item' do
          delete :cancel, id: gift_request
          expect(response).to redirect_to user_gift_item_path(user, gift_item)
        end
      end
      context 'When user does not own the gift item' do
        let!(:user2) { create :user }
        before :each do
          gift_item.update_attributes(user: user2)
        end
        let!(:gift_request) do
          create :gift_request, organization: organization, user: user2, gift_item: gift_item
        end
        context 'When trying to cancel a request' do
          it 'responds status forbidden' do
            delete :cancel, id: gift_request.id
            expect(response.status).to eq 403
          end
        end
      end
    end
  end
  describe '#show' do
    context 'When user is logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'When user owns the gift item' do
        before :each do
          gift_item.update_attributes(user: user)
        end
        let!(:gift_request) do
          create :gift_request, organization: organization, user: user, gift_item: gift_item
        end
        it 'render the gift_request' do
          get :show, id: gift_request.id
          expect(response).to render_template :show
        end
        it 'responds status okey' do
          get :show, id: gift_request.id
          expect(response).to be_success
        end
      end
      context 'When user does not own the gift item' do
        let!(:user2) { create :user }
        before :each do
          gift_item.update_attributes(user: user2)
        end
        let!(:gift_request) do
          create :gift_request, organization: organization, user: user2, gift_item: gift_item
        end
        it 'responds status forbidden' do
          get :show, id: gift_request.id
          expect(response.status).to eq 403
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
        get :show, id: gift_request.id
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
