pragma solidity ^0.6.0;

interface IPool {

    // ***** GET INFO ***** //

    function hasRole(bytes32 role, address account) external view returns (bool);

    function getRoleMemberCount(bytes32 role) external view returns (uint256);

    function getDepositEther(address owner, uint256 index) external view returns(uint256 amount, uint256 time, uint256 lock_period, bool refund_authorize);

    function getDepositEtherLength(address owner) external view returns(uint256);

    function getMembersRole(bytes32 role) external view returns (address[] memory Accounts);

    function getInfoPool() external view returns( bool isPublicPool, address token, uint256 locked, uint256 rate, uint256 depositFixedFee, uint256 referralDepositFee, uint256 anualPrecent, uint256 penaltyEarlyWithdraw, uint256 totalInvestLpartner, uint256 premiumFee);

    function getReferral(address lPartner) external view returns (address);
    
    // ***** SET INFO ***** //

    function _updatePool(bool isPublicPool, address token, uint256 locked, uint256 depositFixedFee, uint256 referralDepositFee, uint256 anualPrecent, uint256 penaltyEarlyWithdraw) external returns (bool);

    function _depositEtherPoolRegistry(address sender, uint256 amount) external returns (bool);

    function _depositTokenPoolRegistry(address payable sender, uint256 amount) external returns (bool);

    function _withdrawEtherTeam (address payable sender, uint256 amount) external returns (bool);

    function _activateDepositToPool() external returns (bool);

    function _disactivateDepositToPool() external returns (bool);

    function _setReferral(address sender, address lPartner, address referral) external returns (bool);

    function _approveWithdrawLpartner(address lPartner, uint256 index) external returns (bool);

    function _withdrawEtherLpartner (address payable sender) external returns (bool);

    function grantRole(bytes32 role, address account) external;

    function revokeRole(bytes32 role, address account) external;
}

