pragma solidity ^0.6.0;

import "./AccessControl.sol";
import "../ownership/Ownable.sol";
import "../interface/IRoleModel.sol";

contract PoolRoles is AccessControl, Ownable, IRoleModel {
    bool private _finalized = false;
    event Finalized();

    modifier onlyGPartner() {
        require(hasRole(GENERAL_PARTNER_ROLE, msg.sender), "Roles: caller does not have the general partner role");
        _;
    }

    modifier onlyLPartner() {
        require(hasRole(LIMITED_PARTNER_ROLE, msg.sender), "Roles: caller does not have the limited partner role");
        _;
    }

    modifier onlyStartupTeam() {
        require(hasRole(STARTUP_TEAM_ROLE, msg.sender), "Roles: caller does not have the team role");
        _;
    }

    modifier onlyPoolRegistry() {
        require(hasRole(POOL_REGISTRY, msg.sender), "Roles: caller does not have the pool regystry role");
        _;
    }

    modifier onlyReturnsInvestmentLpartner() {
        require(hasRole(RETURN_INVESTMENT_LPARTNER, msg.sender), "Roles: caller does not have the return invesment lpartner role");
        _;
    }

    modifier onlyOracle() {
        require(hasRole(ORACLE, msg.sender), "Roles: caller does not have oracle role");
        _;
    }

    constructor () public {
        _setRoleAdmin(GENERAL_PARTNER_ROLE, SUPER_ADMIN_ROLE);
        _setRoleAdmin(LIMITED_PARTNER_ROLE, SUPER_ADMIN_ROLE);
        _setRoleAdmin(STARTUP_TEAM_ROLE, SUPER_ADMIN_ROLE);
        _setRoleAdmin(POOL_REGISTRY, SUPER_ADMIN_ROLE);
        _setRoleAdmin(RETURN_INVESTMENT_LPARTNER, SUPER_ADMIN_ROLE);
        _setRoleAdmin(ORACLE, SUPER_ADMIN_ROLE);
    }

    /**
     * @dev Create and ading new role.
     * @param role role account.
     * @param account account for adding to the role.
     */
    function addAdmin(bytes32 role, address account) public onlyOwner returns (bool) {
        require(!_finalized, "ManagerRole: already finalized");

        _setupRole(role, account);
        return true;
    }

    /**
     * @dev Block adding admins.
     */
    function finalize() public onlyOwner {
        require(!_finalized, "ManagerRole: already finalized");

        _finalized = true;
        emit Finalized();
    }
}