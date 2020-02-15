unless Rails.env.test?
  teaching_methods = TeachingMethod.all.index_by(&:name)

  FactoryBot.create(
    :ccp,
    name: 'Year 7 History - The Norman Invasion',
    overview: <<~OVERVIEW,
      The Battle of Hastings was fought on 14 October 1066 between the
      Norman-French army of William, the Duke of Normandy, and an English army
      under the Anglo-Saxon King Harold Godwinson, beginning the Norman conquest
      of England. It took place approximately 7 miles northwest
      of Hastings, close to the present-day town of Battle, East Sussex, and was
      a decisive Norman victory.
    OVERVIEW
    benefits: <<~BENEFITS
      The lessons in this unit have been planned progressively to enable pupils
      to retain powerful knowledge and vocabulary that can be used confidently
      later in life. Progressively planned learning enables children to apply
      prior knowledge and build upon it. This approach solidifies learning
      beyond learning facts in the classroom, allowing knowledge to be stored
      in pupils’ long-term memories."
    BENEFITS
  ) do |ccp|
    puts "Created #{ccp.name}"

    [
      {
        attributes: {
          name: 'The battle of Hastings',
          overview: <<~OVERVIEW
            In 1002 Ethelred King of England married Emma, the sister of
            Richard II, Duke of Normandy. The alliance formed by this marriage
            had far reaching effects. When King Canute came to the throne of
            England in 1016, he took Queen Emma of Normandy as his wife. Her
            two sons by her former marriage fled to Normandy for their own
            safety. Edward the Confessor the older son stayed in Normandy for
            many years at the court of the dukes. The last duke who protected
            him there was his cousin Duke William. Edward became king of
            England in 1042. in 1052 King Edward, who was childless, made
            William his heir. In 1065 Harold Godwinson was in Normandy.
            While he was there he promised Duke William he would support him as
            successor to the English throne
          OVERVIEW
        },
        lessons: [
          {
            attributes: {
              name: 'Prelude',
              misconceptions: [
                "Historians know exactly where and when the battle took place",
                "Harold Godwinson was killed by an arrow in the eye"
              ],
              core_knowledge: <<~CORE_KNOWLEDGE,
                When William heard the news that Harold had become king his
                reaction was swift. He called a meeting of his greatest men.
                William made plans to gather a large army from all over
                France. His influence and wealth meant he could mount a large
                campaign. His first task was to build a fleet of ships to
                carry his army across the English Channel. Then he started
                gathering an army. His friendship with Brittany, France, and
                Flanders meant he did not have to rely only on his own army.
                He hired and paid soldiers from many parts of Europe. William
                asked for and got the support of the pope who gave him a banner
                to carry into battle. At the same time Duke William was
                planning his invasion so too was Harald Hardrada. The king of
                England knew both would be coming but he kept his ships and
                forces in the south of England where William might land.

                William may have had as many as 1,000 ships in his invasion fleet. They had
                favorable winds to leave Normandy on the night of 27 September 1066.
                William's ship, the Mora, was a gift of his wife, Matilda. It
                led the fleet to the landing at Pevensey the next morning. As
                soon as he landed William got news of King Harold's victory over
                the Norwegian king at Stamford Bridge in the north of England.
                Harold also received news that William had landed at Pevensey and
                came south as quickly as he could. The king rested at London for a
                few days before taking his army to meet William and his French
                forces.
              CORE_KNOWLEDGE

              summary: <<~SUMMARY,
                On 12 September 1066 William's fleet sailed from Normandy.
                Several ships sank in storms, which forced the fleet to take
                shelter at Saint-Valery-sur-Somme and to wait for the wind to
                change. On 27 September the Norman fleet set sail for England,
                arriving the following day at Pevensey on the coast of East
                Sussex. Harold's army marched 241 miles to intercept William, who
                had landed perhaps 7,000 men in Sussex, southern England. Harold
                established his army in hastily built earthworks near Hastings.
                The two armies clashed at the Battle of Hastings, at Senlac Hill
                (near the present town of Battle) close by Hastings on 14
                October, where after nine hours of hard fighting, Harold was
                killed and his forces defeated. His brothers Gyrth and Leofwine
                were also killed in the battle, according to the Anglo-Saxon
                Chronicle.
              SUMMARY

              previous_knowledge: {
                "Who was Harold Godwinson?" => <<~HISTORY,
                  Harold was a son of Godwin (c. 1001–1053), the powerful Earl of
                  Wessex, and of Gytha Thorkelsdóttir, whose brother Ulf the Earl
                  was married to Estrid Svendsdatter (c. 1015/1016), the daughter
                  of King Sweyn Forkbeard (died 1014) and sister of King Cnut the
                  Great of England and Denmark. Ulf and Estrith's son would become
                  King Sweyn II of Denmark in 1047. Godwin was the son of
                  Wulfnoth, probably a thegn and a native of Sussex. Godwin began his
                  political career by supporting King Edmund Ironside (reigned April
                  to November 1016), but switched to supporting King Cnut by 1018,
                  when Cnut named him Earl of Wessex.
                HISTORY

                "Who are the Normans?" => <<~NORMANS,
                  The Norman dynasty had a major political, cultural and military
                  impact on medieval Europe and the Near East. The Normans were
                  famed for their martial spirit and eventually for their Catholic
                  piety, becoming exponents of the Catholic orthodoxy of the Romance
                  community into which they assimilated. They adopted the
                  Gallo-Romance language of the Frankish land they settled, their
                  dialect becoming known as Norman, Normaund or Norman French, an
                  important literary language which is still spoken today in parts of
                  Normandy and the nearby Channel Islands. The Duchy of Normandy,
                  which they formed by treaty with the French crown, was a great fief
                  of medieval France, and under Richard I of Normandy was forged into
                  a cohesive and formidable principality in feudal tenure.
                NORMANS

                "William the Conqueror" => <<~WILLIAM_1,
                  William was the son of the unmarried Robert I, Duke of
                  Normandy, by his mistress Herleva. His illegitimate status and
                  his youth caused some difficulties for him after he succeeded
                  his father, as did the anarchy which plagued the first years of
                  his rule. During his childhood and adolescence, members of the
                  Norman aristocracy battled each other, both for control of the
                  child duke and for their own ends. In 1047, William was able to
                  quash a rebellion and begin to establish his authority over the
                  duchy, a process that was not complete until about 1060. His
                  marriage in the 1050s to Matilda of Flanders provided him with
                  a powerful ally in the neighbouring county of Flanders. By the
                  time of his marriage, William was able to arrange the
                  appointment of his supporters as bishops and abbots in the
                  Norman church. His consolidation of power allowed him to expand
                  his horizons, and he secured control of the neighbouring county
                  of Maine by 1062.
                WILLIAM_1
              }
            },
            lesson_parts: {
              1 => [
                {
                  attributes: {
                    overview: <<~OVERVIEW
                      As students enter the room, direct them to try and match up
                      each key word with the correct definition. They should
                      write the number with the correct letter in their books.
                      Feed back and show correct responses.
                    OVERVIEW
                  },
                  teaching_methods: [teaching_methods['Whole'], teaching_methods['Practical']]
                },
                {
                  attributes: {
                    overview: <<~OVERVIEW
                      For this lesson, students need to know the events of
                      the battle in chronological order. The teacher uses
                      maps on slides 6 and 7 to remind students what led up
                      to the battle. Students then read the Word document
                      “description of the Battle of Hastings” either as a
                      group taking it in turns to read aloud or
                      independently.
                    OVERVIEW
                  },
                  teaching_methods: [teaching_methods['Whole'], teaching_methods['Formative']]
                },
              ],
              2 => [
                {
                  attributes: {
                    overview: <<~OVERVIEW
                      Give students slips of paper at random, but make sure the
                      student with the first event knows who they are. Get them
                      to read out their slip and see how smoothly the whole class
                      can get through the story.

                      This exercise requires participants to have understood
                      the order of events and be alert for when their turn to
                      read arises. Teachers can make this more competitive by
                      making students start again if there is a pause of more
                      than a couple of seconds between each student.
                    OVERVIEW
                  },
                  teaching_methods: [teaching_methods['Whole'], teaching_methods['Worksheet']]
                },
                {
                  attributes: {
                    overview: <<~OVERVIEW
                      Students can work individually, in pairs or in groups for
                      this activity. Instructions for the activity are on slide
                      9. Students decide which statements on the cards are
                      irrelevant to answering the question “Why did William win
                      the Battle of Hastings?” and discard them. Then they
                      categorise the cards under different headings. Higher
                      attainers can be encouraged to come up with their own
                      category headings or think of alternatives to the one you
                      give them.
                    OVERVIEW
                  },
                  teaching_methods: [teaching_methods['Pair'], teaching_methods['Writing']]
                },
              ],
              3 => [
                {
                  attributes: {
                    overview: <<~OVERVIEW
                      Show students example paragraphs and get them to verbally
                      feed back on what they think is wrong with the first one.
                      Then show the better paragraph, and use questioning to get
                      students to identify what is better about this piece of
                      writing before you show them the complete annotated
                      version.
                    OVERVIEW
                  },
                  teaching_methods: [teaching_methods['Writing']]
                },
                {
                  attributes: {
                    overview: <<~OVERVIEW
                      Students attempt their own paragraphs. Starter sentences
                      can be displayed on the slide for students who need more
                      support.
                    OVERVIEW
                  },
                  teaching_methods: [teaching_methods['Writing']]
                },
              ],
              4 => [
                {
                  attributes: {
                    overview: <<~OVERVIEW
                      Ask students to use the checklist on the slide to feed back
                      on the work of the person next to them. They can either
                      award a mark for each element of the checklist that is
                      present, or write a “what went well” and an “even better
                      if” for their partner.
                    OVERVIEW
                  }
                },
              ],
              5 => [
                {
                  attributes: {
                    overview: <<~OVERVIEW
                      Ask a student to read out their paragraph and either
                      offer feedback or get other students to offer verbal
                      feedback.
                    OVERVIEW
                  }
                }
              ]
            }
          },
          { attributes: { name: 'Norman preparations and forces' } },
          { attributes: { name: %(Landing and Harold's march south) } },
          { attributes: { name: 'First rebellions' } },
          { attributes: { name: 'Revolts of 1069' } },
          { attributes: { name: 'Danish troubles' } }
        ]
      },
      {
        attributes: {
          name: 'The aftermath of the invasion',
          overview: <<~OVERVIEW
            Following the conquest, many Anglo-Saxons, including groups of
            nobles, fled the country for Scotland, Ireland, or Scandinavia.
            Members of King Harold Godwinson's family sought refuge in Ireland
            and used their bases in that country for unsuccessful invasions of
            England. The largest single exodus occurred in the 1070s, when a
            group of Anglo-Saxons in a fleet of 235 ships sailed for the
            Byzantine Empire. The empire became a popular destination for many
            English nobles and soldiers, as the Byzantines were in need of
            mercenaries. The English became the predominant element in the
            elite Varangian Guard, until then a largely Scandinavian unit, from
            which the emperor's bodyguard was drawn. Some of the English
            migrants were settled in Byzantine frontier regions on the Black
            Sea coast, and established towns with names such as New London and
            New York.
          OVERVIEW
        },
        lessons: [
          { attributes: { name: 'English emigration' } },
          { attributes: { name: 'Governmental systems' } },
          { attributes: { name: 'Language' } },
          { attributes: { name: 'Immigration and intermarriage' } },
          { attributes: { name: 'Society in Norman England' } },
        ]
      },
      {
        attributes: {
          name: 'Viking invasions',
          overview: %(The death of King Edward the Confessor of England in January 1066 had triggered a succession struggle in which a variety of contenders from across north-western Europe fought for the English throne.)
        },
        lessons: [
          { attributes: { name: 'The Anglo Saxon Chronicle' } },
          { attributes: { name: 'Harold Hardrada - King of Norway' } },
          { attributes: { name: 'The Battle of Stamford Bridge' } },
          { attributes: { name: 'Viking culture' } },
          { attributes: { name: 'The Harrowing of Rohan' } },
          { attributes: { name: 'Viking trade, goods and exploration' } },
          { attributes: { name: 'Rígsþula' } },
        ]
      },
      {
        attributes: {
          name: 'The Houses of Denmark, Wessex and Godwin',
          overview: <<~OVERVIEW
            Following the decisive Battle of Assandun on 18 October 1016, King
            Edmund signed a treaty with Cnut (Canute) under which all of
            England except for Wessex would be controlled by Cnut. Upon
            Edmund's death just over a month later on 30 November, Cnut ruled
            the whole kingdom as its sole king for nineteen years.
          OVERVIEW
        },
        lessons: [
          { attributes: { name: 'Edmund and the battle of Assandun' } },
          { attributes: { name: 'Canute, Harold Harefoot and Harthacnut' } },
          { attributes: { name: 'Finding your location' } },
          { attributes: { name: %(Edward the Confessor's succession) } },
          { attributes: { name: 'Edgar Ætheling' } },
        ]
      },
      {
        attributes: {
          name: 'Heptarchy - The Kingdoms of Anglo-Saxon England',
          overview: <<~OVERVIEW
            The heptarchy is a collective name applied to seven Anglo-Saxon
            kingdoms. These were: Northumbria, Mercia, East Anglia, Essex,
            Kent, Sussex and Wessex. The Anglo-Saxon kingdoms eventually became
            the Kingdom of England. The term has been in use since the 16th
            century. It is used to apply both to the seven kingdoms and to the
            time period in which they existed.
          OVERVIEW
        },
        lessons: [
          { attributes: { name: 'Origins of the heptarchy' } },
          { attributes: { name: 'Bretwaldas - the seven kings' } },
          { attributes: { name: 'Kingdoms of the Heptarchy' } },
          { attributes: { name: 'Sussex, Wessex and Kent' } },
          { attributes: { name: 'Northumbria: Bernica and Deira' } },
          { attributes: { name: 'Mercia and East Anglia' } },
          { attributes: { name: 'Bede' } }
        ]
      }
    ]
    .each do |unit_data|
      # FIXME, this is now unmanageable and really needs reworking.

      FactoryBot.create(:unit, unit_data[:attributes].merge(complete_curriculum_programme: ccp)) do |unit|
        puts " Added unit: #{unit.name}"

        unit_data[:lessons].each do |lesson_attributes|
          FactoryBot.create(:lesson, lesson_attributes[:attributes].merge(unit: unit)).tap do |l|
            puts "  Added lesson: #{l.name}"

            lesson_attributes[:lesson_parts]&.each do |position, activities|
              FactoryBot.create(:lesson_part, { lesson_id: l.id }.merge(position: position)).tap do |lp|
                puts "  Added lesson part: #{lp.position}"

                activities.each do |activity_attributes|
                  Activity.create(
                    lesson_part_id: lp.id,
                    **FactoryBot.attributes_for(:activity).merge(activity_attributes[:attributes])
                  ).tap do |a|
                    activity_attributes[:teaching_methods]&.each do |tm|
                      a.teaching_methods << tm
                    end
                  end
                end

                puts "   Added #{activities.count} activities"
              end
            end
          end
        end
      end
    end
  end
end
