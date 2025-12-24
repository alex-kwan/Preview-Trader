//+------------------------------------------------------------------+
//|                                      PreviewTrader.mq4 |
//|                        Copyright 2025, MetaTrader 4 User         |
//|                                        https://www.mql4.com      |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaTrader 4 User"
#property link      "https://www.mql4.com"
#property version   "1.01"

// grid-based trading
input double _tpRange = 10.0;
input double _lotSize = 1;

// defense-metrics
input double _exchangeRate = 1.389373;

int OnInit()
  {
   CreateRerenderMetrics();
   return(INIT_SUCCEEDED);
  }

void CreateRerenderMetrics() {
   string buttonName = "btnUpdateMetrics";

   if (!ObjectCreate(buttonName, OBJ_BUTTON, 0, 0, 0)) {
      Print("Failed to create button");
      return;
   }

   ObjectSet(buttonName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSet(buttonName, OBJPROP_XDISTANCE, 10);
   ObjectSet(buttonName, OBJPROP_XSIZE, 175);
   ObjectSet(buttonName, OBJPROP_YSIZE, 20);
   ObjectSet(buttonName, OBJPROP_YDISTANCE, 250);
   ObjectSet(buttonName, OBJPROP_WIDTH, 200); 
   ObjectSetText(buttonName, "Refresh comment", 12, "Arial", clrBlack);
}


void OnDeinit(const int reason)
  {
   Print("Goodbye, OnDeinit called!");
  }

void RenderMetrics() 
{
  double contractSize = MarketInfo(Symbol(), MODE_LOTSIZE);
  double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
  double exchangeRateTickValue = tickValue * _exchangeRate;

  double estimatedProfit = EstimateProfit(Symbol(), _lotSize, _tpRange);
  double estimatedMargin = CalculateRequiredMargin(Symbol(), _lotSize) * _exchangeRate;

  double atrValue = iATR(Symbol(), Period(), 14, 0);

  double minLot = MarketInfo(Symbol(), MODE_MINLOT);
  double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
  double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);

  double spreadPoints = MarketInfo(Symbol(), MODE_SPREAD);
  double spreadPrice = spreadPoints * _Point;

  double tickSize     = MarketInfo(Symbol(), MODE_TICKSIZE);
  double leverage     = AccountLeverage();

   Comment(
      "Min Lot Size: ", minLot,
      " ",
      "Max Lot Size: ", maxLot,
      " ",
      "Lot Step Size: ", lotStep,
      " ",
      "ATR(14) :", atrValue,
      "\n",
      "Lot Size :", _lotSize,
      " ",
      "TP Range :", _tpRange,
      " ",
      "Spread :", spreadPrice,
      "\n",
      "Estimated Margin: ", estimatedMargin,
      " ",
      "Estimated Profit: ", estimatedProfit,
      "\n",
      "Tick Size: ",tickSize,
      " ",
      "Tick Value: ",tickValue,
      " ",
      "Contract Size: ",contractSize,
      " ",
      "Leverage: ", leverage,
      " ",
      "Margin: ", MarketInfo(Symbol(), MODE_MARGINREQUIRED),
      "\n"
   );
}

double EstimateProfit(string symbol, double lotSize, double priceMove) {
   // Get tick value and tick size from broker
   double tickValueUSD = MarketInfo(symbol, MODE_TICKVALUE);
   double tickSize     = MarketInfo(symbol, MODE_TICKSIZE);

   // Calculate number of ticks moved
   double ticksMoved = priceMove / tickSize;

   // Adjust tick value for lot size
   double profitUSD = ticksMoved * tickValueUSD * lotSize;

   return profitUSD;
}

double CalculateRequiredMargin(string symbol, double lotSize) {
   // Try to get broker-defined dynamic margin per lot
   double marginPerLot = MarketInfo(symbol, MODE_MARGINREQUIRED);

   // If marginPerLot is invalid or zero, fall back to manual calculation
   if (marginPerLot <= 0) {
      double contractSize = MarketInfo(symbol, MODE_LOTSIZE);
      double price        = MarketInfo(symbol, MODE_ASK);  // Use MODE_BID for sell
      double leverage     = AccountLeverage();             // Account leverage

      marginPerLot = (contractSize * price) / leverage;
   }

   // Total margin required for the given lot size
   double totalMargin = marginPerLot * lotSize;
   return totalMargin;
}



void OnTick()
  {
   RenderMetrics();
  }

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam) {
   if (id == CHARTEVENT_OBJECT_CLICK && sparam == "btnUpdateMetrics") {
      RenderMetrics();
   }
}