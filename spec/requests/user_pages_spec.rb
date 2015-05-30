require "rails_helper"

describe 'User pages' do
  let(:user) { FactoryGirl.create :user }
  before { sign_in user }

  subject { page }

  describe 'Show page' do
    before { visit user_path user }

    context 'content' do
      it { should have_title 'Bulletin Board' }
      it { should have_content user.name }
      it { should have_content user.email }
      it { should have_selector 'img' }
    end

    describe 'for page with advert' do
      let(:advert) { FactoryGirl.create(:advert, user: user) }

      context 'without upload image' do
        it { should have_selector 'img'}

        it "advert should have right user" do
          expect(advert.user).to eq user
        end
      end

      context 'with image' do
        let(:picture) { FactoryGirl.create(:picture, advert: advert) }

        it "picture should have right advert and user" do
          expect(picture.advert).to eq advert
          expect(picture.advert.user).to eq advert.user
        end
      end
    end

    describe 'for page without advert' do
      context 'current user' do
        it { should have_link 'New advert' }
        it { should have_content 'Oops' }
      end

      context 'nor current user' do
        before {
          click_link 'Log out'
          visit user_path user
        }

        it { should_not have_link 'New advert' }
        it { should_not have_content 'Oops' }
      end
    end
  end

  describe 'Settings page' do
    before { visit edit_user_registration_path }

    context 'content' do
      it { should have_content 'Settings' }
      it { should have_content 'Delete' }
      it { should have_content 'Cancel' }
      it { should have_link 'Change' }
    end

    context 'with valid info' do
      let(:new_name) { 'Alex' }
      let(:new_email) { 'alex@com.com' }
      before {
        fill_in 'Name', with: new_name
        fill_in 'Email', with: new_email
        fill_in 'Current password', with: user.password
        click_button 'Edit'
      }

      it { should have_selector 'div.alert.alert-notice.alert-dismissible' }
      it { should have_link 'Profile' }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

    context 'as admin' do
      let(:admin) { FactoryGirl.create :admin }
      before {
        click_link 'Log out'
        sign_in admin
        visit edit_user_registration_path admin
      }

      it { should_not have_link('Delete', href: user_path(admin)) }
    end
  end
end
