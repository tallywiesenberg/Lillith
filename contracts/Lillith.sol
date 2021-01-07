// add MIT License
pragma solidity >=0.7.4 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";

//ERC 20 Inheritance
contract Lillith is ERC20, Ownable {

    using SafeMath for uint256;

    //Engagement index (uint)
    //Gender ratio (uint)
    uint256 public genderRatioIndex;
    //Cost per message (uint)
    //Count of men (uint)
    uint256 public numMen;
    //Count of women (uint)
    uint256 public numWomen;
    //Gender enum
    enum Gender{ male, female }

    //Events
        event NewUser(address user); //NewUser
        event MinuteLogged(address user); //HourLogged
        event NewMatch(address user1, address user2); //NewMatch ??

    //User Struct
    struct User {
        int256 balance; //balance int256
        uint32 hoursLogged; //uint32 hours logged
        uint32 swipes; //uint32 swipes
        Gender gender;
    }
    //Mapping: user (address) to user (struct)
    mapping(address => User) users;

    //Array of addresses
    address[] public addresses;

    //Inital Mint
    constructor(uint256 _initialSupply) ERC20("Lillith", "LTH") {
        _mint(msg.sender, _initialSupply);
    }



    //Add user (called from Python)
    function newUser(address _newUser, Gender _gender) external onlyOwner {
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
        if (_gender == Gender.female) {
            numWomen += 1*10^18;
        //else, add 10E18 to male count
        } else if (_gender == Gender.male) {
            numMen += 1*10^18;
        }

        //Set GenderRatioIndex
        _setGenderRatioIndex();
        //emit NewUser event
        emit NewUser(_newUser);
    }

    //Rewards (called from Python)
    function dispenseTimeReward(address _user) external onlyOwner {
        //Dispense funds for 1 hour of logged time (1 LTH)
        transferFrom(msg.sender, _user, 1*10**18);
        //Increment user balance (do I need to do this? does the above take care of this?)
        emit MinuteLogged(_user);
        
    }
    //Costs
        //Calculate charge per swipe
    function chargeForSwipe(address _user) external payable onlyOwner {
        //Charges for a swipe based on gender and GenderRatioIndex
        //Multiply default rate (rate where genders are equal) by genderRatioIndex
        uint defaultRate = uint(1*10**18/120); //allows 120 profitable swipes per minute at default rate

        //Retrieve user's gender from "users" mapping

        if (users[_user].gender == Gender.male) {
            //Transfer value divided by 100 to account for precision in genderRatioIndex
            transferFrom(_user, msg.sender, defaultRate*genderRatioIndex);
        }

        if (users[_user].gender == Gender.female) {
            //Transfer value divided by 100 to account for precision in genderRatioIndex
            transferFrom(_user, msg.sender, SafeMath.div(defaultRate, genderRatioIndex));
        }
    }

    //Messaging
    function chargeForMessage(address _user, uint toxicity) external payable onlyOwner {
        //toxicity measured by off-chain sentiment analysis

    }

    function _setGenderRatioIndex() internal {
        //Compares Ratio of Men to Women
        genderRatioIndex = SafeMath.div(numMen*100, numWomen);
    }

}