describe("Unit", () => {
  beforeEach(() => {
    cy.loadFixtures();
    cy.login();
    cy.shouldHaveHeaderAndFooter();
  });

  it("Displays each unit", () => {
    cy.get("@units").each(unit => {
      cy.visit(`/teachers/units/${unit.id}`);
      cy.get(".siblings > ol > li.current")
        .should("contain.text", unit.name);
      cy.get(".govuk-heading-l").should("have.text", unit.name);
      cy.get(".govuk-grid-column-two-thirds").within(() => {
        cy.get(".rationale").should("contain.text", "Rationale");
        cy.get(".guidance").should("contain.text", "Guidance");
      });
    });
  });
});
