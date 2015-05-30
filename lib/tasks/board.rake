require "faker"
require "populator"

USERS_COUNT = 10
IDENTITES_COUNT = 1

namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    clean_database
    make_users
    make_adverts
    make_pictures_for_adverts
    make_vote
  end
end

def clean_database
  [User, Identity].each(&:delete_all)
end

def make_users
  User.create(name: 'alex',
              email: 'aleksey.senkou@gmail.com',
              password: 'zxczxczxc',
              password_confirmation: 'zxczxczxc',
              admin: true)

  USERS_COUNT.times {
    name                 = Faker::Name.name
    email                = Faker::Internet.free_email
    password             = Faker::Internet.password(8)
    signup_with_provider = (1 == rand(2) ? true : false)

    user = User.create(name: name, email: email, password: password,
                       password_confirmation: password,
                       signup_with_provider: signup_with_provider)

    if user.signup_with_provider
      Identity.populate IDENTITES_COUNT do |identity|
        identity.user_id  = user.id
        identity.provider = ['twitter', 'facebook']
        identity.uid      = Faker::Number.number(10)
      end
    end
  }
end
