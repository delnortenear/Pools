pragma solidity ^0.6.0;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        address[] accounts;
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
        role.accounts.push(account);
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        
        for (uint256 i; i < role.accounts.length; i++) {
            if (role.accounts[i] == account) {
                _removeIndexArray(i, role.accounts);
                break;
            }
        }
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }

    function _removeIndexArray(uint256 index, address[] storage array) internal virtual {
        for(uint256 i = index; i < array.length-1; i++) {
            array[i] = array[i+1];
        }
        
        array.pop();
    }
}