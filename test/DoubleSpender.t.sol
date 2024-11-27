// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "./mocks/IERC20Mock.t.sol";
import "../src/DoubleSpender.sol";
import "./contracts/RogueReceiver.sol";

/**
 * @title ERC1155 exploit setup and testing
 * @author Mahendran Anbarasan
 * @notice 
 */

contract DoubleSpenderTest is Test {
    DoubleSpender spender;
    IERC20Mock token;
    uint256 public constant DECIMAL_PER_TOKEN = 1e18;
    RogueReceiver receiver;

    function setUp() public {
        token = new IERC20Mock();
        spender = new DoubleSpender(token);
        receiver = new RogueReceiver();
        token.mint(address(spender), DECIMAL_PER_TOKEN);
        console.log(token.balanceOf(address(receiver)));
        vm.startPrank(address(spender));
        token.approve(address(receiver), DECIMAL_PER_TOKEN);
    }

    function test_hack() public {
        receiver.hack(address(spender), address(token));
        console.log(spender.balanceOf(address(receiver), 0));
    }
}
