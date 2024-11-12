// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

//deploy mocks when we on our local anvil chain
//keep track of keep  track of contract address from every chains
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mockV3Aggregator.sol";

contract helperConfig is Script {
    uint8 public constant DECIMAL = 8;
    int256 public constant ETH_PRICE = 2000e8;
    //if we are on local anvil depploy mocks
    //otherwise, grab exixting network on the live network
    struct networkConfig {
        address priceFeed;
    }
    networkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        }
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 42161) {
            activeNetworkConfig = getArbitrumEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getMainnetEthConfig() public pure returns (networkConfig memory) {
        networkConfig memory mainnetConfig = networkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetConfig;
    }

    function getSepoliaEthConfig() public pure returns (networkConfig memory) {
        networkConfig memory sepoliaConfig = networkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getArbitrumEthConfig() public pure returns (networkConfig memory) {
        networkConfig memory arbitrumConfig = networkConfig({
            priceFeed: 0x31697852a68433DbCc2Ff612c516d69E3D9bd08F
        });
        return arbitrumConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (networkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        //priceFeed address
        //1. deploy mocks
        //2. return mock address
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMAL,
            ETH_PRICE
        );

        vm.stopBroadcast();
        networkConfig memory anvilConfig = networkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
