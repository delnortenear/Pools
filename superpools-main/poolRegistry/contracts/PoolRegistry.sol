pragma solidity ^0.6.0;

import "./interface/IPool.sol";
import "./interface/IAssetsManageTeam.sol";
import "./interface/IReturnInvestmentLpartner.sol";
import "./interface/ICreator.sol";
import "./interface/IRoleModel.sol";

import "./access/TeamRole.sol";
import "./utils/EnumerableSet.sol";

contract PoolRegistry is TeamRole, IRoleModel {
    using EnumerableSet for EnumerableSet.AddressSet;

    event CreatePool(address pool);
    event AddPool(address pool);
    event UpdatePool(address pool);

    // The address of the contract that creates the Investment Pool
    address private _creatorInvestPool;
    // Smart contract for request deposit
    IAssetsManageTeam private _assetsManageTeam;
    // Smart contract for return investment
    IReturnInvestmentLpartner private _returnInvestmentLpartner;

    // Collection of all pool addresses
    EnumerableSet.AddressSet private _addressesPools;

    /*************************************************************
    ****************** MANAGEMENT POOL METHODS *******************
    **************************************************************/

    /**
    * @dev Create new Investment Pool.
    * @param token The address token contract for investment pool.
    * @param lockPeriod The blocking period of assets.
    * @param depositFixedFee Ether deposit commission LPartner.
    * @param referralDepositFee Referral commission.
    * @param anualPrecent The annual percentage of tokens.
    * @param superAdmin The An address that has privileges SUPER_ADMIN_ROLE.
    * @param gPartner The An address that has privileges GENERAL_PARTNER_ROLE.
    * @param lPartner The An address that has privileges LIMITED_PARTNER_ROLE.
    * @param startupTeam The An address that has privileges TEAM_ROLE.
    * @return A boolean that indicates if the operation was successful.
    */
    function createPool(
        address token,
        uint256 lockPeriod,
        uint256 depositFixedFee,
        uint256 referralDepositFee,
        uint256 anualPrecent,
        uint256 penaltyEarlyWithdraw,
        address superAdmin,
        address gPartner,
        address lPartner,
        address startupTeam
    ) public onlyTeam returns (bool) {
        ICreator _creatorContract = ICreator(_creatorInvestPool);

        address _investPool = _creatorContract.createPool(
            token,
            lockPeriod,
            depositFixedFee,
            referralDepositFee,
            anualPrecent,
            penaltyEarlyWithdraw,
            superAdmin,
            gPartner,
            lPartner,
            startupTeam
        );

        _addressesPools.add(_investPool);

        emit CreatePool(_investPool);
        return true;
    }
    
    /**
    * @dev Add new smart contract Investment Pool.
    * @param poolAddress The address Investment Pool.
    * @return A boolean that indicates if the operation was successful.
    */
    function addPool(address poolAddress) public onlyTeam returns (bool) {
        // require(!_addressesPools.contains(poolAddress), "PoolRegistry: pool with this address already exists");

        _addressesPools.add(poolAddress);
        _assetsManageTeam.addManager(poolAddress);

        emit AddPool(poolAddress);
        return true;
    }

    /**
    * @dev Update smart contract Investment Pool.
    * @param token The address token contract.
    * @param locked The address to query the wager of.
    * @param depositFixedFee Commission from the deposit Limited Partner.
    * @param referralDepositFee Commission from the deposit if the limited partner has a referral.
    * @param anualPrecent The annual percentage of tokens.
    * @param penaltyEarlyWithdraw The penalty for early withdraw.
    * @return A boolean that indicates if the operation was successful.
    */
    function updatePool(address pool, bool publicPool, address token, uint256 locked, uint256 depositFixedFee, uint256 referralDepositFee, uint256 anualPrecent, uint256 penaltyEarlyWithdraw) public onlyTeam returns (bool) {
        IPool poolContract = IPool(pool);
        poolContract._updatePool(publicPool, token, locked, depositFixedFee, referralDepositFee, anualPrecent, penaltyEarlyWithdraw);
        
        emit UpdatePool(pool);
        return true;
    }

    /*************************************************************
    ******************** ASSET MANAGE TEAM ***********************
    **************************************************************/

    /**
    * @dev Deposit token for Investment Pool.
    * @param pool The address Investment Pool.
    * @param amount Amount of deposit tokens.
    * @return A boolean that indicates if the operation was successful.
    */
    function depositTokenToPool(address pool, uint256 amount) public returns(bool) {
        IPool _poolContract = IPool(pool);
        _poolContract._depositTokenPoolRegistry(msg.sender, amount);

        return true;
    }

    /**
    * @dev Withdraw ether from Investment pool STARTUP_TEAM.
    * @param pool The address Investment Pool.
    * @param amount Amount of withdraw ether.
    * @return A boolean that indicates if the operation was successful.
    */
    function withdrawEtherStartupTeam(address pool, uint256 amount) public returns(bool) {
        IPool _poolContract = IPool(pool);
        _poolContract._withdrawEtherTeam(msg.sender, amount);

        return true;
    }

    /**
    * @dev Creation of a request to deposit token or withdraw ether.
    * @param withdraw Boolean value to indicate the type of request.
    * @param pool The address Investment Pool.
    * @param maxValue Maximum possible deposit.
    * @return A boolean that indicates if the operation was successful.
    */
    function requestStartupTeam(bool withdraw, address pool, uint256 maxValue) public returns (bool) {        
        return _assetsManageTeam._request(withdraw, pool, msg.sender, maxValue);
    }

    /**
    * @dev Approve of a request to deposit token or withdraw ether.
    * @param pool The address Investment Pool.
    * @param team Address to confirm the token deposit.
    * @return A boolean that indicates if the operation was successful.
    */
    function approveReqStartupTeam(address pool, address team) public returns (bool) {
        return _assetsManageTeam._approve(pool, team, msg.sender);
    }
    
    /**
    * @dev Disapprove of a request to deposit a token or withdraw ether.
    * @param pool The address Investment Pool.
    * @param team Address to disapprove the token deposit.
    * @return A boolean that indicates if the operation was successful.
    */
    function disapproveReqStartupTeam(address pool, address team) public returns (bool) {
        return _assetsManageTeam._disapprove(pool, team, msg.sender);
    }
    
    /**
    * @dev Lock deposit or withdraw ether for startup team address.
    * @param pool The address Investment Pool.
    * @param team Address to lock token deposit or withdraw ether.
    * @return A boolean that indicates if the operation was successful.
    */
    function lockStartupTeam(address pool, address team) public returns (bool) {        
        return _assetsManageTeam._lock(pool, team, msg.sender);
    }

    /**
    * @dev Unlock deposit or withdraw ether for startup team address.
    * @param pool The address Investment Pool.
    * @param team Address to unlock token deposit or withdraw ether.
    * @return A boolean that indicates if the operation was successful.
    */
    function unlockStartupTeam(address pool, address team) public returns (bool) {        
        return _assetsManageTeam._unlock(pool, team, msg.sender);
    }

    /**
    * @dev Get information about the user who made a deposit ETH.
    * @param pool The address Investment Pool.
    * @param owner The address investor pool.
    * @param index The owner's deposit index.
    */
    function getDepositEtherPool(address pool, address owner, uint256 index) public view 
        returns (
            uint256 amount,
            uint256 time,
            uint256 lock_period,
            bool refund_authorize)
        {
            IPool _poolContract = IPool(pool);
            (amount, time, lock_period, refund_authorize) = _poolContract.getDepositEther(owner, index);

            return (amount, time, lock_period, refund_authorize);
    }

    /**
    * @dev Get information about the user who made a depositToken or withdrawEther.
    * @param pool The address Investment Pool.
    * @param owner The address investor pool.
    * @param index The owner's deposit index.
    */
    function getPerformedOperationsTeamStartup(address pool, address owner, uint256 index) public view
        returns(
            address token, 
            uint256 amountToken,
            uint256 withdrawEther,
            uint256 time)
        {
            (token, amountToken, withdrawEther, time) = _assetsManageTeam.getPerformedOperations(pool, owner, index);

            return (token, amountToken, withdrawEther, time);
    }

    /**
    * @dev Get all addresses that made a requests for a token deposit or withdraw.
    * @param pool The address Investment Pool.
    */
    function getRequestsTeam(address pool) public view returns (address[] memory) {
        return _assetsManageTeam.getRequests(pool);
    }

    /**
    * @dev Get all addresses that made a approve for a token deposit or withdraw.
    * @param pool The address Investment Pool.
    */
    function getApprovalReqTeam(address pool) public view returns (address[] memory) {
        return _assetsManageTeam.getApproval(pool);
    }

    /**
    * @dev Get request information for team address.
    * @param pool The address Investment Pool.
    * @param team The address team account.
    */
    function getRequestTeamAddress(address pool, address team) public view returns (bool lock, uint256 maxValueToken, uint256 madeValueToken, uint256 maxValueEther, uint256 madeValueEther) {
        (lock, maxValueToken, madeValueToken, maxValueEther, madeValueEther) = _assetsManageTeam.getRequestTeamAddress(pool, team);
        return (lock, maxValueToken, madeValueToken, maxValueEther, madeValueEther);
    }

    /**
    * @dev Get approve information for team address.
    * @param pool The address Investment Pool.
    * @param team The address team account.
    */
    function getApproveTeamAddress(address pool, address team) public view returns (bool lock, uint256 maxValueToken, uint256 madeValueToken, uint256 maxValueEther, uint256 madeValueEther) {
        (lock, maxValueToken, madeValueToken, maxValueEther, madeValueEther) = _assetsManageTeam.getApproveTeamAddress(pool, team);
        return (lock, maxValueToken, madeValueToken, maxValueEther, madeValueEther);
    }

    /*************************************************************
    ********************* REFERRAL METHODS ***********************
    **************************************************************/

    /**
    * @dev Adding referral LPartner.
    * @param pool The address Investment Pool.
    * @param referral The address referral LPartner.
    * @return A boolean that indicates if the operation was successful.
    */
    function setReferral(address pool, address lPartner, address referral) public returns (bool) {
        IPool _poolContract = IPool(pool);
        require(_poolContract.hasRole(LIMITED_PARTNER_ROLE, lPartner), "PoolRegistry: parameter Lpartner has no role LPartner");

        return _poolContract._setReferral(msg.sender, lPartner, referral);
    }

    /**
    * @dev Get address referal for LPartner.
    * @param pool The address Investment Pool.
    */
    function getReferral(address pool, address lPartner) public view returns (address) {
        IPool _poolContract = IPool(pool);
        return _poolContract.getReferral(lPartner);
    }

    /*************************************************************
    **************** METHODS RETURNS INVESTMENT ******************
    **************************************************************/

    /**
    * @dev Creating a request for a return investment Limited partner.
    * @param pool The address Investment Pool contract.
    * @param index Investment index.
    * @return A boolean that indicates if the operation was successful.
    */
    function requestReturnInvestmentLpartner(address pool, uint256 index) public returns (bool) {
        return _returnInvestmentLpartner._request(pool, msg.sender, index);
    }

    /**
    * @dev Approve of a request for return investment.
    * @param pool The address Investment Pool contract.
    * @param lPartner Address to confirm the request.
    * @return A boolean that indicates if the operation was successful.
    */
    function approveReturnInvestmentLpartner(address pool, address lPartner) public returns (bool) {
        return _returnInvestmentLpartner._approve(pool, lPartner, msg.sender);
    }

    /**
    * @dev Returns investment pool.
    * @param pool The address Investment Pool contract.
    * @return A boolean that indicates if the operation was successful.
    */
    function withdrawEtherLpartner(address pool) public returns (bool) {        
        IPool _poolContract = IPool(pool);
        return _poolContract._withdrawEtherLpartner(msg.sender);
    }

    /**
    * @dev Disapprove of a request for return investment.
    * @param pool The address Investment Pool contract.
    * @param lPartner Address to confirm the request.
    * @return A boolean that indicates if the operation was successful.
    */
    function disapproveReturnInvestmentLpartner(address pool, address lPartner) public returns (bool) {
        return _returnInvestmentLpartner._disapprove(pool, lPartner, msg.sender);
    }

    /**
    * @dev Get all requests.
    * @param pool address investment pool contract.
    */
    function getAddrRequestsReturnInvesLpartner(address pool) public view returns (address[] memory) {
        return _returnInvestmentLpartner.getRequests(pool);
    }

    /**
    * @dev Get all requests current LPartner.
    * @param pool address investment pool contract.
    * @param lPartner address limited parner role.
    */
    function getRequestsReturnInvestLpartner(address pool, address lPartner) public view returns (uint256[] memory) {
        return _returnInvestmentLpartner.getRequestsLpartner(pool, lPartner);
    }

    /*************************************************************
    ********************* INTERNAL METHODS ***********************
    **************************************************************/

    /**
    * @dev Deposit ETH for Investment Pool.
    * @param pool The address Investment Pool.
    * @return A boolean that indicates if the operation was successful.
    */
    function depositEtherToPool(address payable pool) public payable returns(bool) {
        uint256 amount = msg.value;
        IPool _poolContract = IPool(pool);

        pool.transfer(amount);
        _poolContract._depositEtherPoolRegistry(msg.sender, amount);

        return true;
    }

    /**
    * @dev Returns ether to investment pool from team.
    * @param pool The address Investment Pool.
    * @return A boolean that indicates if the operation was successful.
    */
    function returnsEtherFromTeam(address payable pool) public payable returns(bool) {
        IPool _poolContract = IPool(pool);
        require(_poolContract.hasRole(STARTUP_TEAM_ROLE, msg.sender), "PoolRegistry: sender has no role TeamStartup");

        pool.transfer(msg.value);

        return true;
    }

    /**
    * @dev Allow ether deposit to investment pool.
    * @param pool The address Investment Pool.
    * @return A boolean that indicates if the operation was successful.
    */
    function activateDepositToPool(address pool) public onlyTeam returns (bool) {
        IPool _poolContract = IPool(pool);
        return _poolContract._activateDepositToPool();
    }

    /**
    * @dev Disallow ether deposit to investment pool.
    * @param pool The address Investment Pool.
    * @return A boolean that indicates if the operation was successful.
    */
    function disactivateDepositToPool(address pool) public onlyTeam returns (bool) {
        IPool _poolContract = IPool(pool);
        return _poolContract._disactivateDepositToPool();
    }

    /**
    * @dev Grants role to account.
    * @param pool The address Investment Pool.
    * @param role Role account.
    * @param account The address for grant role.
    * @return A boolean that indicates if the operation was successful.
    */
    function grantRoleInvestmentPool(address pool, bytes32 role, address account) public returns (bool) {        
        IPool _poolContract = IPool(pool);

        require(_poolContract.hasRole(SUPER_ADMIN_ROLE, msg.sender), "PoolRegistry: sender has no role GPartner");

        _poolContract.grantRole(role, account);

        return true;
    }

    /**
    * @dev Revoke role to account.
    * @param pool The address Investment Pool.
    * @param role Role account.
    * @param account The address for grant role.
    * @return A boolean that indicates if the operation was successful.
    */
    function revokeRoleInvestmentPool(address pool, bytes32 role, address account) public returns (bool) {        
        IPool _poolContract = IPool(pool);

        require(_poolContract.hasRole(SUPER_ADMIN_ROLE, msg.sender), "PoolRegistry: sender has no role GPartner");

        _poolContract.revokeRole(role, account);

        return true;
    }

    /**
    * @dev Set the address of the contract creating Investment Pools.
    * @param creatorContract The address creator pool.
    * @return A boolean that indicates if the operation was successful.
    */
    function setAddressCreatorInvestPool(address creatorContract) public onlyTeam returns (bool) {
        _creatorInvestPool = creatorContract;
        return true;
    }
    
    /**
    * @dev Set address assetManageTeam contract.
    * @param addrContract The address AssetManageTeam contract.
    * @return A boolean that indicates if the operation was successful.
    */
    function setAssetManageTeamContract(IAssetsManageTeam addrContract) public onlyTeam returns (bool) {
        _assetsManageTeam = addrContract;
        return true;
    }

    /**
    * @dev Set address ReturnInvestmentLpartner contract.
    * @param addrContract The address ReturnInvestmentLpartner contract.
    * @return A boolean that indicates if the operation was successful.
    */
    function setReturnInvestmentLpartner(IReturnInvestmentLpartner addrContract) public onlyTeam returns (bool) {
        _returnInvestmentLpartner = addrContract;
        return true;
    }

    /**
    * @dev Get all Investment Pool addresses.
    */
    function getPools() public view returns (address[] memory) {
        return _addressesPools.collection();
    }

    /**
    * @dev Get information about the Investment Pool.
    * @param pool The address Investment Pool.
    */
    function getInfoPool(address pool) public view
        returns(
            bool isPublicPool,
            address token, 
            uint256 locked, 
            uint256 rate, 
            uint256 depositFixedFee, 
            uint256 referralDepositFee, 
            uint256 anualPrecent, 
            uint256 penaltyEarlyWithdraw, 
            uint256 totalInvestLpartner,
            uint256 premiumFee
        )
    {
        IPool _poolContract = IPool(pool);
        (isPublicPool, token, locked, rate, depositFixedFee, , , , ,) = _poolContract.getInfoPool();
        (, , , , , referralDepositFee, anualPrecent, penaltyEarlyWithdraw, totalInvestLpartner, premiumFee) = _poolContract.getInfoPool();
        
        return (isPublicPool, token, locked, rate, depositFixedFee, referralDepositFee, anualPrecent, penaltyEarlyWithdraw, totalInvestLpartner, premiumFee);
    }

    /**
    * @dev Get address TokenRequestContract.
    */
    function getAssetManageTeamContract() public view returns (IAssetsManageTeam) {
        return _assetsManageTeam;
    }

    /**
    * @dev Get address TokenRequestContract.
    */
    function getReturnInvesmentLpartner() public view returns (IReturnInvestmentLpartner) {
        return _returnInvestmentLpartner;
    }

    /**
    * @dev Get all addresses for role.
    * @param pool The address Investment Pool.
    * @param role Role accounts.
    */
    function getAddressesRolesPool(address pool, bytes32 role) public view returns (address[] memory) {
        IPool _poolContract = IPool(pool);
        return _poolContract.getMembersRole(role);
    }

    /**
    * @dev Get address contract creator Invest pool.
    */
    function getAddressCreatorInvestPool() public view returns(address) {
        return _creatorInvestPool;
    }
}