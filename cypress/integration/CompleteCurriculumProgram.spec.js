describe("CompleteCurriculumProgram", () => {
  beforeEach(() => {
    cy.request({
      url: "/api/v1/ccps",
      auth: { bearer: Cypress.env("API_TOKEN") }
    })
      .its("body.0")
      .as("ccps");
    cy.login();
    cy.get("@ccps").then(ccp => {
      cy.request({
        url: `/api/v1/ccps/${ccp.id}/units`,
        auth: { bearer: Cypress.env("API_TOKEN") }
      })
        .its("body")
        .then(body => {
          body = body.map(b => {
            b.ccp_id = ccp.id;
            return b;
          });
          return body.sort((a, b) => (a.position > b.position ? 1 : -1));
        })
        .as("units");
      cy.visit(`/teachers/complete-curriculum-programmes/${ccp.id}/years/7`);
    });
    cy.shouldHaveHeaderAndFooter();
  });

  it("Displays rationale of Curriculum", () => {
    cy.get(".govuk-grid-column-two-thirds").should(
      "contain.text",
      "Year 7 History Curriculum"
    );
    cy.get(".govuk-grid-column-two-thirds .rationale")
      .should(
        "contain.text",
        "How curriculum content is sequenced throughout year 7"
      )
      .should(
        "contain.text",
        "Year 7 begins with coverage of some essential historical skills"
      )
      .should("contain.text", "Key themes, changes, and continuities")
      .should(
        "contain.text",
        "The journey through British history then begins with a study"
      )
      .should("contain.text", "Key themes, changes, and continuities");
  });

  it("Displays possible Curriculum Units", () => {
    cy.get("@units").then(units => {
      cy.get("article.card").each(($el, index) => {
        const unit = units[index];
        cy.wrap($el).within(() => {
          cy.get(".card-header").should("contain.text", unit.name);
          if ($el.find(".card-footer > a").length > 0) {
            cy.get(".card-footer a")
              .should($el => {
                expect($el.text()).to.equal("View and plan lessons");
              })
              .should("have.attr", "href")
              .should("equal", `/teachers/units/${unit.id}`);
          } else {
            cy.get(".card-footer").should("contain.text", "Available soon");
          }
        });
      });
    });
  });
});
