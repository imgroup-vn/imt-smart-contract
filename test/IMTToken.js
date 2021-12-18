const IMTToken = artifacts.require('IMTToken');

// Start a test series named IMTToken, it will use 10 test accounts
contract('IMTToken', async (accounts) => {
  // each it is a new test, and we name our first test initial supply
  it('initial supply must be 35000000', async () => {
    token = await IMTToken.deployed();
    let supply = await token.totalSupply();
    let name = await token.name();

    assert.equal(name, 'IM Token');
    assert.equal(
      BigInt(supply).toString(),
      '35000000',
      'Initial supply was not the same as in migration',
    );
  });

  it('sell tokens', async () => {
    token = await IMTToken.deployed();

    // Grab initial balance
    let initial_balance = await token.balanceOf(accounts[1]);

    // transfer tokens from account 0 to 1

    assert.equal(initial_balance, 0);
  });
});
