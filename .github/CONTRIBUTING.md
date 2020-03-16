# Contributing

Contributions are always welcome. We've compiled these docs to help you
understand our contribution guidelines.

If you still have questions, please [contact us](mailto:curriculum-materials@digital.education.gov.uk).

Before submitting your contribution, please make sure to take a moment and read
through the following guidelines:

* [The Department for Education's digital guidelines](https://dfe-digital.github.io/)
* [Pull Request Guidelines](#pull-request-guidelines)

## Issue Reporting Guidelines

Try to search for your issue - it may have already been answered or even fixed
in the development branch. However, if you find that an old, closed issue still
persists in the latest version, you should open a new issue.

## Pull Request Guidelines

* Branch from `development`
* It's OK to have multiple small commits as you work on the PR - GitHub will automatically squash it before merging
* Make sure all the tests run by `bundle exec rake` pass
* If adding a new feature:
  * Add accompanying test case
  * Provide a convincing reason to add this feature. Ideally, you should open a suggestion issue first and have it approved before working on it
* If fixing bug:
  * Provide a detailed description of the bug in the PR. Live demo preferred
  * Add appropriate test coverage if applicable
