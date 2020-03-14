FactoryBot.define do
  factory :supplier do
    sequence(:name) { |n| "Supplier #{n}" }
    token { SecureRandom.hex(12) } # the limit is 24 chars; SecureRandom#hex returns 2n chars
  end
end
