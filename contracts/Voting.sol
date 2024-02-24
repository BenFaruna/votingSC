// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Voting {
    address public owner;

    uint256 public totalVotes;

    struct Pool {
        string description;
        string[] options;
        uint256[] votes;
    }

    Pool _pool;

    mapping(address => bool) public hasVoted;

    event VoteSuccessful(address indexed _voter, uint256 _option);

    constructor(address _owner, string memory _description, string[] memory _options) {
        owner = _owner;

        _pool.description = _description;
        _pool.options = _options;

        for (uint256 i = 0; i < _options.length; i = i+1) {
            _pool.votes.push(0);
        }
    }

    function getDescription() public view returns (string memory) {
        return _pool.description;
    }

    function getOptions() public view returns (string[] memory) {
        return _pool.options;
    }

    function getVotesByOption(uint256 _option) public view returns (uint256) {
        require(hasVoted[msg.sender], "Cannot check votes until you have voted");
        require(_pool.options.length >= _option, "Option does not exist");
        require(_option > 0, "Option starts from 1");
        return _pool.votes[_option-1];
    }

    function vote(uint256 _option) public {
        require(!hasVoted[msg.sender], "Cannot vote twice");
        require(_pool.options.length >= _option, "Option does not exist");
        require(_option > 0, "Option starts from 1");
        hasVoted[msg.sender] = true;
        totalVotes = totalVotes + 1;
        _pool.votes[_option-1] = _pool.votes[_option-1] + 1;

        emit VoteSuccessful(msg.sender, _option);
    }

    function getTotalOptions() public view returns(uint256) {
        return _pool.options.length;
    }
}