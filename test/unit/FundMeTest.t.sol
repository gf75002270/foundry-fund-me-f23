// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../../src/FundMe.sol";
import { DeployFundMe } from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {

    FundMe fundMe;
    DeployFundMe deployFundMe;

    //Prank address foundry doc
    address USER = makeAddr("user");
    //Function variables and constants
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    //simulating gas price on Anvil
    uint256 constant GAS_PRICE = 1; 


    function setUp() external { /**always runs first */
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.getMinimumUsd(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        console.log(fundMe.getOwner());
        console.log(address(this));
        assertEq(fundMe.getOwner(), msg.sender); /**address(this) */
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        console.log(fundMe.getVersion());
        assertEq(version, uint256(4)); 
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // say, the next line should revert. look into foundry docs test
        fundMe.fund(); //send 0 value
    }

    function testFundUpdatedDataStructure() public m_funded { 
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded,SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public m_funded { 
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerWithdraw() public m_funded {
        vm.expectRevert();

        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawWithASinglFunder() public m_funded {
        //Arrange, Act, Assert AAA-methodology
        //1.Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        //uint256 gasStart = gasleft();//getting the remaining gas before the transaction
        vm.txGasPrice(GAS_PRICE); // get gas price from next transaction
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        //uint256 gasEnd = gasleft();//getting the remaining gas after the transaction
        //uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        //console.log("Gas used for testWithdrawWithASinglFunder(): ");
        //console.log(gasUsed);

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testCheaperWithdrawFromMultipleFunders() public m_funded {
        //Arrange
        uint160 numberOfFunders = 10;//uint160 for using number to generate addresses
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            //hoax combines prank and deal -> its create and send fund directly
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value:SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assert(endingFundMeBalance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public m_funded {
        //Arrange
        uint160 numberOfFunders = 10;//uint160 for using number to generate addresses
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            //hoax combines prank and deal -> its create and send fund directly
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value:SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assert(endingFundMeBalance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == endingOwnerBalance);
    }

    modifier m_funded() {
        vm.prank(USER);// the next tx will be sent by USER
        fundMe.fund{value:SEND_VALUE}();
        _;
    }
}