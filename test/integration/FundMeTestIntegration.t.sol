// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeTestIntegration is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;

    //Prank address foundry doc
    address USER = makeAddr("user");
    //Function variables and constants
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    //simulating gas price on Anvil
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        /**always runs first */
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundeMe = new WithdrawFundMe();
        withdrawFundeMe.withdrawFundMe(address(fundMe));
        console.log(
            "Balance of FundMe after withdrawal is: %s",
            address(fundMe).balance
        );
        assert(address(fundMe).balance == 0);
    }
}
