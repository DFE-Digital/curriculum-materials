unless Rails.env.test?
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
          {
            name: 'Fissure vents',
            misconceptions: [
              "The fragments that form a spatter cone are cool and aren't hot enough to weld together",
              "Only isolated lava fountains along the fissure produce crater rows of small spatter and cinder cones."
            ],
            core_knowledge: <<~CORE_KNOWLEDGE,
              In Iceland, volcanic vents, which can be long fissures, often
              open parallel to the rift zones where the Eurasian and the North
              American Plate lithospheric plates are diverging, a system which
              is part of the Mid-Atlantic Ridge. Renewed eruptions generally
              occur from new parallel fractures offset by a few hundred to
              thousands of metres from the earlier fissures. This distribution
              of vents and sometimes voluminous eruptions of fluid basaltic
              lava usually builds up a thick lava plateau, rather than a single
              volcanic edifice. But there are also the central volcanoes,
              composite volcanoes, often with calderas, which have been formed
              during thousands of years, and eruptions with one or more magma
              reservoirs underneath controlling their respective fissure system
            CORE_KNOWLEDGE

            summary: <<~SUMMARY,
              A fissure vent, also known as a volcanic fissure, eruption
              fissure or simply a fissure, is a linear volcanic vent through
              which lava erupts, usually without any explosive activity. The
              vent is often a few metres wide and may be many kilometres long.
              Fissure vents can cause large flood basalts which run first in
              lava channels and later in lava tubes. After some time the
              eruption builds up spatter cones and may concentrate on one or
              some of them. Small fissure vents may not be easily discernible
              from the air, but the crater rows or the canyons built up by some
              of them are.
            SUMMARY

            previous_knowledge: {
              "History" => <<~HISTORY,
                The Laki fissures, part of the Grímsvötn volcanic system,
                produced one of the biggest effusive eruptions on earth in
                historical times.
              HISTORY

              "Magma reservoirs" => <<~MAGMA,
                The dikes that feed fissures reach the surface from depths of a
                few kilometers and connect them to deeper magma reservoirs,
                often under volcanic centers. Fissures are usually found in or
                along rifts and rift zones, such as Iceland and the East
                African Rift. Fissure vents are often part of the structure of
                shield volcanoes
              MAGMA

              "Splatter cone" => <<~SPLATTER_CONE,
                The fragments that form a spatter cone are hot and plastic enough
                to weld together, while the fragments that form a cinder cone
                remain separate because of their lower temperature.
              SPLATTER_CONE
            }
          },
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
end

if ENV['KNOWN_TEACHER_UUID'].present?
  Teacher.find_or_create_by! token: ENV['KNOWN_TEACHER_UUID']
end
