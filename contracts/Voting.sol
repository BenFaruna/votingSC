// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Voting contract
/// @notice This contract allows users to vote on a pool of options
contract Voting {
    // user that created the voting pool
    address public owner;

    // total number of votes cast
    uint256 public totalVotes;
    
    struct Pool {
        string description; // The description of the pool users are voting on
        string[] options; // The options users can vote on
        uint256[] votes; // The number of votes each option has received
    }

    Pool _pool;

    // mapping to check if a user has voted
    mapping(address => bool) public hasVoted;

    /// @notice Event emitted when a user successfully votes
    /// @param _voter the address of the user that voted
    /// @param _option the option the user voted for
    event VoteSuccessful(address indexed _voter, uint256 _option);

    /// @notice Constructor to create a new voting pool
    /// @param _owner the address of the user that created the pool
    /// @param _description the description of the pool
    /// @param _options the options users can vote on
    constructor(address _owner, string memory _description, string[] memory _options) {
        owner = _owner;

        _pool.description = _description;
        _pool.options = _options;

        for (uint256 i = 0; i < _options.length; i = i+1) {
            _pool.votes.push(0);
        }
    }

    /// @notice Get the description of the pool
    /// @return the description of the pool
    function getDescription() public view returns (string memory) {
        return _pool.description;
    }

    /// @notice Get the options users can vote on
    function getOptions() public view returns (string[] memory) {
        return _pool.options;
    }

    /// @notice Get the number of votes for a particular option in the pool
    /// @param _option the option to get the number of votes for
    function getVotesByOption(uint256 _option) public view returns (uint256) {
        require(hasVoted[msg.sender], "Cannot check votes until you have voted");
        require(_pool.options.length >= _option, "Option does not exist");
        require(_option > 0, "Option starts from 1");
        return _pool.votes[_option-1];
    }

    /// @notice Allows a user to vote on a particular option
    /// @param _option the option to vote for
    /// @dev A user can only vote once and cannot vote for an option that does not exist
    function vote(uint256 _option) public {
        require(!hasVoted[msg.sender], "Cannot vote twice");
        require(_pool.options.length >= _option, "Option does not exist");
        require(_option > 0, "Option starts from 1");
        hasVoted[msg.sender] = true;
        totalVotes = totalVotes + 1;
        _pool.votes[_option-1] = _pool.votes[_option-1] + 1;

        emit VoteSuccessful(msg.sender, _option);
    }

    /// @notice Get the total number of options in the pool
    /// @return the total number of options
    function getTotalOptions() public view returns(uint256) {
        return _pool.options.length;
    }
}