require "rails_helper"

RSpec.describe 'Advert pages' do
  let(:user) { FactoryGirl.create :user }
  before { sign_in user }

  subject { page }

  describe 'New' do
    before { visit new_advert_path }

    context "content" do
      it { should have_content 'New advert' }
      it { should have_content 'Name' }
      it { should have_content 'Description' }
      it { should have_content 'Price' }
      it { should have_selector 'button' }
      it { should have_selector 'div#form-advert-file' }
    end

    context 'with valid info' do
      let(:name) { 'Advert name' }
      before {
        fill_in 'Name', with: name
        fill_in 'Description', with: 'Description'
        fill_in 'Price', with: 32
        click_button 'New'
      }

      it { should have_content name }
      it { should have_content '32' }
      it { should have_selector 'div.alert.alert-notice' }
    end

    context 'with invalid info' do
      let(:advert) { FactoryGirl.create(:advert, user: user) }
      before {
        fill_in "Name", with: advert.name
        fill_in "Description", with: ''
        fill_in "Price", with: advert.price
      }

      it "should not create a advert" do
        expect { click_button 'New' }.not_to change(Advert, :count)
      end
    end
  end

  describe 'Show' do
    let(:advert) { FactoryGirl.create(:advert, user: user) }
    before { visit advert_path advert }

    context 'content' do
      it { should have_content advert.name.capitalize }
      it { should have_content advert.description }
      it { should have_content advert.price }
      it { should have_content advert.type }
    end

    # context 'with image' do
    #   let(:picture) { FactoryGirl.create(:picture, advert: advert) }
    #   it { should have_selector 'div.show-advert-image' }
    # end

    context 'without image' do
      it { should_not have_css 'img', text: 'robot.png' }
    end

    context 'current user == user who created' do
      it { should have_link 'Edit this advert' }
      it { should_not have_selector 'a.avatar' }
    end

    context 'not the user who created' do
      let(:user_fake) { FactoryGirl.create :user, email: 'fake@fake.fake' }
      before {
        click_link 'Log out'
        sign_in user_fake
        visit advert_path advert
      }

      it { should_not have_link 'Edit this advert' }
      it { should have_selector 'a.avatar' }
      it { should have_css "img[src*='gravatar']" }
      it { should have_content user.name }
    end

    context 'admin user' do
      let(:admin) { FactoryGirl.create :admin }
      before {
        click_link 'Log out'
        sign_in admin
        visit advert_path advert
      }

      it { should have_selector 'a.avatar' }
      it { should have_content advert.user.name }
      it { should have_link('Edit', href: edit_advert_path(advert)) }
    end
  end

  describe 'Edit' do
    let(:advert) { FactoryGirl.create :advert, user: user }
    let(:picture) { FactoryGirl.create :picture, advert: advert }
    before { visit edit_advert_path advert }

    context 'content' do
      it { should have_content 'Edit advert' }
      it { should have_content advert.description }
      it { should have_content advert.type }
      it { should have_link('Delete advert', href: advert_path(advert)) }
      it { should have_link 'Cancel' }
      it { should have_button 'Edit' }
    end

    context 'with valid info' do
      let(:new_name) { 'Advert' }
      let(:new_description) { 'Description' }
      before {
        fill_in 'Name', with: new_name
        fill_in 'Description', with: new_description
        fill_in 'Price', with: advert.price
        click_button 'Edit'
      }

      it { should have_selector 'div.alert.alert-notice.alert-dismissible' }
      it { should have_link 'Edit this advert' }
      specify { expect(advert.reload.name).to        eq new_name }
      specify { expect(advert.reload.description).to eq new_description }
    end

    # describe 'image' do
    #   it { should have_link('Delete', href: picture_path(picture)) }

    #   context 'delete' do
    #     before {
    #       click_link 'Delete', href: "/pictures/1"
    #       visit edit_advert_path advert
    #     }

    #     it { should_not have_css("img[src*='robot']") }
    #   end
    # end
  end
end
