// add MIT License
pragma solidity >=0.7.0 <0.8.0;

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
        numMen = 1;
        numWomen = 1;
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
            gender:_gender //collect gender as argument
        });
        //if gender is female (true), add 10E18 to female count
        if (_gender == Gender.female) {
            numWomen += 1;
        //else, add 10E18 to male count
        } else if (_gender == Gender.male) {
            numMen += 1;
        }
        _mint(_newUser, 100*10**18);
        //Set GenderRatioIndex
        _setGenderRatioIndex();
        //emit NewUser event
        emit NewUser(_newUser);
    }

    //Rewards (called from Python)
    function dispenseTimeReward(address _user) external onlyOwner {
        //Dispense funds for 1 hour of logged time (1 LTH)
        transferFrom(msg.sender, _user, 1*10**18);
        emit MinuteLogged(_user);  
    }
    //Costs
        //Calculate charge per swipe
    function chargeForSwipe(address _user) external payable onlyOwner {
        //Charges for a swipe based on gender and GenderRatioIndex
        //Multiply default rate (rate where genders are equal) by genderRatioIndex
        uint defaultRate = uint(1*10**18/uint(120)); //allows 120 profitable swipes per minute at default rate

        //Retrieve user's gender from "users" mapping

        if (users[_user].gender == Gender.male) {
            //Transfer value divided by 100 to account for precision in genderRatioIndex
            transferFrom(_user, msg.sender, uint(SafeMath.div(defaultRate*genderRatioIndex, 100)));
        }

        if (users[_user].gender == Gender.female) {
            //Transfer value divided by 100 to account for precision in genderRatioIndex
            transferFrom(_user, msg.sender, uint(SafeMath.div(defaultRate*100, genderRatioIndex)));
        }
    }

    //Messaging
    function chargeForMessage(address _user, uint _toxicity) external payable onlyOwner {
        //Charges user per message. toxicity measured by off-chain sentiment analysis
        transferFrom(_user, msg.sender, _toxicity*10**15);
    }

    function _setGenderRatioIndex() internal {
        //Compares Ratio of Men to Women
        genderRatioIndex = uint(SafeMath.div(numMen*100, numWomen));
    }

}