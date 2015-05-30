require "rails_helper"

describe 'Static pages' do
  subject { page }

  describe "Home page" do
    before { visit root_path }

    context 'content' do
      it { should have_title "Bulletin Board" }
      it { should have_link "Bulletin Board", href: root_path }
    end

    context "for non sign-in user" do
      it { should have_link "Login", href: new_user_session_path }
      it { should have_link "Sign up", href: new_user_registration_path }
    end

    describe "for sign-in user" do
      let(:user) { FactoryGirl.create :user }
      before { sign_in user }

      it { should have_link 'Log out', href: destroy_user_session_path }
      it { should have_link 'Profile' }
      it { should have_link '+', href: new_advert_path }
      it { should_not have_link 'Login' }
      it { should have_selector 'button', text: 'Menu' }
      it { should have_selector 'img' }

      context "'add advert' link" do
        before { click_link '+' }
        it { should have_content "New advert" }
        it { should have_selector "button" }
      end
    end

    describe 'for sign-up user' do
      context 'without provider' do
        let(:user) { FactoryGirl.create :user }
        before { sign_in user }

        it { should have_link "Settings", href: edit_user_registration_path }
        it { should_not have_link "Change avatar" }
      end

      context 'with provider' do
        before {
          user_with_provider = User.create(name: 's',
                                           email: 'sd@gd.com',
                                           password: 'asdasdasd',
                                           password_confirmation: 'asdasdasd',
                                           signup_with_provider: true)
          sign_in user_with_provider
        }

        it { should have_link('Change avatar',
                              href: "http://gravatar.com/emails") }
        it { should_not have_link 'Settings' }
      end
    end

    describe 'for admin user' do
      let(:admin) { FactoryGirl.create :admin }
      before {
        sign_in admin
      }

      it { should have_link 'Settings' }
      it { should have_link 'Log out' }
      it { should have_link('Users', href: all_users_path) }
      it { should have_link('Adverts', href: all_adverts_path) }
    end
  end
end
