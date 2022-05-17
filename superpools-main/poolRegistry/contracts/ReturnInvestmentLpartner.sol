pragma solidity ^0.6.0;

import "./access/ManagerRole.sol";

import "./interface/IPool.sol";
import "./interface/IRoleModel.sol";

import "./utils/EnumerableSet.sol";
import "./math/SafeMath.sol";

contract ReturnInvestmentLpartner is ManagerRole, IRoleModel {
    using EnumerableSet for EnumerableSet.AddressSet;
    using SafeMath for uint256;

    event Request(address indexed pool, address from, uint256 index);
    event Approve(address indexed pool, address to);
    event Disapprove(address indexed pool, address to);

    // Collection request for return investment Limited Partner
    mapping(address => mapping(address => uint256[])) private _requests;
    // Collection of addresses that made the request
    mapping(address => EnumerableSet.AddressSet) private _requestsLpartner;

    /**
    * @dev Creating a request for a return investment Limited partner.
    * @param pool The address Investment Pool contract.
    * @param lPartner The address account with role Limited partner.
    * @param index Investment index.
    * @return A boolean that indicates if the operation was successful.
    */
    function _request(address pool, address lPartner, uint256 index) external onlyManager returns(bool) {
        IPool _poolContract = IPool(pool);

        require(_poolContract.hasRole(LIMITED_PARTNER_ROLE, lPartner), "ReturnInvestmentLpartner: sender has no role Limited Partner");
        require(_poolContract.getDepositEtherLength(lPartner) > 0, "ReturnInvestmentLpartner: сurrent address has not been invested");
        require(index < _poolContract.getDepositEtherLength(lPartner), "ReturnInvestmentLpartner: deposit index does not exist");

        for (uint256 i = 0; i < _requests[pool][lPartner].length; i++) {
          require(_requests[pool][lPartner][i] != index, "ReturnInvestmentLpartner: a query with this index already exists");
        }

        _requests[pool][lPartner].push(index);
        _requestsLpartner[pool].add(lPartner);

        emit Request(pool, lPartner, index);
        return true;
    }

    /**
    * @dev Approve of a request for return investment.
    * @param pool The address Investment Pool contract.
    * @param lPartner Address to confirm the request.
    * @param sender Address with general partner role.
    * @return A boolean that indicates if the operation was successful.
    */
    function _approve(address pool, address lPartner, address sender) external onlyManager returns(bool) {
        require(_requestsLpartner[pool].contains(lPartner), "ReturnInvestmentLpartner: there is no request for this account");

        IPool _poolContract = IPool(pool);

        require(_poolContract.hasRole(GENERAL_PARTNER_ROLE, sender), "ReturnInvestmentLpartner: sender has no role General Partner");

        for (uint256 i = 0; i < _requests[pool][lPartner].length; i++) {
          _poolContract._approveWithdrawLpartner(lPartner, _requests[pool][lPartner][i]);
        }
        
        delete _requests[pool][lPartner];
        _requestsLpartner[pool].remove(lPartner);
        
        emit Approve(pool, lPartner);
        return true;
    }
    
    /**
    * @dev Disapprove of a request.
    * @param pool The address Investment Pool contract.
    * @param lPartner Address to disapprove.
    * @param sender Address with general partner role.
    * @return A boolean that indicates if the operation was successful.
    */
    function _disapprove(address pool, address lPartner, address sender) external onlyManager returns(bool) {
        IPool _poolContract = IPool(pool);

        require(_poolContract.hasRole(GENERAL_PARTNER_ROLE, sender), "ReturnInvestmentLpartner: sender has no role General Partner");
        require(_requestsLpartner[pool].contains(lPartner), "ReturnInvestmentLpartner: there is no request for this account");

        delete _requests[pool][lPartner];
        _requestsLpartner[pool].remove(lPartner);
 
        emit Disapprove(pool, lPartner);
        return true;
    }

    /**
    * @dev Get all requests.
    * @param pool address investment pool contract.
    */
    function getRequests(address pool) public view returns(address[] memory) {
        return _requestsLpartner[pool].collection();
    }

    /**
    * @dev Get all requests current LPartner.
    * @param pool address investment pool contract.
    * @param lPartner address limited parner role.
    */
    function getRequestsLpartner(address pool, address lPartner) public view returns(uint256[] memory) {
        return _requests[pool][lPartner];
    }
}