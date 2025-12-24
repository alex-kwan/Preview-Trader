# Preview-Trader

A MetaTrader 4 Expert Advisor (EA) that displays real-time trading metrics and calculations to help you preview and plan your trades before execution.

## What It Does

PreviewTrader is a diagnostic tool that calculates and displays important trading information directly on your MT4 chart, including:

- **Lot size requirements** (minimum, maximum, and step sizes)
- **ATR (Average True Range)** - volatility indicator
- **Spread costs** in price units
- **Estimated Profit** - projected profit for your trade setup
- **Estimated Margin** - required margin for your position
- **Technical specifications** - tick size, tick value, contract size, leverage

The EA updates these metrics every tick, giving you live feedback on how market conditions affect your potential trades.

## How to Use

1. **Installation**: Copy `PreviewTrader.mq4` to your MT4 `Experts` folder
2. **Attach to Chart**: Drag the EA onto any chart
3. **Configure Inputs**:
   - `_tpRange`: Your target take-profit distance (default: 10.0 points)
   - `_lotSize`: Position size to calculate metrics for (default: 1 lot)
   - `_exchangeRate`: Exchange rate for currency conversion (default: 1.389373)
4. **View Metrics**: All calculations appear in the chart's top-left corner comment area
5. **Refresh**: Click the "Refresh comment" button to manually update metrics

## Key Metrics Explained

### Estimated Profit
The projected profit if price moves by your specified `_tpRange`:
- Calculated using broker's tick value and tick size
- Adjusted for your lot size (`_lotSize`)
- Shows potential profit in USD before accounting for spread

**Formula**: (Price Move / Tick Size) × Tick Value × Lot Size

### Estimated Margin
The amount of capital required to open a position with your specified lot size:
- Calculated for your specific `_lotSize` parameter
- Multiplied by `_exchangeRate` to convert to your account currency
- Shows the actual margin that will be locked when you open the trade
- Based on broker's margin requirements and account leverage

**Formula**: (Margin Per Lot × Lot Size) × Exchange Rate

This helps you determine if you have sufficient account balance to open the planned position.

## Strategy Setup Guide

### Step 1: Choose Your TP Range
1. Attach the EA to an **H1 (1-hour) chart**
2. Observe the **ATR(14)** value - this shows average price movement over 14 periods
3. Note the **Spread** value - this is your minimum cost per trade
4. Set `_tpRange` to a value that:
   - Is **greater than the Spread** (to ensure profitable trades)
   - Can **hit multiple times within ATR(14)** (for frequent trade opportunities)
   
   **Example**: If ATR(14) = 50 and Spread = 2.5, you might set `_tpRange = 10` (allowing 5 potential hits within ATR range)

### Step 2: Optimize Your Position Size
1. Adjust `_lotSize` up or down based on your capital allocation
2. Monitor **Estimated Margin** - this is how much capital will be locked
3. Monitor **Estimated Profit** - this is your potential gain per trade
4. Find a balance that:
   - Keeps Estimated Margin within your risk budget
   - Provides Estimated Profit that justifies the trade

### Step 3: Deploy to Your Trading Algorithm
Once you've found optimal values through testing:
1. Copy your calibrated `_tpRange` value
2. Copy your calibrated `_lotSize` value
3. **Plug these parameters into your actual trading algorithm/EA**
4. Start executing trades with confidence based on your previewed metrics

## Notes

- This EA does **not** place any trades - it's purely informational
- Metrics update on every tick for real-time accuracy
- Useful for testing different lot sizes and TP ranges before committing capital