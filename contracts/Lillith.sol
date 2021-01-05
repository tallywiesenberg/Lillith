// add MIT License
pragma solidity >=0.7.4 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
import {FixedMath} from "FixedMath.sol"

//ERC 20 Inheritance
contract Lillith is ERC20, Ownable {

    using SafeMath for uint256;
    using FixedMath for uint256;

    //Engagement index (uint)
    //Gender ratio (uint)
    uint256 public genderRatioIndex;
    //Cost per message (uint)
    //Count of men (uint)
    uint256 public numMen;
    //Count of women (uint)
    uint256 public numWomen;
    //Set profit margin (stored as percent * 100, ex: 105, 110)
    uint256 public profitMargin;

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
    constructor(uint256 _initialSupply, uint256 _profitMargin) ERC20("Lillith", "LTH") {
        _mint(msg.sender, _initialSupply);
        profitMargin = _profitMargin
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
        //if gender is female (true), add 10E18 to female count
        if (_gender) {
            numWomen += 1*10^18;
        //else, add 10E18 to male count
        } else {
            numMen += 1*10^18;
        }

        //Set GenderRatioIndex
        _setGenderRatioIndex();
        //emit NewUser event
        emit NewUser(_newUser);
    }

    //Rewards (called from Python)
    function dispenseTimeReward(address _user, uint _reward) external onlyOwner {
        //Dispense funds for 1 hour of logged time
        transferFrom(msg.sender, _user, _reward);
        //Increment user balance (do I need to do this? does the above take care of this?)
        emit HourLogged(_user);
        
    }
    //Costs
        //Calculate charge per swipe
    function chargeForSwipe(address _user, bool _gender) external payable onlyOwner {
        //Charges for a swipe based on gender and GenderRatioIndex
        //Multiply default rate (rate where genders are equal) by genderRatioIndex
        int defaultRate = 1*10^18/120; //allows 120 profitable swipes per minute at defaullt rate
    }

    //Redeem for USDT

    //Money market (calculate)
        //calculate ratio of men to women
    

    function getGenderRatioIndex() external {
            return genderRatioIndex;
    }  
    
        //calculate cost per swipe relative to hours logged
    function getEngagementIndex() external {
        //aka user engagement

    }
        //get prices
            //men to women ratio (gender index)
            //avg swipes per hour (engagement index)

    //Messaging
        //Charge per message (flat rate??)

    //Setters

    function _setGenderRatioIndex() internal {
        //Compares Ratio of Men to Women

        genderRatioIndex = SafeMath.div(numMen, numWomen);
    }
        //Set user gender
        //Increment swipe count

    //Get profit margin
    function getProfitMargin() view external returns (uint) {
        return profitMargin;
    }


    //Relationship between data value and hourly wage

    //Calculate cost of upkeep

    //Getters
    //get numMen
    function getNumMen() view external returns (uint) {
        return numMen;
    }
    //get numWomen
    function getNumWomen() view external returns (uint) {
        return numWomen;
    }
}