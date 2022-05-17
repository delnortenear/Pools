pragma solidity ^0.6.0;

interface IPoolRegistry {
    function isTeam(address account) external view returns (bool);

    function getTeamAddresses() external view returns (address[] memory);
}