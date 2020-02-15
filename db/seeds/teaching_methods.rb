{
  "Pair" => "pair",
  "Group" => "group",
  "Whole" => "whole",
  "Formative" => "formative",
  "Reading" => "reading",
  "Writing" => "writing",
  "Practical" => "practical",
  "Worksheet" => "worksheet",
  "Individual" => "individual",
}.each do |name, icon|
  FactoryBot.create(:teaching_method, :randomised, name: name, icon: icon)
end
