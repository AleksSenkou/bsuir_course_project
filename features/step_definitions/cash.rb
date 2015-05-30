Given(/^I have deposited \$(\d+) in my account$/) do |num|
  @money = num.to_i
end

When(/^I request \$(\d+)$/) do |num|
  @dispensed_money = num.to_i
  if @money < @dispensed_money
    raise "Big number"
  end
  @money -= @dispensed_money
end

Then(/^\$(\d+) should be dispensed$/) do |num|
  expect(@dispensed_money).to eq num.to_i
end
