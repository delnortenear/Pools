pragma solidity ^0.6.0;

interface IOracle {
    function getLatestPrice() external view returns (int);
}
