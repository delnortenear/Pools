pragma solidity ^0.6.0;

interface ITokenRequest {

    // ***** SET INFO ***** //

    function _requestDeposit(address pool, address team, uint256 maxDeposit) external returns(bool);
    
    function _approveDeposit(address pool, address team) external returns(bool);
    
    function _disapproveDeposit(address pool, address team) external returns(bool);
    
    function _lockDeposit(address pool, address team) external returns(bool);

    function _unlockDeposit(address pool, address team) external returns(bool);
    
    function _depositToken(address pool, address team, address token, uint256 amount) external returns (bool);
    
    function grantRole(bytes32 role, address account) external;
    
    // ***** GET INFO ***** //

    function getDepositToken(address pool, address owner, uint256 index) external view returns(address team, address token, uint256 amountToken, uint256 time);
    
    function getRequestsDepositToken(address pool) external view returns(address[] memory);
    
    function getApproveDepositToken(address pool) external view returns(address[] memory);
    
    function getRequestTeamAddress(address pool, address team) external view returns(bool lock, uint256 maxDeposit, uint256 madeDeposit);
    
    function getApproveTeamAddress(address pool, address team) external view returns(bool lock, uint256 maxDeposit, uint256 madeDeposit);
}