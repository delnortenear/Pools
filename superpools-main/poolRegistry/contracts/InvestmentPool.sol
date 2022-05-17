pragma solidity ^0.6.0;

import "./interface/IPoolRegistry.sol";
import "./interface/IAssetsManageTeam.sol";
import "./interface/IERC20.sol";
import "./interface/ICalculateWithdrawEth.sol";

import "./access/PoolRoles.sol";
import "./math/SafeMath.sol";

contract InvestmentPool is PoolRoles {
    using SafeMath for uint256;

    event DepositEther(address indexed from, uint256 value);

    bool private _isPublicPool = true;
    // Address token contract 
    address private _token;
    // Period lock investment
    uint256 private _lockPeriod;
    // Token unit rate
    uint256 private _rate;
    // Ether deposit commission LPartner
    uint256 private _depositFixedFee;
    // Referral commission
    uint256 private _referralDepositFee;
    // Anual precent
    uint256 private _anualPrecent;
    // Penalty early withdraw token
    uint256 private _penaltyEarlyWithdraw;
    // Total investment limited partner 
    uint256 private _totalInvestLpartner;
    // Premium fee for General partner
    uint256 private _premiumFee;

    struct DepositEth {
        uint256 amount;          // Amount of funds deposited
        uint256 time;            // Deposit time
        uint256 lock_period;     // Asset lock time
        bool refund_authorize;   // Are assets unlocked for withdrawal
    }

    // Collection of investors who made a deposit ETH
    mapping(address => DepositEth[]) private _depositesEth;
    // All referrals who are limited partners
    mapping(address => address) private _referrals;

    // Smart contract for requests deposit or withdraw
    IAssetsManageTeam private _assetsManageTeam;
    // Smart contract pool registry contract
    IPoolRegistry private _poolRegistry;
    // Calculate withdraw ether for team
    ICalculateWithdrawEth private _calculateWithdraw;

    modifier onlyAdmin(address sender) {
        if(
            hasRole(GENERAL_PARTNER_ROLE, sender) ||
            hasRole(SUPER_ADMIN_ROLE, sender) ||
            _poolRegistry.isTeam(sender)
        ) {
            _;
        } else {
            revert("The sender does not have permission");
        }
    }

    constructor(
        address token,
        uint256 locked,
        uint256 depositFixedFee,
        uint256 referralDepositFee,
        uint256 anualPrecent,
        uint256 penaltyEarlyWithdraw,
        address superAdmin,
        address gPartner,
        address lPartner,
        address team,
        address poolRegistry,
        address returnInvestmentLpartner,
        IAssetsManageTeam assetsManageTeam,
        ICalculateWithdrawEth calculateWithdraw
    ) public {
        _token = token;
        _lockPeriod = locked;
        _depositFixedFee = depositFixedFee;
        _referralDepositFee = referralDepositFee;
        _anualPrecent = anualPrecent;
        _penaltyEarlyWithdraw = penaltyEarlyWithdraw;
        _assetsManageTeam = assetsManageTeam;
        _poolRegistry = IPoolRegistry(poolRegistry);

        PoolRoles.addAdmin(SUPER_ADMIN_ROLE, msg.sender);
        PoolRoles.addAdmin(SUPER_ADMIN_ROLE, superAdmin);
        PoolRoles.addAdmin(SUPER_ADMIN_ROLE, poolRegistry);

        PoolRoles.finalize();
        grantRole(GENERAL_PARTNER_ROLE, gPartner);
        grantRole(LIMITED_PARTNER_ROLE, lPartner);
        grantRole(STARTUP_TEAM_ROLE, team);
        grantRole(POOL_REGISTRY, poolRegistry);
        grantRole(RETURN_INVESTMENT_LPARTNER, returnInvestmentLpartner);

        _calculateWithdraw = calculateWithdraw;
    }

    fallback() external payable {
        if (msg.sender == address(_poolRegistry)) {
            return;
        }

        if (!isContract(msg.sender)) {
            if (!hasRole(LIMITED_PARTNER_ROLE, msg.sender)) {
                _transferGeneralPartner(msg.value);
                return;
            }
            _depositEther(msg.sender, msg.value);
            return;
        } else if(!hasRole(POOL_REGISTRY, msg.sender)) {
            _transferGeneralPartner(msg.value);
            return;
        }
    }

    /**
    * @dev Get information about the user who made a deposit ETH.
    * @param owner The address investor pool.
    * @param index The owner's deposit index.
    */
    function getDepositEther(address owner, uint256 index) public view returns(uint256 amount, uint256 time, uint256 lock_period, bool refund_authorize) {
        return (
            _depositesEth[owner][index].amount,
            _depositesEth[owner][index].time,
            _depositesEth[owner][index].lock_period,
            _depositesEth[owner][index].refund_authorize
        );
    }

    /**
    * @dev Get the number of deposits ETH made by an investor.
    * @param owner The address investor.
    */
    function getDepositEtherLength(address owner) public view returns(uint256) {
        return (_depositesEth[owner].length);
    }

    /**
    * @dev Get the referral account limited partner.
    */
    function getReferral(address lPartner) public view returns (address) {
        return _referrals[lPartner];
    }

    /**
    * @dev Get information by this pool.
    */
    function getInfoPool() public view
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
        return (
            _isPublicPool,
            _token,
            _lockPeriod,
            _rate,
            _depositFixedFee,
            _referralDepositFee,
            _anualPrecent,
            _penaltyEarlyWithdraw,
            _totalInvestLpartner,
            _premiumFee
        );
    }

    /*************************************************************
    **************** METHODS RETURNS INVESTMENT ******************
    **************************************************************/

    /**
    * @dev Approve of a request for return investment. (RETURN_INVESTMENT_LPARTNER)
    * @param lPartner The address account with role Limited partner.
    * @param index Investment index.
    * @return A boolean that indicates if the operation was successful.
    */
    function _approveWithdrawLpartner(address lPartner, uint256 index) external onlyReturnsInvestmentLpartner returns (bool) {
        _depositesEth[lPartner][index].refund_authorize = true;
        return true;
    }

    /*************************************************************
    ****************** METHODS POOL REGISTRY *********************
    **************************************************************/

    /**
    * @dev Deposit ETH. (POOL REGISTRY)
    * @param sender address sender transaction.
    * @param amount deposit ETH.
    * @return A boolean that indicates if the operation was successful.
    */
    function _depositEtherPoolRegistry(address sender, uint256 amount) external onlyPoolRegistry returns (bool) {
        require(hasRole(LIMITED_PARTNER_ROLE, sender), "InvestmentPool: the sender does not have permission");
        return _depositEther(sender, amount);
    }

    /**
    * @dev Deposit Token. (POOL REGISTRY)
    * @param sender Address sender transaction.
    * @param amount Deposit ETH.
    * @return A boolean that indicates if the operation was successful.
    */
    function _depositTokenPoolRegistry(address payable sender, uint256 amount) external onlyPoolRegistry returns (bool) {
        require(hasRole(STARTUP_TEAM_ROLE, sender), "InvestmentPool: the sender does not have permission");
        return _depositToken(sender, amount);
    }

    /**
    * @dev Withdraw token recipient to TeamStartup. (POOL REGISTRY)
    * @param sender Address sender transaction.
    * @param amount Count sending ETH.
    * @return A boolean that indicates if the operation was successful.
    */
    function _withdrawEtherTeam (address payable sender, uint256 amount) external onlyPoolRegistry returns (bool) {
        require(hasRole(STARTUP_TEAM_ROLE, sender), "InvestmentPool: the sender does not have permission");
        _assetsManageTeam._withdrawEther(address(this), sender, amount);

        sender.transfer(amount);

        return true;
    }

    /**
    * @dev Withdraw ether LPartner. (POOL REGISTRY)
    * @param sender Address sender transaction.
    * @return A boolean that indicates if the operation was successful.
    */
    function _withdrawEtherLpartner(address payable sender) external onlyPoolRegistry returns (bool) {
        require(hasRole(LIMITED_PARTNER_ROLE, sender), "InvestmentPool: the sender does not have permission");

        uint256 totalAmountReturn;
        uint256 teamReward;

        (totalAmountReturn, teamReward) = _calculateWithdraw.calcWithdrawEthLpartner(address(this), sender);
        
        require(totalAmountReturn != 0, "InvestmentPool: total amount for limited partner is 0");
        require(totalAmountReturn > address(this).balance, "InvestmentPool: total amount for limited partner is 0");
        
        if (teamReward > 0) {
            payable(_poolRegistry.getTeamAddresses()[1]).transfer(teamReward);
        }

        sender.transfer(totalAmountReturn);
        return true;
    }

    /**
    * @dev Activate the pool for the possibility of ether deposit. (POOL REGISTRY)
    * @return A boolean that indicates if the operation was successful.
    */
    function _activateDepositToPool() external onlyPoolRegistry returns (bool) {
        require(!_isPublicPool, "InvestmentPool: the pool is already activated");

        _isPublicPool = true;
        return true;
    }

    /**
    * @dev Disactivate the pool for the possibility of ether deposit. (POOL REGISTRY)
    * @return A boolean that indicates if the operation was successful.
    */
    function _disactivateDepositToPool() external onlyPoolRegistry returns (bool) {
        require(_isPublicPool, "InvestmentPool: the pool is already deactivated");

        _isPublicPool = false;
        return true;
    }

    /**
    * @dev Set referral for limited partner. (POOL REGISTRY)
    * @param sender Address sender transaction.
    * @param lPartner referral limited partner.
    * @param referral for lPartner.
    * @return A boolean that indicates if the operation was successful.
    */
    function _setReferral(address sender, address lPartner, address referral) external onlyPoolRegistry onlyAdmin(sender) returns (bool) {
        _referrals[lPartner] = referral;
        return true;
    }

    /**
    * @dev Update data contract. (POOL REGISTRY)
    * @param token The address token contract.
    * @param locked The address to query the wager of.
    * @param depositFixedFee Commission from the deposit Limited Partner.
    * @param referralDepositFee Commission from the deposit if the limited partner has a referral.
    * @param anualPrecent The annual percentage of tokens.
    * @param penaltyEarlyWithdraw The penalty for early withdraw.
    * @return A boolean that indicates if the operation was successful.
    */
    function _updatePool(
        bool isPublicPool,
        address token,
        uint256 locked,
        uint256 depositFixedFee,
        uint256 referralDepositFee,
        uint256 anualPrecent,
        uint256 penaltyEarlyWithdraw
    ) external onlyPoolRegistry returns (bool) {
        _isPublicPool = isPublicPool;
        _token = token;
        _lockPeriod = locked;
        _depositFixedFee = depositFixedFee;
        _referralDepositFee = referralDepositFee;
        _anualPrecent = anualPrecent;
        _penaltyEarlyWithdraw = penaltyEarlyWithdraw;
        return true;
    }
    
    /*************************************************************
    ********************* PRIVATE METHODS ************************
    **************************************************************/
    
    /**
    * @dev Deposit ETH. (PRIVATE METHOD)
    * @param sender Address sender transaction.
    * @param amount Count deposit ETH.
    * @return A boolean that indicates if the operation was successful.
    */
    function _depositEther(address sender, uint256 amount) private returns (bool) {
        require(_isPublicPool, "InvestmentPool: pool deposit blocked");
        
        address payable team = payable(_poolRegistry.getTeamAddresses()[1]);
        uint256 depositFee = amount.mul(_depositFixedFee).div(100);
        uint256 depositFeeReferrer = amount.mul(_referralDepositFee).div(100);
        uint256 totalDeposit = 0;

        if (_referrals[sender] != address(0)) {
            payable(_referrals[sender]).transfer(depositFeeReferrer);
            team.transfer(depositFee);
            totalDeposit = amount.sub(depositFee).sub(depositFeeReferrer);
        } else {
            team.transfer(depositFee);
            totalDeposit = amount.sub(depositFee);
        }

        _depositesEth[sender].push(DepositEth(
            totalDeposit,
            block.timestamp,
            _lockPeriod,
            false
        ));

        _totalInvestLpartner = _totalInvestLpartner.add(amount);

        emit DepositEther(sender, amount);
        return true;
    }
    
    /**
    * @dev Deposit Token. (PRIVATE METHOD)
    * @param sender Address sender transaction.
    * @param amount Count deposit Token.
    * @return A boolean that indicates if the operation was successful.
    */
    function _depositToken(address payable sender, uint256 amount) private returns (bool) {
        _assetsManageTeam._depositToken(address(this), sender, _token, amount);

        uint256 amountEther = _getTokenAmount(amount);
        require(amountEther <= address(this).balance, "InvestmentPool: contract balance is insufficient");
        // require(amountEther != 0, "InvestmentPool: contract balance is insufficient");

        sender.transfer(amountEther);
        return true;
    }

    /**
    * @dev Transfer ETH on address General Partner. (PRIVATE METHOD)
    * @param amount Count sending token GPartner.
    */
    function _transferGeneralPartner(uint256 amount) private returns (bool) {
        address payable gPartner = payable(getMembersRole(GENERAL_PARTNER_ROLE)[0]);
        gPartner.transfer(amount);
        
        return true;
    }

    // ***** HELPERS ***** //
    /**
    * @dev Calculates the ratio of the number of tokens in relation to the rate ETH.
    */
    function _getTokenAmount(uint256 weiAmount) public view returns (uint256) {
        IERC20 _tokenContract = IERC20(_token);
        uint8 DECIMALS = _tokenContract.decimals();

        return (weiAmount.mul(_rate)).div(10 ** uint256(DECIMALS));
    }

    /**
    * @dev Checks if an address is a contract.
    */
    function isContract(address _addr) private view returns (bool is_contract) {
        uint length;
        assembly {
            // retrieve the size of the code on target address, this needs assembly
            length := extcodesize(_addr)
        }
        return (length>0);
    }

    /**
    * @dev Remove element for current index.
    */
    function _removeIndexArray(uint256 index, DepositEth[] storage array) internal virtual {
        for(uint256 i = index; i < array.length-1; i++) {
            array[i] = array[i+1];
        }
        
        array.pop();
    }
}