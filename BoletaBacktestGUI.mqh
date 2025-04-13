//+------------------------------------------------------------------+
//|                                              BoletaBacktestGUI.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __BOLETA_BACKTEST_GUI_MQH__
#define __BOLETA_BACKTEST_GUI_MQH__

#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Label.mqh>
#include <Trade\Trade.mqh>

// Constantes para a interface
#define BUTTON_WIDTH    100
#define BUTTON_HEIGHT   30
#define BUTTON_SPACING  10
#define EDIT_HEIGHT     30
#define WINDOW_WIDTH    350
#define WINDOW_HEIGHT   200

// Classe que implementa o painel usando CAppDialog
class CBoletaBacktestGUI : public CAppDialog {
private:
   CButton           m_buttonBuy;
   CButton           m_buttonSell;
   CButton           m_buttonClose;
   CEdit             m_editVolume;
   CLabel            m_labelVolume;
   CTrade*           m_trade;
   double            m_volume;
   
   // Botões invisíveis para hack
   string            m_hackBuyButton;
   string            m_hackSellButton;
   string            m_hackCloseButton;

public:
   CBoletaBacktestGUI(CTrade &tradeObj);
   ~CBoletaBacktestGUI(void);
   
   virtual bool      Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2);
   virtual bool      OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
   
   bool             CreateButtons(void);
   bool             CreateEdits(void);
   bool             CreateHackButtons(void);
   void             SetVolume(const double volume) { m_volume = volume; }
   double           GetVolume(void) const { return m_volume; }
   void             CheckHackButtons(void);
   
protected:
   bool             OnClickBuy(void);
   bool             OnClickSell(void);
   bool             OnClickClose(void);
   void             OnChangeVolume(void);
};

//+------------------------------------------------------------------+
//| Constructor                                                        |
//+------------------------------------------------------------------+
CBoletaBacktestGUI::CBoletaBacktestGUI(CTrade &tradeObj)
{
   m_trade = GetPointer(tradeObj);
   m_volume = 0.1;
   
   // Nomes únicos para os botões hack
   m_hackBuyButton = "HackBuyButton_" + IntegerToString(GetTickCount());
   m_hackSellButton = "HackSellButton_" + IntegerToString(GetTickCount());
   m_hackCloseButton = "HackCloseButton_" + IntegerToString(GetTickCount());
}

//+------------------------------------------------------------------+
//| Destructor                                                         |
//+------------------------------------------------------------------+
CBoletaBacktestGUI::~CBoletaBacktestGUI(void)
{
   ObjectDelete(0, m_hackBuyButton);
   ObjectDelete(0, m_hackSellButton);
   ObjectDelete(0, m_hackCloseButton);
}

//+------------------------------------------------------------------+
//| Create the panel                                                   |
//+------------------------------------------------------------------+
bool CBoletaBacktestGUI::Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2)
{
   if(!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2))
      return(false);
   if(!CreateButtons())
      return(false);
   if(!CreateEdits())
      return(false);
   if(!CreateHackButtons())
      return(false);
   return(true);
}

//+------------------------------------------------------------------+
//| Create the buttons                                                 |
//+------------------------------------------------------------------+
bool CBoletaBacktestGUI::CreateButtons(void)
{
   int x = BUTTON_SPACING;
   int y = BUTTON_SPACING;
   
   // Botão Comprar
   if(!m_buttonBuy.Create(0, "BuyButton", 0, x, y, x + BUTTON_WIDTH, y + BUTTON_HEIGHT))
      return(false);
   if(!m_buttonBuy.Text("Comprar"))
      return(false);
   if(!m_buttonBuy.ColorBackground(clrGreen))
      return(false);
   if(!m_buttonBuy.Color(clrWhite))
      return(false);
   if(!Add(m_buttonBuy))
      return(false);
   
   x += BUTTON_WIDTH + BUTTON_SPACING;
   
   // Botão Vender
   if(!m_buttonSell.Create(0, "SellButton", 0, x, y, x + BUTTON_WIDTH, y + BUTTON_HEIGHT))
      return(false);
   if(!m_buttonSell.Text("Vender"))
      return(false);
   if(!m_buttonSell.ColorBackground(clrRed))
      return(false);
   if(!m_buttonSell.Color(clrWhite))
      return(false);
   if(!Add(m_buttonSell))
      return(false);
   
   x += BUTTON_WIDTH + BUTTON_SPACING;
   
   // Botão Fechar
   if(!m_buttonClose.Create(0, "CloseButton", 0, x, y, x + BUTTON_WIDTH, y + BUTTON_HEIGHT))
      return(false);
   if(!m_buttonClose.Text("Fechar"))
      return(false);
   if(!m_buttonClose.ColorBackground(clrGray))
      return(false);
   if(!m_buttonClose.Color(clrWhite))
      return(false);
   if(!Add(m_buttonClose))
      return(false);
   
   return(true);
}

//+------------------------------------------------------------------+
//| Create the edit fields                                            |
//+------------------------------------------------------------------+
bool CBoletaBacktestGUI::CreateEdits(void)
{
   int x = BUTTON_SPACING;
   int y = 2 * BUTTON_SPACING + BUTTON_HEIGHT;
   
   // Label Volume
   if(!m_labelVolume.Create(0, "VolumeLabel", 0, x, y, x + BUTTON_WIDTH, y + 20))
      return(false);
   if(!m_labelVolume.Text("Volume:"))
      return(false);
   if(!Add(m_labelVolume))
      return(false);
   
   y += 25;
   
   // Edit Volume
   if(!m_editVolume.Create(0, "VolumeEdit", 0, x, y, x + BUTTON_WIDTH, y + EDIT_HEIGHT))
      return(false);
   if(!m_editVolume.Text(DoubleToString(m_volume, 2)))
      return(false);
   if(!Add(m_editVolume))
      return(false);
   
   return(true);
}

//+------------------------------------------------------------------+
//| Create hack buttons                                               |
//+------------------------------------------------------------------+
bool CBoletaBacktestGUI::CreateHackButtons(void)
{
   // Aguarda os botões serem criados
   Sleep(100);
   
   // Botão Hack Comprar - Pega posição do botão real
   int buy_x = (int)m_buttonBuy.Left();
   int buy_y = (int)m_buttonBuy.Top();
   
   ObjectCreate(0, m_hackBuyButton, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, m_hackBuyButton, OBJPROP_XDISTANCE, buy_x);
   ObjectSetInteger(0, m_hackBuyButton, OBJPROP_YDISTANCE, buy_y);
   ObjectSetInteger(0, m_hackBuyButton, OBJPROP_XSIZE, BUTTON_WIDTH);
   ObjectSetInteger(0, m_hackBuyButton, OBJPROP_YSIZE, BUTTON_HEIGHT);
   ObjectSetInteger(0, m_hackBuyButton, OBJPROP_BGCOLOR, clrNONE);
   ObjectSetInteger(0, m_hackBuyButton, OBJPROP_COLOR, clrNONE);
   ObjectSetInteger(0, m_hackBuyButton, OBJPROP_BORDER_COLOR, clrNONE);
   ObjectSetInteger(0, m_hackBuyButton, OBJPROP_STATE, false);
   ObjectSetInteger(0, m_hackBuyButton, OBJPROP_ZORDER, 999);
   
   // Botão Hack Vender - Pega posição do botão real
   int sell_x = (int)m_buttonSell.Left();
   int sell_y = (int)m_buttonSell.Top();
   
   ObjectCreate(0, m_hackSellButton, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, m_hackSellButton, OBJPROP_XDISTANCE, sell_x);
   ObjectSetInteger(0, m_hackSellButton, OBJPROP_YDISTANCE, sell_y);
   ObjectSetInteger(0, m_hackSellButton, OBJPROP_XSIZE, BUTTON_WIDTH);
   ObjectSetInteger(0, m_hackSellButton, OBJPROP_YSIZE, BUTTON_HEIGHT);
   ObjectSetInteger(0, m_hackSellButton, OBJPROP_BGCOLOR, clrNONE);
   ObjectSetInteger(0, m_hackSellButton, OBJPROP_COLOR, clrNONE);
   ObjectSetInteger(0, m_hackSellButton, OBJPROP_BORDER_COLOR, clrNONE);
   ObjectSetInteger(0, m_hackSellButton, OBJPROP_STATE, false);
   ObjectSetInteger(0, m_hackSellButton, OBJPROP_ZORDER, 999);
   
   // Botão Hack Fechar - Pega posição do botão real
   int close_x = (int)m_buttonClose.Left();
   int close_y = (int)m_buttonClose.Top();
   
   ObjectCreate(0, m_hackCloseButton, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, m_hackCloseButton, OBJPROP_XDISTANCE, close_x);
   ObjectSetInteger(0, m_hackCloseButton, OBJPROP_YDISTANCE, close_y);
   ObjectSetInteger(0, m_hackCloseButton, OBJPROP_XSIZE, BUTTON_WIDTH);
   ObjectSetInteger(0, m_hackCloseButton, OBJPROP_YSIZE, BUTTON_HEIGHT);
   ObjectSetInteger(0, m_hackCloseButton, OBJPROP_BGCOLOR, clrNONE);
   ObjectSetInteger(0, m_hackCloseButton, OBJPROP_COLOR, clrNONE);
   ObjectSetInteger(0, m_hackCloseButton, OBJPROP_BORDER_COLOR, clrNONE);
   ObjectSetInteger(0, m_hackCloseButton, OBJPROP_STATE, false);
   ObjectSetInteger(0, m_hackCloseButton, OBJPROP_ZORDER, 999);
   
   return(true);
}

//+------------------------------------------------------------------+
//| Check hack buttons states                                         |
//+------------------------------------------------------------------+
void CBoletaBacktestGUI::CheckHackButtons(void)
{
   // Verifica botão de compra
   if((bool)ObjectGetInteger(0, m_hackBuyButton, OBJPROP_STATE))
   {
      ObjectSetInteger(0, m_hackBuyButton, OBJPROP_STATE, false);
      OnClickBuy();
   }
   
   // Verifica botão de venda
   if((bool)ObjectGetInteger(0, m_hackSellButton, OBJPROP_STATE))
   {
      ObjectSetInteger(0, m_hackSellButton, OBJPROP_STATE, false);
      OnClickSell();
   }
   
   // Verifica botão de fechar
   if((bool)ObjectGetInteger(0, m_hackCloseButton, OBJPROP_STATE))
   {
      ObjectSetInteger(0, m_hackCloseButton, OBJPROP_STATE, false);
      OnClickClose();
   }
}

//+------------------------------------------------------------------+
//| Event handler                                                      |
//+------------------------------------------------------------------+
bool CBoletaBacktestGUI::OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if(sparam == "BuyButton")
         return OnClickBuy();
      if(sparam == "SellButton")
         return OnClickSell();
      if(sparam == "CloseButton")
         return OnClickClose();
   }
   else if(id == CHARTEVENT_OBJECT_ENDEDIT)
   {
      if(sparam == "VolumeEdit")
         OnChangeVolume();
   }
   
   return(CAppDialog::OnEvent(id, lparam, dparam, sparam));
}

//+------------------------------------------------------------------+
//| Button Buy clicked                                                |
//+------------------------------------------------------------------+
bool CBoletaBacktestGUI::OnClickBuy(void)
{
   Print("Enviando ordem de compra. Volume:", m_volume);
   
   if(m_trade.Buy(m_volume))
   {
      Print("Ordem de compra enviada! Ticket:", m_trade.ResultOrder(),
            " Preço:", m_trade.ResultPrice(),
            " Volume:", m_trade.ResultVolume());
      return true;
   }
   else
   {
      Print("Erro ao enviar ordem de compra! Erro:", GetLastError(),
            " Descrição:", m_trade.ResultRetcodeDescription());
      return false;
   }
}

//+------------------------------------------------------------------+
//| Button Sell clicked                                               |
//+------------------------------------------------------------------+
bool CBoletaBacktestGUI::OnClickSell(void)
{
   Print("Enviando ordem de venda. Volume:", m_volume);
   
   if(m_trade.Sell(m_volume))
   {
      Print("Ordem de venda enviada! Ticket:", m_trade.ResultOrder(),
            " Preço:", m_trade.ResultPrice(),
            " Volume:", m_trade.ResultVolume());
      return true;
   }
   else
   {
      Print("Erro ao enviar ordem de venda! Erro:", GetLastError(),
            " Descrição:", m_trade.ResultRetcodeDescription());
      return false;
   }
}

//+------------------------------------------------------------------+
//| Button Close clicked                                              |
//+------------------------------------------------------------------+
bool CBoletaBacktestGUI::OnClickClose(void)
{
   Print("Fechando todas as posições...");
   int totalFechadas = 0;
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0)
      {
         if(m_trade.PositionClose(ticket))
         {
            Print("Posição ", ticket, " fechada com sucesso! Preço:", m_trade.ResultPrice());
            totalFechadas++;
         }
         else
         {
            Print("Erro ao fechar posição ", ticket,
                  " Erro:", GetLastError(),
                  " Descrição:", m_trade.ResultRetcodeDescription());
         }
      }
   }
   
   Print("Total de posições fechadas: ", totalFechadas);
   return true;
}

//+------------------------------------------------------------------+
//| Volume edit changed                                               |
//+------------------------------------------------------------------+
void CBoletaBacktestGUI::OnChangeVolume(void)
{
   string text = m_editVolume.Text();
   double newVolume = StringToDouble(text);
   
   if(newVolume > 0)
   {
      m_volume = newVolume;
      Print("Volume atualizado para: ", m_volume);
   }
   else
   {
      m_volume = 0.1;
      m_editVolume.Text(DoubleToString(m_volume, 2));
      Print("Volume inválido, restaurado para: ", m_volume);
   }
}

#endif // __BOLETA_BACKTEST_GUI_MQH__