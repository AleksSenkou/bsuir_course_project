require "rails_helper"

describe 'Authentication pages' do
  subject { page }

  describe 'Login page' do
    before { visit new_user_session_path }

    context 'with invalid info' do
      before { click_button 'Login' }

      it { should have_content 'Login' }
      it { should have_link 'Sign up' }
    end

    context 'with valid info' do
      let(:user) { FactoryGirl.create :user }
      before { sign_in user }

      it { should have_link 'Profile', href: user_path(user) }
      it { should have_link 'Log out', href: destroy_user_session_path }
      it { should_not have_link 'Login' }
      it { should have_selector 'div.alert.alert-notice.alert-dismissible' }
    end
  end

  describe 'Sign up page' do
    let(:submit) { "Sign up" }
    before { visit new_user_registration_path }

    context 'with invalid info' do
      it 'should not create a user' do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before {
        fill_in "Name",                  with: "Example User"
        fill_in "Email",                 with: "user@example.com"
        fill_in "Password",              with: "foobarfoo"
        fill_in "Password confirmation", with: "foobarfoo"
      }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      context "after saving the user" do
        before { click_button submit }
        it { should have_selector("div.alert.alert-notice.alert-dismissible") }
      end
    end
  end

  describe 'When attempting to visit a protected page' do
    let(:user) { FactoryGirl.create :user }

    context 'visiting the settings page' do
      before { visit edit_user_registration_path }
      it { should have_content 'Login' }
    end

    context 'visiting the user page' do
      before { visit user_path user }
      it { should have_content 'Login' }
    end

    context 'after sign in' do
      before {
        visit edit_user_registration_path
        sign_in user
      }

      it 'should render the desired protected page' do
        expect(page).to have_content 'Settings'
      end
    end
  end
end
