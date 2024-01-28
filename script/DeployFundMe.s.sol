// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { FundMe } from "../src/FundMe.sol";
import { HelperConfig } from "./HelperConfig.s.sol";

contract DeployFundMe is Script {

    FundMe fundMe;

    function run() external returns (FundMe) {
        //Before startBroadcast -> not a "real" tx(transaction)
        HelperConfig helperConfig = new HelperConfig();
        //After startBroadcast -> Real tx!
        vm.startBroadcast();
        (address ethUsdPriceFeed) = helperConfig.activeNetworkConfig();
        fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}