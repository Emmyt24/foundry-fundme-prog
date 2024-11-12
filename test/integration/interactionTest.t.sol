//SPDX-License-Identifier:MIT
pragma solidity ^0.8.15;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundMe.sol";
import {fundMeScript} from "../../script/fundMeScript.s.sol";
import {FundFundMe, withdrawFundFundMe} from "../../script/interactions.s.sol";

contract interactionTest is Test {
    FundMe fundMe;

    uint256 constant AMOUNT_FUND = 10e18;
    address USER = makeAddr("paps");
    uint256 constant STARTING_BALANCE = 5 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        fundMeScript FundMeDeploy = new fundMeScript();
        fundMe = FundMeDeploy.run();
        vm.prank(USER);
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        withdrawFundFundMe WithdrawFundFundMe = new withdrawFundFundMe();
        WithdrawFundFundMe.withdrawFundMe(address(fundMe));
        assert(address(fundMe).balance == 0);
    }
}
