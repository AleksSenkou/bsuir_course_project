require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = User.new(name: 'Alex', email: 'asd@gmail.com',
                   password: 'asdasdasd', password_confirmation: 'asdasdasd') }
  subject { @user }

  describe 'Content' do
    it { should respond_to :name }
    it { should respond_to :email }
    it { should respond_to :encrypted_password }
    it { should respond_to :signup_with_provider }
    it { should be_valid }
  end

  describe 'Name' do
    context 'is not present' do
      before { @user.name = '' }
      it { should_not be_valid }
    end

    context 'is too long' do
      before { @user.name = 'a' * 41 }
      it { should_not be_valid }
    end
  end

  describe 'Email' do
    context 'is not present' do
      before { @user.email = '' }
      it { should_not be_valid }
    end

    context 'format is not valid' do
      it 'should be invalid' do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
        addresses.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).not_to be_valid
        end
      end
    end

    context 'format is valid' do
      it 'should be valid' do
        addresses = %w[user@foo.COM user_at_foo@edc.org
                       example.user@foo.com.org foo@bazbar.com foo+baz@barbaz.com]
        addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end
    end

    context 'address is already taken' do
      before {
        user_with_same_email = @user.dup
        user_with_same_email.save
      }

      it { should_not be_valid }
    end
  end

  describe 'Password' do
    context 'is not present' do
      before { @user.password = '' }
      it { should_not be_valid }
    end

    context "dosn't match confirmation" do
      before { @user.password_confirmation = 'mismatch' }
      it { should_not be_valid }
    end

    context 'is too short' do
      before { @user.password = @user.password_confirmation = 'a' * 5 }
      it { should_not be_valid }
    end
  end
end
