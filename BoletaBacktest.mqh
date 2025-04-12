//+------------------------------------------------------------------+
//|                                                 BoletaBacktest.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\SymbolInfo.mqh>

// Estrutura para armazenar informações da ordem
struct SOrderInfo
{
   ulong ticket;
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
   CTrade m_trade;
   CPositionInfo m_position;
   CSymbolInfo m_symbolInfo;
   
public:
   COperationManager(string symbol = NULL, double lotSize = 0.1)
   {
      m_symbol = symbol == NULL ? Symbol() : symbol;
      m_lotSize = lotSize;
      
      // Configurações do trade
      m_trade.SetExpertMagicNumber(123456);
      m_trade.SetDeviationInPoints(10);
      m_trade.SetMarginMode();
      m_trade.SetTypeFilling(ORDER_FILLING_FOK);
      m_trade.SetAsyncMode(false);  // Modo síncrono para garantir execução
      m_trade.LogLevel(LOG_LEVEL_ALL);
      
      // Inicializa informações do símbolo
      if(!m_symbolInfo.Name(m_symbol))
      {
         Print("Erro ao inicializar símbolo: ", m_symbol);
         return;
      }
      
      if(!m_symbolInfo.RefreshRates())
      {
         Print("Erro ao atualizar preços do símbolo: ", m_symbol);
         return;
      }
      
      Print("COperationManager inicializado - Símbolo: ", m_symbol,
            ", Volume: ", m_lotSize,
            ", Ask: ", m_symbolInfo.Ask(),
            ", Bid: ", m_symbolInfo.Bid());
   }
   
   bool OpenPosition(bool isBuy, double volume = 0.0)
   {
      Print("--- Início OpenPosition ---");
      
      // Verifica se o trading está permitido
      if(!MQLInfoInteger(MQL_TRADE_ALLOWED))
      {
         Print("Trading não está permitido!");
         return false;
      }
      
      // Verifica se estamos no contexto correto
      if(!MQLInfoInteger(MQL_TESTER) && !TerminalInfoInteger(TERMINAL_CONNECTED))
      {
         Print("Terminal não está conectado ao servidor!");
         return false;
      }
      
      if(volume == 0.0) volume = m_lotSize;
      
      if(!m_symbolInfo.RefreshRates())
      {
         Print("Erro ao atualizar preços!");
         return false;
      }
      
      double price = isBuy ? m_symbolInfo.Ask() : m_symbolInfo.Bid();
      
      // Verifica se o preço é válido
      if(price <= 0)
      {
         Print("Preço inválido: ", price);
         return false;
      }
      
      Print("Preparando ordem - Direção: ", (isBuy ? "Compra" : "Venda"), 
            ", Volume: ", volume,
            ", Preço: ", price,
            ", Símbolo: ", m_symbol,
            ", Saldo: ", AccountInfoDouble(ACCOUNT_BALANCE),
            ", Margem Livre: ", AccountInfoDouble(ACCOUNT_MARGIN_FREE));
      
      bool result = false;
      
      if(isBuy)
      {
         result = m_trade.Buy(volume, m_symbol, 0.0, 0.0, 0.0, "Compra via Boleta");
      }
      else
      {
         result = m_trade.Sell(volume, m_symbol, 0.0, 0.0, 0.0, "Venda via Boleta");
      }
      
      if(result)
      {
         Print("Ordem enviada com sucesso! Ticket: ", m_trade.ResultOrder(),
               ", Preço: ", m_trade.ResultPrice(),
               ", Volume: ", m_trade.ResultVolume(),
               ", Retcode: ", m_trade.ResultRetcode(),
               ", RetMsg: ", m_trade.ResultRetcodeDescription());
      }
      else
      {
         Print("Erro ao enviar ordem! Código: ", GetLastError(),
               ", Descrição: ", m_trade.ResultComment(),
               ", Retcode: ", m_trade.ResultRetcode(),
               ", RetMsg: ", m_trade.ResultRetcodeDescription());
      }
      
      Print("--- Fim OpenPosition ---");
      return result;
   }
   
   bool ClosePosition(int ticket)
   {
      if(!m_position.SelectByTicket(ticket))
      {
         Print("Erro ao selecionar posição ", ticket, " para fechar");
         return false;
      }
      
      m_symbolInfo.RefreshRates();
      
      Print("Tentando fechar posição - Ticket: ", ticket,
            ", Volume: ", m_position.Volume(),
            ", Preço Atual: ", (m_position.PositionType() == POSITION_TYPE_BUY ? m_symbolInfo.Bid() : m_symbolInfo.Ask()));
      
      bool result = m_trade.PositionClose(ticket);
      
      if(result)
      {
         Print("Posição fechada com sucesso! Preço: ", m_trade.ResultPrice());
      }
      else
      {
         Print("Erro ao fechar posição! Código: ", GetLastError(),
               ", Descrição: ", m_trade.ResultComment(),
               ", Retcode: ", m_trade.ResultRetcode());
      }
      
      return result;
   }
   
   SOrderInfo GetPositionInfo(int ticket)
   {
      SOrderInfo info = {};
      
      if(m_position.SelectByTicket(ticket))
      {
         info.ticket = ticket;
         info.volume = m_position.Volume();
         info.price = m_position.PriceOpen();
         info.time = m_position.Time();
         info.symbol = m_position.Symbol();
         info.type = m_position.PositionType() == POSITION_TYPE_BUY ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
         info.isBuy = info.type == ORDER_TYPE_BUY;
      }
      
      return info;
   }
}; 