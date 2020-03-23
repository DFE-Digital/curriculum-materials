describe("Unit", () => {
  beforeEach(() => {
    cy.loadLessonFixtures();
    cy.login();
    cy.shouldHaveHeaderAndFooter();
  });

  it("Displays each unit", () => {
    cy.get("@units").each(unit => {
      cy.visit(`/teachers/units/${unit.id}`);
      cy.get(".siblings > ol > li.current").should("contain.text", unit.name);
      cy.get(".govuk-heading-l").should("have.text", unit.name);
      cy.get(".govuk-grid-column-two-thirds").within(() => {
        cy.get(".rationale").should("contain.text", "Rationale");
        cy.get(".guidance").should("contain.text", "Guidance");
      });
    });
  });

  it("Displays lessons for each unit", () => {
    let unitsCovered = [];
    cy.get("@lessons").each(lesson => {
      if (unitsCovered.includes(lesson.unit_id)) {
        return;
      }
      unitsCovered.push(lesson.unit_id);
      cy.visit(`/teachers/units/${lesson.unit_id}`);
      cy.get(".govuk-table").should("exist");
      cy.get(".govuk-table__body tr").within(() => {
        cy.get("td").should("contain.text", lesson.learning_objective);
        cy.get("a")
          .should("have.attr", "href")
          .should("equal", `/teachers/lessons/${lesson.id}`);
      });
    });
  });
});
