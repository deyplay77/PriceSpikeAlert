// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "contracts/interfaces/ITrap.sol";

contract PriceSpikeAlert is ITrap {
    uint256 public constant SPIKE_THRESHOLD = 20; // 20% threshold (in percentage points)

    constructor() {}

    function collect() external pure override returns (bytes memory) {
        // PoC: Return a single uint256 price value
        // In production, replace with real oracle/AMM price call
        uint256 currentPrice = 100; // Example price in appropriate units (1e18)
        return abi.encode(currentPrice);
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        // 1. Planner-safety guards
        require(data.length >= 2, "Insufficient data samples");
        require(data[0].length > 0 && data[1].length > 0, "Empty data blobs");
        
        // 2. Compare data[0] (newest) vs data[1] (previous) - NOT data[data.length-1]
        uint256 currentPrice = abi.decode(data[0], (uint256));
        uint256 previousPrice = abi.decode(data[1], (uint256));
        
        // 3. Division-by-zero guard
        require(previousPrice > 0, "Previous price cannot be zero");
        
        // 4. Calculate percentage change
        if (currentPrice > previousPrice) {
            uint256 priceIncrease = currentPrice - previousPrice;
            uint256 priceChangePercent = (priceIncrease * 100) / previousPrice;
            
            // 5. Return uint256 payload (price change percentage) to match responder
            if (priceChangePercent > SPIKE_THRESHOLD) {
                return (true, abi.encode(priceChangePercent));
            }
        }
        
        // Return false with zero payload
        return (false, abi.encode(uint256(0)));
    }
}

