describe("CompleteCurriculumProgrammes", () => {
  beforeEach(() => {
    cy.login();
    cy.visit("/teachers/complete-curriculum-programmes");
    cy.shouldHaveHeaderAndFooter();
  });

  it("Displays Key Stages", () => {
    cy.get(".govuk-grid-column-two-thirds")
      .should("contain.text", "Key stage 3 history")
      .should("contain.text", "Chronological study")
      .should("contain.text", "A study of British history and society");
    cy.get(".govuk-grid-column-two-thirds > form")
      .should("contain.text", "Which year group would you like to view?")
      .should(
        "contain.text",
        "Select a year group to view its full history curriculum"
      )
      .should($el => {
        expect($el.find(".govuk-button").text()).to.eq("Continue");
      });
    cy.get(".govuk-radios__item")

      .first()
      .should("contain.text", "Year 7")
      .and($el => {
        expect($el.find("input")).not.to.have.attr("disabled");
      })

      .next()
      .should("contain.text", "Year 8")
      .and($el => {
        expect($el.find("input")).to.have.attr("disabled");
      })

      .next()
      .should("contain.text", "Year 9")
      .and($el => {
        expect($el.find("input")).to.have.attr("disabled");
      });
  });

  it("Navigates to CCP on choose and click of button", () => {
    cy.get(
      ".govuk-grid-column-two-thirds > form .govuk-radios__item:nth-child(1) input"
    ).check();
    cy.get(".govuk-grid-column-two-thirds > form .govuk-button").click();
    cy.location("pathname").should(
      "eq",
      "/teachers/complete-curriculum-programmes/1/years/7"
    );
  });
});
