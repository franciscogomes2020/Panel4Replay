#property copyright "Copyright 2024"
#property link      ""
#property version   "1.00"
#property strict

// Inclusão dos arquivos necessários
#include "BoletaBacktest.mqh"
#include "BoletaBacktestGUI.mqh"

// Variáveis globais
CBoletaBacktestGUI* g_interface = NULL;
bool g_isTestMode = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit()
{
   // Verifica se está no testador
   g_isTestMode = MQLInfoInteger(MQL_TESTER);
   
   // Inicializa a interface gráfica
   g_interface = new CBoletaBacktestGUI();
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
      g_interface.Update();
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