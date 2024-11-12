// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.15;
import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundMe.sol";
import {helperConfig} from "./helperConfig.s.sol";

contract fundMeScript is Script {
    helperConfig HelperConfig = new helperConfig();
    address ethPriceFeed = HelperConfig.activeNetworkConfig();

    function run() external returns (FundMe) {
        vm.startBroadcast();
        FundMe fundme = new FundMe(ethPriceFeed);
        vm.stopBroadcast();

        return fundme;
    }
}
