describe("Splashpage", () => {
  beforeEach(() => {
    cy.login();
    cy.visit("/teachers/splash");
    cy.shouldHaveHeaderAndFooter();
  });

  it('Displays "How to use this service" information', () => {
    cy.get(".govuk-splash")
      .should("contain.text", "How the service works")
      .should(
        "contain.text",
        `Access curriculum resources is a service for teachers.`
      )
      .should(
        "contain.text",
        "The Department for Education has collaborated with educational experts"
      )
    .should(
      "contain.text",
      "The curriculum programmes available through this service are rooted in the"
    )
    cy.get(".govuk-splash img")
      .should("have.attr", "src")
      .should("match", /logo\-\w+\.png/);
  });

  it('Displays a "back" button to previous page', () => {
    cy.get('.govuk-back-link').should('have.text', "Back").click()
    cy.location('pathname').should('eq', '/teachers/home')
  })

  it('Displays a "continue" button', () => {
    cy.get('.govuk-splash .govuk-button').should('contain.text', "Continue").click()
    cy.location("pathname").should('eq', "/teachers/complete-curriculum-programmes")
  })
});
