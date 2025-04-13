#property copyright "Copyright 2024"
#property link      ""
#property version   "1.00"
#property strict

// Inputs
input int InpMagicNumber = 123456;  // Magic Number
input double InpVolume = 0.1;       // Volume Inicial

// Includes
#include "BoletaBacktestGUI.mqh"

// Variáveis globais
CBoletaBacktestGUI* g_gui = NULL;
CTrade trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit()
{
   // Configura o trade
   trade.SetExpertMagicNumber(InpMagicNumber);
   trade.SetMarginMode();
   trade.SetTypeFilling(ORDER_FILLING_FOK);
   trade.SetDeviationInPoints(10);
   trade.LogLevel(LOG_LEVEL_ALL);
   
   // Cria e inicializa a interface gráfica
   g_gui = new CBoletaBacktestGUI(trade);
   if(g_gui == NULL)
   {
      Print("Erro ao criar interface gráfica");
      return INIT_FAILED;
   }
   
   if(!g_gui.Create(0, "Boleta Backtest", 0, 20, 20, 370, 220))
   {
      Print("Erro ao criar painel");
      delete g_gui;
      return INIT_FAILED;
   }
   
   g_gui.SetVolume(InpVolume);
   g_gui.Run();
   
   Print("EA iniciado - Magic Number:", InpMagicNumber, " Volume:", InpVolume);
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(g_gui != NULL)
   {
      g_gui.Destroy();
      delete g_gui;
      g_gui = NULL;
   }
}

//+------------------------------------------------------------------+
//| Expert tick function                                              |
//+------------------------------------------------------------------+
void OnTick()
{
   if(g_gui != NULL)
      g_gui.CheckHackButtons();
}

//+------------------------------------------------------------------+
//| ChartEvent function                                               |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if(g_gui != NULL)
      g_gui.OnEvent(id, lparam, dparam, sparam);
} 