class Schedule < ActiveRecord::Base
  validates :group_number,
    numericality: { only_integer: true,
                    greater_than_or_equal_to: 112601,
                    less_than_or_equal_to: 474003 }
end
