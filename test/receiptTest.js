const Receipt = artifacts.require("Receipt")
const truffleAssert = require('truffle-assertions')
contract("Receipt", accounts => {
    //The contract should generate a receipt ID and display the receipt.
    it("should throw an error if there is not a receipt generated", async() => {
        let receipt = await Receipt.deployed()
        await truffleAssert.passes(
            receipt.issueReceipt(0, "Shipper A", "Cosignee B", "Destination X", 545, 5, 455, 05464645, 4546421, 02/24/2021)
        )
    })
})