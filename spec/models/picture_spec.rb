require 'rails_helper'

RSpec.describe Picture, type: :model do
  before {
    @user = FactoryGirl.create :user
    @advert = FactoryGirl.create(:advert, user: @user)
    @picture = FactoryGirl.create(:picture, advert: @advert)
  }

  subject { @picture }

  describe 'Content' do
    it { should respond_to :image }
    it { should respond_to :image_file_name }
    it { should respond_to :image_file_size }
    it { should respond_to :image_content_type }
    it { should respond_to :advert }
    it { should be_valid }
  end

  describe 'When advert_id is empty' do
    before { @picture.advert_id = '' }
    it { should be_valid }
  end
end

