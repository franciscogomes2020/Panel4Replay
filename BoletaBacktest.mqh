//+------------------------------------------------------------------+
//|                                                 BoletaBacktest.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

// Estrutura para armazenar informações da ordem
struct SOrderInfo
{
   int ticket;
   double volume;
   double price;
   datetime time;
   string symbol;
   ENUM_ORDER_TYPE type;
   bool isBuy;
};

// Classe para gerenciar operações
class COperationManager
{
private:
   string m_symbol;
   double m_lotSize;
   
public:
   COperationManager(string symbol = NULL, double lotSize = 0.1)
   {
      m_symbol = symbol == NULL ? Symbol() : symbol;
      m_lotSize = lotSize;
   }
   
   bool OpenPosition(bool isBuy, double volume = 0.0)
   {
      if(volume == 0.0) volume = m_lotSize;
      
      MqlTradeRequest request = {};
      MqlTradeResult result = {};
      
      request.action = TRADE_ACTION_DEAL;
      request.symbol = m_symbol;
      request.volume = volume;
      request.type = isBuy ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
      request.price = isBuy ? SymbolInfoDouble(m_symbol, SYMBOL_ASK) : SymbolInfoDouble(m_symbol, SYMBOL_BID);
      request.deviation = 10;
      request.magic = 123456;
      
      return OrderSend(request, result);
   }
   
   bool ClosePosition(int ticket)
   {
      if(!PositionSelectByTicket(ticket)) return false;
      
      MqlTradeRequest request = {};
      MqlTradeResult result = {};
      
      request.action = TRADE_ACTION_DEAL;
      request.position = ticket;
      request.symbol = PositionGetString(POSITION_SYMBOL);
      request.volume = PositionGetDouble(POSITION_VOLUME);
      request.type = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
      request.price = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? 
                     SymbolInfoDouble(request.symbol, SYMBOL_BID) : 
                     SymbolInfoDouble(request.symbol, SYMBOL_ASK);
      request.deviation = 10;
      request.magic = 123456;
      
      return OrderSend(request, result);
   }
   
   SOrderInfo GetPositionInfo(int ticket)
   {
      SOrderInfo info = {};
      
      if(PositionSelectByTicket(ticket))
      {
         info.ticket = ticket;
         info.volume = PositionGetDouble(POSITION_VOLUME);
         info.price = PositionGetDouble(POSITION_PRICE_OPEN);
         info.time = (datetime)PositionGetInteger(POSITION_TIME);
         info.symbol = PositionGetString(POSITION_SYMBOL);
         info.type = (ENUM_ORDER_TYPE)PositionGetInteger(POSITION_TYPE);
         info.isBuy = info.type == ORDER_TYPE_BUY;
      }
      
      return info;
   }
}; 