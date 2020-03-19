describe("Homepage", () => {
  beforeEach(() => {
    cy.visit(`/teachers/session/${Cypress.env("TEACHER_TOKEN")}`, {
      auth: {
        username: "curriculum-materials",
        password: "curriculum-materials"
      }
    });

    cy.shouldHaveHeaderAndFooter()
  });

  it('Validates the user is able to see "Before you start" message', () => {
    cy.get(".govuk-grid-row .govuk-grid-column-two-thirds")
      .should("contain.text", "Before you start")
      .should("contain.text", "Your school can use this service if it has:")
      .should(
        "contain.text",
        "signed up to participate in the DfE’s single-unit pilot"
      )
      .should(
        "contain.text",
        "arranged to participate in the DfE’s user research"
      );
  });

  it('Shows the initial landing page with "Start now" button', () => {
    cy.get(".govuk-grid-row .govuk-grid-column-two-thirds")
      .should("have.contain", "Access curriculum resources")
      .get(".govuk-button--start")
      .should("have.text", "Start now")
      .click();
    cy.location("pathname").should("eq", "/teachers/splash");
  });
});
