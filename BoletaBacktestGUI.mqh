//+------------------------------------------------------------------+
//|                                              BoletaBacktestGUI.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "BoletaBacktest.mqh"

// Constantes para a interface
#define BUTTON_WIDTH 100
#define BUTTON_HEIGHT 30
#define BUTTON_MARGIN 10
#define PANEL_WIDTH 300
#define PANEL_HEIGHT 400

// IDs dos controles
#define ID_BUY_BUTTON 1
#define ID_SELL_BUTTON 2
#define ID_CLOSE_BUTTON 3
#define ID_VOLUME_EDIT 4
#define ID_POSITIONS_LIST 5

// Classe da interface gráfica
class CBoletaBacktestGUI
{
private:
   COperationManager* m_operationManager;
   bool m_buyButtonState;
   bool m_sellButtonState;
   bool m_closeButtonState;
   double m_volume;
   
   // Métodos privados
   void CreateButtons()
   {
      // Botão de Compra
      ObjectCreate(0, "BuyButton", OBJ_BUTTON, 0, 0, 0);
      ObjectSetString(0, "BuyButton", OBJPROP_TEXT, "Comprar");
      ObjectSetInteger(0, "BuyButton", OBJPROP_XDISTANCE, BUTTON_MARGIN);
      ObjectSetInteger(0, "BuyButton", OBJPROP_YDISTANCE, BUTTON_MARGIN);
      ObjectSetInteger(0, "BuyButton", OBJPROP_XSIZE, BUTTON_WIDTH);
      ObjectSetInteger(0, "BuyButton", OBJPROP_YSIZE, BUTTON_HEIGHT);
      ObjectSetInteger(0, "BuyButton", OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, "BuyButton", OBJPROP_COLOR, clrWhite);
      ObjectSetInteger(0, "BuyButton", OBJPROP_BGCOLOR, clrGreen);
      ObjectSetInteger(0, "BuyButton", OBJPROP_BORDER_COLOR, clrBlack);
      ObjectSetInteger(0, "BuyButton", OBJPROP_STATE, false);
      
      // Botão de Venda
      ObjectCreate(0, "SellButton", OBJ_BUTTON, 0, 0, 0);
      ObjectSetString(0, "SellButton", OBJPROP_TEXT, "Vender");
      ObjectSetInteger(0, "SellButton", OBJPROP_XDISTANCE, BUTTON_MARGIN);
      ObjectSetInteger(0, "SellButton", OBJPROP_YDISTANCE, BUTTON_MARGIN + BUTTON_HEIGHT + BUTTON_MARGIN);
      ObjectSetInteger(0, "SellButton", OBJPROP_XSIZE, BUTTON_WIDTH);
      ObjectSetInteger(0, "SellButton", OBJPROP_YSIZE, BUTTON_HEIGHT);
      ObjectSetInteger(0, "SellButton", OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, "SellButton", OBJPROP_COLOR, clrWhite);
      ObjectSetInteger(0, "SellButton", OBJPROP_BGCOLOR, clrRed);
      ObjectSetInteger(0, "SellButton", OBJPROP_BORDER_COLOR, clrBlack);
      ObjectSetInteger(0, "SellButton", OBJPROP_STATE, false);
      
      // Botão de Fechar
      ObjectCreate(0, "CloseButton", OBJ_BUTTON, 0, 0, 0);
      ObjectSetString(0, "CloseButton", OBJPROP_TEXT, "Fechar");
      ObjectSetInteger(0, "CloseButton", OBJPROP_XDISTANCE, BUTTON_MARGIN);
      ObjectSetInteger(0, "CloseButton", OBJPROP_YDISTANCE, BUTTON_MARGIN + (BUTTON_HEIGHT + BUTTON_MARGIN) * 2);
      ObjectSetInteger(0, "CloseButton", OBJPROP_XSIZE, BUTTON_WIDTH);
      ObjectSetInteger(0, "CloseButton", OBJPROP_YSIZE, BUTTON_HEIGHT);
      ObjectSetInteger(0, "CloseButton", OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, "CloseButton", OBJPROP_COLOR, clrWhite);
      ObjectSetInteger(0, "CloseButton", OBJPROP_BGCOLOR, clrGray);
      ObjectSetInteger(0, "CloseButton", OBJPROP_BORDER_COLOR, clrBlack);
      ObjectSetInteger(0, "CloseButton", OBJPROP_STATE, false);
   }
   
   void CreateVolumeEdit()
   {
      ObjectCreate(0, "VolumeEdit", OBJ_EDIT, 0, 0, 0);
      ObjectSetString(0, "VolumeEdit", OBJPROP_TEXT, DoubleToString(m_volume, 2));
      ObjectSetInteger(0, "VolumeEdit", OBJPROP_XDISTANCE, BUTTON_MARGIN);
      ObjectSetInteger(0, "VolumeEdit", OBJPROP_YDISTANCE, BUTTON_MARGIN + (BUTTON_HEIGHT + BUTTON_MARGIN) * 3);
      ObjectSetInteger(0, "VolumeEdit", OBJPROP_XSIZE, BUTTON_WIDTH);
      ObjectSetInteger(0, "VolumeEdit", OBJPROP_YSIZE, BUTTON_HEIGHT);
      ObjectSetInteger(0, "VolumeEdit", OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, "VolumeEdit", OBJPROP_ALIGN, ALIGN_CENTER);
      ObjectSetInteger(0, "VolumeEdit", OBJPROP_READONLY, false);
   }
   
public:
   CBoletaBacktestGUI()
   {
      m_operationManager = new COperationManager();
      m_buyButtonState = false;
      m_sellButtonState = false;
      m_closeButtonState = false;
      m_volume = 0.1;
   }
   
   ~CBoletaBacktestGUI()
   {
      if(m_operationManager != NULL)
      {
         delete m_operationManager;
         m_operationManager = NULL;
      }
      
      // Remove todos os objetos
      ObjectDelete(0, "BuyButton");
      ObjectDelete(0, "SellButton");
      ObjectDelete(0, "CloseButton");
      ObjectDelete(0, "VolumeEdit");
   }
   
   bool Init()
   {
      CreateButtons();
      CreateVolumeEdit();
      return true;
   }
   
   void Update()
   {
      // Atualiza o estado dos botões com base nas posições abertas
      bool hasPositions = false;
      for(int i = PositionsTotal() - 1; i >= 0; i--)
      {
         if(PositionSelectByIndex(i))
         {
            hasPositions = true;
            break;
         }
      }
      
      ObjectSetInteger(0, "CloseButton", OBJPROP_STATE, hasPositions);
   }
   
   void ProcessEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
   {
      if(id == CHARTEVENT_OBJECT_CLICK)
      {
         if(sparam == "BuyButton")
         {
            m_buyButtonState = !m_buyButtonState;
            ObjectSetInteger(0, "BuyButton", OBJPROP_STATE, m_buyButtonState);
            
            if(m_buyButtonState)
            {
               m_operationManager.OpenPosition(true, m_volume);
            }
         }
         else if(sparam == "SellButton")
         {
            m_sellButtonState = !m_sellButtonState;
            ObjectSetInteger(0, "SellButton", OBJPROP_STATE, m_sellButtonState);
            
            if(m_sellButtonState)
            {
               m_operationManager.OpenPosition(false, m_volume);
            }
         }
         else if(sparam == "CloseButton")
         {
            m_closeButtonState = !m_closeButtonState;
            ObjectSetInteger(0, "CloseButton", OBJPROP_STATE, m_closeButtonState);
            
            if(m_closeButtonState)
            {
               for(int i = PositionsTotal() - 1; i >= 0; i--)
               {
                  if(PositionSelectByIndex(i))
                  {
                     m_operationManager.ClosePosition(PositionGetInteger(POSITION_TICKET));
                  }
               }
            }
         }
      }
      else if(id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "VolumeEdit")
      {
         string text = ObjectGetString(0, "VolumeEdit", OBJPROP_TEXT);
         m_volume = StringToDouble(text);
         if(m_volume <= 0) m_volume = 0.1;
         ObjectSetString(0, "VolumeEdit", OBJPROP_TEXT, DoubleToString(m_volume, 2));
      }
   }
}; 