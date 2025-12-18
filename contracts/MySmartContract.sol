pragma solidity ^0.8.28;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MySmartContract is ERC20{

    

    constructor() {
        totalSupply = 10000;
         name = "BlockchainTT";
        symbol = "BTT";

        _mint();
    }
}