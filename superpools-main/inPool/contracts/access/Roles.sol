pragma solidity ^0.6.0;

import "./AccessControl.sol";
import "../ownership/Ownable.sol";
import "../interface/IRoleModel.sol";

contract Roles is AccessControl, Ownable, IRoleModel {
    bool private _finalized = false;
    event Finalized();

    modifier onlyAdmin() {
        require(hasRole(SUPER_ADMIN_ROLE, msg.sender), "Roles: caller does not have the super admin role role");
        _;
    }

    modifier onlyGPartner() {
        require(hasRole(GENERAL_PARTNER_ROLE, msg.sender), "Roles: caller does not have the general partner role");
        _;
    }

    modifier onlyLPartner() {
        require(hasRole(LIMITED_PARTNER_ROLE, msg.sender), "Roles: caller does not have the limited partner role");
        _;
    }

    modifier onlyTeam() {
        require(hasRole(TEAM_ROLE, msg.sender), "Roles: caller does not have the team role");
        _;
    }

    modifier onlySturtapTeam() {
        require(hasRole(STURTAP_TEAM_ROLE, msg.sender), "Roles: caller does not have the sturtap team role");
        _;
    }

    modifier onlyReferer() {
        require(hasRole(REFERER_ROLE, msg.sender), "Roles: caller does not have the referer role");
        _;
    }

    modifier onlyOracle() {
        require(hasRole(ORACLE_ROLE, msg.sender), "Roles: caller does not have the oracle role");
        _;
    }

    modifier onlyPoolRegistry() {
        require(hasRole(POOL_REGISTRY, msg.sender), "Roles: caller does not have the pool regystry role");
        _;
    }

    constructor () public {
        _setRoleAdmin(GENERAL_PARTNER_ROLE, SUPER_ADMIN_ROLE);
        _setRoleAdmin(LIMITED_PARTNER_ROLE, SUPER_ADMIN_ROLE);
        _setRoleAdmin(TEAM_ROLE, SUPER_ADMIN_ROLE);
        _setRoleAdmin(STURTAP_TEAM_ROLE, SUPER_ADMIN_ROLE);
        _setRoleAdmin(REFERER_ROLE, SUPER_ADMIN_ROLE);
        _setRoleAdmin(ORACLE_ROLE, SUPER_ADMIN_ROLE);
        _setRoleAdmin(POOL_REGISTRY, SUPER_ADMIN_ROLE);
    }

    /**
     * @dev Create and ading new role.
     * @param role role account.
     * @param account account for adding to the role.
     */
    function addAdmin(bytes32 role, address account) public virtual onlyOwner returns (bool) {
        require(!_finalized, "ManagerRole: already finalized");

        _setupRole(role, account);
        return true;
    }

    /**
     * @dev Block adding admins.
     */
    function finalize() public virtual onlyOwner {
        require(!_finalized, "ManagerRole: already finalized");

        _finalized = true;
        emit Finalized();
    }
}