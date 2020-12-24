// add MIT License
pragma solidity >=0.7.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//ERC 20 Inheritance
contract Lillith is ERC20 {


    //User Struct
    struct User {
        int256 balance; //balance int256
        uint32 hoursLogged; //uint32 hours logged
        uint32 swipes; //uint32 swipes
    }
    //Mapping: user (address) to user (struct)
    mapping(address => User) users;

    //Array of addresses
    address[] public addresses;


    
    //Swipe Struct ??

    //Events
        //NewUser
        //HourLogged
        //NewMatch ??
    //Inital Mint
    constructor(uint256 _initialSupply) ERC20("Lillith", "LTH") {
        _mint(msg.sender, _initialSupply);
    }



    //Add user (called from Python)
        //Create user (struct)
        //add to mapping (address => user struct)
        //append to array

    //Rewards
        //Dispense funds for 1 hour of logged time

    //Costs
        //Charge per swipe

    //Redeem for USDT

    //Money market (calculate)
        //calculate ratio of men to women
        //calculate cost per swipe relative to hours logged
        //aka user engagement
        
}