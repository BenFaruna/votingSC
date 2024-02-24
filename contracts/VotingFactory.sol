// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Voting.sol";


contract VotingFactory {
    address public owner;
    Voting[] votingPools;

    mapping(address => address) poolOwner;

    event VotingPoolCreated(address indexed _poolAddress, address indexed _owner);

    constructor() {
        owner = msg.sender;
    }

    function createVotingPool(string memory _description, string[] memory _options) public {
        Voting _newPool = new Voting(msg.sender, _description, _options);
        votingPools.push(_newPool);
        address _poolAddress = address(_newPool);
        poolOwner[_poolAddress] = msg.sender;

        emit VotingPoolCreated(_poolAddress, msg.sender);
    }

    function getMostRecentPool() public view returns (Voting) {
        uint256 _totalPools = votingPools.length;
        require(_totalPools > 0, "No voting pool has been created");

        return votingPools[_totalPools-1];
    }
}