pragma solidity ^0.6.0;

import "./lib/Roles.sol";

contract TeamRole {
    using Roles for Roles.Role;

    event TeamAdded(address indexed account);
    event TeamRemoved(address indexed account);

    Roles.Role private _team;

    constructor () internal {
        _addTeam(msg.sender);
    }

    modifier onlyTeam() {
        require(isTeam(msg.sender), "TeamRole: caller does not have the Team role");
        _;
    }

    function isTeam(address account) public view returns (bool) {
        return _team.has(account);
    }

    function getTeamAddresses() public view returns (address[] memory) {
        return _team.accounts;
    }

    function addTeam(address account) public onlyTeam {
        _addTeam(account);
    }

    function renounceTeam() public {
        _removeTeam(msg.sender);
    }

    function _addTeam(address account) internal {
        _team.add(account);
        emit TeamAdded(account);
    }

    function _removeTeam(address account) internal {
        _team.remove(account);
        emit TeamRemoved(account);
    }
}