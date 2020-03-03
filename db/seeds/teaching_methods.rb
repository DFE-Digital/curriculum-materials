[
  {
    name: "Do it now",
    icon: "writing"
  },
  {
    name: "Writing",
    icon: "writing",
    description: "Help pupils to understand a topic by writing about it"
  },
  {
    name: "Teacher instruction",
    icon: "whole"
  },
  {
    name: "Guided reading",
    icon: "guided-reading"
  },
  {
    name: "Mind map",
    icon: "mind-map"
  },
  {
    name: "Reading",
    icon: "reading"
  },
  {
    name: "Worksheet",
    icon: "worksheet"
  },
  {
    name: "Poster",
    icon: "poster"
  },
  {
    name: "Feedback",
    icon: "feedback"
  }
].each do |teaching_method_attributes|
  FactoryBot.create(:teaching_method, :randomised, **teaching_method_attributes)
end
