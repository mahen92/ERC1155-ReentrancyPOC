//SDPX-Identification:MIT
pragma solidity ^0.8.2;

import "../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

/**
 * @title Reentrancy Attack POC
 * @author Mahendran Anbarasan
 * @notice Contract with loophole for exploiting ERC1155 _mint function.
 */
contract DoubleSpender is ERC1155 {
    uint256 public constant DECIMALS_PER_TOKEN = 1e18;
    IERC20 immutable token;
    mapping(address => bool) alreadyClaimed;

    constructor(IERC20 _token) ERC1155("") {
        token = _token;
    }

    function mintToken() external payable {
        require(!alreadyClaimed[msg.sender], "Already Claimed");
        _mint(msg.sender, 0, 1, "");
        alreadyClaimed[msg.sender] = true;
    }
}
