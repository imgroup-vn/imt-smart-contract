var IMTToken = artifacts.require('./IMTToken.sol');

module.exports = async function (deployer) {
  await deployer.deploy(IMTToken, 'IM Academy Token', 'IMT', 18, '35000000');
};
