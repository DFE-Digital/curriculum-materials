FactoryBot.define do
  factory :teacher do
    token { SecureRandom.uuid }
  end
end
