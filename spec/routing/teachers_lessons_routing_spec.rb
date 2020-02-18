require "rails_helper"

RSpec.describe "routes for Teachers::Lessons", type: :routing do
  it "routes /teachers/lessons/:id/print to the widgets controller" do
    expect(get("/teachers/lessons/1/print")).
      to route_to("teachers/lessons#print", id: "1")
  end
end
