// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "contracts/interfaces/ITrap.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract PriceSpikeAlert is ITrap {
    address public constant TOKEN = 0xFba1bc0E3d54D71Ba55da7C03c7f63D4641921B1;
    uint256 public constant SPIKE_THRESHOLD = 20; // 20%

    struct CollectOutput {
        uint256 currentPrice;
        uint256 previousPrice;
    }

    constructor() {}

    function collect() external view override returns (bytes memory) {
        // Placeholder logic for fetching current and previous prices
        uint256 currentPrice = 100; // Example current price
        uint256 previousPrice = 80; // Example previous price
        return abi.encode(CollectOutput({currentPrice: currentPrice, previousPrice: previousPrice}));
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        CollectOutput memory current = abi.decode(data[0], (CollectOutput));
        CollectOutput memory past = abi.decode(data[data.length - 1], (CollectOutput));
        uint256 priceIncrease = current.currentPrice - past.previousPrice;
        uint256 priceChangePercent = (priceIncrease * 100) / past.previousPrice;
        if (priceChangePercent > SPIKE_THRESHOLD) return (true, bytes("Price spike detected"));
        return (false, bytes(""));
    }
}

