// add MIT License
pragma solidity >=0.7.4 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//ERC 20 Inheritance
contract Lillith is ERC20, Ownable {

    using SafeMath for uint;

    //Engagement index (uint)
    //Gender ratio (uint)
    //Cost per message (uint)
    //Count of men (uint)
    //Count of women (uint)

    //Events
        event NewUser(address user); //NewUser
        event HourLogged(address user); //HourLogged
        event NewMatch(address user1, address user2); //NewMatch ??

    //User Struct
    struct User {
        int256 balance; //balance int256
        uint32 hoursLogged; //uint32 hours logged
        uint32 swipes; //uint32 swipes
        bool gender; //false is male, true is female
    }
    //Mapping: user (address) to user (struct)
    mapping(address => User) users;

    //Array of addresses
    address[] public addresses;


    
    //Swipe Struct ??


    //Inital Mint
    constructor(uint256 _initialSupply) ERC20("Lillith", "LTH") {
        _mint(msg.sender, _initialSupply);
    }



    //Add user (called from Python)
    function newUser(address _newUser, bool _gender) external onlyOwner {
        //require ownly owner, otherwise anyone can create new users...
        //append new address to array
        addresses.push(_newUser);
        //Create user (struct) and add to mapping (address => user struct)
        users[_newUser] = User({
            balance:0,
            hoursLogged:0,
            swipes:0,
            gender:_gender //collect gender as argument (false is male, true is female)
        });
        //emit NewUser event
        emit NewUser(_newUser);
    }

    //Rewards (called from Python)
    function dispenseTimeReward(address _user, uint _reward) external onlyOwner {
        //Dispense funds for 1 hour of logged time
        transferFrom(msg.sender, _user, _reward);
        //Increment user balance (do I need to do this? does the above take care of this?)
        
    }
    //Costs
        //Calculate charge per swipe
        //Charge per swipe
        //Linear increase in swipe charge
        //Slope = logistic engagement index

    //Redeem for USDT

    //Money market (calculate)
        //calculate ratio of men to women
            //get count of men
            //get count of women
            
        //calculate cost per swipe relative to hours logged
        //aka user engagement
        //get prices
            //men to women ratio (gender index)
            //avg swipes per hour (engagement index)

    //Messaging
        //Charge per message (flat rate??)

    //Setters
        //Set user gender
        //Increment swipe count

    //Relationship between data value and hourly wage

    //Calculate cost of upkeep
}