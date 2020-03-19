// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add("login", (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })

Cypress.Commands.add("waitUntilPageLoad", time => {
  cy.wait(time * 1000);
});

Cypress.Commands.add("navigateBack", () => {
  cy.go("back");
});

Cypress.Commands.add("shouldHaveHeaderAndFooter", () => {
  cy.get(".govuk-header__content").should(
    "contain.text",
    "Curriculum Materials"
  );
  cy.get(".govuk-footer__meta")
    .should(
      "contain.text",
      "All content is available under the Open Government Licence v3.0, except where otherwise stated"
    )
    .should("contain.text", "© Crown copyright");
});
