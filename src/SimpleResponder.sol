// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleResponder {
    // Changed from public to external (better convention per review)
    function respondCallback(uint256 amount) external {
        // PoC: The Trap triggered, the Responder was called.
    }
}
