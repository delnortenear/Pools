pragma solidity ^0.6.0;

import "./access/ManagerRole.sol";

import "./interface/IERC20.sol";
import "./interface/IPool.sol";
import "./interface/IRoleModel.sol";

import "./utils/EnumerableSet.sol";
import "./math/SafeMath.sol";

contract AssetsManageTeam is ManagerRole, IRoleModel {
    using EnumerableSet for EnumerableSet.AddressSet;
    using SafeMath for uint256;

    event Request(address indexed pool, address from, uint256 maxValue);
    event Approve(address indexed pool, address to, uint256 maxValueToken, uint256 maxValueEther);
    event Disapprove(address indexed pool, address to);
    event Lock(address indexed pool, address to);
    event Unlock(address indexed pool, address to);
    event DepositERC20(address indexed pool, address from, address token, uint256 value);
    event WithdrawEth(address indexed pool, address to, uint256 value);

    struct TeamOperation {
        address token;                 // Address token
        uint256 amountToken;           // Count token deposit
        uint256 withdrawEther;         // Count withdraw ether
        uint256 time;                  // Time deposit
    }

    struct TeamAccount {
        bool lock;                     // Lock operation
        uint256 maxValueToken;         // Max value deposit token
        uint256 madeValueToken;        // Already made value
        uint256 maxValueEther;         // Max value withdraw ether
        uint256 madeValueEther;        // Already withdrawn ether
    }

    // Collection of investors who made a deposit token
    mapping(address => mapping(address => TeamOperation[])) private _performedOperations;
    // A collection of those who made the request
    mapping(address => mapping(address => TeamAccount)) private _requests;
    // Collection of those to whom the request was confirmed
    mapping(address => mapping(address => TeamAccount)) private _approval;
    // Collection of addresses that made the request
    mapping(address => EnumerableSet.AddressSet) private _requestsTeam;
    // Collection of addresses to which the request was confirmed
    mapping(address => EnumerableSet.AddressSet) private _approvalTeam;
    
    /**
    * @dev Deposit token to Investment Pool.
    * @param pool The address Investment Pool contract.
    * @param team The address depositor.
    * @param token The address token contract.
    * @param amount Amount of deposit tokens.
    * @return A boolean that indicates if the operation was successful.
    */
    function _depositToken(address pool, address team, address token, uint256 amount) external onlyManager returns (bool) {
        require(amount > 0, "AssetsManageTeam: the number of sent token is 0");
        require(!_approval[pool][team].lock, "AssetsManageTeam: deposit token locked");
        require(_approval[pool][team].madeValueToken.add(amount) <= _approval[pool][team].maxValueToken, "AssetsManageTeam: token deposit not confirmed");

        IERC20 tokenContract = IERC20(token);

        tokenContract.transferFrom(team, pool, amount);
        _approval[pool][team].madeValueToken = _approval[pool][team].madeValueToken.add(amount);
        
        _performedOperations[pool][team].push(TeamOperation(
            token,
            amount,
            0,
            block.timestamp
        ));

        emit DepositERC20(pool, team, token, amount);
        return true;
    }

    /**
    * @dev Withdraw ether from investment pool contract.
    * @param pool The address Investment Pool contract.
    * @param team The address team account.
    * @param amount Amount of withdraw ether.
    * @return A boolean that indicates if the operation was successful.
    */
    function _withdrawEther(address pool, address team, uint256 amount) external onlyManager returns (bool) {
        require(amount > 0, "AssetsManageTeam: the number of sent token is 0");
        require(!_approval[pool][team].lock, "AssetsManageTeam: deposit token locked");
        require(_approval[pool][team].madeValueEther.add(amount) <= _approval[pool][team].maxValueEther, "AssetsManageTeam: withdraw not confirmed");

        _approval[pool][team].madeValueEther = _approval[pool][team].madeValueEther.add(amount);

        _performedOperations[pool][team].push(TeamOperation(
            address(0),
            0,
            amount,
            block.timestamp
        ));

        emit WithdrawEth(pool, team, amount);
        return true;
    }

    /**
    * @dev Creating a request for a deposit of tokens in exchange for ether or withdrawal of tokens.
    * @param withdraw Indicates whether to withdraw ether without a deposit in tokens or not.
    * @param pool The address Investment Pool contract.
    * @param team The address depositor.
    * @param maxValue Maximum possible token deposit.
    * @return A boolean that indicates if the operation was successful.
    */
    function _request(bool withdraw, address pool, address team, uint256 maxValue) external onlyManager returns(bool) {
        require(pool != address(0), "AssetsManageTeam: pool zero address");
        require(team != address(0), "AssetsManageTeam: team zero address");
        require(maxValue > 0, "AssetsManageTeam: value is zero");

        IPool _poolContract = IPool(pool);
        require(_poolContract.hasRole(STARTUP_TEAM_ROLE, team), "AssetsManageTeam: sender has no role TEAM");

        if (withdraw) {
            _requests[pool][team] = TeamAccount(true, 0, 0, maxValue, 0);
        } else {
            _requests[pool][team] = TeamAccount(true, maxValue, 0, 0, 0);
        }

        if(!_requestsTeam[pool].contains(team)) {
            _requestsTeam[pool].add(team);
        }

        emit Request(pool, team, maxValue);
        return true;
    }
    
    /**
    * @dev Approve of a request to deposit a token or withdraw ether.
    * @param pool The address Investment Pool contract.
    * @param team Address to confirm the request.
    * @return A boolean that indicates if the operation was successful.
    */
    function _approve(address pool, address team, address owner) external onlyManager returns(bool) {
        require(pool != address(0), "AssetsManageTeam: pool zero address");
        require(team != address(0), "AssetsManageTeam: team zero address");

        IPool _poolContract = IPool(pool);
        require(_poolContract.hasRole(GENERAL_PARTNER_ROLE, owner), "AssetsManageTeam: owner has no role GPartner");

        uint256 maxValueToken = _requests[pool][team].maxValueToken;
        uint256 maxValueEther = _requests[pool][team].maxValueEther;

        if (_requests[pool][team].maxValueToken > 0) {
            if (_approvalTeam[pool].contains(team)) {
                _approval[pool][team].maxValueToken = (_approval[pool][team].maxValueToken).add(maxValueToken);
            } else {
                _approval[pool][team] = TeamAccount(false, maxValueToken, 0, 0, 0);
                _approvalTeam[pool].add(team);
            }
        } else  if(_requests[pool][team].maxValueEther > 0) {
            if (_approvalTeam[pool].contains(team)) {
                _approval[pool][team].maxValueEther = (_approval[pool][team].maxValueEther).add(maxValueEther);
            } else {
                _approval[pool][team] = TeamAccount(false, 0, 0, maxValueEther, 0);
                _approvalTeam[pool].add(team);
            }
        }
        
        delete _requests[pool][team];
        _requestsTeam[pool].remove(team);
        
        emit Approve(pool, team, maxValueToken, maxValueEther);
        return true;
    }
    
    /**
    * @dev Disapprove of a request.
    * @param pool The address Investment Pool contract.
    * @param team Address to disapprove.
    * @return A boolean that indicates if the operation was successful.
    */
    function _disapprove(address pool, address team, address owner) external onlyManager returns(bool) {
        require(_requestsTeam[pool].contains(team), "AssetsManageTeam: there is no request for this account");

        IPool _poolContract = IPool(pool);
        require(_poolContract.hasRole(GENERAL_PARTNER_ROLE, owner), "AssetsManageTeam: owner has no role GPartner");

        delete _requests[pool][team];
        _requestsTeam[pool].remove(team);

        emit Disapprove(pool, team);
        return true;
    }
    
    /**
    * @dev Lock the operation deposit or withdraw to the team address.
    * @param pool The address Investment Pool contract.
    * @param team The address depositor.
    * @return A boolean that indicates if the operation was successful.
    */
    function _lock(address pool, address team, address owner) external onlyManager returns(bool) {
        require(_approvalTeam[pool].contains(team), "AssetsManageTeam: team address not exists");
        require(!_approval[pool][team].lock, "AssetsManageTeam: the account is already blocked");

        IPool _poolContract = IPool(pool);
        require(_poolContract.hasRole(GENERAL_PARTNER_ROLE, owner), "AssetsManageTeam: owner has no role GPartner");

        _approval[pool][team].lock = true;

        emit Lock(pool, team);
        return true;
    }
    
    /**
    * @dev Unlock the operation deposit or withdraw to the team address.
    * @param pool The address Investment Pool contract.
    * @param team The address depositor.
    * @return A boolean that indicates if the operation was successful.
    */
    function _unlock(address pool, address team, address owner) external onlyManager returns(bool) {
        require(_approvalTeam[pool].contains(team), "AssetsManageTeam: team address not exists");
        require(_approval[pool][team].lock, "AssetsManageTeam: the account is already blocked");

        IPool _poolContract = IPool(pool);
        require(_poolContract.hasRole(GENERAL_PARTNER_ROLE, owner), "AssetsManageTeam: owner has no role GPartner");

        _approval[pool][team].lock = false;

        emit Unlock(pool, team);
        return true;
    }

    /**
    * @dev Get count operation for team account.
    * @param pool address investment pool contract
    * @param owner The address investor pool..
    */
    function getPerformedOperationsLength(address pool, address owner) public view returns(uint256 length) {
        return _performedOperations[pool][owner].length;
    }

    /**
    * @dev Get information about the user who made a performed operation.
    * @param pool address investment pool contract
    * @param owner The address investor pool.
    * @param index The owner's deposit index.
    */
    function getPerformedOperations(address pool, address owner, uint256 index) public view returns(address token, uint256 amountToken, uint256 withdrawEther, uint256 time) {
        return (
            _performedOperations[pool][owner][index].token,
            _performedOperations[pool][owner][index].amountToken,
            _performedOperations[pool][owner][index].withdrawEther,
            _performedOperations[pool][owner][index].time
        );
    }
    
    /**
    * @dev Get all addresses that made a requests.
    * @param pool address investment pool.
    */
    function getRequests(address pool) public view returns(address[] memory) {
        return _requestsTeam[pool].collection();
    }
    
    /**
    * @dev Get all addresses that made a approve for a token deposit.
    * @param pool address investment pool.
    */
    function getApproval(address pool) public view returns(address[] memory) {
        return _approvalTeam[pool].collection();
    }
    
    /**
    * @dev Get request information for team address.
    * @param pool address investment pool.
    * @param team The address that made the deposit
    */
    function getRequestTeamAddress(address pool, address team) public view returns(bool lock, uint256 maxValueToken, uint256 madeValueToken, uint256 maxValueEther, uint256 madeValueEther) {
        return (
            _requests[pool][team].lock,
            _requests[pool][team].maxValueToken,
            _requests[pool][team].madeValueToken,
            _requests[pool][team].maxValueEther,
            _requests[pool][team].madeValueEther
            );
    }
    
    /**
    * @dev Get approve information for team address.
    * @param pool address investment pool.
    * @param team The address that made the deposit.
    */
    function getApproveTeamAddress(address pool, address team) public view returns(bool lock, uint256 maxValueToken, uint256 madeValueToken, uint256 maxValueEther, uint256 madeValueEther) {
        return (
            _approval[pool][team].lock,
            _approval[pool][team].maxValueToken,
            _approval[pool][team].madeValueToken,
            _approval[pool][team].maxValueEther,
            _approval[pool][team].madeValueEther
            );
    }
}