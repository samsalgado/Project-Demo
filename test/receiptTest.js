const Receipt = artifacts.require("Receipt");
contract("Receipt", (accounts) => {
  //The contract should generate a receipt ID and display the receipt.
  let receipt;
  const admin = accounts[0];

  beforeEach(async () => {
    receipt = await Receipt.new();
  });

  // We need to add more to the receipt smart contract
  it("should issue a receipt", async () => {
    const date = new Date().toJSON().slice(0, 10);
    await receipt.issueReceipt(
      0,
      "Hanjin",
      "Mr. Bill",
      "New York, NY",
      3,
      25,
      75,
      0,
      12,
      parseInt(date)
    );
  });
});
