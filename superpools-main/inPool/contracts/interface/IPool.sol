pragma solidity ^0.6.0;

interface IPool {

    // ***** GET INFO ***** //

    function hasRole(bytes32 role, address account) external view returns (bool);

    function getRoleMemberCount(bytes32 role) external view returns (uint256);

    function token() external view returns (address);

    function locked() external view returns (uint256);

    function rate() external view returns (uint256);

    function interestFee() external view returns (uint256);

    function anualPrecent() external view returns (uint256);

    function getDepositEther(address owner, uint256 index) external view returns(address investor, uint256 amount, uint256 time, uint256 lock_period, bool refund_authorize);

    function getRequestsDepositToken() external view returns(address[] memory);

    function getMembersRole(bytes32 role) external view returns (address[] memory Accounts);
    
    // ***** SET INFO ***** //

    function _setToken(address sender, address tokenAddress) external returns (bool);
    
    function _updatePool(address sender, uint256 lock, uint256 rate, uint256 interestFee, uint256 anualPrecent) external returns (bool);

    function _depositEtherPoolRegistry(address sender, uint256 amount) external returns (bool);

    function _depositTokenPoolRegistry(address payable sender, uint256 amount) external returns (bool);

    function _depositEtherInternal(address sender, uint256 amount) external returns (bool);
    
    function _withdrawEther (address sender, address payable recipient, uint256 amount) external returns (bool);

    function grantRole(bytes32 role, address account) external;
}

