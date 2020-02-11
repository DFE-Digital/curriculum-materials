FactoryBot.define do
  factory :resource do
    activity { nil }
    name { "MyString" }
    sha256 { "MyString" }
    taxonomies { "MyText" }
    uri { "MyText" }
  end
end
