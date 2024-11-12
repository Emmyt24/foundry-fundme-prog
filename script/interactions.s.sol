// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;
//fund
//withdraw
import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/fundMe.sol";

contract FundFundMe is Script {
    uint256 FUND_VALUE = 0.01 ether;

    function fundFundMe(address mostlatesteDeployment) public {
        vm.startBroadcast();
        FundMe(payable(mostlatesteDeployment)).fund{value: FUND_VALUE}();
        vm.stopBroadcast();
        console.log("funded contract with %s", FUND_VALUE);
    }

    function run() public {
        address mostLatestDeployment = DevOpsTools.get_most_recent_deployment(
            "fundMe",
            block.chainid
        );

        fundFundMe(mostLatestDeployment);
    }
}

contract withdrawFundFundMe is Script {
    function withdrawFundMe(address mostlatestDeployment) public {
        vm.startBroadcast();
        FundMe(payable(mostlatestDeployment)).withdraw();
        vm.stopBroadcast();
    }

    function run() public {
        address mostLatestDeploy = DevOpsTools.get_most_recent_deployment(
            "fundMe",
            block.chainid
        );

        withdrawFundMe(mostLatestDeploy);
    }
}
