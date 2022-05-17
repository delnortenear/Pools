pragma solidity ^0.6.0;

interface IAssetsManageTeam {

    // ***** SET INFO ***** //

    function _depositToken(address pool, address team, address token, uint256 amount) external returns (bool);
    
    function _withdrawEther(address pool, address team, uint256 amount) external returns (bool);
    
    function _request(bool withdraw, address pool, address team, uint256 maxValue) external returns(bool);
    
    function _approve(address pool, address team, address owner) external returns(bool);

    function _disapprove(address pool, address team, address owner) external returns(bool);
    
    function _lock(address pool, address team, address owner) external returns(bool);
    
    function _unlock(address pool, address team, address owner) external returns(bool);

    function addManager(address account) external;
    
    // ***** GET INFO ***** //

    function getPerformedOperationsLength(address pool, address owner) external view returns(uint256 length);
    
    function getPerformedOperations(address pool, address owner, uint256 index) external view returns(address token, uint256 amountToken, uint256 withdrawEther, uint256 time);
    
    function getRequests(address pool) external view returns(address[] memory);

    function getApproval(address pool) external view returns(address[] memory);
    
    function getRequestTeamAddress(address pool, address team) external view returns(bool lock, uint256 maxValueToken, uint256 madeValueToken, uint256 maxValueEther, uint256 madeValueEther);
    
    function getApproveTeamAddress(address pool, address team) external view returns(bool lock, uint256 maxValueToken, uint256 madeValueToken, uint256 maxValueEther, uint256 madeValueEther);
}