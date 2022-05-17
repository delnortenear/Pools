pragma solidity ^0.6.0;

import "./interface/IPool.sol";
import "./interface/ITokenRequest.sol";
import "./interface/IERC20.sol";

import "./access/Roles.sol";

import "./utils/EnumerableSet.sol";
import "./math/SafeMath.sol";   

contract InvestmentPool is Roles {
    using SafeMath for uint256;
    using EnumerableSet for EnumerableSet.AddressSet;

    event DepositEther(address indexed from, uint256 value);

    // Address token contract
    address private _token;
    // Address token request contract
    address private _tokenReq;
    // Period lock investment
    uint256 private _locked;
    // Token unit rate
    uint256 private _rate;
    // Comission withdraw
    uint256 private _interestFee;
    uint256 private _anualPrecent;

    struct DepositEth {
        address investor;      // Address investor
        uint256 amount;        // Amount of funds deposited
        uint256 time;          // Deposit time
        uint256 lock_period;   // Asset lock time
        bool refund_authorize; // Are assets unlocked for withdrawal
    }

    // Collection of investors who made a deposit ETH
    mapping(address => DepositEth[]) private _depositesEth;

    // Smart contract for request deposit
    ITokenRequest private _tokenRequestContract;
    
    constructor(
        address token,
        uint256 locked,
        uint256 rate,
        uint256 interestFee,
        uint256 anualPrecent,
        address superAdmin,
        address gPartner,
        address lPartner,
        address team,
        address sturtapTeam,
        address referer,
        address poolRegistry,
        ITokenRequest tokenRequestContract
    ) public {
        _token = token;
        _locked = locked;
        _rate = rate;
        _interestFee = interestFee;
        _anualPrecent = anualPrecent;
        _tokenRequestContract = tokenRequestContract;

        Roles.addAdmin(SUPER_ADMIN_ROLE, msg.sender);
        Roles.addAdmin(SUPER_ADMIN_ROLE, superAdmin);
        Roles.addAdmin(SUPER_ADMIN_ROLE, poolRegistry);

        Roles.finalize();
        grantRole(GENERAL_PARTNER_ROLE, gPartner);
        grantRole(LIMITED_PARTNER_ROLE, lPartner);
        grantRole(TEAM_ROLE, team);
        grantRole(STURTAP_TEAM_ROLE, sturtapTeam);
        grantRole(REFERER_ROLE, referer);
        grantRole(POOL_REGISTRY, poolRegistry);
    }

    fallback() external payable {
        if (!isContract(msg.sender)) {
            if (!hasRole(LIMITED_PARTNER_ROLE, msg.sender)) {
                _transferGeneralPartner(msg.value);
                return;
            }
            depositEther();
            return;
        } else if(!hasRole(POOL_REGISTRY, msg.sender)) {
            _transferGeneralPartner(msg.value);
            return;
        }
    }

    /**
    * @dev Deposit ETH.
    * @return A boolean that indicates if the operation was successful.
    */
    function depositEther() public virtual payable onlyLPartner returns (bool) {
        return _depositEther(msg.sender, msg.value);
    }

    /**
    * @dev Deposit Token.
    * @return A boolean that indicates if the operation was successful.
    */
    function depositToken(uint256 amount) public virtual onlyTeam returns (bool) {
        return _depositToken(msg.sender, amount);
    }

    /**
    * @dev Change the address of the current Investment Pool token.
    * @param token New token address.
    * @return A boolean that indicates if the operation was successful.
    */
    function setToken(address token) public virtual onlyGPartner returns (bool) {
        _token = token;
        return true;
    }

    /**
    * @dev Set lock period.
    * @param lock New lock period.
    * @return A boolean that indicates if the operation was successful.
    */
    function setLock(uint256 lock) public virtual onlyGPartner returns (bool) {
        _locked = lock;
        return true;
    }

    /**
    * @dev Set rate for one token.
    * @param newRate New rate.
    * @return A boolean that indicates if the operation was successful.
    */
    function setRate(uint256 newRate) public virtual onlyGPartner returns (bool) {
        _rate = newRate;
        return true;
    }

    /**
    * @dev Set interest fee.
    * @param fee New comisiotn.
    * @return A boolean that indicates if the operation was successful.
    */
    function setInterestFee(uint256 fee) public virtual onlyGPartner returns (bool) {
        _interestFee = fee;
        return true;
    }

    /**
    * @dev Set annual precent.
    * @return A boolean that indicates if the operation was successful.
    */
    function setAnnualPrecent(uint256 precent) public virtual onlyGPartner returns (bool) {
        _anualPrecent = precent;
        return true;
    }
    
    /**
    * @dev Set the address of the contract creating Investment Pools.
    * @param tokenReq The address creator pool.
    * @return A boolean that indicates if the operation was successful.
    */
    function setTokenRequestContract(ITokenRequest tokenReq) public onlyGPartner returns (bool) {
        _tokenRequestContract = tokenReq;
        return true;
    }
    
    /**
    * @dev Get information about the user who made a deposit ETH.
    * @param owner The address investor pool.
    * @param index The owner's deposit index.
    */
    function getDepositEther(address owner, uint256 index) public view returns(address investor, uint256 amount, uint256 time, uint256 lock_period, bool refund_authorize) {
        return (
            _depositesEth[owner][index].investor,
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
    * @dev Get token address.
    */
    function token() public view returns (address) {
        return _token;
    }

    /**
    * @dev Get lock period.
    */
    function locked() public view returns (uint256) {
        return _locked;
    }

    /**
    * @dev Get rate for one token.
    */
    function rate() public view returns (uint256) {
        return _rate;
    }

    /**
    * @dev Get interest fee.
    */
    function interestFee() public view returns (uint256) {
        return _interestFee;
    }

    /**
    * @dev Get anual precent.
    */
    function anualPrecent() public view returns (uint256) {
        return _anualPrecent;
    }
    
    // ***** METHODS FOR POOL REGISTRY ***** //

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
    function _depositTokenPoolRegistry(address payable sender, uint256 amount) public virtual onlyPoolRegistry returns (bool) {
        require(hasRole(TEAM_ROLE, sender), "InvestmentPool: the sender does not have permission");
        return _depositToken(sender, amount);
    }

    /**
    * @dev Change the address of the current Investment Pool token. (POOL REGISTRY)
    * @param sender Address sender transaction.
    * @param token New token address.
    * @return A boolean that indicates if the operation was successful.
    */
    function _setToken(address sender, address token) external virtual onlyPoolRegistry returns (bool) {
        require(hasRole(GENERAL_PARTNER_ROLE, sender), "InvestmentPool: the sender does not have permission");
        
        _token = token;
        return true;
    }

    /**
    * @dev Update data contract. (POOL REGISTRY)
    * @param sender address sender transaction.
    * @param lock The blocking period of assets.
    * @param rate The address to query the wager of.
    * @param interestFee The asset withdrawal commission.
    * @param anualPrecent The annual percentage of tokens.
    * @return A boolean that indicates if the operation was successful.
    */
    function _updatePool(address sender, uint256 lock, uint256 rate, uint256 interestFee, uint256 anualPrecent) external virtual onlyPoolRegistry returns (bool) {
        require(hasRole(GENERAL_PARTNER_ROLE, sender), "InvestmentPool: the sender does not have permission");

        _locked = lock;
        _rate = rate;
        _interestFee = interestFee;
        _anualPrecent = anualPrecent;
        
        return true;
    }
    
    /**
    * @dev Withdraw token recipient. (POOL REGISTRY)
    * @param sender address sender transaction.
    * @param recipient The address recipient transaction.
    * @param amount Count sending ETH.
    * @return A boolean that indicates if the operation was successful.
    */
    function _withdrawEther (address sender, address payable recipient, uint256 amount) external virtual onlyPoolRegistry returns (bool) {
        require(hasRole(GENERAL_PARTNER_ROLE, sender), "InvestmentPool: the sender does not have permission");
        uint256 precent = amount.div(5);
        uint256 countPayout = amount.sub(precent);
        recipient.transfer(countPayout);
        
        return true;
    }
    
    // ***** PRIVATE METHODS ***** //
    
    /**
    * @dev Deposit ETH. (PRIVATE METHOD)
    * @param sender Address sender transaction.
    * @param amount Count deposit ETH.
    * @return A boolean that indicates if the operation was successful.
    */
    function _depositEther(address sender, uint256 amount) private returns (bool) {
        require(sender != address(0), "InvestmentPool: sneder zero address");
        require(amount > 0, "InvestmentPool: the number of sent ETH is 0");

        _depositesEth[sender].push(DepositEth(
            sender,
            amount,
            block.timestamp,
            _locked,
            false
        ));

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
        _tokenRequestContract._depositToken(address(this), sender, _token, amount);

        uint256 amountEther = _getTokenAmount(amount);
        require(amountEther <= address(this).balance, "InvestmentPool: contract balance is insufficient");

        sender.transfer(amountEther);
        return true;
    }
    
    /**
    * @dev Transfer ETH on address General Partner. (PRIVATE METHOD)
    * @param amount Count sending token GPartner.
    */
    function _transferGeneralPartner(uint256 amount) private returns (bool) {
        require(amount > 0, "InvestmentPool: the number of sent ETH is 0");
        
        address payable gPartner = payable(getMembersRole(GENERAL_PARTNER_ROLE)[0]);
        gPartner.transfer(amount);
        
        return true;
    }

    // ***** HELPERS ***** //
    
    /**
    * @dev Calculates the ratio of the number of tokens in relation to the rate ETH.
    */
    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
        return weiAmount.mul(_rate);
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
}