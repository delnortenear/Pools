pragma solidity ^0.6.0;

interface ICalculateWithdrawEth {
    function calcWithdrawEthLpartner(address pool, address sender)
        external
        view
        returns (uint256 amountLpartner, uint256 amountTeam);
}
