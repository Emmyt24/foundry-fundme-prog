//SPDX-License-Identifier:MIT
pragma solidity ^0.8.15;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundMe.sol";
import {fundMeScript} from "../../script/fundMeScript.s.sol";

contract fundMeTest is Test {
    FundMe fundMe;

    uint256 constant AMOUNT_FUND = 10e18;
    address USER = makeAddr("paps");
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        //now we don't have to update the address every time we update the Script contract.
        fundMeScript FundMeScript = new fundMeScript();
        fundMe = FundMeScript.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumUsdIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testContractOwner() public view {
        console.log(msg.sender);
        console.log(address(this));
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFailWithoutEnoughFunds() public {
        vm.expectRevert();
        fundMe.fund{value: 2e18}();
    }

    function testFundsUpdatesDataStructure() public funded {
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, AMOUNT_FUND);
    }

    function testAddFunderToArray() public funded {
        address funders = fundMe.getFunder(0);
        assertEq(funders, USER);
    }

    function testOnlyOwnerCanWithraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithraw() public funded {
        //arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundmeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //assert
        uint256 endingownerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundmeBalance + startingOwnerBalance,
            endingownerBalance
        );
    }

    function testWithdrawFromMultipleAddress() public funded {
        //arrange
        uint160 numberoffunders = 10;
        uint160 startingfunderindex = 1;
        for (uint160 i = startingfunderindex; i < numberoffunders; i++) {
            //this for loop will loop through the addresses and fund all the addresses
            hoax(address(i), AMOUNT_FUND);
            fundMe.fund{value: AMOUNT_FUND}();
        }
        uint256 startingFundmeBalance = fundMe.getOwner().balance;
        uint256 startingOwnerBalance = address(fundMe).balance;
        //act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //assert
        assertEq(address(fundMe).balance, 0);
        assertEq(
            startingFundmeBalance + startingOwnerBalance,
            fundMe.getOwner().balance
        );
    }

    function testWithdrawFromMultipleAddresscheaper() public funded {
        //arrange
        uint160 numberoffunders = 10;
        uint160 startingfunderindex = 1;
        for (uint160 i = startingfunderindex; i < numberoffunders; i++) {
            //this for loop will loop through the addresses and fund all the addresses
            hoax(address(i), AMOUNT_FUND);
            fundMe.fund{value: AMOUNT_FUND}();
        }
        uint256 startingFundmeBalance = fundMe.getOwner().balance;
        uint256 startingOwnerBalance = address(fundMe).balance;
        //act
        vm.prank(fundMe.getOwner());
        fundMe.cheaperwithdraw();

        //assert
        assertEq(address(fundMe).balance, 0);
        assertEq(
            startingFundmeBalance + startingOwnerBalance,
            fundMe.getOwner().balance
        );
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: AMOUNT_FUND}();
        _;
    }
}
