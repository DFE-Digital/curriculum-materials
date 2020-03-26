describe("Lesson", () => {
  beforeEach(() => {
    cy.loadLessonFixtures();
    cy.login();
  });

  it("Displays lesson contents", () => {
    cy.get("@lessons").each(lesson => {
      cy.visit(`/teachers/lessons/${lesson.id}`);
      cy.shouldHaveHeaderAndFooter();
      cy.get('h1.govuk-heading-l').should('have.text', lesson.name)
      cy.get(".govuk-tabs__list")
        .find(".govuk-tabs__list-item--selected")
        .should("contain.text", "Knowledge overview");
      cy.get("#knowledge-overview")
        .should("contain.text", "Understand the aims of the lesson")
        .should("contain.text", "Lesson objective")
        .should("contain.text", "Core knowledge for teachers")
        .should("contain.text", "Core knowledge for pupils")
        .should("contain.text", "Key vocabulary")
        .should("contain.text", "Common misconceptions")
        .should($el => {
          expect($el.find('.govuk-button').text()).to.equal('2.Lesson plan')
          expect($el.find('.govuk-button').attr('href')).to.equal(`/teachers/lessons/${lesson.id}#lesson-contents`)
        });
      cy.shouldContainMarkdown(".vocabulary", lesson.vocabulary)
      cy.shouldContainMarkdown(".building-on-previous-knowledge", lesson.previous_knowledge)
      cy.shouldContainMarkdown(".common-misconceptions", lesson.misconceptions)
      cy.shouldContainMarkdown(".core-knowledge-for-teachers", lesson.core_knowledge_for_teachers)
      cy.shouldContainMarkdown(".core-knowledge-for-pupils", lesson.core_knowledge_for_pupils)
    });
  });
});
