FactoryGirl.define do
  factory :advert do
    user
    name "mytring"
    description "MyString"
    type 'Sale'
    price "9.99"
  end
end
