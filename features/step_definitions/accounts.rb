
Given(/^I have deposited \$(\d+) in my (\w+) Account$/) do |num, account_type|
  @info = {}
  @info[account_type] = num.to_i
end

When(/^I transfer \$(\d+) from my (\w+) Account into my (\w+) Account$/) do |num, first_account_type, second_account_type|
  if @info[first_account_type] < num.to_i
    raise '__ Num is biger then account amount __'
  end
  @info[second_account_type] += num.to_i
  @info[first_account_type] -= num.to_i
end

Then(/^the balance of the (\w+) Account should be \$(\d+)$/) do |account_type, num|
  expect(@info[account_type]).to eq num.to_i
end
