// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Voting.sol";

/// @title VotingFactory contract
/// @notice Can be used to create new voting pools
contract VotingFactory {
    // deployer of the contract
    address public owner;

    // voting pools created
    Voting[] votingPools;

    // mapping of voting pool address to owner address
    mapping(address => address) poolOwner;

    /// @notice Event emitted when a new voting pool is created
    /// @param _poolAddress the address of the voting pool
    /// @param _owner the address of the user that created the pool
    event VotingPoolCreated(address indexed _poolAddress, address indexed _owner);

    constructor() {
        owner = msg.sender;
    }

    /// @notice Create a new voting pool
    /// @param _description the description of the pool
    /// @param _options the options users can vote on
    function createVotingPool(string memory _description, string[] memory _options) public {
        Voting _newPool = new Voting(msg.sender, _description, _options);
        votingPools.push(_newPool);
        address _poolAddress = address(_newPool);
        poolOwner[_poolAddress] = msg.sender;

        emit VotingPoolCreated(_poolAddress, msg.sender);
    }

    /// @notice Get the most recent voting pool created
    /// @return the most recent voting pool
    function getMostRecentPool() public view returns (Voting) {
        uint256 _totalPools = votingPools.length;
        require(_totalPools > 0, "No voting pool has been created");

        return votingPools[_totalPools-1];
    }
}