# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :party, aliases: [:winner, :server] do
    name "Fred"
  end
end
