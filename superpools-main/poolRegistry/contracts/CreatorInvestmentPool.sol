pragma solidity ^0.6.0;

import "./InvestmentPool.sol";
import "./interface/IAssetsManageTeam.sol";
import "./interface/ICalculateWithdrawEth.sol";

contract CreatorInvestmentPool {
    // Address pool registry
    address private _poolRegistry;
    // Address ReturnInvestmentLpartner
    address private _returnInvestmentLpartner;
    // Address token request contract
    IAssetsManageTeam private _assetsManageTeam;
    // Calculate withdraw ETH for Limited partner
    ICalculateWithdrawEth private _calculateWithdraw;
    
    constructor(address pool, IAssetsManageTeam assetManageTeam, address returnInvestLpartner, ICalculateWithdrawEth calculateWithdrawEth) public {
        _poolRegistry = pool;
        _assetsManageTeam = assetManageTeam;
        _returnInvestmentLpartner = returnInvestLpartner;
        _calculateWithdraw = calculateWithdrawEth;
    }
    
    /**
     * @dev Create new investment pool.
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
    ) public returns (address) {
        require(msg.sender == _poolRegistry, "CreatorInvestmentPool: sender don't poolRegistry contract");

        InvestmentPool _poolContract = new InvestmentPool(
            token,
            lockPeriod,
            depositFixedFee,
            referralDepositFee,
            anualPrecent,
            penaltyEarlyWithdraw,
            superAdmin,
            gPartner,
            lPartner,
            startupTeam,
            msg.sender,
            _returnInvestmentLpartner,
            _assetsManageTeam,
            _calculateWithdraw
        );

        address poolAddress = address(_poolContract);

        _assetsManageTeam.addManager(poolAddress);

        return poolAddress;
    }
}