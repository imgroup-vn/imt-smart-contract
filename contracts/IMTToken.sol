// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "./IBEP20.sol";
import "./Ownable.sol";
import "./Stakeable.sol";


contract IMTToken is Ownable, Stakeable , IBEP20 {
  // address public owner = msg.sender;
  uint public last_completed_migration;

  /**
  * @notice Our Tokens required variables that are needed to operate everything
  */
  uint private _totalSupply;
  uint private _totalSold;
  uint8 private _decimals;
  string private _symbol;
  string private _name;

  /**
  * @notice __balances is a mapping that contains a address as KEY 
  * and the balance of the address as the value
  */
  mapping (address => uint256) private _balances;

  mapping(address => mapping (address => uint256)) _allowances;

  /**
  * @notice Events are created below.
  * Transfer event is a event that notify the blockchain that a transfer of assets has taken place
  *
  */
  // event Transfer(address indexed from, address indexed to, uint256 value);
  // event Approval(address indexed owner, address indexed spender, uint256 value);
  event Bought(uint256 amount);
  event Sold(uint256 amount);

  /**
  * @notice constructor will be triggered when we create the Smart contract
  * _name = name of the token
  * _short_symbol = Short Symbol name for the token
  * token_decimals = The decimal precision of the Token, defaults 18
  * _totalSupply is how much Tokens there are totally 
  */
  constructor(
    // string memory token_name, string memory short_symbol, uint8 token_decimals, uint256 token_totalSupply
    ){
      // _name = token_name;
      // _symbol = short_symbol;
      // _decimals = token_decimals;
      // _totalSupply = token_totalSupply;
      _name = "IM Academy Token";
      _symbol = "IMT";
      _decimals = 8;
      _totalSupply = 3500000000000000;
      // Add all the tokens created to the creator of the token
      _balances[msg.sender] = 3500000000000000;

      // Emit an Transfer event to notify the blockchain that an Transfer has occured
      emit Transfer(address(0), msg.sender, _totalSupply);
  }

/**
  * @notice decimals will return the number of decimal precision the Token is deployed with
  */
  function decimals() external view returns (uint8) {
    return _decimals;
  }
  /**
  * @notice symbol will return the Token's symbol 
  */
  function symbol() external view returns (string memory){
    return _symbol;
  }
  /**
  * @notice name will return the Token's symbol 
  */
  function name() external view returns (string memory){
    return _name;
  }
  /**
  * @notice totalSupply will return the tokens total supply of tokens
  */
  function totalSupply() external view returns (uint256){
    return _totalSupply;
  }

  modifier restricted() {
    require(
      msg.sender == owner(),
      "This function is restricted to the contract's owner"
    );
    _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }

  function balanceOf(address tokenOwner) public  view returns (uint256) {
        return _balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public  returns (bool) {
        require(numTokens <= _balances[msg.sender]);
        _balances[msg.sender] = _balances[msg.sender] - numTokens;
        _balances[receiver] = _balances[receiver] - numTokens;
        _totalSold = _totalSold + numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public  returns (bool) {
        _allowances[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public  view returns (uint) {
        return _allowances[owner][delegate];
    }

    function  getOwner() external view returns (address) {
        return owner();
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public  returns (bool) {
        require(numTokens <= _balances[owner]);
        require(numTokens <= _allowances[owner][msg.sender]);

        _balances[owner] = _balances[owner] - numTokens;
        _allowances[owner][msg.sender] = _allowances[owner][msg.sender] - numTokens;
        _balances[buyer] = _balances[buyer] + numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
    /**
  * @notice _mint will create tokens on the address inputted and then increase the total supply
  *
  * It will also emit an Transfer event, with sender set to zero address (adress(0))
  * 
  * Requires that the address that is recieveing the tokens is not zero address
  */
  function _mint(address account, uint256 amount) internal {
    require(account != address(0), "TruongToken: cannot mint to zero address");

    // Increase total supply
    _totalSupply = _totalSupply + (amount);
    // Add amount to the account balance using the balance mapping
    _balances[account] = _balances[account] + amount;
    // Emit our event to log the action
    emit Transfer(address(0), account, amount);
  }
  /**
  * @notice _burn will destroy tokens from an address inputted and then decrease total supply
  * An Transfer event will emit with receiever set to zero address
  * 
  * Requires 
  * - Account cannot be zero
  * - Account balance has to be bigger or equal to amount
  */
  function _burn(address account, uint256 amount) internal {
    require(account != address(0), "TruongToken: cannot burn from zero address");
    require(_balances[account] >= amount, "TruongToken: Cannot burn more than the account owns");

    // Remove the amount from the account balance
    _balances[account] = _balances[account] - amount;
    // Decrease totalSupply
    _totalSupply = _totalSupply - amount;
    // Emit event, use zero address as reciever
    emit Transfer(account, address(0), amount);
  }

  /**
  * @notice burn is used to destroy tokens on an address
  * 
  * See {_burn}
  * Requires
  *   - msg.sender must be the token owner
  *
   */
  function burn(address account, uint256 amount) public onlyOwner returns(bool) {
    _burn(account, amount);
    return true;
  }

    /**
  * @notice mint is used to create tokens and assign them to msg.sender
  * 
  * See {_mint}
  * Requires
  *   - msg.sender must be the token owner
  *
   */
  function mint(address account, uint256 amount) public onlyOwner returns(bool){
    _mint(account, amount);
    return true;
  }

  // function buy() payable public {
  //   uint256 amountTobuy = msg.value;
  //   uint256 dexBalance = balanceOf(address(this));
  //   require(amountTobuy > 0, "You need to send some ether");
  //   require(amountTobuy <= dexBalance, "Not enough tokens in the reserve");
  //   transfer(msg.sender, amountTobuy);
  //   emit Bought(amountTobuy);
  // } 

  // function sell(uint256 amount) public {
  //         require(amount > 0, "You need to sell at least some tokens");
  //         uint256 allowance = allowance(msg.sender, address(this));
  //         require(allowance >= amount, "Check the token allowance");
  //         transferFrom(msg.sender, address(this), amount);
  //         msg.sender.transfer(amount);
  //         emit Sold(amount);
  // }
}
