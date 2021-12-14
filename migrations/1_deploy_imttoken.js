const IMTToken = artifacts.require('IMTToken.sol');

module.exports = async function (deployer, network, accounts) {
  deployer.deploy(IMTToken, 'IM Token', 'IMT', 18, '35000000');
  const token = await IMTToken.deployed();
};
