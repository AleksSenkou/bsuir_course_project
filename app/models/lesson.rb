class Lesson < ActiveRecord::Base
  has_many :options, dependent: :destroy
  belongs_to :schedule
end
