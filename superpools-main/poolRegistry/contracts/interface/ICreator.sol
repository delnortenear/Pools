pragma solidity ^0.6.0;

interface ICreator {
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
    ) external returns (address);
}
