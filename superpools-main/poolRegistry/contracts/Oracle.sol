pragma solidity ^0.6.0;

import "./interface/IAggregatorV3Interface.sol";

contract Oracle {

    IAggregatorV3Interface internal priceFeed;

    /**
     * Network: Kovan
     * Aggregator: ETH/USD
     * Address: 0x9326BFA02ADD2366b30bacB125260Af641031331
     */
    constructor() public {
        priceFeed = IAggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return (price);
    }
    
    // function getHistoricalPrice(uint80 roundId) public view returns (int256) {
    //     (
    //         uint80 id, 
    //         int price,
    //         uint startedAt,
    //         uint timeStamp,
    //         uint80 answeredInRound
    //     ) = priceFeed.getRoundData(roundId);
    //     require(timeStamp > 0, "Round not complete");
    //     return price;
    // }
}