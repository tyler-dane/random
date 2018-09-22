pragma solidity ^0.4.16;

contract Pool {
    address public owner;
    address[] public participants; 
    mapping(address => uint) public participantContribs;
    uint public totalContribs = 0;
    bool public isClosed = false;
    bool public hasPaidOut = false;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function join() payable public {
        require(msg.value > 0);
        require(msg.sender != owner);
        require(!isClosed);
        
        bool alreadyContributed = false;
        for (uint i = 0; i <  participants.length; i++) {
            if (participants[i] == msg.sender) {
                alreadyContributed = true;
                break;
            }
        }
        if (!alreadyContributed) {
            participants.push(msg.sender);
        }
        
        participantContribs[msg.sender] += msg.value;
        totalContribs += msg.value;
    }
    
    function close() public {
        require(owner == msg.sender);
        isClosed = true;
    }
    
    function numParticipants() public view returns (uint) {
        return participants.length;
    }
    
    function disburse(address recipient) public {
        require(owner == msg.sender);
        require(!hasPaidOut);
        hasPaidOut = true;
        return recipient.transfer(totalContribs);
        
    }
    
}