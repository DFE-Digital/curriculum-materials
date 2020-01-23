class ApiClient
  def self.get(url)
    case url
    when /\A\/ccps\Z/
      [
        {
          "id": 101,
          "name": "Year 7 Geography",
          "overview": "What is to be covered...",
          "benefits": "The pupils learnings will benefit..."
        }
      ]
    when /\A\/ccps\/(\d+)\Z/
        {
          "id": $1,
          "name": "Year 7 Geography",
          "overview": "What is to be covered...",
          "benefits": "The pupils learnings will benefit..."
        }
    when /\A\/ccps\/(\d+)\/units\Z/
      [
        {
          "id": 101,
          "complete_curriculum_program_id": $1,
          "name": "Volcanos, earthquakes and plates",
          "overview": "A unit focused on the physical processes that create and destroy our landscape - and their effects on humans.",
          "benefits": "The lessons in this unit have been planned progressively to enable pupils to retain powerful knowledge and vocabulary that can be used confidently later in life. Progressively planned learning enables children to apply prior knowledge and build upon it. This approach solidifies learning beyond learning facts in the classroom, allowing knowledge to be stored in pupils’ long-term memories."
        }
      ]
    when /\A\/units\/(\d+)\Z/
      {
        "id": $1,
        "complete_curriculum_program_id": 101,
        "name": "Volcanos, earthquakes and plates",
        "overview": "A unit focused on the physical processes that create and destroy our landscape - and their effects on humans.",
        "benefits": "The lessons in this unit have been planned progressively to enable pupils to retain powerful knowledge and vocabulary that can be used confidently later in life. Progressively planned learning enables children to apply prior knowledge and build upon it. This approach solidifies learning beyond learning facts in the classroom, allowing knowledge to be stored in pupils’ long-term memories."
      }
    when /\A\/units\/(\d+)\/lessons\Z/
      [
        {
          "id": 101,
          "complete_curriculum_program_id": 101,
          "unit_id": $1,
          "name": "Types of volcanoes",
          "sequence_no": 0,
          "summary": "Objective - To learn the types of volcanoes",
          "core_knowledge": "Pupils should know that...",
          "vocabulary": [
            "cone",
            "vent",
            "magma chamber"
          ],
          "misconceptions": [
            "all volcanoes erupt violently",
            "if a volcano doesnt erupt in a hundred years its extinct"
          ],
          "previous_knowledge": "Pupils should already know that..."
        }
      ]
    when /\A\/lessons\/(\d+)\Z/
      {
        "id": $1,
        "complete_curriculum_program_id": 101,
        "unit_id": 101,
        "name": "Types of volcanoes",
        "sequence_no": 0,
        "summary": "Objective - To learn the types of volcanoes",
        "core_knowledge": "Pupils should know that...",
        "vocabulary": [
          "cone",
          "vent",
          "magma chamber"
        ],
        "misconceptions": [
          "all volcanoes erupt violently",
          "if a volcano doesnt erupt in a hundred years its extinct"
        ],
        "previous_knowledge": "Pupils should already know that..."
      }
    else
      fail %{Unknown endpoint #{url}}
    end
  end
end
