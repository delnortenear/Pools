pragma solidity ^0.6.0;

import "./lib/Roles.sol";

contract ManagerRole {
    using Roles for Roles.Role;

    event ManagerAdded(address indexed account);
    event ManagerRemoved(address indexed account);

    Roles.Role private _managers;

    constructor () internal {
        _addManager(msg.sender);
    }

    modifier onlyManager() {
        require(isManager(msg.sender), "ManagerRole: caller does not have the Manager role");
        _;
    }

    function isManager(address account) public view returns (bool) {
        return _managers.has(account);
    }

    function getManagerAddresses() public view returns (address[] memory) {
        return _managers.accounts;
    }

    function addManager(address account) public onlyManager {
        _addManager(account);
    }

    function renounceManager() public {
        _removeManager(msg.sender);
    }

    function _addManager(address account) internal {
        _managers.add(account);
        emit ManagerAdded(account);
    }

    function _removeManager(address account) internal {
        _managers.remove(account);
        emit ManagerRemoved(account);
    }
}