pragma solidity ^0.8.28;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MySmartContract is IERC20{

    uint256 private _totalSupply;
    string private _tokenName;
    string private _tokenSymbol;
    uint256 private x = 0;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;


    error ZeroAddress();
    error InsufficientBalance();
    error InsufficientAllowance();

    event Increment(uint by);
    
    constructor(){
        _totalSupply = 10000;
        _tokenName = "BlockchainI";
        _tokenSymbol = "BCI";

        _mint();
    }

    function inc() public {
        x++;
        emit Increment(1);
    }

    function incBy(uint by) public {
        require(by > 0, "incBy: increment should be positive");
        x += by;
        emit Increment(by);
    }

    function _mint() private {
        if (msg.sender == address(0)){
            revert ZeroAddress();
        }
        _balances[msg.sender] = _totalSupply;

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() public view returns (string memory) {
        return _tokenName;
    }
        
    function symbol() public view returns (string memory)  {
        return _tokenSymbol;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }
    
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return _balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        return update(msg.sender, _to, _value);
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        address spender = msg.sender;

        if (_allowances[_from][spender] < _value) {
            revert InsufficientAllowance();
        }
                
        _allowances[_from][spender] -= _value;
        update(_from, _to, _value);
        
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        if (_spender == address(0)) {
            revert ZeroAddress();
        }

        _allowances[msg.sender][_spender] = _value;

        emit Approval (msg.sender, _spender, _value);

        return true;
    }
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return _allowances[_owner][_spender];
    }

    function update(address _from, address _to, uint256 _value) private returns (bool success) {
        uint256 fromBalance = _balances[_from];
        uint256 toBalance = _balances[_to];

        if (fromBalance < _value) {
            revert InsufficientBalance();    
        }

        if (_from == address(0) || _to == address(0)) {
            revert ZeroAddress();
        }
               
        fromBalance -= _value;
        toBalance += _value;

        _balances[_from] = fromBalance;
        _balances[_to] = toBalance;

        emit Transfer(_from, _to, _value);
        return true;
    }
}