FactoryBot.define do
  factory :teaching_method do
    sequence(:name) { |n| "Teaching method #{n}" }
    sequence(:icon) { |n| "teaching-method-#{n}" }
    sequence(:description) { |n| "Teaching method description #{n}" }

    trait(:randomised) do
      name { Faker::Lorem.sentence }
      icon { Faker::Lorem.words.join('-').downcase }
      description { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    end
  end
end
