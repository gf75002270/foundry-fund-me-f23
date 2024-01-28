// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
// 1. we going to deploy mocks when we are on a local anvil chain
// 2. we gonna keep tract of contract address across different chains
import { Script } from "forge-std/Script.sol";
import { MockV3Aggregator } from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //If we are on a local anvil chain, we deploy a mock
    //Otherwise, grab the existing address from the live network
    NetworkConfig public activeNetworkConfig;

    //Network IDs
    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant MAINNET_ETH_CHAIN_ID = 1;
    uint256 public constant GOERLI_CHAIN_ID = 5;

    //Price Feed Adresses
    address constant MAINNET_ADDRESS_FEED = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419; 
    address constant SEPOLIA_ADDRESS_FEED = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address constant GOERLI_ADDRESS_FEED = 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e;

    //Price Feed Constructor Parameter
    uint8 public constant DECIMALS = 8; //**decimal of EtH/USd*/
    int256 public constant INITIAL_PRICE = 2000e8;///**initial price*/

    constructor() {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else if (block.chainid == MAINNET_ETH_CHAIN_ID) {
            activeNetworkConfig = getMainnetEthConfig();
        }
        else if (block.chainid == GOERLI_CHAIN_ID) {
            activeNetworkConfig = getGoerliEthConfig();
        } 
        else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    struct NetworkConfig {
        address priceFeed; // ETH-USD price feed address
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        //price feed address (Live) for Eth Mainnet ...
        NetworkConfig memory ethMainnetConfig = NetworkConfig(
            { priceFeed: MAINNET_ADDRESS_FEED });
        return ethMainnetConfig;
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        //price feed address (Live) for Sepolia ...
        NetworkConfig memory sepoliaConfig = NetworkConfig(
            { priceFeed: SEPOLIA_ADDRESS_FEED });
        return sepoliaConfig;
    }

    function getGoerliEthConfig() public pure returns (NetworkConfig memory) {
        //price feed address (Live) for Eth Mainnet ...
        NetworkConfig memory goerliConfig = NetworkConfig(
            { priceFeed:GOERLI_ADDRESS_FEED });
        return goerliConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        //price feed address (mock) for Anvil
        // 1. Deploy the mocks
        // 2. Return the mock address
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig(
            { priceFeed: address(mockPriceFeed)});
        return anvilConfig;
    }
}
