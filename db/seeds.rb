if Rails.env.development?
  FactoryBot.create(
    :ccp,
    name: 'Year 7 Geography',
    overview: "A unit focused on the physical processes that create and destroy our landscape - and their effects on humans.",
    benefits: <<~BENEFITS
      The lessons in this unit have been planned progressively to enable pupils
      to retain powerful knowledge and vocabulary that can be used confidently
      later in life. Progressively planned learning enables children to apply
      prior knowledge and build upon it. This approach solidifies learning
      beyond learning facts in the classroom, allowing knowledge to be stored
      in pupils’ long-term memories."
    BENEFITS
  ) do |ccp|
    [
      {
        attributes: {
          name: 'Types of volcano',
          overview: 'Geologists generally group volcanoes into four main kinds; cinder cones, composite volcanoes, shield volcanoes, and lava domes.'
        },
        lessons: [
          { name: 'Fissure vents' },
          { name: 'Shield volcanoes' },
          { name: 'Lava domes' },
          { name: 'Cryptodomes' },
          { name: 'Stratovolcanoes' },
          { name: 'Underwater volcanoes' }
        ]
      },
      {
        attributes: {
          name: 'Plate tectonics',
          overview: <<~OVERVIEW
            Plate tectonics is a theory of geology. It explains movement of the
            Earth's lithosphere: this is the earth's crust and the upper part
            of the mantle. The lithosphere is divided into plates, some of which
            are very large and can be entire continents.)
          OVERVIEW
        },
        lessons: [
          { name: 'Driving forces related to mantle dynamics' },
          { name: 'Plume tectonics' },
          { name: 'Surge tectonics' },
          { name: 'Driving forces related to gravity' },
          { name: 'Driving forces related to Earth rotation' },
        ]
      },
      {
        attributes: {
          name: 'Earthquakes',
          overview: %(Earthquakes are caused by friction between tectonic plates)
        },
        lessons: [
          { name: 'Naturally occurring earthquakes' },
          { name: 'Earthquake fault types' },
          { name: 'Shallow-focus and deep-focus earthquakes' },
          { name: 'Earthquake clusters' },
          { name: 'Measuring and locating earthquakes' },
          { name: 'Human impacts' },
        ]
      },
      {
        attributes: {
          name: 'Map skills',
          overview: <<~OVERVIEW
            A map is an image of an area, usually of the Earth or part of the
            Earth. A map is different from an aerial photograph because it
            includes interpretation. Many maps are called "charts" such as star
            charts and nautical charts. Before the late 20th century almost all
            maps were on paper. Now they are more often seen on a computer
            screen.)
          OVERVIEW
        },
        lessons: [
          { name: 'The basics of how to read a map' },
          { name: 'Taking bearings' },
          { name: 'Finding your location' },
          { name: 'Route planning' },
          { name: 'The easy way to use a compass and GPS' },
        ]
      },
      {
        attributes: {
          name: 'Earthquake damage',
          overview: <<~OVERVIEW
            Shaking and ground rupture are the main effects created by
            earthquakes, principally resulting in more or less severe damage to
            buildings and other rigid structures. The severity of the local
            effects depends on the complex combination of the earthquake
            magnitude, the distance from the epicenter, and the local geological
            and geomorphological conditions, which may amplify or reduce wave
            propagation.)
          OVERVIEW
        },
        lessons: [
          { name: 'Shaking and ground rupture' },
          { name: 'Soil liquefaction' },
          { name: 'Human impacts' },
          { name: 'Landslides' },
          { name: 'Fires' },
          { name: 'Tsunami' },
          { name: 'Floods' }
        ]
      }
    ]
      .each do |unit_data|
        FactoryBot.create(:unit, unit_data[:attributes].merge(complete_curriculum_programme: ccp)) do |unit|
          unit_data[:lessons].each do |lesson_attributes|
            FactoryBot.create(:lesson, lesson_attributes.merge(unit: unit))
          end
        end
      end
  end

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
