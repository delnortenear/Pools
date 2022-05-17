pragma solidity ^0.6.0;

import "./access/ManagerRole.sol";

import "./interface/IPool.sol";
import "./interface/IERC20.sol";
import "./interface/IOracle.sol";

import "./math/SafeMath.sol";

contract CalculateWithdrawEth is ManagerRole {
    using SafeMath for uint256;

    address oracleContract;
    IOracle _oracle = IOracle(oracleContract);
    
    uint256 private timeYear = 365 days;

    struct DopositesLpartner {
        uint256 amount;
        uint256 time;
        uint256 lock_period;
        bool refund_authorize;
    }

    struct InfoPool {
        address token;
        uint256 anualPrecent;
        uint256 penaltyEarlyWithdraw;
        uint256 totalInvestLpartner;
        uint256 premiumFee;
    }

    /**
    * @dev Withdraw ether LPartner. (POOL REGISTRY)
    * @param sender Address sender transaction.
    */
    function calcWithdrawEthLpartner(address pool, address sender) external view returns (uint256 amountLpartner, uint256 amountTeam) {
        IPool _poolContract = IPool(pool);

        DopositesLpartner memory deposit;
        InfoPool memory infoPool;

        (, infoPool.token, , , , , infoPool.anualPrecent, infoPool.penaltyEarlyWithdraw, infoPool.totalInvestLpartner, infoPool.premiumFee) = _poolContract.getInfoPool();

        uint256 currentGeneralInvestment = address(pool).balance;          // Total number of tokens by price and ether
        uint256 totalAmountReturn = 0;                                     // Ether amount to return tokens
        uint256 teamReward = 0;                                            // Number of wei for the team
        uint256 currentApu;                                                // Сurrent calculated APU

        if (infoPool.token != address(0)) {
            currentGeneralInvestment = currentGeneralInvestment.add(calcWeiPerToken(pool, infoPool.token));
        }

        if (infoPool.totalInvestLpartner < currentGeneralInvestment) {
            currentApu = calcCurrentApu(infoPool.totalInvestLpartner, currentGeneralInvestment);
        } else {
            return (0, 0);
        }
        
        for (uint256 i = 0; i < _poolContract.getDepositEtherLength(sender); i++) {
            (deposit.amount, deposit.time, deposit.lock_period, deposit.refund_authorize) = _poolContract.getDepositEther(sender, i);

            if (deposit.refund_authorize) {
                if (deposit.time.add(deposit.lock_period) < block.timestamp) {
                    uint256 shareTeam = deposit.amount.mul(infoPool.penaltyEarlyWithdraw).div(100);

                    totalAmountReturn = totalAmountReturn.add(deposit.amount.sub(shareTeam));
                    teamReward = teamReward.add(shareTeam);
                    continue;
                }

                totalAmountReturn = totalAmountReturn.add(calculateApu(
                    infoPool.anualPrecent,
                    currentApu,
                    deposit.amount,
                    deposit.time,
                    infoPool.premiumFee
                ));
                
                if (currentApu > infoPool.anualPrecent) {
                    uint256 precentTeam = (currentApu.sub(infoPool.anualPrecent)).mul(infoPool.premiumFee).div(100);
                    teamReward.add(deposit.amount.mul(precentTeam).div(100));
                }

                totalAmountReturn = totalAmountReturn.add(deposit.amount);
            }
        }

        return (totalAmountReturn, teamReward);
    }

    /**
     * @dev Activate the pool for the possibility of ether deposit. (POOL REGISTRY)
     */
    function calculateApu(
        uint256 elementaryApu,
        uint256 currentApu,
        uint256 deposit,
        uint256 time,
        uint256 premiumFee
    ) public view returns (uint256 totalAmount) {
        uint256 totalAmountReturn = 0;
        uint256 timePassedPrecent = 0;
        uint256 precentageOfApu;
        uint256 differenceApu;

        if (time.add(timeYear) > block.timestamp) {
            timePassedPrecent = timeYear.sub((block.timestamp).sub(time)).mul(100).div(timeYear);

            if (currentApu > 0 && currentApu <= elementaryApu) {
                precentageOfApu = currentApu.mul(timePassedPrecent).div(100);
                totalAmountReturn = totalAmountReturn.add(deposit.mul(precentageOfApu).div(100));
                return totalAmountReturn;

            } else if (currentApu > 0 && currentApu > elementaryApu) {
                precentageOfApu = elementaryApu.mul(timePassedPrecent).div(100);
                totalAmountReturn = totalAmountReturn.add(deposit.mul(precentageOfApu).div(100));

                differenceApu = currentApu.sub(elementaryApu);
                precentageOfApu = differenceApu.mul(timePassedPrecent).div(100);

                totalAmountReturn = totalAmountReturn.add(deposit.mul(precentageOfApu.sub(precentageOfApu.mul(premiumFee).div(100))).div(100));

                return totalAmountReturn;
            }
        } else if (time.add(timeYear) < block.timestamp) {
            if (currentApu > 0 && currentApu <= elementaryApu) {
                totalAmountReturn = totalAmountReturn.add(deposit.mul(currentApu).div(100));
                return totalAmountReturn;

            } else if (currentApu > 0 && currentApu > elementaryApu) {
                differenceApu = currentApu.sub(elementaryApu);
                totalAmountReturn = totalAmountReturn.add(deposit.mul(elementaryApu).div(100));
                totalAmountReturn = totalAmountReturn.add(deposit.mul(differenceApu.sub(differenceApu.mul(premiumFee).div(100))).div(100));
                
                return totalAmountReturn;
            }

            totalAmountReturn = totalAmountReturn.add(deposit.mul(currentApu).div(100));
            return totalAmountReturn;

        } else {
            return 0;
        }

        return totalAmountReturn;
    }

    /**
     * @dev Calculate percentage
     */
    function setOracle(address oracle) public onlyManager returns(bool) {
        oracleContract = oracle;
        return true;
    }

    /**
     * @dev Calculate the number of wei per token
     */
    function calcWeiPerToken(address pool, address token) public view returns(uint256) {
        IERC20 _tokenContract = IERC20(token);

        uint8 decimals = _tokenContract.decimals();
        uint256 balanceToken = _tokenContract.balanceOf(pool);
        uint256 priceToken = uint256(_oracle.getLatestPrice());

        return balanceToken.mul(priceToken).div(decimals);
    }


    /**
     * @dev Calculate the number of wei per token
     */
    function calcCurrentApu(uint256 totalInvestLpartner, uint256 currentInvest) public pure returns(uint256) {
        uint256 investmentDifference = currentInvest.sub(totalInvestLpartner);

        return calcPrecent(totalInvestLpartner, investmentDifference);
    }

    /**
     * @dev Calculate percentage
     */
    function calcPrecent(uint256 a, uint256 b) public pure returns(uint256) {
        return b.mul(100).div(a);
    }
}
