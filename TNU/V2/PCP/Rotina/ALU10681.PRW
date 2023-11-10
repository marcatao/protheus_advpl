#Include "Protheus.ch"
#Include "FWMVCDEF.CH"
/*/{Protheus.doc} ARO10650
Apontamento de Producao Alumbra
@type function
@version 
@author Samsung
@since 16/10/2020
@return return_type, return_description
/*/

Static __WV084AUT  := ExistBlock("WV084AUT")

User Function ALU10681()

//Local oModel		:= FWModelActive()
//Local oView		   := FwViewActive()
Local cAlias  := GetNextAlias()
//Local lRet		   := .F.
//Local nTamCodMV	:= 0
Local nSuperior	:= 0
Local nEsquerda	:= 0
Local nInferior	:= 520
Local nDireita	:= 800
Local oBrowSZ3	:= Nil
Local oDlgTela	:= Nil
Local cSZ3Qry	    := ""
//Local cTitFilial	:= ""
//Local cTitCodMV	:= ""
//Local cTitProdut	:= ""
//Local cTitDesc	:= ""
//Local cTitBaAtd	:= ""
//Local cTitMotivo	:= ""
//Local cTitObsMNT	:= ""
//Local cTitEQ3	:= ""
Local aIndex		:= {}		// Definição do índice da Consulta Padrão
Local aSeek		:= {}					// Definição da Descrição da Chave de Pesquisa da Consulta Padrão
//Local cTitSep		:= ""
//Local cRetSB1     := ""

Local cDoc        := ""
Local cProduto    := "" 
Local cDesc       := ""
Local cUM         := ""
Local nSaldo      := 0


Local oPanel
Local oButPesar
Local oSayPeso
Local oSayTara
Local oTimer
Local nMilissegundos := 3000 // Disparo será de 2 em 2 segundos
Local oFont1    := TFont():New('Arial',,10,.T.)
Local oFont2    := TFont():New('Arial',,14,.T.)
Local oFont16   := TFont():New('Arial',,16,.T.)
Local oFont18B  := TFont():New('Arial',,18,.T.,.T.)
Local oFont22B  := TFont():New('Arial',,22,.T.,.T.)
Local aColumns  := {}
Local oPanelBal
Local cPictPeso := "" 
Local cPictSaldo:= "" 
Local cLocal    := ""
Local cUn       := "KG"
//Local oSaySinal
Local cTitulo   := ""
//Local oTimer
Local cBalanca   := ""
Local aCmbBal    := {}
Local oCmbBal
Local oSayQtd 
Local oGetQtd  
//Local oSayNum
//Local oTGetNum
Local cOperador


//Obejtos da balança

Local oGetPeso
Local nPeso       := 0

Local oGetTara
Local nTara       := 0
Local nQtd       := 0

Local nPesoLiq    := 0
Local oGetLiq 
Local nTipo     := "" 
Local aRadTipo  := {}
//Local cNum      := "00001" //GetSXENum()
//Local cPesagem  := "000001"
Local cOperacao := "01"
Local oRadTipo 
Local cResp     := "04900"
Local oSayTT
Local oSayLT
Local oSayQT
Local cRecurso := ""
Local lLeitura  := .T.
Local cQryCpo   := ""
Local oTGetOper 
Local cIdUnitz  := PadR(" ",TamSX3("Z3_IDUNITZ")[1], " ")
Local cEndEnt   := PadR(" ",TamSX3("Z3_ENDENT")[1], " ")
Local lManual   := .F.
Local cLocOri   := PadR(" ",TamSX3("Z3_LOCORI")[1], " ")
Local cEndDes   := PadR(" ",TamSX3("Z3_ENDDES")[1], " ")
Local oTGetEndEnt
Local oTGetEndDes


//Objetos do Rodape
Private oGetPT
Private nPesoT    := 0

Private oTGetTT
Private nTaraT    := 0

Private oGetLT  
Private nPesoLT   := 0

Private nQtdT := 0
Private oGetQT

Private nFaltante := 0

Default cLote  := ""

Private oTGetFaltante
Private aProdEnd    := {}
Private lUsaCB001 	:=UsaCB0("01")
Private lPort       := .F.  //verificar necessidade
//Private nUltimoPeso := 0

Private cTempoT     := ""//Tempo total desde o inicio do apontamento
Private cTempoP     := "" //Tempo da pesagem, zerado a cada pesagem
Private oGetTmpT 
Private oGetTmpP 
Private cHoraIni    := ""
//Private lPort       := .F.

Default lVisual := .F.
Default nNecess := 0

//Cn010F3Tip()


If FunName() == "MATA650"
	nTipo    := 1
Else
    nTipo    := 2
EndIf

cPictPeso := PesqPict("SZ3", "Z3_PESO")
cPictSaldo:= PesqPict("SB8", "B8_SALDO")

cTitulo := "BALANCA"

//Validar e posicionar operador
cOperador   := CBRetOpe()

CBVldOpe(cOperador)

aColumns := PegColunas(@cQryCpo)

cSZ3Qry := PegQuery(cDoc,cQryCpo)

DEFINE MSDIALOG oDlgTela TITLE cTitulo + " - PESAGEM " FROM nSuperior, nEsquerda TO nInferior, nDireita PIXEL	
//TButton():New( [ nRow ], [ nCol ], [ cCaption ], [ oWnd ], [ bAction ], [ nWidth ], [ nHeight ], [ uParam8 ], [ oFont ], [ uParam10 ], [ lPixel ], [ uParam12 ], [ uParam13 ], [ uParam14 ], [ bWhen ], [ uParam16 ], [ uParam17 ] )
//TGet():New( [ nRow ], [ nCol ], [ bSetGet ], [ oWnd ], [ nWidth ], [ nHeight ], [ cPict ], [ bValid ], [ nClrFore ], [ nClrBack ], [ oFont ], [ uParam12 ], [ uParam13 ], [ lPixel ], [ uParam15 ], [ uParam16 ], [ bWhen ], [ uParam18 ], [ uParam19 ], [ bChange ], [ lReadOnly ], [ lPassword ], [ uParam23 ], [ cReadVar ], [ uParam25 ], [ uParam26 ], [ uParam27 ], [ lHasButton ], [ lNoButton ], [ uParam30 ], [ cLabelText ], [ nLabelPos ], [ oLabelFont ], [ nLabelColor ], [ cPlaceHold ], [ lPicturePriority ], [ lFocSel ] )
//TSay():New( [ nRow ], [ nCol ], [ bText ], [ oWnd ], [ cPicture ], [ oFont ], [ uParam7 ], [ uParam8 ], [ uParam9 ], [ lPixels ], [ nClrText ], [ nClrBack ], [ nWidth ], [ nHeight ], [ uParam15 ], [ uParam16 ], [ uParam17 ], [ uParam18 ], [ uParam19 ], [ lHTML ], [ nTxtAlgHor ], [ nTxtAlgVer ] )
// TPanel():New( [ nRow ], [ nCol ], [ cText ], [ oWnd ], [ oFont ], [ lCentered ], [ uParam7 ], [ nClrText ], [ nClrBack ], [ nWidth ], [ nHeight ], [ lLowered ], [ lRaised ] )


// // Muda a cor da linha do browser Pesar
// oBrowse:SetBlkBackColor({|| IIf(SA1->A1_COD == "000001" .AND. SA1->A1_LOJA == '01' , CLR_HMAGENTA , Nil )})

//oGetLote	:= TGet():New(40,15, BSetGet(cLote),oDlgTela,100,10,"@!",{ || Vazio() .Or. ExistCpo("FN8",cLote)} ,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"FN8",cLote,,,,,,,STR0015+':' ) //"Lote"

oPanel:= tPanel():New(110,01,"",oDlgTela,oFont1,.T.,,CLR_WHITE,CLR_GRAY,400,110)

//nMilissegundos := 15000 // Disparo será de 2 em 2 segundos

oTimer := TTimer():New(nMilissegundos, {|| AtualizarPeso(@nPeso,@nTara,@nPesoLiq, @cUn,oPanelBal,nTipo,@nQtd, @lLeitura),oGetPeso:Refresh(),oGetTara:Refresh(),oGetLiq:Refresh(), oPanelBal:Refresh(),oGetUn:Refresh(), oGetQtd:Refresh()}, oDlgTela )
oTimer:Activate()

//oButFechar := TButton():New( 002, 300, "Fechar",oDlgTela,{||iIf(Fechar(nTipo, cDoc, cProduto, cLocal, cLote, lVisual),oDlgTela:End(),A030Final())}, 040,016,,oFont2,.F.,.T.,.F.,,.F.,,,.F. )
 
//oSayLote:= TSay():New(016,002,{||'Lote'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
//oTGetLote := TGet():New( 024,002,{|u| If(PCount() > 0,cLote := u,cLote)},oDlgTela,80,014,"@!",,0,,oFont22B,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"cLote",,,, )
//oGetLote	:= TGet():New(40,15, BSetGet(cLote),oDlgTela,100,10,"@!",{ || Vazio() .Or. ExistCpo("FN8",cLote)} ,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"FN8",cLote,,,,,,,STR0015+':' ) //"Lote"
//oPlano	:=	TGet():New( 040, 038, {|u| If(PCount() > 0,cLote := u,cLote) }, oDlg, 020, ,"@!",{||CTB050VlPl()},,,,,,.T./*<.pixel.>*/,,,{|| INCLUI },,,,,,,"cPlanoCV0"/*<(uVar)>*/,,,)
	
//oSayLocal:= TSay():New(016,085,{||'Local'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
//oTGetLocal := TGet():New( 024,085,{||cLocal},oDlgTela,30,014,"@!",,0,,oFont22B,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"cLote",,,, )
//TRadMenu():New( [ nRow ], [ nCol ], [ aItems ], [ bSetGet ], [ oWnd ], [ uParam6 ], [ bChange ], [ nClrText ], [ nClrPane ], [ cMsg ], [ uParam11 ], [ bWhen ], [ nWidth ], [ nHeight ], [ bValid ], [ uParam16 ], [ uParam17 ], [ lPixel ], [ lHoriz ], [ lAutoHeight ] )
//TCheckBox():New( [ nRow ], [ nCol ], [ cCaption ], [ bSetGet ], [ oDlg ], [ nWidth ], [ nHeight ], [ uParam8 ], [ bLClicked ], [ oFont ], [ bValid ], [ nClrText ], [ nClrPane ], [ uParam14 ], [ lPixel ], [ cMsg ], [ uParam17 ], [ bWhen ] )


oLeitura := TCheckBox():New( 010,280 , OemTOAnsi("Leitura Automática"),{|u| If(PCount()>0,lLeitura:=u,lLeitura)} , oDlgTela, 070, 015, , , oFont16,, ,,, .T.,,, {|| .T.} )
oManual := TCheckBox():New( 010,350 , OemTOAnsi("Manual"),{|u| If(PCount()>0,lManual:=u,lManual)} , oDlgTela, 050, 015, ,{|| ReportManual(lManual,oGetPeso,@nPeso,oGetTara,@nTara,oGetQtd,@nQtd,oGetLiq,@nPesoLiq)} , oFont16,, ,,, .T.,,, {|| .T.} )

aRadTipo := {'Reporte Produção','Pesagem Individual','Sem Ordem de Produção'}

oRadTipo := TRadMenu():New (020,002,aRadTipo,,oDlgTela,,,,,,,,  200,15,,,,.T.,.T.)
oRadTipo:bSetGet := {|u|Iif (PCount()==0,nTipo,nTipo:=u)}
ORadTipo:bChange := {|| A030Inicio(oBrowSZ3, nTipo, @cBalanca, @oTGetDoc,@oTGetProduto, @cDoc, @cProduto, lLeitura,@oTGetOper,@oTGetLocal, @cIdUnitz, @oTGetEtiq,@cLocal,@nSaldo,@cOperacao,@cRecurso,@cUM,@cDesc,@cEndEnt, cQryCpo,oTGetLocOri,oTGetEndEnt,oTGetEndDes)}

oSayLSaldo:= TSay():New(045,160,{||'Saldo Op'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
oTGetLSaldo := TGet():New( 053,160,{||nSaldo},oDlgTela,50,014,cPictSaldo,,0,,oFont16,.F.,,.T.,,.F.,{||.F.},.F.,.F.,,.T.,.F.,,"nSaldo",,,, )

oSayLUM:= TSay():New(045,224,{||'UM'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,10,10)
oTGetLUM := TGet():New( 053,224,{||cUM},oDlgTela,50,014,"@!",,0,,oFont16,.F.,,.T.,,.F.,{||.F.},.F.,.F.,,.T.,.F.,,"cUM",,,, )

oSayDoc:= TSay():New(045,002,{||'Ordem de Produção'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
oTGetDoc := TGet():New( 053,002,{ |u|Iif (PCount()==0,cDoc,cDoc:=u)},oDlgTela,60,012,"@!",{ |u| If(PCount()>0,BuscaOP(cDoc, @cProduto, @cDesc, @nSaldo, @cLocal, @cUM,oBrowSZ3, @cOperacao, @cRecurso, cQryCpo) , .T.) },0,,oFont16,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.T.,.F.,"SC2","cDoc",,,, )

oSayOper:= TSay():New(045,70,{||'Operacão'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
oTGetOper := TGet():New( 053,70,{ |u|Iif (PCount()==0,cOperacao,cOperacao:=u)},oDlgTela,60,012,"@!",,0,,oFont16,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.T.,.F.,"SG2BAL","cOperacao",,,, )

oSayProduto:= TSay():New(069,002,{||'Produto'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
oTGetProduto := TGet():New( 077,002,{ |u|Iif (PCount()==0,cProduto,cProduto:=u)},oDlgTela,60,012,"@!",{|| VldProd(cProduto,@cDesc,oTGetDesc,@cUM,  oBrowSZ3, cDoc, cQryCpo)},0,,oFont16,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.T.,.F.,"SB1","cProduto",,,, )

oSayDesc:= TSay():New(069,070,{||'Descrição'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
oTGetDesc := TGet():New( 077,070,{||cDesc},oDlgTela,200,012,"@!",,0,,oFont16,.F.,,.T.,,.F.,{||.F.},.F.,.T.,,.T.,.F.,,"cDesc",,,, )

oSayEtiq:= TSay():New(093,002,{||'Etiqueta'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
oTGetEtiq := TGet():New( 101,002,{ |u|Iif (PCount()==0,cIdUnitz,cIdUnitz:=u)},oDlgTela,60,012,"@!",{|| VldUnitz(cIdUnitz,oTGetEtiq, oBrowSZ3, cQryCpo, oDlgTela,@cDoc,@cProduto,@cLocal,@cRecurso,@cDesc,@cUM) },0,,oFont16,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.T.,.F.,"SZ3","cIdUnitz",,,, )

oSayLocal:= TSay():New(093,072,{||'Armazem'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
oTGetLocal := TGet():New( 101,072,{ |u|Iif (PCount()==0,cLocal,cLocal:=u)},oDlgTela,30,012,"@!",,0,,oFont16,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.T.,.F.,"NNR","cLocal",,,, )

oSayEndDes:= TSay():New(093,105,{||'Ender Des'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
oTGetEndDes := TGet():New( 101,105,{ |u|Iif (PCount()==0,cEndDes,cEndDes:=u)},oDlgTela,30,012,"@!",,0,,oFont16,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.T.,.F.,"SBE","cEndDes",,,, )

oSayLocOri:= TSay():New(093,140,{||'Arm Origem'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
oTGetLocOri := TGet():New( 101,140,{ |u|Iif (PCount()==0,cLocOri,cLocOri:=u)},oDlgTela,30,012,"@!",,0,,oFont16,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.T.,.F.,"NNR","cLocOri",,,, )

oSayEndEnt:= TSay():New(093,175,{||'Ender Ori'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
oTGetEndEnt := TGet():New( 101,175,{ |u|Iif (PCount()==0,cEndEnt,cEndEnt:=u)},oDlgTela,30,012,"@!",,0,,oFont16,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.T.,.F.,"SBE","cEndEnt",,,, )

//TGet():New( [ nRow ], [ nCol ], [ bSetGet ], [ oWnd ], [ nWidth ], [ nHeight ], [ cPict ], [ bValid ], [ nClrFore ], [ nClrBack ], [ oFont ], [ uParam12 ], [ uParam13 ], [ lPixel ], [ uParam15 ], [ uParam16 ], [ bWhen ], [ uParam18 ], [ uParam19 ], [ bChange ], [ lReadOnly ], [ lPassword ], [ uParam23 ], [ cReadVar ], [ uParam25 ], [ uParam26 ], [ uParam27 ], [ lHasButton ], [ lNoButton ], [ uParam30 ], [ cLabelText ], [ nLabelPos ], [ oLabelFont ], [ nLabelColor ], [ cPlaceHold ], [ lPicturePriority ], [ lFocSel ] )
oSayResp:= TSay():New(093,210,{||'Responsável'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
oTGetResp := TGet():New( 101,210,{ |u|Iif (PCount()==0,cResp,cResp:=u)},oDlgTela,60,012,"@!",,0,,oFont16,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.F.,.F.,,"cResp",,,, )



//Quando for producao, mostrar necessidade da materia prima
/*If nTipo <> "3"
    oSayNecess:= TSay():New(093,002,{||'Necessidade'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
    oTGetNecess := TGet():New( 101,002,{||nNecess},oDlgTela,60,012,cPictSaldo,,0,,oFont18B,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"cProduto",,,, )

    oSayFaltante:= TSay():New(093,070,{||'Falta Pesar'},oDlgTela,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,50,10)
    oTGetFaltante := TGet():New( 101,070,{||nFaltante},oDlgTela,60,012,cPictSaldo,,0,,oFont18B,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"cDesc",,,, )
EndIf
*/
oPanelBal:= tPanel():New(024,278," BALANÇA",oDlgTela,oFont1,.F.,,CLR_WHITE,CLR_RED,110,105,.F.,.T.)

//TComboBox():New( [ nRow ], [ nCol ], [ bSetGet ], [ nItens ], [ nWidth ], [ nHeight ], [ oWnd ], [ uParam8 ], [ bChange ], [ bValid ], [ nClrText ], [ nClrBack ], [ lPixel ], [ oFont ], [ uParam15 ], [ uParam16 ], [ bWhen ], [ uParam18 ], [ uParam19 ], [ uParam20 ], [ uParam21 ], [ cReadVar ], [ cLabelText ], [ nLabelPos ], [ oLabelFont ], [ nLabelColor ] )
aCmbBal  := PegaBal() 
oCmbBal := TComboBox():New(006,002,{|u|if(PCount()>0,cBalanca:=u,cBalanca)}, aCmbBal,108,14,oPanelBal,,,{|| .T. /*VldBal(cBalanca)*/},,,.T.,oFont16,,,{||.T.},,,,,'cBalanca')

oSayPeso:= TSay():New(018,002,{||'Peso'},oPanelBal,,oFont1,,,,.T.,CLR_WHITE,CLR_WHITE,50,10)
oGetPeso := TGet():New( 023,002,{|u| If(PCount() > 0,nPeso := u,nPeso)},oPanelBal,090,10,cPictPeso,{|| VldTara(@nPesoLiq,nPeso,nTara,oGetLiq)},0,,oFont16,.F.,,.T.,,.F.,{|| .T. /*CB1->CB1_XPERPE == "1"*/},.F.,.F.,,.T.,.F.,,"nPeso",,,, )
oGetUn := TGet():New( 023,092,{||cUn},oPanelBal,017,10,"",,0,,oFont16,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"cUn",,,, )

//Sinal de conexao
//oSaySinal:= TSay():New(032,040,{||'CONECTADO'},oPanelBal,,oFont1,,,,.T.,CLR_RED,CLR_RED,012,004)
//oSaySinal:lTransparent = .F.

oGetPeso:SetContentAlign(1)

oSayTara:= TSay():New(037,002,{||'Tara'},oPanelBal,,oFont1,,,,.T.,CLR_WHITE,CLR_WHITE,60,10)
oGetTara := TGet():New( 042,002,{|u| If(PCount() > 0,nTara := u,nTara)},oPanelBal,040,010,cPictPeso,{|| VldTara(@nPesoLiq,nPeso,nTara,oGetLiq)},0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"nTara",,,, )
oGetTara:SetContentAlign(1)


oSayQtd:= TSay():New(056,002,{||'Quantidade'},oPanelBal,,oFont1,,,,.T.,CLR_WHITE,CLR_WHITE,60,10)
oGetQtd := TGet():New( 063,025,{|u| If(PCount() > 0,nQtd := u,nQtd)},oPanelBal,065,016,cPictPeso,{|| VldTara(@nPesoLiq,nPeso,nTara,oGetLiq)},0,,oFont22B,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"nQtd",,,, )
oGetQtd:SetContentAlign(1)


oSayLiq:= TSay():New(037,047,{||'Peso Liquido'},oPanelBal,,oFont1,,,,.T.,CLR_WHITE,CLR_WHITE,60,10)
oGetLiq := TGet():New(042,047,{|u| If(PCount() > 0,nPesoLiq := u,nPesoLiq)},oPanelBal,060,010,cPictPeso,,0,,oFont16,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"nPesoLiq",,,, )
oGetLiq:SetContentAlign(1)

oButPesar := TButton():New( 083, 002, "PESAR",oPanelBal,{||Pesar(oBrowSZ3,,oButPesar, nPeso, nTara,nPesoLiq, cDoc, cProduto, cLocal, cLote, nTipo, nQtd, cOperacao, cRecurso, cOperador,cEndEnt, cResp, cQryCpo, .F. , lManual,cLocOri, cEndDes)},;
                        105,020,,oFont16,.F.,.T.,.F.,,.F.,{|| !lVisual},,.F. )  
oButPesar:SetCss("QPushButton { background: #149FC1; border: 1px solid #096A82;outline:0; border-radius: 5px; font: bold 12px Arial; padding: 6px;color: #FFFFFF;} QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #149FC1); }")

//Usando CSS 
//Local cButton := "QPushButton { background: #35ACCA; border: 1px solid #096A82;outline:0; border-radius: 5px; font: normal 12px Arial; padding: 6px;color: #ffffff;} 
//"               QPushButton:pressed {background-color: #3AAECB;border-style: inset; border-color: #35ACCA; color: #ffffff; }"




                        //RGB( 0, 0, 128 )

oBrowSZ3 := FWFormBrowse():New(oPanel)
oBrowSZ3:SetDescription("") 
oBrowSZ3:SetAlias(cAlias)
//oBrowSZ3:SetAlias("SZ3")
oBrowSZ3:SetDataQuery()
oBrowSZ3:SetQuery(cSZ3Qry)
oBrowSZ3:SetOwner(oPanel)
oBrowSZ3:DisableDetails()
oBrowSZ3:SetQueryIndex(aIndex)
oBrowSZ3:SetColumns(aColumns)
oBrowSZ3:SetSeek({||.T.},aSeek)

//cCondicao := " SZ3->Z3_DOC == '" + cDoc + "' "// := " SZ3->Z3_DOC == '" + '&AllTrim(cDoc)' + "' "cQryCpoatua

//oBrowSZ3:SetFilterDefault(cCondicao)

//oBrowSZ3:SetDoubleClick({|| lRet := .T., cRetSB1 := (oBrowSZ3:Alias())->B1_COD, oDlgTela:End()})

If !lVisual

  oBrowSZ3:AddButton( OemTOAnsi("Reprocessar"), {|| Pesar(oBrowSZ3,,oButPesar, nPeso, nTara,nPesoLiq, cDoc, cProduto, cLocal, cLote, nTipo, nQtd, cOperacao, cRecurso, cOperador,cEndEnt, cResp, cQryCpo, .T., lManual, cLocOri,cEndDes ) },, 2 ) 
  oBrowSZ3:AddButton( OemTOAnsi("Reimprimir"), {|| ImpEtiq((cAlias)->Z3_CODETI) },, 2 ) 
  oBrowSZ3:AddButton( OemTOAnsi("Estornar"), {|| Alert("Estorne pelo processo padrão do sistema na seguinte sequencia: MOVIMENTO WMS, OS, APONTAMENTO") },, 2 ) 
  oBrowSZ3:AddButton( OemTOAnsi("Excluir"), {|| ExcluirPesag(cAlias, oBrowSZ3, cDoc, cQryCpo,nTipo, cProduto) },, 2 ) //"Cancelar"
  oBrowSZ3:AddButton( OemTOAnsi("Reconectar"), {|| u_ALU10Balanca(1, cBalanca,@lLeitura), oGetPeso:Refresh()},, 2 ) 

EndIf


oBrowSZ3:Activate()

//Rodape
oPanelRodap:= tPanel():New(001,001,"",oDlgTela,oFont1,.T.,,CLR_WHITE,CLR_GRAY,400,25)
oPanelRodap:Align :=CONTROL_ALIGN_BOTTOM

If nTipo == 1 //Somente para producao
//    oSayTmpP:= TSay():New(001,080,{||'Tempo Pesagem'},oPanelRodap,,oFont1,,,,.T.,CLR_WHITE,CLR_WHITE,50,10)
//oGetTmpP := TGet():New( 008,080,{|u| If(PCount() > 0,cTempoP := u,cTempoP)},oPanelRodap,40,010,"99:99:99",,0,,oFont16,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"cTempoP",,,, )

 //   oSayTmpT:= TSay():New(001,140,{||'Tempo Total'},oPanelRodap,,oFont1,,,,.T.,CLR_WHITE,CLR_WHITE,50,10)
//    oGetTmpT := TGet():New( 008,140,{|u| If(PCount() > 0,cTempoT := u,cTempoT)},oPanelRodap,40,010,"99:99:99",,0,,oFont16,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"cTempoT",,,, )
EndIf
oSayPesoT:= TSay():New(001,140,{||'Peso Total'},oPanelRodap,,oFont1,,,,.T.,CLR_WHITE,CLR_WHITE,50,10)
oGetPT := TGet():New(008,140,{||nPesoT},oPanelRodap,058,012,cPictPeso,,0,CLR_WHITE,oFont16,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"nPesoT",,,, )
oGetPT:SetContentAlign(1)

oSayTT:= TSay():New(001,200,{||'Tara Total'},oPanelRodap,,oFont1,,,,.T.,CLR_WHITE,CLR_WHITE,50,10)
oTGetTT := TGet():New(008,200,{||nTaraT},oPanelRodap,058,012,cPictPeso,,0,CLR_WHITE,oFont16,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"nTaraT",,,, )
oTGetTT:SetContentAlign(1)

oSayLT:= TSay():New(001,260,{||'Peso Liq. Total'},oPanelRodap,,oFont1,,,,.T.,CLR_WHITE,CLR_WHITE,60,10)
oGetLT := TGet():New(008,260,{||nPesoLT},oPanelRodap,058,012,cPictPeso,,0,,oFont16,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"nPesoLT",,,, )
oGetLT:SetContentAlign(1)

oSayQT:= TSay():New(001,320,{||'Qtd Total'},oPanelRodap,,oFont1,,,,.T.,CLR_WHITE,CLR_WHITE,60,10)
oGetQT := TGet():New(008,320,{||nQtdT},oPanelRodap,062,014,cPictPeso,,0,,oFont18B,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"nQtdT",,,, )
oGetQT:SetContentAlign(1)


oSayOperador:= TSay():New(008,002,{||cOperador + "-"+CB1->CB1_NOME},oPanelRodap,,oFont2,,,,.T.,CLR_WHITE,CLR_WHITE,80,10)

ACTIVATE MSDIALOG oDlgTela CENTERED ON INIT (A030Inicio(oBrowSZ3, nTipo, @cBalanca, @oTGetDoc,@oTGetProduto, @cDoc, @cProduto, lLeitura, @oTGetOper, @oTGetLocal, @cIdUnitz, @oTGetEtiq,@cLocal,@nSaldo,@cOperacao,@cRecurso,@cUM,@cDesc,@cEndEnt, cQryCpo,oTGetLocOri,oTGetEndEnt,oTGetEndDes)) 

//Finaliza a conexão com a balança
u_ALU10Balanca(3, cBalanca, @lLeitura)

Return



/*/{Protheus.doc} A04030Pesar
Pesar
@type function
@version 
@author Samsung
@since 01/10/2020
@return return_type, return_description
/*/
Static Function Pesar(oBrowSZ3,xobsoleto,oButPesar, nPeso, nTara,nPesoLiq, cDoc, cProduto, cLocal, cLote, nTipo, nQtd, cOperacao, cRecurso, cOperador, cEndEnt, cResp, cQryCpo, lReprocesso, lManual, cLocOri,cEndDes )
Local cPesagem  := ""
Local lContinua := .T. 
Local cSeqPesagem := ""
Local oSay
Local cAlias   := oBrowSZ3:GetAlias()

If lReprocesso
    
    If !Empty((cAlias)->RECNO)

        SZ3->(DbGoTo((cAlias)->RECNO))

        If Empty(SZ3->Z3_IDMOV)
            If !Aviso("Atençao!!!","Reprocessar a pesagem "+ SZ3->Z3_SEQPESA + "? ",{"SIM","NÃO"}) == 1
                lContinua := .F.
            EndIf  
        Else
            MsgStop("A pesagem "+SZ3->Z3_SEQPESA+" já foi processada","Atençao!!!")
            lContinua := .F.
        EndIf
    Else
        MsgStop("Sem registro para reprocessar","Atençao!!!")
        lContinua := .F.
    EndIf
EndIf

if !lReprocesso .AND. !lManual .AND. (nTara <= 0 .OR. nPeso <= 0 )
    Aviso(OemToAnsi("Atençao!!!"),OemToAnsi("Sem PESO ou TARA para registrar. Verifique a balança"),{"Ok"})
    lContinua := .F.
EndIf

nPesoLiq := nPeso - nTara

if !lReprocesso .AND. !lManual .AND. nQtd <= 0
    Aviso(OemToAnsi("Atençao!!!"),OemToAnsi("Sem quantidadde para registrar. Verifique a balança"),{"Ok"})
    lContinua := .F.
EndIf


//Ver se a etiqueta ja teve o movimento finalizado - se nao nao deixar dividr
If !Empty(SZ3->Z3_IDMOV) .AND. nTipo == 2
    DbSelectArea("D12")
    DbSetorder(4) //D12_FILIAL+D12_IDDCF+D12_IDMOV+D12_IDOPER+D12_STATUS+D12_SERVIC+D12_TAREFA                                                                                      
    If D12->(DbSeek(xFilial("D12")+SZ3->Z3_IDDCF+SZ3->Z3_IDMOV))
        If D12->D12_STATUS <> "1"
            MsgStop("Endereçamento da etiqueta pendente de execução/beep","Erro!!!")
            lContinua := .F.   
        EndIf
    EndIf
EndIf

If lContinua
 
    If !lReprocesso
    
        cSeqPesagem := PegaSeq(oBrowSZ3) 

        RecLock("SZ3",.T.)
        SZ3->Z3_FILIAL  := xFilial("SZ3")
        SZ3->Z3_DOC     := cDoc
        SZ3->Z3_PESAGEM := cPesagem 
        SZ3->Z3_COD     := cProduto
        SZ3->Z3_LOCAL   := cLocal
        SZ3->Z3_LOTECTL := cLote
        SZ3->Z3_SEQPESA := cSeqPesagem 
        SZ3->Z3_PESO    := nPeso
        SZ3->Z3_PESORI  := nPesoLiq
        SZ3->Z3_QUANT   := nQtd
        SZ3->Z3_QTDORI  := nQtd
        SZ3->Z3_PESOL   := nPesoLiq
        SZ3->Z3_TARA    := nTara
        //SZ3->Z3_CODETI  := cLote //Vai ser registrado o unitizador apos montagem
        SZ3->Z3_TIPO    := AllTrim(Str(nTipo))  
        SZ3->Z3_RESP    := cResp //*Criar campo
        SZ3->Z3_CODOPE  := cOperador
        SZ3->Z3_DATA    := dDataBase
        SZ3->Z3_HORA    := Time()
        SZ3->Z3_ENDENT  := cEndEnt
        SZ3->Z3_LOCORI := cLocOri
        SZ3->Z3_ENDDES  := cEndDes

        If nTipo == 2
            SZ3->Z3_IDUZORI := (cAlias)->Z3_IDUNITZ
            SZ3->Z3_ENDENT  := (cAlias)->Z3_ENDDES //Se for divisao de etiqueta o endereco incial é o endereço atual do unitizador
            SZ3->Z3_ENDDES  := (cAlias)->Z3_ENDDES //Tentar manter o mesmo endereço
            SZ3->Z3_TIPUNIT := (cAlias)->Z3_TIPUNIT
        EndIf



        SZ3->(MsUnlock())
    
    EndIf
    
    If nTipo == 1  //Report de Produçao
        
        FwMsgRun(NIL, {|oSay| lContinua := ApontarProd(cDoc,cProduto, nQtd, cOperacao, cLocal, cRecurso, cOperador,oSay) }, "Processando", "Apontando produção...")
        
        If lContinua 
            //Verificar se é um local/estrutura unitizado
            FwMsgRun(NIL, {|oSay| MontagEtiq(oSay) }, "Processando", "Montando etiqueta ...")
        EndIf
    
    ElseIf nTipo == 2 //Pesagem Individual - divisao de etiqueta
        If !lReprocesso
            //Criar uma nova etiqueta de untiizador e transferir o saldo pesado 
            FwMsgRun(NIL, {|oSay| MontagEtiq(oSay,cAlias) }, "Processando", "Montando etiqueta ...")
        Else
            MsgStop("Opção indisponivel para pesagem individual")
        EndIf

    ElseIf nTipo == 3 //Pesagem sem Ordem de Producao
        //A transferencia quando o armazem for unitizado gera demanda e tem que montar 
        If AluTransWMS(1) //a transf mesmo para armz unitizado é sempre por produto
            FwMsgRun(NIL, {|oSay| MontagEtiq(oSay) }, "Processando", "Montando etiqueta...")
        EndIf

    EndIf
 
    //nUltimoPeso :=  nPesoLiq
   
    //(cAlias)->(DbGoBottom())
 

 
    //Atualiza o Browse
    AtuBrowse(oBrowSZ3, cDoc, cQryCpo, cProduto, SZ3->Z3_CODETI, nTipo)

    AtuTotais(oBrowSZ3,nTipo)

EndIf


Return

/*/{Protheus.doc} AluTransWMS
description
@type function
@version  
@author Deosdete Deo
@since 9/1/2023
@param aitens, array, param_description
@param cArmDest, character, param_description
@return variant, return_description
/*/
Static Function AluTransWMS(nOpc)

Local nModAux   := nModulo
Local lRet      := .T.
Local cSrvTra   := SuperGetMv('MX_XSRVTRA',.F.,'014')
//Local aParam150 := {}
Local oTransf 

nModulo  := 42
oTransf  := WMSBCCTransferencia():New()
oTransf:oOrdServ := WMSDTCOrdemServicoCreate():New()
    
WmsOrdSer(oTransf:oOrdServ) // Atualiza referencia do objeto WMS

oTransf:oOrdServ:oServico:SetServico(cSrvTra)
// Atribui produto/Lote/Sublote
oTransf:oOrdServ:oProdLote:SetArmazem(SZ3->Z3_LOCORI)
oTransf:oOrdServ:oProdLote:SetPrdOri(SZ3->Z3_COD)
oTransf:oOrdServ:oProdLote:SetProduto(SZ3->Z3_COD)
oTransf:oOrdServ:oProdLote:SetLoteCtl(SZ3->Z3_LOTECTL) 
oTransf:oOrdServ:oProdLote:SetNumLote('')
// Atribui endereco origem
oTransf:oOrdServ:oOrdEndOri:SetArmazem(SZ3->Z3_LOCORI)
oTransf:oOrdServ:oOrdEndOri:SetEnder(SZ3->Z3_ENDENT)
// Atribui endereco destino
oTransf:oOrdServ:oOrdEndDes:SetArmazem(SZ3->Z3_LOCAL)
oTransf:oOrdServ:oOrdEndDes:SetEnder(SZ3->Z3_ENDDES)

If nOpc == 2 //Armazem unitizado
    oTransf:oOrdServ:SetUniDes("")
    oTransf:oOrdServ:SetTipUni("")
EndIf

oTransf:oOrdServ:SetQuant(SZ3->Z3_QUANT)
oTransf:oOrdServ:SetOrigem('DCF')

If !oTransf:ChkEndOri()
    //oModel:GetModel():SetErrorMessage( , , oModel:GetId() , "", "", oMovimento:GetErro(), "", "", "")
    MsgStop("Endereço origem invalido " + oTransf:GetErro() ,"Erro!!!")
    lRet := .F.
EndIf
If lRet .And. !Empty(oTransf:oOrdServ:oOrdEndDes:GetEnder())
    If !oTransf:ChkEndDes()

        MsgStop("Endereço de destino " + SZ3->Z3_ENDDES + " invalido. " + oTransf:GetErro() + ". Endereçando para BALANCA ", "Atencao!!!")

        oTransf:oMovEndDes:SetEnder("BALANCA")        

        If oTransf:ChkEndDes()
            oTransf:oOrdServ:oOrdEndDes:SetEnder("BALANCA")     
        Else
            MsgStop("Endereco BALANCA invalido, verifique e reprocesse a pesagem" + oTransf:GetErro()  ,"Erro!")  
            Disarmtransaction()
            lRet := .F.    
        EndIf       
    EndIf      
EndIf


BeginTran()
If !oTransf:oOrdServ:CreateDCF()
    oTransf:oOrdServ:GetErro()
    DisarmTransaction()
    lRet := .F.
Else
    If !WmsExeServ(.F.,.T.,.F.)
        //DisarmTransaction()   
        lRet := .F.
    EndIf
EndIf
/*
        //--Posiciona na DCF para executar as atividades
        DCF->(DbGoTo(oTransf:oOrdServ:GetRecno()))
        //--Executa os serviços
        If U_PIFINTAR(DCF->DCF_DOCTO, aitens[nitens][2], cSrvTra)

            aParam150  := Array(32)

            aParam150[01] := aitens[nitens][2]              //-- Produto
            aParam150[02] := aitens[nitens][3]              //-- Armazem Origem
            aParam150[03] := aitens[nitens][6]              //-- Lote origem
            //aParam150[04] := CriaVar('DCF_SERIE', .F.)      //-- Serie
            //aParam150[05] := ProxNum()
            aParam150[06] := aitens[nitens][7]              //-- Quantidade 
            aParam150[07] := dDataBase                      //-- Data da Movimentacao
            aParam150[09] := '014'                          //-- Serviço
            aParam150[12] := CriaVar("DCF_CLIFOR", .F.)     //-- Cliente/Fornecedor
            aParam150[13] := CriaVar("DCF_LOJA", .F.)       //-- Loja
            aParam150[17] := "DCF"                          //-- Origem de Movimentacao
            aParam150[22] := CriaVar("DCF_REGRA", .F.)      //-- Regra de Apanhe (1=Lote/2=N.Serie/3=Data)
            aParam150[23] := CriaVar("DCF_CARGA", .F.)      //-- Carga
            aParam150[25] := aitens[nitens][3]              //-- Armazem Destino
            aParam150[26] := aitens[nitens][9]              //-- Endereco Destino
            aParam150[29] := "ZZ"                           //-- Ordem da Atividade
            aParam150[30] := aitens[nitens][4]              //-- Lote
            
            //--Cria movimento de transferencia de endereçamento
            If !FCriaEnd(aParam150)
                DisarmTransaction()
            EndIf
        Else
            DisarmTransaction()
        EndIf
    Else
        //--Desfaz apos erro de execuçao de serviço
        DisarmTransaction()
    EndIf    
EndIf
*/
EndTran()

//Destroi objetos
oTransf:Destroy()

nModulo := nModAux

Return lRet



/*/{Protheus.doc} AtualizarPeso
Atualiza balança
@type function
@version 
@author Samsung
@since 06/10/2020
@param nPeso, numeric, param_description
@param nTara, numeric, param_description
@param nPesoLiq, numeric, param_description
@param cUn, character, param_description
@return return_type, return_description
/*/
Static Function AtualizarPeso(nPeso, nTara, nPesoLiq, cUn,oPanelBal, nTipo, nQtd, lLeitura)
Local aRet := {}

aRet := u_ALU10Balanca(2, Nil, @lLeitura)

If lPort //aRet[3] //Leitura ok
    
    oPanelBal:SetColor(CLR_GREEN,CLR_GREEN)

    //Mudar o peso somente se houver retorno
    If aRet[1] > 0
        
        nPeso := aRet[1]
        nTara := aRet[2]
        nQtd :=  aRet[3]
        nPesoLiq := nPeso - nTara

    EndIf

Else
    oPanelBal:SetColor(CLR_RED,CLR_RED)
EndIf

Return





/*/{Protheus.doc} PegaSeq
Sequencia
@type function
@version 
@author Samsung
@since 01/10/2020
@param oBrowSZ3, object, param_description
@return return_type, return_description
/*/
Static Function PegaSeq(oBrowSZ3)
Local cSeq     := ""
Local nTamSeq  := TamSX3("Z3_SEQPESA")[1]
Local cChave := (oBrowSZ3:Alias())->(Z3_FILIAL+Z3_DOC+Z3_COD+Z3_PESAGEM)

cSeq  := StrZero(oBrowSZ3:LogicLen(),nTamSeq)

DbSelectArea("SZ3")
DbSetorder(1) //Z3_FILIAL+Z3_DOC+Z3_COD+Z3_LOCAL+Z3_LOTECTL+Z3_PESAGEM
While .T.
    cSeq := Soma1(cSeq)

    If !SZ3->(DbSeek(cChave+cSeq))
        Exit
    Endif

EndDo   


Return cSeq


//Para deletar 

//SetDelete(lDelete,bDelete)
//FWBrowse(): DelLine ( ) 




/*/{Protheus.doc} AtuTotais
description
@type function
@version 
@author Samsung
@since 09/10/2020
@param oBrowSZ3, object, param_description
@return return_type, return_description
/*/
Static Function AtuTotais(oBrowSZ3, nTipo)
Local cAlias := oBrowSZ3:Alias()
//Local aArea  := getArea()
nPesoT    := 0
nTaraT    := 0
nPesoLT   := 0
nFaltante := 0
nQtdT     := 0

(cAlias)->(DbGoTop())
While !(cAlias)->(Eof())
    nPesoT    += (cAlias)->Z3_PESO
    nTaraT    += (cAlias)->Z3_TARA
    nQtdT     += (cAlias)->Z3_QUANT
    nPesoLT   += (cAlias)->Z3_PESOL
    (cAlias)->(DbSkip())
EndDo

oGetPT:Refresh() 
oTGetTT:Refresh() 
oGetLT:Refresh() 
oGetQT:Refresh() 

Return





/*/{Protheus.doc} A030Inicio
description
@type function
@version  
@author Deosdete Deo
@since 20/06/2023
@param oBrowSZ3, object, param_description
@param nTipo, numeric, param_description
@param cBalanca, character, param_description
@param oTGetDoc, object, param_description
@param oTGetProduto, object, param_description
@param cDoc, character, param_description
@param cProduto, character, param_description
@return variant, return_description
/*/
Static Function A030Inicio(oBrowSZ3, nTipo, cBalanca, oTGetDoc,oTGetProduto, cDoc, cProduto, lLeitura, oTGetOper, oTGetLocal, cIdUnitz, oTGetEtiq,cLocal,nSaldo,cOperacao,cRecurso,cUM,cDesc,cEndEnt, cQryCpo,oTGetLocOri,oTGetEndEnt,oTGetEndDes)
Local lRet := .T.

If nTipo == 1
    //Variaveis da interface
    //Pegar dados da OP    
    If FunName() == "MATA650" // Pegar a op posicionada
        cDoc         := PadR(SC2->(SC2->C2_NUM+C2_ITEM+C2_SEQUEN),TamSX3("H6_OP")[1], " ")
        cProduto    := SC2->C2_PRODUTO
        cLocal      := SC2->C2_LOCAL
        nSaldo  := SC2->C2_QUANT - SC2->C2_QUJE
        
        //Verificar proxima operaçao
        cOperacao := ""

        DbSelectArea("SG2")
        DbSetOrder(1) //G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC                                                                                                                                                                                                                                                        
        If SG2->(DbSeek(xFilial("SG2")+SC2->C2_PRODUTO+SC2->C2_ROTEIRO+cOperacao))

            //Posicionar no recurso / impressora
            DbSelectArea("SH1")                                                                                                                                           
            DbSetOrder(1) //H1_FILIAL+H1_CODIGO  
            If !SH1->(DbSeek(xFilial("SH1")+SG2->G2_RECURSO))
                MsgAlert("Recurso cadastrado na operaçao nao encontrado","Erro!!!")
            EndIf

            cRecurso    := SG2->G2_RECURSO
            If Empty(cOperacao) //Pega a primeira operacao
                cOperacao := SG2->G2_OPERAC 
            EndIF
        EndIf    

        DbSelectArea("SB1")
        DbSetorder(1)//B1_FILIAL+B1_COD
        If SB1->(DbSeek(xFilial("SB1")+cProduto))
            cDesc       := SB1->B1_DESC
            cUM         := SB1->B1_UM


            //Ver Complemento/Pegar o endereço inicial 
            DbSelectArea("SB5")
            DbSetOrder(1) //B5_FILIAL+B5_COD                                                                                                                                                
            If SB5->(DbSeek(xFilial("SB5")+cProduto))
                cEndEnt := SB5->B5_ENDENT  //Para todas as hipoteses em que existir unitizaçao o saldo vai pro endereço de entrada do produto
            Else    
                MsgInfo("Erro no cadastro de Complemento do Produto","Atençao!")
                lRet := .F.
            EndIf


            //Pegar o endereço incicial do produto para unitizar
            If SB1->B1_TIPO $ "PA/PI"
                DbSelectArea("D1A")
                DbSetOrder(1) // D1A_FILIAL+D1A_COD                                                                                                                                              
                If D1A->(DbSeek(xFilial("D1A")+cProduto))
                    cEndEnt := D1A->D1A_ENDEPR //"DOCA003" 
                Else
                     MsgInfo("Erro no cadastro de Complemento do Produto WMS","Atençao!")
                     lRet := .F.
                EndIf
            Endif
 
        Else    
            MsgStop("Poduto "+ cProduto + " nao localizado.",ProcName() + "- Erro")
        Endif    


    Else //Limpar os campos e deixar o usuario escolher a Ordem de Producao
       cDoc       := Space(TamSX3("Z3_DOC")[1])
       cProduto   := Space(TamSX3("Z3_COD")[1])
       cIdUnitz   := Space(TamSX3("Z3_IDUNITZ")[1])
       cLocal     := Space(TamSX3("Z3_LOCAL")[1])
       nSaldo     := 0
       cOperacao  := Space(TamSX3("G2_OPERAC")[1])
       cRecurso   := Space(TamSX3("G2_RECURSO")[1])
       cUM        := Space(TamSX3("B1_UM")[1]) 
       cDesc      := Space(TamSX3("B1_DESC")[1]) 
   
    EndIf

    oTGetDoc:lReadOnly := .F.
    oTGetOper:lReadOnly := .F.
    oTGetProduto:lReadOnly := .T. 
    oTGetLocal:lReadOnly  := .T.
    oTGetEtiq:lReadOnly  := .T.
    oTGetLocOri:lReadOnly := .T.
    oTGetEndEnt:lReadOnly := .T.
    oTGetEndDes:lReadOnly := .T.

ElseIf nTipo == 2
    oTGetDoc:lReadOnly := .T.
    oTGetOper:lReadOnly := .T.
    oTGetProduto:lReadOnly := .T. 
    oTGetLocal:lReadOnly  := .T.
    oTGetEtiq:lReadOnly  := .F.
    oTGetLocOri:lReadOnly := .T.
    oTGetEndEnt:lReadOnly := .T.
    oTGetEndDes:lReadOnly := .T.
    //cIdUnitz    := PadR(" ",TamSX3("Z3_IDUNITZ")[1], " ")
    cDoc       := Space(TamSX3("Z3_DOC")[1])
    cProduto   := Space(TamSX3("Z3_COD")[1])
    cIdUnitz   := Space(TamSX3("Z3_IDUNITZ")[1])
    cLocal     := Space(TamSX3("Z3_LOCAL")[1])
    nSaldo     := 0
    cOperacao  := Space(TamSX3("G2_OPERAC")[1])
    cRecurso   := Space(TamSX3("G2_RECURSO")[1])
    cUM        := Space(TamSX3("B1_UM")[1]) 
    cDesc      := Space(TamSX3("B1_DESC")[1]) 

ElseIf nTipo == 3
    oTGetDoc:lReadOnly := .T.
    oTGetOper:lReadOnly := .T.
    oTGetProduto:lReadOnly := .F. 
    oTGetLocal:lReadOnly  := .F.
    oTGetEtiq:lReadOnly  := .T.
    oTGetLocOri:lReadOnly := .F.
    oTGetEndEnt:lReadOnly := .F.
    oTGetEndDes:lReadOnly := .F.

    cDoc       := Space(TamSX3("Z3_DOC")[1])
    cProduto   := Space(TamSX3("Z3_COD")[1])
    cIdUnitz   := Space(TamSX3("Z3_IDUNITZ")[1])
    cLocal     := Space(TamSX3("Z3_LOCAL")[1])
    nSaldo     := 0
    cOperacao  := Space(TamSX3("G2_OPERAC")[1])
    cRecurso   := Space(TamSX3("G2_RECURSO")[1])
    cUM        := Space(TamSX3("B1_UM")[1]) 
    cDesc      := Space(TamSX3("B1_DESC")[1]) 

EndIf

u_ALU10Balanca(1, CB1->CB1_XBALAN, @lLeitura) 


AtuBrowse(oBrowSZ3, cDoc, cQryCpo, cProduto, cIdUnitz, nTipo)

//Atualiza os totais do rodape conforme pesagens ja gravadas
AtuTotais(oBrowSZ3, nTipo)

If nTipo == 1
    oTGetDoc:SetFocus()
ElseIf nTipo == 2
    oTGetEtiq:SetFocus()
ElseIf nTipo == 3
    oTGetProduto:SetFocus()
EndIf

//RestArea(aArea)

Return lRet 


/*/{Protheus.doc} VldTara
description
@type function
@version  
@author Deosdete Deo
@since 28/07/2023
@param nPesoLiq, numeric, param_description
@param nPeso, numeric, param_description
@param nTara, numeric, param_description
@param oGetLiq, object, param_description
@return variant, return_description
/*/
Static Function VldTara(nPesoLiq,nPeso,nTara,oGetLiq)
Local lRet := .T.

//If nTara > 0
    nPesoLiq := nPeso - nTara
    oGetLiq:Refresh()
//EndIf

Return lRet 


Static Function VldPeso(nPesoLiq,nPeso,nTara)
Local lRet := .T.
/*
If nPeso > 0
    nPesoLiq := nPeso - nTara
    oGetLiq:Refresh()

Else
    lRet := .F.    
EndIf
*/
Return lRet 


/*/{Protheus.doc} GravaApontamento
Gravação do apontamento antes da confirmaçao
@type function
@version 
@author Deosdete Deo
@since 26/10/2020
@return return_type, return_description
/*//*
User Function GravaApontamentos(cDoc, cProduto, cLocal, cLote, cMotParada, cTempo)

Default cMotParada := ""
//Espelho da SH6
//Carga inicial do apontamento o tempo de producaçao sera a soma do tempo desse registro


//If Empty(SD4->D4_LOTECTL)
//    SD4-> D4_LOTECTL := cLote
//    SD4->D4_LOCAL := cLocal
//EndIf

DbSelectArea("SZ2")
DbSetOrder(1) //Z2_FILIAL+Z2_OP+Z2_PRODUTO+Z2_OPERAC+Z2_SEQ+DTOS(Z2_DATAINI)+Z2_HORAINI+DTOS(Z2_DATAFIN)+Z2_HORAFIN                                                             

RecLock("SZ2", .T.)

SZ2->Z2_FILIAL    :=       xFilial("SZ2")
//SZ2->Z2_OP        := 	   M->H6_OP      
//SZ2->Z2_PRODUTO   := 	   M->H6_PRODUTO 
//SZ2->Z2_OPERAC    := 	   M->H6_OPERAC  
//SZ2->Z2_RECURSO   := 	   M->H6_RECURSO 
SZ2->Z2_DATAINI   := 	   M->H6_DATAINI 
SZ2->Z2_HORAINI   := 	   M->H6_HORAINI 
SZ2->Z2_DATAFIN   :=       dDataBase
SZ2->Z2_HORAFIN   :=       Time()
SZ2->Z2_OPERADO   := 	   M->H6_OPERADO 
//SZ2->Z2_DTAPONT   := 	   M->H6_DTAPONT 
//SZ2->Z2_CBFLAG    := 	   M->H6_CBFLAG  
//SZ2->Z2_LOCAL     := 	   M->H6_LOCAL   
//SZ2->Z2_LOTECTL   :=	   M->H6_LOTECTL 
//SZ2->Z2_DTVALID   :=	   M->H6_DTVALID 
//SZ2->Z2_QTDPROD   :=       M->Z2_QTDPROD

SZ2->Z2_TEMPO     := 	"0" + SubStr(cTempo,1,5)

cHoraIni          := Time()   //Zerando para a proxima pesagem   

If !Empty(cMotParada) //Grava motivo
    SZ2->Z2_MOTPARA := cMotParada    
Endif


SZ2->(MsUnlock())

Return
*/

/*/{Protheus.doc} GravaRecebimento
Gravação do recebimento antes da confirmaçao
@type function
@version 
@author Deosdete Deo
@since 26/10/2020
@return return_type, return_description
/*/
Static Function GravaRecebimento(cDoc, cProduto, cLocal, cLote)

//Gravar a somatoria das pesagens no campo D1_QTDCONF
RecLock("SD1",.F.)
SD1->D1_QTDCONF := nPesoLT
SD1->D1_LOTECTL := cLote
SD1->(MsUnlock())

Return



/*/{Protheus.doc} MudaBal
description
@type function
@version 
@author 55119
@since 05/11/2020
@param cBalanca, character, param_description
@return return_type, return_description
/*/
/*Static Function VldBal(cBalanca)
Local lRet      := .T.

If Aviso(ProcName()+" - Atençao!!!","Esta ação requer reconexão com a balança. Mudar balança?",{"Sim","Não"})
    If !u_ALU10Balanca(1, cBalanca,.T.)[4]
        MsgStop("Balança " + cBalanca + "não encontrada. Verifique cadastro Local de Impressora/Dispositivo",ProcName()+" - Erro!!!")
        lRet := .F.
    EndIf
EndIf

Return lRet 
*/


Static Function PegaBal()
Local aBal := {}

DbSelectArea("CB5")
DBSetOrder(1) //CB5_FILIAL+CB5_CODIGO        
CB5->(DbGoTop())                                                                                                                            
While !CB5->(Eof())
    If AllTrim(CB5->CB5_MODELO) == "BALANCA"
        aAdd(aBal,CB5->CB5_CODIGO + "-" + CB5->CB5_DESCRI)    
    EndIf
    CB5->(DbSkip())
EndDo

If Len(aBal) == 0
    MsgStop("Nenhuma balança cadastra. Verifique o cadastro Local de Impressora/Dispositivo",ProcName()+" - Erro!!!")
EndIf

Return aBal


/*/{Protheus.doc} ARO650OP
Validacao da OP
@type function
@version 
@author Deosdete Deo
@since 17/10/2020
@param cOP, character, param_description
@return return_type, return_description
/*/
Static Function ARO650OP()
Local lRet    := .T. 

/*
If Empty(cOP)
	MsgStop("OP não informada", "Atençao!!!")
	lRet := .F.
EndIf
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se OP e do tipo Firme                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	SC2->C2_TPOP <> "F"
	MsgStop("Nao é permitida movimentacão com OPs Previstas","Atenção!!!") //"Nao e permitida movimentacao com OPs Previstas"###"Atenção"	
	lRet := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se OP ja foi encerrada                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SC2->C2_DATRF)
	MsgStop("OP ja Encerrada","Atençao!!!") //"OP ja Encerrada"###"Aviso"
	lRet := .F.
EndIf

Return lRet

/*/{Protheus.doc} ARO650Pesagem
Pesagem
@type function
@version 
@author Deosdete Deo
@since 23/10/2020
@return return_type, return_description
/*/
Static Function Pesagem(oBrw1)
Local lFinaliza := .F.
Local nTipo      := 1
Local cLote      := ""
Local nNecess    := 0

//Verificar se a operacao é de pesagem
If SG2->G2_XPESAGE <> "1"
	While !lFinaliza
		
		cLote := u_A04Localizalote(nTipo) 
		
		//SB8 posicionada
		If !Empty(cLote)
			If VldCod(cLote, @nNecess)
				u_A04030Pesagem(cLote,nTipo, ,nNecess)
			EndIf
		EndIf 

		lFinaliza := Empty(cLote)  
	Enddo
else
	MsgInfo("Esta operação não exige pesagem. Para finaizar a produção, basta confirmar","Atençao!!!")
EndIf


Return


Static Function VldCod(cLote, nNecess)
Local lRet    := .T.
Local nRecSD4 := 0 


//Localizar a SD4 - Necessidade
DbSelectArea("SD4")
DbSetOrder(1)//D4_FILIAL+D4_COD+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE       
If SD4->(DbSeek(xFilial("SD4")+SB8->B8_PRODUTO+M->H6_OP))                                                                                                      
	If SD4->D4_XSITUA <> "2"
		//Marcar Status
		If !SD4->(RLock())
			MsgStop("Operador executando pesagem em outro terminal","Atençao") //'Operador executando inventario em outro terminal'###'Atencao'
			lRet := .F.
		EndIf
		SD4->(DBUnLock())
	Else
		MsgStop("Empenho com pesagem já finalizada",ProcName()+" - Atençao")
		lRet := .F.
	EndIf	

	If lRet
		//Guardar o registro principal e varrer todos os SD4 deste produto
		nRecSD4 := SD4->(RecNo())
		While !SD4->(Eof()) .AND. SD4->(D4_FILIAL+D4_COD+D4_OP) == xFilial("SD4")+SB8->B8_PRODUTO+M->H6_OP
			nNecess += SD4->D4_QTDEORI
			SD4->(DbSkip())
		EndDo

	EndIf


Else
	
	MsgStop("Produto não empenhado nesta OP", ProcName() + "Atenção!!!")
	lRet := .F.
EndIf

If lRet 
	SD4->(DbGoTo(nRecSD4))
	
	RecLock("SD4",.F.)

    SD4->D4_XSITUA := "1"    //" " - AGUARDANDO PESAGEM  "1" - PESAGEM EM ANDAMENTO "2" - PESAGEM FINALIZADA

    SD4->(MsUnLock())

	//Deixar SD4 LOckada para nenhum outro mexer.
	RecLock("SD4",.F.)
	
EndIf

Return lRet



Static Function StatusEmp(cStatus, cProduto)
Local cRetorno := ""
	If Rastro(cProduto) .AND. Empty(cStatus) //Empenho em aberto
		cRetorno := "BR_VERDE"
	ElseIf Rastro(cProduto) .AND. cStatus == "1" //Pesagem em andamento BR_AMARELO
		cRetorno := "BR_AMARELO"
	ElseIf (Rastro(cProduto) .AND. cStatus == "2") .OR. !Rastro(cProduto) //Pesagem finalizada
		cRetorno := "BR_VERMELHO"
	EndIf
Return cRetorno


Static Function StatusLegend(nTipo)

Local oLegend  :=  FWLegend():New()

    oLegend:Add("","BR_VERDE"   , "Pesagem não iniciada" ) 
    oLegend:Add("","BR_AMARELO" , "Pesagem em andamento" )
    oLegend:Add("","BR_VERMELHO"    , "Pesagem finalizada") 
	
	oLegend:Activate()
	oLegend:View()
	oLegend:DeActivate()

Return




Static Function MotParada()
Local cRet    := ""
Local nOpc    := 0
Local oGetMot 
Local cMot    := Space(10) 
Local cMotDes := Space(50)
Local cTitulo := "Parada de Produção"
Local oSayMot
Local oTGetMot
Local oTGetDesc
Local oBCancelar
Local oBOk
//Local oFont08 := TFont():New('Arial',,08,.F.)
Local oFont10 := TFont():New('Arial',,10,.F.)
Local oFont12 := TFont():New('Arial',,12,.F.)

//Define a janela do Browse
oDlg = TDialog():New(130, 270, 270, 550,cTitulo,,,,,,,,,.T.)
//Define MsDialog oGetMot Title cTitulo From 130,270 To 270,550 Pixel

//TGet():New( [ nRow ], [ nCol ], [ bSetGet ], [ oWnd ], [ nWidth ], [ nHeight ], [ cPict ], [ bValid ], [ nClrFore ], [ nClrBack ], [ oFont ], [ uParam12 ], [ uParam13 ], [ lPixel ], [ uParam15 ], [ uParam16 ], [ bWhen ], [ uParam18 ], [ uParam19 ], [ bChange ], [ lReadOnly ], [ lPassword ], [ uParam23 ], [ cReadVar ], [ uParam25 ], [ uParam26 ], [ uParam27 ], [ lHasButton ], [ lNoButton ], [ uParam30 ], [ cLabelText ], [ nLabelPos ], [ oLabelFont ], [ nLabelColor ], [ cPlaceHold ], [ lPicturePriority ], [ lFocSel ] )

oSayMot   := TSay():New(005,002,{||'Motivo'},oGetMot,,oFont10,,,,.T.,CLR_BLACK,CLR_WHITE,50,12)
oTGetMot  := TGet():New( 015,002,{|u| If(PCount() > 0,cMot := u,cMot)},oGetMot,030,012,"@!",,0,,oFont12,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"cMot",,,, )
oTGetDesc := TGet():New( 015,040,{|u| If(PCount() > 0,cMotDes := u,cMotDes)},oGetMot,080,012,"@!",,0,,oFont12,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"cMotDes",,,, )
oTGetMot:bF3 := &('{|| IIf(ConPad1(,,,"CYN004",,,.F.),Eval({|| cMot := CYN->CYN_CDSP, cMotDes := CYN->CYN_DSSP, oTGetMot:Refresh(), oTGetDesc:Refresh()}),.T.)}')

oBOk       := TButton():New( 045, 035, "Ok",oGetMot,{||nOpc := 1,oDlg:End()}, 030,012,,oFont12,.F.,.T.,.F.,,.F.,,,.F. )
oBCancelar := TButton():New( 045, 080, "Cancelar",oGetMot,{|| nOpc := 2, oDlg:End()}, 030,012,,oFont12,.F.,.T.,.F.,,.F.,,,.F. )
 
/*
@ 005,005 Say "Morivo da parada"
@ 015,005 MsGet oMot Var cMot F3 "CYN004" Size 050,010 Pixel Of oGetMot VALID () 
@ 005,005 Say "Descrição"
@ 015,005 MsGet oMot Var cMot F3 "CYN004" Size 050,010 Pixel Of oGetMot VALID () 

@ 045,035 Button "Ok"	 		Size 030,010 Pixel Action (nOpc:=1,oGetMot:End() )
@ 045,080 Button "Cancelar" 	Size 030,010 Pixel Action (nOpc:=2,oGetMot:End() )
*/	
///Activate MsDialog oGetMot Centered   
// Ativação da janela
oDlg:Activate(,,,.T.)

If nOpc == 1
	cRet := cMot
Else	
	cRet := ""
EndIf

Return cRet




/*/{Protheus.doc} AtuBrowse
description
@type functionPegQuery
@version  
@author Deosdete Deo
@since 10/06/2023
@param oBrowSZ3, object, param_description
@param cPesagem, character, param_description
@return variant, return_description
/*/
Static Function AtuBrowse(oBrowSZ3, cDoc, cQryCpo, cProduto, cEtiqueta, nTipo)
Local cSZ3Qry := PegQuery(cDoc, cQryCpo, cProduto, cEtiqueta, nTipo)

oBrowSZ3:SetQuery(cSZ3Qry)

oBrowSZ3:Refresh()
oBrowSZ3:oBrowse:Refresh()
//(oBrowSZ3:GetAlias())->(dbGoBottom())

oBrowSZ3:GoBottom()

Return

/*/{Protheus.doc} PegColunas
description
@type function
@version  
@author Deosdete Deo
@since 11/07/2023
@return variant, return_description
/*/
Static Function PegColunas(cQryCpo)
Local nI        := 0
Local aStruSZ3  := {}
Local oStruSZ3  := FWFormStruct(1,"SZ3")
Local aRet      := {}
Local aColumns  := {}

DbSelectArea("SZ3")
DbSetorder(1)
aStruSZ3 := oStruSZ3:GetFields()

//Campos para a quey e para o Browse
For nI := 1 To Len(aStruSZ3)

    If !Empty(cQryCpo)
        cQryCpo += ","  
    EndIf
    cQryCpo += aStruSZ3[nI][03]

    If !AllTrim(aStruSZ3[nI][03]) $ "Z3_FILIAL+Z3_DOC+Z3_COD+Z3_LOCAL+Z3_LOTECTL+Z3_PESAGEM"
        aRet := TamSX3(aStruSZ3[nI][03])
                
        AAdd(aColumns,FWBrwColumn():New())
        
        If aRet[3] == "N"
            aColumns[Len(aColumns)]:SetData( &("{||"+aStruSZ3[nI][03]+"}") )
            aColumns[Len(aColumns)]:SetAlign(2)
            aColumns[Len(aColumns)]:SetType("N")								
        ElseIf aRet[3] == "D"
            aColumns[Len(aColumns)]:SetData( &("{||SToD("+aStruSZ3[nI][03]+")}") )
            aColumns[Len(aColumns)]:SetType("D")	
        Else
            aColumns[Len(aColumns)]:SetData( &("{||"+aStruSZ3[nI][03]+"}") )
            aColumns[Len(aColumns)]:SetType("C")	
        EndIf

        aColumns[Len(aColumns)]:SetTitle(RetTitle(AllTrim(aStruSZ3[nI][03]))) 
        //aColumns[Len(aColumns)]:SetSize(aRet[1]) 
        aColumns[Len(aColumns)]:nSize := Int((aRet[1])/2)
        //oColumn:nSize := aEstrut[nAtual][7]

        aColumns[Len(aColumns)]:SetDecimal(aRet[2]) 
        aColumns[Len(aColumns)]:SetPicture(PesqPict("SZ3", aStruSZ3[nI][03]))
        //aColumns[Len(aColumns)]:SetEdit(.F.)

    EndIf

Next nI

//Adicionar o recno
AAdd(aColumns,FWBrwColumn():New())

aColumns[Len(aColumns)]:SetData( &("{|| RECNO }") )
//aColumns[Len(aColumns)]:SetAlign(2)
aColumns[Len(aColumns)]:SetType("N")								

aColumns[Len(aColumns)]:SetTitle("RECNO") 
aColumns[Len(aColumns)]:SetSize(1)  
aColumns[Len(aColumns)]:SetDecimal(0) 
//aColumns[Len(aColumns)]:SetPicture(PesqPict("SZ3", aStruSZ3[nI][03]))
aColumns[Len(aColumns)]:SetEdit(.F.)

Return aColumns


/*/{Protheus.doc} AtuQuery
description
@type function
@version  
@author Deosdete Deo
@since 11/07/2023
@return variant, return_description
/*/
Static Function PegQuery(cDoc, cQryCpo, cProduto, cEtiqueta, nTipo)
Local aIndex	:= {"Z3_IDUNITZ","Z3_SEQPESA"}
Local cSZ3Qry   := ""

cSZ3Qry := "SELECT " + cQryCpo + ", SZ3.R_E_C_N_O_ AS RECNO "
cSZ3Qry +=   " FROM " + RetSqlName("SZ3") + " SZ3 "
cSZ3Qry +=  "WHERE Z3_FILIAL = '" + xFilial("SZ3") + "' "

If nTipo == 1
    cSZ3Qry +=  "AND Z3_DOC = '" + cDoc + "' "
EndIf

If nTipo == 2
    cSZ3Qry +=  "AND (Z3_CODETI = '" + cEtiqueta + "' OR Z3_IDUZORI = '" + cEtiqueta + "')  "  
EndIf

If nTipo == 3
    cSZ3Qry +=  "AND Z3_DOC = '' AND Z3_COD = '" + cProduto + "' " 
EndIf

cSZ3Qry +=  "AND SZ3.D_E_L_E_T_ = ' ' "
cSZ3Qry += "ORDER BY " + aIndex[1] + ", " + aIndex[2]

Return cSZ3Qry


/*/{Protheus.doc} FinalPesagem
description
@type function
@version  
@author Deosdete Deo
@since 10/06/2023
@return variant, return_description
/*/
Static Function ApontarProd(cDoc,cProduto, nQtd, cOperacao,cLocal, cRecurso, cOperador, oSay)
Local cTempo    := "01:00"
Local aMata681  := {}
Local lRet      := .T.
Local aArea     := getArea() //Mantera area da SZ3
Local nTempo    := 0 

Private lMsHelpAuto:= .f.
Private lMSErroAuto:= .f.
//Private  LMSERROAUTO := .F. 


DbSelectArea("SG2")
DbSetOrder(1) //G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC                                                                                                                                                                                                                                                        
If SG2->(DbSeek(xFilial("SG2")+SC2->C2_PRODUTO+SC2->C2_ROTEIRO+cOperacao))
    nTempo := SG2->G2_TEMPAD/SG2->G2_LOTEPAD * nQtd
Else
    MsgAlert("Operaçao nao encontrada","Erro!!!") 
EndIf

oSay:SetText("Processando: Apontando OP " + cDoc + "-" + AllTrim(Str(nQtd)) + "...") // ALTERA O TEXTO CORRETO
ProcessMessages() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

//Formatar tempo
cTempo := AllTrim(StrZero(Int(nTempo),3)) 
cTempo += ":" + AllTrim(StrZero(((nTempo - Int(nTempo))/100 * 60 * 100 ),2))

If lRet
	
	aAdd(aMata681,{"H6_OP",      cDoc       ,NIL})
	aAdd(aMata681,{"H6_PRODUTO", cProduto    ,NIL})
	aAdd(aMata681,{"H6_OPERAC" , cOperacao   ,NIL})
	aAdd(aMata681,{"H6_RECURSO", cRecurso    ,NIL})
	aAdd(aMata681,{"H6_DATAINI", dDataBase      ,NIL})
	aAdd(aMata681,{"H6_HORAINI", Time()       ,NIL})
	aAdd(aMata681,{"H6_DATAFIN", dDataBase      ,NIL})
	aAdd(aMata681,{"H6_HORAFIN", IncTime( Time() , 1 , 0 , 0 ) ,NIL})
	aAdd(aMata681,{"H6_OPERADO", cOperador   ,NIL})
	aAdd(aMata681,{"H6_DTAPONT", dDataBase   ,NIL})
	aAdd(aMata681,{"H6_QTDPROD", nQtd    ,NIL})
	aAdd(aMata681,{"H6_CBFLAG","2"           ,NIL}) // Flag que indica que foi gerado pelo ACD
	aadd(aMata681,{"H6_LOCAL",cLocal    ,NIL})
	aadd(aMata681,{"H6_PT","P"    ,NIL})  //Pendente de teste

	If Rastro(cProduto)
		aadd(aMata681,{"H6_LOTECTL",cLoteCtl    ,Nil})
		aadd(aMata681,{"H6_DTVALID",dDtValid   ,Nil})
	EndIf

	//Gravando tempo real produto
	aAdd(aMata681,{"H6_TEMPO"  , cTempo,NIL})


	lMsHelpAuto := .T.
	lMSErroAuto := .F.
	//nModuloOld  := nModulo
	//nModulo     := 4
	msExecAuto({|x|MATA681(x)},aMata681)
	//nModulo     := nModuloOld

	//lMsHelpAuto:=.F.
	If lMSErroAuto
		//DisarmTransaction()
		//Break
		MostraErro()
        
	EndIf
    //__oOrdServ

     If !WmsArmUnit(SZ3->Z3_LOCAL)  // SE NAO É UNITIZADO, ENTAO JA GEROU A ORDSERV DE ENDEREÇEAMENTO
        If !lMSErroAuto 
            DbSelectArea("D12")
            DbSetorder(4)//D12_FILIAL+D12_IDDCF+D12_IDMOV+D12_IDOPER+D12_STATUS+D12_SERVIC+D12_TAREFA                                                                                      
            If DbSeek(xFilial("D12")+SZ3->Z3_IDDCF)
            
                RecLock("SZ3",.F.)
                SZ3->Z3_ENDDES  := D12->D12_ENDDES
                SZ3->Z3_IDMOV   := D12->D12_IDMOV
                SZ3->(MsUnlock())


            Else
                MsgStop("A Ordem de Serviço WMS não foi executada, verifique e reprocesse a pesagem","Erro!")
                //DisarmTransaction()
                lRet := .F.
            EndIf
        EndIf
    EndIf

EndIf

RestArea(aArea)

Return !lMSErroAuto .AND. lRet //ver transacao

/*/{Protheus.doc} MontagUnitz
description
@type function
@version  
@author Deosdete Deo
@since 12/06/2023
@param cDoc, character, param_description
@param cProduto, character, param_description
@param cPesagem, character, param_description
@param nQtdTotal, numeric, param_description
@param cOperacao, character, param_description
@return variant, return_description
/*/
Static Function MontagUnitz(cEtiqueta)
Local oMntUniItem := WMSDTCMontagemUnitizadorItens():New()
Local cIdUnitiz   := ""
Local lRet        := .T.
Local cTipUni     := ""

//cEtiqueta := Space(cEtiqueta) //Zerar a etiqueta pois caso de erro, vai retornar etiqueta vazia

//Gerar a etiqueta
//Nao controla lote
      
//cada pesagem deve ser um unitizador
//Gerar e imprimir a etiqueta de unitizador
//Pegar o tipo de unitizador da NORMA
DbSelectArea("DC3")
DbSetOrder(1) //DC3_FILIAL+DC3_CODPRO+DC3_LOCAL+DC3_ORDEM
If DC3->(DbSeek(xFilial("DC3")+SZ3->Z3_COD+SZ3->Z3_LOCAL))
    DbSelectArea("DC2")
    DbSetOrder(1) //DC2_FILIAL+DC2_CODNOR
    If DC2->(DbSeek(xFilial("DC2")+DC3->DC3_CODNOR))
        cTipUni := DC2_CODUNI
    EndIf
EndIf

If GeraEtiq(1,@cIdUnitiz)
    BEGIN TRANSACTION
 
    //Fazer a beepagem automatica ja montando o unitizador com a demanda gerada no apontamento
    oMntUniItem:ClearData()
    oMntUniItem:oUnitiz:SetOrigem("SC2")
    oMntUniItem:oUnitiz:SetArmazem(SZ3->Z3_LOCAL)
    oMntUniItem:oUnitiz:SetEnder(SZ3->Z3_ENDENT)
    
    VldIdUnit(cIdUnitiz,cTipUni,.F., @oMntUniItem)

    oMntUniItem:SetProduto(SZ3->Z3_COD)
    //oMntUniItem:SetLoteCtl(cLoteCtl)
    //oMntUniItem:SetNumLote(cSubLote)
    // Seta o produto origem e faz a pergunta ao operador
    // caso necessário escolher entre produto ou partes
    lEstorno := .F.
    oMntUniItem:VldPrdCmp(lEstorno)

    oMntUniItem:SetQuant(SZ3->Z3_QUANT)
    If !oMntUniItem:MntPrdUni()
        Alert("Erro na montagem do unitizador") // Erro do objeto
        lRet := .F.
    EndIf
    oMntUniItem:SetIdUnitA(oMntUniItem:GetIdUnit())

    // Se tudo deu certo, gera a OS do unitizador
    If lRet
        //lRet := GerarOS(cUnitiz)
        RecLock("SZ3",.F.)
        SZ3->Z3_IDUNITZ  := cIdUnitiz
        SZ3->Z3_CODETI   := cIdUnitiz
        SZ3->Z3_TIPUNIT  := cTipUni
        SZ3->(MsUnlock())

        cEtiqueta := SZ3->Z3_IDUNITZ

    EndIf

    oMntUniItem:oUnitiz:SetStatus("2") // Aguardando Endereçamento
    If !oMntUniItem:oUnitiz:UpdStatus()
        Alert("Não foi pssivel atualizar o status do unitizador") 
        DisarmTransaction()
        lRet := .F.
    EndIf

    // Se tudo deu certo, gera a OS do unitizador para endereçar
    If lRet
        lRet := GerarOSAlu(cIdUnitiz,oMntUniItem)
    EndIf

    If lRet
        DbSelectArea("D12")
        DbSetorder(4)//D12_FILIAL+D12_IDDCF+D12_IDMOV+D12_IDOPER+D12_STATUS+D12_SERVIC+D12_TAREFA                                                                                      
        If DbSeek(xFilial("D12")+SZ3->Z3_IDDCF)
        
            RecLock("SZ3",.F.)
            SZ3->Z3_ENDDES  := D12->D12_ENDDES
            SZ3->Z3_IDMOV   := D12->D12_IDMOV
            SZ3->(MsUnlock())
        Else
            MsgStop("O movimento da Ordem de Serviço WMS não foi encontrado, verifique e reprocesse a pesagem","Erro!")
            DisarmTransaction()
            lRet := .F.
        EndIf
    Else
        MsgStop("A Ordem de Serviço WMS não foi gerada/executada, verifique e reprocesse a pesagem","Erro!")
        DisarmTransaction()
    EndIf
    
    END TRANSACTION

EndIf


Return lRet

/*/{Protheus.doc} VldIdUnit
description
@type function
@version  
@author Deosdete Deo
@since 17/06/2023
@param cUnitiz, character, param_description
@param cTipUni, character, param_description
@param lEstorno, logical, param_description
@return variant, return_description
/*/
Static Function VldIdUnit(cIdUnitiz,cTipUni,lEstorno,oMntUniItem)
Local lRet := .T.
	// Se possui o PE WV084AUT e a etiqueta não existe, gera automaticamente
	If __WV084AUT
		D0Y->(DbSetOrder(1))
		If !D0Y->(DbSeek(xFilial("D0Y")+cIdUnitiz))
			WmsGerUnit(.F.,.F.,.F.,cIdUnitiz,cTipUni)
		EndIf
	EndIf
	oMntUniItem:SetIdUnit(cIdUnitiz)
	If !(lRet := oMntUniItem:VldIdUnit(1,@cTipUni,lEstorno))
		oMntUniItem:SetIdUnit("")
		If !Empty(oMntUniItem:GetErro())
			WMSVTAviso("Erro do objeto",oMntUniItem:GetErro()) // Erro do objeto
			VTKeyBoard(Chr(20))
		EndIf
	EndIf

    oMntUniItem:oUnitiz:SetStatus("1") // Em Montagem
    If !oMntUniItem:oUnitiz:UniHasItem()
        oMntUniItem:oUnitiz:SetTipUni(cTipUni)
        oMntUniItem:oUnitiz:SetDatIni(dDataBase)
        oMntUniItem:oUnitiz:SetHorIni(Time())
    Else
        // Caso seja alterado para um unitizador que estava com status '2=Aguard. Ender', retorna para status '1=Em Montagem'
        If !oMntUniItem:oUnitiz:UpdStatus()
            WMSVTAviso(WMSV08418, oMntUniItem:oUnitiz:GetErro()) // Erro do objeto
        EndIf
    EndIf
    oMntUniItem:oUnitiz:SetDatFim(StoD(""))
    oMntUniItem:oUnitiz:SetHorFim("")


Return lRet


/*/{Protheus.doc} GeraEtiq
description
@type function
@version  
@author Deosdete Deo
@since 10/06/2023
@param nQtdEti, numeric, param_descriptionGeraEtiqTIP
@return variant, return_description
/*/
Static Function GeraEtiq(nQtdEti,cIdUnitiz )
Local lRet   := .T.
Local nCont  := 1
Local aItens := {}
	For nCont := 1 To nQtdEti
		If Empty(cIdUnitiz := WmsGerUnit(.F.,.T.))
			lRet := .F.
			Exit
		EndIf
		aAdd(aItens,{cIdUnitiz})
	Next nCont
	/*
    If lRet
		//Imprimir a etiqueta gerada
        
        If ExistBlock("WMSA110E")
            ExecBlock("WMSA110E",.F.,.F.,{aItens, Len(aItens)})
        Else
            WMSR130ETI(aItens)
        EndIf
	
	Else
		Alert("Erro ao gerar ID")
	EndIf
    */
Return lRet

/*/{Protheus.doc} GerarOSAlu
description
@type function
@version  
@author Deosdete Deo
@since 17/06/2023
@param cIdUnitiz, character, param_description
@return variant, return_description
/*/
Static Function GerarOSAlu(cIdUnitiz,oMntUniItem)
Local lRet := .T.

lRet := u_ALUV086END({cIdUnitiz}) //WMSV086END({cIdUnitiz})

// Se deu certo a geração da ordem de serviço limpa o unitizador
If lRet
    lEndereca := .T.
    oMntUniItem:SetIdUnit("")
    oMntUniItem:oUnitiz:SetStatus("3")
    //VTKeyBoard(Chr(27)) //-- Tecla ESC para sair do unitizador
Else
    MsgStop("Erro ao gerar OS")
EndIf

Return lRet

/*/{Protheus.doc} ImpEtiq
description
@type function
@version  
@author Deosdete Deo
@since 18/06/2023
@param cIdUnitiz, character, param_description
@return variant, return_description
/*/
Static Function ImpEtiq(cEtiqueta)
Local lRet      := .T.
Local aItens     := {}
//Local lPesqUnit := .F.

Default cEtiqueta := ""

If !Empty(cEtiqueta) 
    aAdd(aItens,{cEtiqueta})    
Else
    MsgStop("A pesagem não possui unitizador","Erro")
EndIf

//Imprimir a etiqueta gerada
If ExistBlock("WMSA110E")
    ExecBlock("WMSA110E",.F.,.F.,{aItens, Len(aItens)})
Else
    WMSR130ETI(aItens)
EndIf

Return lRet


/*/{Protheus.doc} ExcluirPesag
description
@type function
@version  
@author Deosdete Deo
@since 20/06/2023
@param cAlias, character, param_description
@return variant, return_description
/*/
Static Function ExcluirPesag(cAlias, oBrowSZ3, cDoc, cQryCpo, nTipo, cProduto)

If Empty((cAlias)->Z3_IDUNITZ)
       
        SZ3->(DbGoTo((cAlias)->RECNO))
        
        RecLock("SZ3",.F.)
        SZ3->(DbDelete())
        SZ3->(MsUnlock())

        //SZ3->(DbGoTop())
        
        DbSelectArea("SZ3")
        //oBrowSZ3:Refresh()
        //Atualiza os totais do rodape conforme pesagens ja gravadas
        AtuTotais(oBrowSZ3, 1) 

        AtuBrowse(oBrowSZ3, cDoc, cQryCpo, cProduto, "", nTipo)
Else
    MsgStop("A pesagem tem Unitizador, para exlcuir estorne antes a montagem de unitizador","Erro")    
EndIf    


Return


/*/{Protheus.doc} BuscaOP
description
@type function
@version  
@author Deosdete Deo
@since 11/07/2023
@return variant, return_description
/*/
Static Function BuscaOP(cDoc, cProduto, cDesc, nSaldo, cLocal, cUM, oBrowSZ3, cOperacao, cRecurso, cQryCpo)
Local aArea := GetArea()
Local lRet  := .T. 

DbSelectArea("SC2")
DbSetOrder(1) //C2_FILIAL+C2_NUM
If SC2->(DbSeek(xFilial("SC2")+cDoc))
    cProduto    := SC2->C2_PRODUTO
    cDesc       := Posicione('SB1',1,xFilial('SB1')+cProduto,'B1_DESC')
    nSaldo      := SC2->C2_QUANT - SC2->C2_QUJE
    cLocal      := SC2->C2_LOCAL
    cUM         := SC2->C2_UM

   //Verificar proxima operaçao
    cOperacao := ""

    DbSelectArea("SG2")
    DbSetOrder(1) //G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC                                                                                                                                                                                                                                                        
    If SG2->(DbSeek(xFilial("SG2")+SC2->C2_PRODUTO+SC2->C2_ROTEIRO+cOperacao))

        //Posicionar no recurso / impressora
        DbSelectArea("SH1")                                                                                                                                           
        DbSetOrder(1) //H1_FILIAL+H1_CODIGO  
        If !SH1->(DbSeek(xFilial("SH1")+SG2->G2_RECURSO))
            MsgAlert("Recurso cadastrado na operaçao nao encontrado","Erro!!!")
        EndIf

        cRecurso    := SG2->G2_RECURSO
        If Empty(cOperacao) //Pega a primeira operacao
            cOperacao := SG2->G2_OPERAC 
        EndIF
    EndIf    


    //Ver Complemento/Pegar o endereço inicial 
    DbSelectArea("SB5")
    DbSetOrder(1) //B5_FILIAL+B5_COD                                                                                                                                                
    If SB5->(DbSeek(xFilial("SB5")+cProduto))
        cEndEnt := SB5->B5_ENDENT  //Para todas as hipoteses em que existir unitizaçao o saldo vai pro endereço de entrada do produto
    Else    
        MsgInfo("Erro no cadastro de Complemento do Produto","Atençao!")
        lRet := .F.
    EndIf


    //Pegar o endereço incicial do produto para unitizar
    If SB1->B1_TIPO $ "PA/PI"
        DbSelectArea("D1A")
        DbSetOrder(1) // D1A_FILIAL+D1A_COD                                                                                                                                              
        If D1A->(DbSeek(xFilial("D1A")+cProduto))
            cEndEnt := D1A->D1A_ENDEPR //"DOCA003" 
        Else
                MsgInfo("Erro no cadastro de Complemento do Produto WMS","Atençao!")
                lRet := .F.
        EndIf
    Endif



    //Atualiza o Browse
    AtuBrowse(oBrowSZ3, cDoc,cQryCpo, cProduto, "", 1)





Else
   MsgStop(OemToAnsi("Ordem de Produção "+AllTrim(cDoc) + "não encontrada"),OemToAnsi("Atenção!!!"))
   lRet := .F.
   RestArea(aArea)
EndIf

Return lRet



/*/{Protheus.doc} PegProxEtiq
description
@type function
@version  
@author Deosdete Deo
@since 13/07/2023
@return variant, return_description
/*/
Static Function PegProxEtiq()
Local cProxEtiq := ""

cProxEtiq := GETSX8NUM("SZ3","Z3_CODETI")

Return cProxEtiq



/*/{Protheus.doc} MontagEtiq
description
@type function
@version  
@author Deosdete Deo
@since 13/07/2023
@return variant, return_description
/*/
Static Function MontagEtiq(oSay, cAlias)                   
Local lRet      := .T.
Local cEtiqueta :=  ""
Local nPeso     := 0
Local nQuant    := 0

cEtiqueta := PegProxEtiq()

If WmsArmUnit(SZ3->Z3_LOCAL) //Armazem unitiazado
      
    If SZ3->Z3_TIPO == "1"
        oSay:SetText("Montando unitizador...") // ALTERA O TEXTO CORRETO
        ProcessMessages() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT
        lRet := MontagUnitz(@cEtiqueta) //Unitizar muda a etiqueta
    ElseIf SZ3->Z3_TIPO == "2"
        
        oSay:SetText("Montando Transferencia..." + SZ3->Z3_IDUZORI + " para novo") // ALTERA O TEXTO CORRETO
        ProcessMessages() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT
        lRet := DivEtiq(@cEtiqueta, cAlias)
    
    Else
        //MsgStop("Armazem unitizado não permite entrada sem Ordem de Producao. A etiqueta de ve ser direcionada para outro armazem que nao seja unitizado","Erro!")
        //lRet := .F.
        oSay:SetText("Montando unitizador...") // ALTERA O TEXTO CORRETO
        ProcessMessages() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT
        lRet := MontagUnitz(@cEtiqueta) //Unitizar muda a etiqueta
  
    EndIf

EndIf //Se o armazem nao for unitizado, apenas gerar a etiqueta com um sequencial comum

If lRet 
    
    RecLock("SZ3",.F.)
    SZ3->Z3_CODETI  := cEtiqueta
    SZ3->(MsUnlock())
    //!Empty(SZ3->Z3_ENDDES) .OR. (Empty(SZ3->Z3_ENDDES) .AND. Z3_TIPO == "3") 
    
    oSay:SetText("Imprimindo etiqueta..." + cEtiqueta) // ALTERA O TEXTO CORRETO
    ProcessMessages() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

    If !ImpEtiq(cEtiqueta)
        MsgStop("Erro ao imprimir a etiqueta, verifique","Erro!")
    EndIf

    //Posicionar na etiqueta original, atualizar os dados e imprimir
    
    If SZ3->Z3_TIPO == "2" //SOMENTE PARA DIVISAO
        If !Empty((cAlias)->RECNO)

            //Pegar a nova pesagem
            nQuant  := SZ3->Z3_QUANT
            nPeso   := SZ3->Z3_PESOL

            SZ3->(DbGoTo((cAlias)->RECNO))
            RecLock("SZ3",.F.)
            SZ3->Z3_QUANT -= nQuant
            SZ3->Z3_PESOL  -= nPeso
            SZ3->(MsUnlock())


            If !ImpEtiq(SZ3->Z3_CODETI)
                MsgStop("Erro ao imprimir a etiqueta, verifique","Erro!")
            EndIf

        Else
            MsgStop("Erro ao buscar a Etiqueta original","Erro")
        EndIf
    EndIf

EndIf

Return



/*/{Protheus.doc} ALUV086END
description
@type function
@version  
@author Deosdete Deo
@since 18/07/2023
@param {cIdUnitiz}, variant, param_description
@return variant, return_description
/*/
User Function ALUV086END(aUnitiz)
Local aAreaAnt   := GetArea()
Local lRet       := .T.
Local nI         := 0
Local oOrdServ   := WMSDTCOrdemServicoCreate():New()
Local cUnitiz    := ""
Local cQuery     := ""
Local cAliasQry  := ""
Local lRetEXE    := .T.

	WmsOrdSer(oOrdServ) 
	
	For nI := 1 To Len(aUnitiz)
		cUnitiz := aUnitiz[nI]
		// Busca as informações da Ordem de Serviço do primeiro documento da demanda
		cQuery := " SELECT D0Q.D0Q_SERVIC,"
		cQuery +=        " D0Q.D0Q_DOCTO,"
		cQuery +=        " D0Q.D0Q_SERIE,"
		cQuery +=        " D0Q.D0Q_CLIFOR,"
		cQuery +=        " D0Q.D0Q_LOJA,"
		cQuery +=        " D0Q.D0Q_NUMSEQ,"
		cQuery +=        " D0Q.D0Q_LOCAL,"
		cQuery +=        " D0Q.D0Q_ORIGEM,"
		cQuery +=        " D0Q.D0Q_ENDER,"
		cQuery +=        " D0Q.D0Q_CODPRO,"
		cQuery +=        " D0Q.D0Q_LOTECT,"
		cQuery +=        " D0Q.D0Q_NUMLOT"
		cQuery +=   " FROM "+RetSqlName("D0S")+" D0S"
		cQuery +=  " INNER JOIN "+RetSqlName("D0Q")+" D0Q"
		cQuery +=     " ON D0Q.D0Q_FILIAL = '"+xFilial("D0Q")+"'"
		cQuery +=    " AND D0Q.D0Q_ID     = D0S.D0S_IDD0Q"
		cQuery +=    " AND D0Q.D_E_L_E_T_ = ' '"
		cQuery +=  " INNER JOIN "+RetSqlName('D0R')+" D0R"
		cQuery +=     " ON D0R.D0R_FILIAL = '"+xFilial('D0R')+"'"
		cQuery +=    " AND D0R.D0R_IDUNIT = D0S.D0S_IDUNIT"
		cQuery +=    " AND D0R.D0R_STATUS IN ('1','2')" // Para garantir que não irá gerar duplicado
		cQuery +=    " AND D0R.D_E_L_E_T_ = ' '"
		cQuery +=  " WHERE D0S.D0S_FILIAL = '"+xFilial("D0S")+"'"
		cQuery +=    " AND D0S.D0S_IDUNIT = '"+cUnitiz+"'"
		cQuery +=    " AND D0S.D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)
		cAliasQry := GetNextAlias()
		DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasQry,.F.,.T.)

		If (cAliasQry)->(!Eof())
			Begin Transaction
				// Seta os atributos do objeto
				oOrdServ:oOrdEndOri:SetArmazem((cAliasQry)->D0Q_LOCAL)
				oOrdServ:oOrdEndOri:SetEnder((cAliasQry)->D0Q_ENDER)
				oOrdServ:SetOrigem("D0R")
				oOrdServ:SetServico((cAliasQry)->D0Q_SERVIC)
				oOrdServ:SetDocto((cAliasQry)->D0Q_DOCTO)
				oOrdServ:SetSerie((cAliasQry)->D0Q_SERIE)
				oOrdServ:SetCliFor((cAliasQry)->D0Q_CLIFOR)
				oOrdServ:SetLoja((cAliasQry)->D0Q_LOJA)
				oOrdServ:SetNumSeq((cAliasQry)->D0Q_NUMSEQ)
				oOrdServ:SetIdUnit(cUnitiz)
				oOrdServ:SetQuant(1)
				// Realiza a criação da ordem de serviço como origem D0R
				If !oOrdServ:CreateDCF()
					WmsMessage(oOrdServ:GetErro(),WMSV08608,1) // Erro do objeto
					lRet := .F.
					Disarmtransaction()
				EndIf
			End Transaction
		EndIf
		(cAliasQry)->(dbCloseArea())
		If !lRet
			Exit
		EndIf
	Next nI
	// Efetua a execução automática quando serviço configurado 
	If lRet
		lRetExe := WmsExeServ()
	EndIf

	RestArea(aAreaAnt)

Return (lRet .AND. lRetExe)


/*/{Protheus.doc} ReportManual
description
@type function
@version  
@author Deosdete Deo
@since 18/07/2023
@return variant, return_description
/*/
Static Function ReportManual(lManual,oGetPeso,nPeso,oGetTara,nTara,oGetQtd,nQtd,oGetLiq,nPesoLiq)
Local lRet     := .T.

If lManual 
    If Aviso("Atençao!!!","Informar a quantidade manualemnte?",{"Sim", "Não"})
        oGetPeso:lReadOnly := .T.
        nPeso := 0
        oGetTara:lReadOnly := .T.
        nTara := 0
        oGetQtd:lReadOnly := .F.
        nQtd  := 0
        oGetLiq:lReadOnly := .T.
        nPesoLiq := 0   

        oGetQtd:SetFocus()  
    Else
        lRet := .F.
    EndIf
Else

    oGetPeso:lReadOnly := .T.
    oGetTara:lReadOnly := .T.
    oGetQtd:lReadOnly := .T.
    oGetLiq:lReadOnly := .T.

EndIf

Return lRet



/*/{Protheus.doc} VldProd
description
@type function
@version  
@author Deosdete Deo
@since 18/07/2023
@param cProduto, character, param_description
@param @cDesc, variant, param_description
@param oTGetDesc, object, param_description
@return variant, return_description
/*/
Static Function VldProd(cProduto,cDesc,oTGetDesc, cUM, oBrowSZ3, cDoc, cQryCpo)
Local lRet := .T.

If !Empty(cProduto)
    DbSelectArea("SB1")
    DbSetorder(1)//B1_FILIAL+B1_COD
    If SB1->(DbSeek(xFilial("SB1")+cProduto))
        cDesc       := SB1->B1_DESC
        cUM         := SB1->B1_UM
    Else
        MsgStop("Codigo do produto invalido!","Erro")
        lRet := .F.
    EndIf
EndIf

//Atualiza o Browse
AtuBrowse(oBrowSZ3, cDoc,cQryCpo, cProduto, "", 1)

Return lRet

/*/{Protheus.doc} VldUnitz
description
@type function
@version  
@author Deosdete Deo
@since 18/07/2023
@param cIdUnitz, character, param_description
@param oTGetEtiq, object, param_description
@param oBrowSZ3, object, param_description
@param cQryCpo, character, param_description
@return variant, return_description
/*/
Static Function VldUnitz(cIdUnitz,oTGetEtiq, oBrowSZ3, cQryCpo, oDlgTela,cDoc,cProduto,cLocal,cRecurso,cDesc,cUM)
Local lRet      := .T.
Local cAlias    := ""

If !Empty(cIdUnitz)
    DbSelectArea("D0R")
    DbSetorder(3)//D0R_FILIAL+D0R_IDUNIT                                                                                                                                           

    If !D0R->(DbSeek(xFilial("D0R")+cIdUnitz))
        MsgStop("Esta etiqueta não é um unitizador!","Erro")
        lRet := .F.
    EndIf
EndIf


//Atualiza o Browse e a tela
If lRet
    
    AtuBrowse(oBrowSZ3, "",cQryCpo, "", cIdUnitz, 2)

    cAlias := oBrowSZ3:GetAlias() 
    If !(cAlias)->(Eof())
        cDoc       := (cAlias)->Z3_DOC
        cProduto   := (cAlias)->Z3_COD
        cIdUnitz   := (cAlias)->Z3_IDUNITZ
        cLocal     := (cAlias)->Z3_LOCAL
        cRecurso   := (cAlias)->Z3_CODOPE
        
        DbSelectArea("SB1")
        DbSetorder(1)//B1_FILIAL+B1_COD
        If SB1->(DbSeek(xFilial("SB1")+(cAlias)->Z3_COD))
            cDesc       := SB1->B1_DESC
            cUM         := SB1->B1_UM
        Else
            MsgStop("Codigo do produto invalido!","Erro")
            lRet := .F.
        EndIf

        oDlgTela:Refresh()

    EndIf

EndIf

Return lRet


/*/{Protheus.doc} DivEtiq
Esta rotina tem como objetivo dividir um unitizador levando o saldo pesado na balança 
para um novo unitizador e mantendo o saldo restantante no unitizador atual.
Para isto no WMS Protheus faz se necessario transferir o saldo de uma para o outro unitizador
@type function
@version  
@author Deosdete Deo
@since 20/07/2023
@return variant, return_description
/*/
Static Function DivEtiq(cEtiqueta,cAlias)
//-------------------------------------------------------
Local lRet      := .T.
Local oMovimento
Local oOrdServ
Local oEtiqUnit
Local cTipUni   := ""
Local cIdUnitiz := ""
Local lRetExe   := .T.
Local aArea   := GetArea()
Local nRecD12 := 0 
Local nRecD14  := 0
Local nRecD12Atu := 0

// Criação das tabelas temporárias para validação do unitizador
WMSCTPENDU()

DbSelectArea("DC3")
DbSetOrder(1) //DC3_FILIAL+DC3_CODPRO+DC3_LOCAL+DC3_ORDEM
If DC3->(DbSeek(xFilial("DC3")+SZ3->Z3_COD+SZ3->Z3_LOCAL))
    DbSelectArea("DC2")
    DbSetOrder(1) //DC2_FILIAL+DC2_CODNOR
    If DC2->(DbSeek(xFilial("DC2")+DC3->DC3_CODNOR))
        cTipUni := DC2_CODUNI
    EndIf
EndIf

oMovRequis := WMSBCCTransferencia():New()
oMovimento := WMSBCCTransferencia():New()
oOrdServ   := WMSDTCOrdemServicoCreate():New()
oEtiqUnit  := WMSDTCEtiquetaUnitizador():New()
//oModelDCF  := oModel:GetModel("DCFMASTER")
//oModelSel  := oModel:GetModel("SELECAO")

WmsOrdSer(oOrdServ)

Begin Transaction

// Criação do serviço com origem DCF quando o armazém destino é o mesmo

// Atribui produto/Lote/Sublote
oOrdServ:oProdLote:SetArmazem(SZ3->Z3_LOCAL)
oOrdServ:oProdLote:SetProduto(SZ3->Z3_COD)
oOrdServ:oProdLote:SetPrdOri(SZ3->Z3_COD)
//oOrdServ:oProdLote:SetLoteCtl(SZ3->Z3_LOTECTL)
//oOrdServ:oProdLote:SetNumLote(oModelSel:GetValue("NUMLOTE"))
//oOrdServ:oProdLote:SetDtValid(oModelSel:GetValue("DTVALD"))
oOrdServ:oProdLote:LoadData()
//oOrdServ:oProdLote:SetNumSer("")

// Atribui endereco origem
oOrdServ:oOrdEndOri:SetArmazem(SZ3->Z3_LOCAL)
oOrdServ:oOrdEndOri:SetEnder(SZ3->Z3_ENDENT)
// Atribui endereco destino
//Definir destino somente se tiver endreço livre
If  .T. //Ver quantidade de unitizar contido no endreço 
    oOrdServ:oOrdEndDes:SetArmazem(SZ3->Z3_LOCAL)
    oOrdServ:oOrdEndDes:SetEnder(SZ3->Z3_ENDDES)
EndIf
// Atribui quantidade
oOrdServ:SetQuant(SZ3->Z3_QUANT)
oOrdServ:SetOrigem("DCF")
oOrdServ:SetDocto(SZ3->Z3_DOC)
// Atribui servico
oOrdServ:oServico:SetServico("014")
oOrdServ:oServico:LoadData()
// Criação do serviço com origem DH1 quando o armazém é diferente

If GeraEtiq(1,@cIdUnitiz)

    // Atribui informações do unitizador
    oOrdServ:SetIdUnit(SZ3->Z3_IDUZORI) //Aqui precisa ser o unitizador autal

    If WmsArmUnit(SZ3->Z3_LOCAL)
        oOrdServ:oOrdEndDes:LoadData()
        If !( cValtoChar(oOrdServ:oOrdEndDes:GetTipoEst()) $ "2|7|8" )
            oOrdServ:SetUniDes(cIdUnitiz)  //Novo unitizador
            oOrdServ:SetTipUni(cTipUni)
            
            // Atualiza dados da etiqueta do unitizador
            oEtiqUnit:SetIdUnit(cIdUnitiz)
            If oEtiqUnit:LoadData()
                If !oEtiqUnit:GetIsUsed()
                    oEtiqUnit:SetUsado("1")
                    oEtiqUnit:SetTipUni(cTipUni)
                    oEtiqUnit:UpdateD0Y()
                EndIf
            EndIf
        EndIf
    Else
        MsgStop("Impossivel DIVIDIR etqueta, o aramzem nao é unitizador","Erro")    
    EndIf
    // Endereco Origem
    oMovimento:SetIdUnit(oOrdServ:GetIdUnit())
    oMovimento:oMovEndOri:SetArmazem(oOrdServ:oOrdEndOri:GetArmazem())
    oMovimento:oMovEndOri:SetEnder(oOrdServ:oOrdEndOri:GetEnder())
    // Endereco Destino
    oMovimento:SetUniDes(oOrdServ:GetUniDes())
    oMovimento:SetTipUni(oOrdServ:GetTipUni())
    oMovimento:oMovEndDes:SetArmazem(oOrdServ:oOrdEndDes:GetArmazem())
    oMovimento:oMovEndDes:SetEnder(oOrdServ:oOrdEndDes:GetEnder())

    // Produto/Lote
    oMovimento:oMovPrdLot:SetArmazem(oOrdServ:oProdLote:GetArmazem())
    oMovimento:oMovPrdLot:SetPrdOri(oOrdServ:oProdLote:GetPrdOri())
    oMovimento:oMovPrdLot:SetProduto(oOrdServ:oProdLote:GetProduto())
    oMovimento:oMovPrdLot:SetLoteCtl(oOrdServ:oProdLote:GetLoteCtl())
    oMovimento:oMovPrdLot:SetNumLote(oOrdServ:oProdLote:GetNumLote())
    oMovimento:oMovPrdLot:SetNumSer(oOrdServ:oProdLote:GetNumSer())
    oMovimento:oMovPrdLot:LoadData()

    oMovimento:oMovServic:SetServico(oOrdServ:oServico:GetServico())
    oMovimento:oOrdServ:SetDocto(oOrdServ:GetDocto())
    oMovimento:SetQuant(oOrdServ:GetQuant())
    If !oMovimento:ChkEndOri()
        //oModel:GetModel():SetErrorMessage( , , oModel:GetId() , "", "", oMovimento:GetErro(), "", "", "")
        MsgStop("Endereço origem invalido " + oMovimento:GetErro() ,"Erro!!!")
        lRet := .F.
    EndIf
    If lRet .And. !Empty(oOrdServ:oOrdEndDes:GetEnder())
        If !oMovimento:ChkEndDes()

            MsgStop("Endereço de destino " + SZ3->Z3_ENDDES + " invalido. " + oMovimento:GetErro() + ". Endereçando para BALANCA ", "Atencao!!!")

            oMovimento:oMovEndDes:SetEnder("BALANCA")        

            If oMovimento:ChkEndDes()
                oOrdServ:oOrdEndDes:SetEnder("BALANCA")     
            Else
                MsgStop("Endereco BALANCA invalido, verifique e reprocesse a pesagem" + oMovimento:GetErro()  ,"Erro!")  
                Disarmtransaction()
                lRet := .F.    
            EndIf       
        EndIf      
    EndIf

    If lRet
        If !oOrdServ:CreateDCF()
            MsgStop("Erro ao criar/executar ordem de serviço no endereço " + SZ3->Z3_ENDDES + " " + oOrdServ:GetErro() + " tentr outro endereço? ")
            Disarmtransaction()
            lRet := .F.
        EndIf
    EndIf

	// Efetua a execução automática quando serviço configurado 
	If lRet
		
        //Trocar o unitizador e endereço do movimento 
        nRecD12 := TrocaUnit(cAlias, 1)
        If nRecD12 > 0
            D12->(DbGoTo(nRecD12))

            //Localizar D12 e tirar o previsto de saida
            DbSetOrder(1) //D14_FILIAL+D14_LOCAL+D14_ENDER+D14_PRDORI+D14_PRODUT+D14_LOTECT+D14_NUMLOT+D14_NUMSER+D14_IDUNIT                                                                
            If D14->(DbSeek(xFilial("D14")+D12->(D12_LOCORI+D12_ENDORI+D12_PRODUT+D12_PRODUT+D12_LOTECT+D12_NUMLOT+D12_NUMSER+D12_IDUNIT) ))
                If D14->D14_QTDSPR >= D12->D12_QTDORI 
                    RecLock("D14",.F.)
                    D14->D14_QTDSPR -= D12->D12_QTDORI 
                    D14->D14_QTDPEM -= D12->D12_QTDORI
                    D14->(MsUnlock()) 
                    nRecD14 := D14->(RecNo())
                EndIf  
            EndIf
        EndIf
        /*
        If nRecD12 > 0
            oOrdSerRev:GoToDCF(aOrdSerEst[nI])
            If oOrdSerRev:CanReverse()
                If !oOrdSerRev:ReverseDCF()
                    //DisarmTransaction()
                EndIf
            EndIf
        EndIf
        */
       /* If nRecD12 > 0
            If oMovRequis:GoToD12(nRecD12)
                
                lRet := Self:RevMovPrev()
                
            EndIf
        EndIf
        
*/

        lRetExe := WmsExeServ()
        
        If !lRetExe
            MsgStop("Erro ao executar ordem de serviço no endereço " + SZ3->Z3_ENDDES + " " + oOrdServ:GetErro() + " tentar outro endereço? ")
            DisarmTransaction()
        EndIf

        lRet := lRetExe
    EndIf

    //Se chegou ate aqui gravar os dados do unitizador
    If lRet .AND. lRetExe

        //Voltar previsto de saida

       //lRet := GerarOS(cUnitiz)
        RecLock("SZ3",.F.)
        SZ3->Z3_IDUNITZ  := cIdUnitiz
        SZ3->Z3_CODETI   := cIdUnitiz
        SZ3->(MsUnlock())

        cEtiqueta := SZ3->Z3_IDUNITZ
 
 
    EndIf

    If lRet
        DbSelectArea("D12")
        DbSetorder(4)//D12_FILIAL+D12_IDDCF+D12_IDMOV+D12_IDOPER+D12_STATUS+D12_SERVIC+D12_TAREFA                                                                                      
        If D12->(DbSeek(xFilial("D12")+SZ3->Z3_IDDCF))
        
            RecLock("SZ3",.F.)
            SZ3->Z3_ENDDES  := D12->D12_ENDDES
            SZ3->Z3_IDMOV   := D12->D12_IDMOV
            SZ3->(MsUnlock())

            

            If nRecD12 > 0
                
                nRecD12Atu := D12->(RecNo())
                
                D12->(DbGoTo(nRecD12))
                RecLock("D12",.F.)
                D12->D12_ENDORI  := SZ3->Z3_ENDDES //SZ3->Z3_ENDDES
                D12->D12_IDUNIT  := SZ3->Z3_IDUNITZ  //SZ3->Z3_IDUNITZ 
                D12->(MsUnlock())

                //TrocaUnit(cAlias, 2)
                //Localizar D12 e tirar o previsto de saida
                DbSetOrder(1) //D14_FILIAL+D14_LOCAL+D14_ENDER+D14_PRDORI+D14_PRODUT+D14_LOTECT+D14_NUMLOT+D14_NUMSER+D14_IDUNIT                                                                
                If D14->(DbSeek(xFilial("D14")+D12->(D12_LOCORI+D12_ENDORI+D12_PRODUT+D12_PRODUT+D12_LOTECT+D12_NUMLOT+D12_NUMSER+D12_IDUNIT) ))
                    //If D14->D14_QTDSPR >= D12->D12_QTDORI 
                        RecLock("D14",.F.)
                        D14->D14_QTDSPR += D12->D12_QTDORI 
                        D14->D14_QTDPEM += D12->D12_QTDORI 
                        D14->(MsUnlock()) 
                        nRecD14 := D14->(RecNo())
                    //EndIf  
                EndIf
                
                D12->(DbGoTo(nRecD12Atu))

            EndIf

         // Para nao mexer nos dados da D14, tentar criar um D14 retirando a quantidade prevista de saida e empenho correspondente ao unitizador e apos finalizar Excluir
          //  Trocar o unitizador da D12 autalizando o movimento 
            //No caso de divisao de etiqueta ja deve Finalizar a atividade
            //Para finalizar a transferencia preciso retirar a quantidade prevista de saida gerada pela requisiçao, equivalente a quantidade divididade e depois voltar

            //Localizar a D14 do unitizador origem
           // DbSetOrder(5)//D14_FILIAL+D14_IDUNIT                                                                                                                                           
           // If DbSeek(xFilial("D14")+D12->D12_IDUNIT)
           //     RecLock(.F.,"D14")
           //     D14->D14_QTDSPR := (D14->D14_QTDSPR - SZ3->Z3_QUANT)
           //     D14->(MsUnlock())
           // EndIf


           u_ALUAFAtiv()

          //  DbSetOrder(5)//D14_FILIAL+D14_IDUNIT                                                                                                                                           
          //  If DbSeek(xFilial("D14")+D12->D12_IDUNIT)
          //      RecLock(.F.,"D14")
          //      D14->D14_QTDSPR := (D14->D14_QTDSPR + SZ3->Z3_QUANT)
          //      D14->(MsUnlock())
          //  EndIf

        Else
            MsgStop("O movimento da Ordem de Serviço WMS não foi encontrado, verifique e reprocesse a pesagem","Erro!")
            DisarmTransaction()
            lRet := .F.
        EndIf
    EndIf
 

Else
    MsgStop("Impossivel pegar o ID novo de unitizador","Erro")
EndIf

End Transaction

// Destroy objetos
oMovimento:Destroy()
oOrdServ:Destroy()
oEtiqUnit:Destroy()

// Deleção das tabelas temporárias para validação do unitizador
WMSDTPENDU()

RestArea(aArea)
Return lRet



/*/{Protheus.doc} TrocaUnit
Verificar movimentos pendentes no unitizador origem e trocar para o novo unitizador divvidido,
caso seja mais deum perguntar pro ususario
@type function
@version  
@author Deosdete Deo
@since 30/07/2023
@param D12->D12_ENDORI, date, param_description
@param D12->D12_IDUNIT, date, param_description
@param D12->D12_ENDDES, date, param_description
@param SZ3->Z3_IDUNITZ, variant, param_description
@return variant, return_description
/*/
Static Function TrocaUnit(cAlias, nOpc)
Local cQuery   := ""
Local cQryD12  := GetNextAlias()
Local aMovSPR  := {}
Local aBot     := {}
Local nI       := 0
Local nISel    := 0
Local aAreaD12 := D12->(GetArea())
//Local oMovimento
//Local oProcess
//Local aErro
Local nRecD12 := 0
 

// SZ3->SZ3->Z3_ENDENT,Z3_IDUZORI, SZ3->Z3_ENDDES,SZ3->Z3_IDUNITZ, SZ3->Z3_IDMOV
If nOpc == 1
    cQuery := "SELECT "
    cQuery += "R_E_C_N_O_ AS RECNO, D12_IDMOV, D12_IDUNIT, D12_QTDORI, D12_ENDDES  "
    cQuery += "FROM " + RetSqlName("D12") + " D12 "
    cQuery += "WHERE D12_FILIAL = '" + xFilial("D12") + "' "
    cQuery += " AND D12_ENDORI = '" + (cAlias)->Z3_ENDDES + "' "
    cQuery += " AND D12_IDUNIT = '" + (cAlias)->Z3_IDUNITZ + "' "
    cQuery += " AND D12_STATUS <> '1' "
    //cQuery += " AND D12_IDMOV <> '" + (cAlias)->Z3_IDMOV + "' "
    cQuery += " AND D12_QTDORI <= '" + AllTrim(Str(SZ3->Z3_QUANT)) + "' "
    cQuery += " AND D12.D_E_L_E_T_ = '' "

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQryD12,.T.,.T.)

    While !(cQryD12)->(Eof())

        aAdd(aMovSPR, {(cQryD12)->RECNO, (cQryD12)->D12_IDMOV, (cQryD12)->D12_IDUNIT, (cQryD12)->D12_QTDORI, (cQryD12)->D12_ENDDES })

        (cQryD12)->(DbSkip())

    EndDo

    If Len(aMovSPR) > 1 
        
        aBot := {}
        aAdd(aBot,"NENHUM") 
        For nI := 1 To Len(aMovSPR)
            aAdd(aBot,aMovSPR[nI][2] + "[" +  AllTrim(Str((cQryD12)->D12_QTDORI)) + "]")
        Next nI4


        nISel := Aviso("Atençao!!!","Existem varios movimentos pendentes. Escolha qual vai ser atendido com esta etiqueta",aBot)
    ElseIf  Len(aMovSPR) == 1
        nISel := 1
    Else
        MsgInfo("Nenhum movimento para ser atendido com esta etiqueta","Nenhum Movimento")
        nISel := 0 
    EndIf

    If nISel > 0 
    
        //Trocar endreço e unitizador para a nova etiqueta
        nRecD12 := aMovSPR[nISel][1]
        //D12->(DbGoTo(nRecD12))
        
        //RecLock("D12",.F.)
        //D12->D12_ENDORI  := ""//SZ3->Z3_ENDDES
        //D12->D12_IDUNIT  := "" //SZ3->Z3_IDUNITZ 
        //D12->(MsUnlock())

        //oMovimento := WMSDTCMovimentosServicoArmazem():New()
        //oMovimento:oEstEnder:EquatePrev(SZ3->Z3_LOCAL,SZ3->Z3_COD,oProcess,@aErro)
            
    /* 
        //Trocar EMPENHO - tirar do mov
        D14_QTDSPR -= D12-D12_QTDORI  
        D14_IDUNIT  SZ3->Z3_IDUZORI
        D14_ENDER SZ3->Z3_ENDENT


    //Trocar EMPENHO incluir o novo
        D14_QTDSPR -= D12-D12_QTDORI  
        D12_IDUNIT SZ3->Z3_IDUNITZ
        D14_ENDER SZ3->Z3_ENDENT

        RecLock('D14',.T.)
        D14->D14_FILIAL := xFilial("D14")
        D14->D14_LOCAL  := SZ3->Z3_LOCAL
        D14->D14_ENDER  := SZ3->Z3_ENDENT
        D14->D14_PRDORI := SZ3->Z3_COD
        D14->D14_PRODUT := SZ3->Z3_COD
        D14->D14_LOTECT := ""
        D14->D14_NUMLOT := ""
        D14->D14_NUMSER := ""
        D14->D14_IDUNIT := Z3_IDUNITZ
    
        D14->D14_CODUNI := SZ3->Z3_TIPUNIT //Self:cTipUni
    
        D14->D14_ESTFIS := D12->D12_ESTFIS
        D14->D14_PRIOR  := D12->D12_PRIOR
        D14->D14_QTDEST := 0
        D14->D14_QTDES2 := 0
        
        //If !Empty(Self:oProdLote:GetLoteCtl()) .And. Empty(D14->D14_DTVALD)
        //    D14->D14_DTVALD  := Self:oProdLote:GetDtValid()
        //    D14->D14_DTFABR  := Self:oProdLote:GetDtFabr()
        //EndIf
        
        D14->D14_QTDEPR := 0
        D14->D14_QTDEP2 := 0
        D14->D14_QTDSPR := SZ3->Z3_QUANT
        D14->D14_QTDSP2 := 0
        D14->D14_QTDBLQ := 0
        D14->D14_QTDBL2 := 0
        D14->D14_QTDPEM := SZ3->Z3_QUANT
        D14->D14_QTDPE2 := 0
        
        D14->(MsUnLock())
        */
    EndIf
EndIf

//If nOpc == 2
//	oMovimento := WMSDTCMovimentosServicoArmazem():New()
//	oMovimento:oEstEnder:EquatePrev(SZ3->Z3_LOCAL,SZ3->Z3_COD,oProcess,@aErro)
//EndIf

RestArea(aAreaD12)

Return nRecD12
