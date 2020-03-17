FactoryBot.define do
  slide_deck_path = File.join(Rails.application.root, 'spec', 'fixtures', 'slide_1_keyword_match_up.odp')
  attachment_path = File.join(Rails.application.root, 'spec', 'fixtures', '1px.png')

  factory :slide_deck_resource do
    association :activity, factory: :activity

    type { "SlideDeckResource" }

    after :build do |slide_deck_resource|
      slide_deck_resource.file.attach \
        io: File.open(slide_deck_path),
        filename: 'slide-1-keyword-match-up.odp',
        content_type: 'application/vnd.oasis.opendocument.presentation'
    end

    trait :with_preview do
      after :build do |slide_deck_resource|
        slide_deck_resource.preview.attach \
          io: File.open(attachment_path),
          filename: 'slide-deck-image.png',
          content_type: 'image/png'
      end
    end
  end
end
