# PriceSpikeAlert (Drosera Proof-of-Concept)

## Overview
This trap monitors for significant price spikes in the market, triggering alerts when prices increase beyond a defined threshold. It is critical for traders to react promptly to price movements.

---

## What It Does
* Monitors the price of a specific token against a threshold.
* Triggers if the price increases by more than 20% from the last confirmed reading.
* It demonstrates the essential Drosera trap pattern using deterministic logic.

---

## Key Files
* `src/PriceSpikeAlert.sol` - The core trap contract containing the monitoring logic.
* `src/SimpleResponder.sol` - The required external response contract.
* `drosera.toml` - The deployment and configuration file.

---

## Detection Logic

The trap's core monitoring logic is contained in the deterministic `shouldRespond()` function.

```solidity
function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
    CollectOutput memory current = abi.decode(data[0], (CollectOutput));
    CollectOutput memory past = abi.decode(data[data.length - 1], (CollectOutput));
    uint256 priceIncrease = current.currentPrice - past.previousPrice;
    uint256 priceChangePercent = (priceIncrease * 100) / past.previousPrice;
    if (priceChangePercent > SPIKE_THRESHOLD) return (true, bytes("Price spike detected"));
    return (false, bytes(""));
}
