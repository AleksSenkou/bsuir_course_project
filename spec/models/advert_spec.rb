require 'rails_helper'

RSpec.describe Advert, type: :model do
  before {
    @user = FactoryGirl.create :user
    @advert = @user.adverts.build(name: 'asd', description: 'ad',
                                        price: 23, type: 'Sale')
  }

  subject { @advert }

  context 'Content' do
    it { should respond_to :name }
    it { should respond_to :description }
    it { should respond_to :price }
    it { should respond_to :type }
    it { should respond_to :user }
    it { should be_valid }
    its(:user) { should eq @user }
  end

  context 'user_id is empty' do
    before { @advert.user_id = '' }
    it { should_not be_valid }
  end

  describe 'Name' do
    context 'is too long' do
      before { @advert.name = 'a' * 41 }
      it { should_not be_valid }
    end

    context 'is empty' do
      before { @advert.name = '' }
      it { should_not be_valid }
    end
  end

  describe 'Description' do
    context 'is too long' do
      before { @advert.description = 'a' * 4001 }
      it { should_not be_valid }
    end

    context 'is empty' do
      before { @advert.description = '' }
      it { should_not be_valid }
    end
  end

  describe 'Price' do
    context 'is less then 0' do
      before { @advert.price = -2 }
      it { should_not be_valid }
    end

    context 'is greater then 1_000_000' do
      before { @advert.price = 1_000_001 }
      it { should_not be_valid }
    end
  end

  describe 'Type' do
    context 'from Advert::TYPES' do
      before { @advert.type = "Rent" }
      it { should be_valid }
    end

    context 'not from TYPES' do
      before { @advert.type = 'ad' }
      it { should_not be_valid }
    end
  end
end
