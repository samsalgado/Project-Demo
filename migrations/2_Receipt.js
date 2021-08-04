const Receipt = artifacts.require("Receipt");

module.exports = function (deployer) {
  deployer.deploy(Receipt);
};
