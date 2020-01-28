if Rails.env.development?
  3.times do
    FactoryBot.create(:ccp, :randomised) do |ccp|
      3.times do
        FactoryBot.create(:unit, :randomised, complete_curriculum_programme: ccp) do |unit|
          6.times do
            FactoryBot.create(:lesson, :randomised, unit: unit)
          end
        end
      end
    end
  end
end
