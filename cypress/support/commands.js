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

const unified = require("unified");
const markdown = require("remark-parse");
const remark2rehype = require("remark-rehype");
const parseHtml = require("rehype-parse");
const rehype2remark = require("rehype-remark");
const stringify = require("remark-stringify");

Cypress.Commands.add("loadCCPFixtures", () => {
  cy.request({
    url: "/api/v1/ccps",
    auth: { bearer: Cypress.env("API_TOKEN") }
  })
    .its("body")
    .as("ccps");
});

Cypress.Commands.add("loadUnitFixtures", () => {
  cy.loadCCPFixtures();
  let units = [];
  cy.get("@ccps").each(ccp => {
    cy.request({
      url: `/api/v1/ccps/${ccp.id}/units`,
      auth: { bearer: Cypress.env("API_TOKEN") }
    })
      .its("body")
      .then(body => {
        body
          .map(unit => {
            unit.ccp_id = ccp.id;
            return unit;
          })
          .sort((a, b) => (a.position > b.position ? 1 : -1))
          .forEach(i => units.push(i));
      });
  });
  cy.wrap(units).as("units");
});

Cypress.Commands.add("loadLessonFixtures", () => {
  cy.loadUnitFixtures();
  let array = [];
  cy.get("@units").each(unit => {
    cy.request({
      url: `/api/v1/ccps/${unit.ccp_id}/units/${unit.id}/lessons`,
      auth: { bearer: Cypress.env("API_TOKEN") }
    })
      .its("body")
      .then(lessons => {
        lessons
          .map(lesson => {
            lesson.ccp_id = unit.ccp_id;
            lesson.unit_id = unit.id;
            return lesson;
          })
          .sort((a, b) => (a.position > b.position ? 1 : -1))
          .forEach(i => array.push(i));
      });
  });
  cy.wrap(array).as("lessons");
});

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

Cypress.Commands.add("login", () => {
  cy.visit(`/teachers/session/${Cypress.env("TEACHER_TOKEN")}`, {
    auth: {
      username: "curriculum-materials",
      password: "curriculum-materials"
    }
  });
});

Cypress.Commands.add("shouldContainMarkdown", (selector, markdownStringRaw) => {
  function formatMarkdownString(str, cb) {
    unified()
      .use(markdown)
      .use(remark2rehype)
      .use(rehype2remark)
      .use(stringify)
      .process(str, (err, file) => {
        cb(String(file));
      });
  }

  function formatHTMLString(str, cb) {
    unified()
      .use(parseHtml)
      .use(rehype2remark)
      .use(stringify)
      .process(str, (err, file) => {
        cb(String(file));
      });
  }

  cy.get(selector).then($el => {
    formatHTMLString($el.html(), htmlStr => {
      formatMarkdownString(markdownStringRaw, markdownStr => {
        expect(htmlStr).to.contain(markdownStr);
      });
    });
  });
});
