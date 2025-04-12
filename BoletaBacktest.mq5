#property copyright "Copyright 2024"
#property link      ""
#property version   "1.00"
#property strict

// Inputs
input int InpMagicNumber = 123456;  // Magic Number

// Inclusão dos arquivos necessários
#include "BoletaBacktest.mqh"
#include "BoletaBacktestGUI.mqh"

// Variáveis globais
CBoletaBacktestGUI* g_interface = NULL;
bool g_isTestMode = false;
CTrade trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit()
{
   // Verifica se está no testador
   g_isTestMode = MQLInfoInteger(MQL_TESTER);
   Print("EA iniciado - Modo testador: ", g_isTestMode);
   
   // Configura o trade
   trade.SetExpertMagicNumber(InpMagicNumber);
   trade.SetMarginMode();
   trade.SetTypeFilling(ORDER_FILLING_FOK);
   trade.SetDeviationInPoints(10);
   trade.LogLevel(LOG_LEVEL_ALL);
   
   // Inicializa a interface gráfica
   g_interface = new CBoletaBacktestGUI(trade);
   if(!g_interface.Init())
   {
      Print("Erro ao inicializar a interface gráfica");
      return INIT_FAILED;
   }
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(g_interface != NULL)
   {
      delete g_interface;
      g_interface = NULL;
   }
}

//+------------------------------------------------------------------+
//| Expert tick function                                              |
//+------------------------------------------------------------------+
void OnTick()
{
   if(g_interface != NULL)
   {
      // Atualiza a interface
      g_interface.Update();
      
      // Verifica o estado dos botões
      if((bool)ObjectGetInteger(0, "BuyButton", OBJPROP_STATE))
      {
         Print("Botão de Compra pressionado!");
         // Desativa o botão
         ObjectSetInteger(0, "BuyButton", OBJPROP_STATE, false);
         // Envia ordem imediatamente
         if(trade.Buy(0.1))
         {
            Print("Ordem de compra enviada! Ticket:", trade.ResultOrder(), 
                  " Preço:", trade.ResultPrice(),
                  " Volume:", trade.ResultVolume());
         }
         else
         {
            Print("Erro ao enviar ordem de compra! Erro:", GetLastError(),
                  " Descrição:", trade.ResultRetcodeDescription());
         }
      }
      
      if((bool)ObjectGetInteger(0, "SellButton", OBJPROP_STATE))
      {
         Print("Botão de Venda pressionado!");
         // Desativa o botão
         ObjectSetInteger(0, "SellButton", OBJPROP_STATE, false);
         // Envia ordem imediatamente
         if(trade.Sell(0.1))
         {
            Print("Ordem de venda enviada! Ticket:", trade.ResultOrder(), 
                  " Preço:", trade.ResultPrice(),
                  " Volume:", trade.ResultVolume());
         }
         else
         {
            Print("Erro ao enviar ordem de venda! Erro:", GetLastError(),
                  " Descrição:", trade.ResultRetcodeDescription());
         }
      }
      
      if((bool)ObjectGetInteger(0, "CloseButton", OBJPROP_STATE))
      {
         Print("Botão de Fechar pressionado!");
         // Desativa o botão
         ObjectSetInteger(0, "CloseButton", OBJPROP_STATE, false);
         // Fecha todas as posições
         for(int i = PositionsTotal() - 1; i >= 0; i--)
         {
            ulong ticket = PositionGetTicket(i);
            if(ticket > 0)
            {
               if(trade.PositionClose(ticket))
               {
                  Print("Posição fechada! Ticket:", ticket,
                        " Preço:", trade.ResultPrice());
               }
               else
               {
                  Print("Erro ao fechar posição! Ticket:", ticket,
                        " Erro:", GetLastError(),
                        " Descrição:", trade.ResultRetcodeDescription());
               }
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| ChartEvent function                                               |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if(g_interface != NULL)
   {
      g_interface.ProcessEvent(id, lparam, dparam, sparam);
   }
} 