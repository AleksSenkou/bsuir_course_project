require "rails_helper"

RSpec.describe 'Admin pages', type: :request do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.create :user, name: '1' }
  before(:each) { sign_in admin }

  subject { page }

  # describe 'Delete links' do
  #   it { should_not have_link 'delete' }

  #   describe 'as an admin user' do
  #     before {
  #       visit users_path
  #     }

  #     it { should have_link('Delete', href: user_path(user)) }
  #     it "should be able to delete another user" do
  #       expect do
  #         click_link('Delete')
  #       end.to change(User, :count).by(-1)
  #     end
  #     it { should_not have_link("Delete", href: user_path(admin)) }
  #   end
  # end

  describe 'Users index' do
    let(:user2) { FactoryGirl.create :user, name: '2' }
    before(:each) {
      visit all_users_path
    }

    context 'content' do
      it { should have_content 'Adverts count:' }
      it { should have_link 'Show' }
      # it { should have_content 'Delete' }
    end

    # context 'user info' do
    #   it { should have_content user.name }
    #   it { should have_content user.adverts.count }
    #   it { should have_selector 'a.gravatar' }
    # end

    # context 'pagination' do
    #   before { 25.times { FactoryGirl.create :user } }
    #   after { User.delete_all }

    #   it 'should list each user' do
    #     User.paginate(page: 1, per_page: 25).each do |user|
    #       expect(page).to have_selector('li', text: user.name)
    #     end
    #   end
    # end
  end
end
