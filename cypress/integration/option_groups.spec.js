describe("My First Test", () => {
  it("Visits the Kitchen Sink", () => {
    cy.visit("http://localhost:1234");

    cy.get("#option-groups").click();

    cy.get("#option-groups").shadow().contains("Yellow").click();

    cy.get("#option-groups")
      .invoke("attr", "selected-value")
      .should("eq", "Yellow");
  });
});
