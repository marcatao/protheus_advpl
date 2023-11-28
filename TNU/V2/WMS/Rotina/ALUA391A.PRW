#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "FWEDITPANEL.CH"

#DEFINE ALUA391A01 "ALUA391A01"
#DEFINE ALUA391A02 "ALUA391A02"
#DEFINE ALUA391A03 "ALUA391A03"
#DEFINE ALUA391A04 "ALUA391A04"
#DEFINE ALUA391A05 "ALUA391A05"
#DEFINE ALUA391A06 "ALUA391A06"
#DEFINE ALUA391A07 "ALUA391A07"
#DEFINE ALUA391A08 "ALUA391A08"
#DEFINE ALUA391A09 "ALUA391A09"
#DEFINE ALUA391A10 "ALUA391A10"
#DEFINE ALUA391A11 "ALUA391A11"
#DEFINE ALUA391A12 "ALUA391A12"
#DEFINE ALUA391A13 "ALUA391A13"
#DEFINE ALUA391A14 "ALUA391A14"
#DEFINE ALUA391A15 "ALUA391A15"
#DEFINE ALUA391A16 "ALUA391A16"
#DEFINE ALUA391A17 "ALUA391A17"
#DEFINE ALUA391A18 "ALUA391A18"
#DEFINE ALUA391A19 "ALUA391A19"
#DEFINE ALUA391A20 "ALUA391A20"
#DEFINE ALUA391A21 "ALUA391A21"

Static __lHasLot   := SuperGetMV("MV_WMSLOTE",.F.,.T.)
Static oMntVolItem := WMSDTCMontagemVolumeItens():New()

/*/{Protheus.doc} ALUA391A
Rotina para Montagem de Volume 
@type function
@version  
@author Deosdete Deo
@since 01/04/2023
@return variant, return_description
/*/
User Function ALUA391A()
Local oDlgTela
Local cAliasDCT  := GetNextAlias()
Local cAliasDCV  := GetNextAlias()
Local nSuperior	:= 0
Local nEsquerda	:= 0
Local nInferior	:= 580
Local nDireita	:= 1024
//Local oBrowSZ3	:= Nil
//Local oDlgTela	:= Nil
//Local cDCVQry	:= ""
//Local cDCTQry	:= ""
Local cTitulo   := "Montagem de Volume ALUMBRA"
Local oPanelDCV
Local oPanelDCU
Local oPanelDCT
Local cQryCpo := ""
//Local oPanelRodap
Local oFont1    := TFont():New('Arial',,10,.T.)
Local oFont2    := TFont():New('Arial',,14,.T.)
Local oFont16   := TFont():New('Arial',,16,.T.)
Local oFont22   := TFont():New('Arial',,22,.T.)
Local cCodMNT   := DCS->DCS_CODMNT
Local cPedido   := DCS->DCS_PEDIDO
Local cCodBar  := Space(iIf(TAMSX3("B1_COD")[1] > 14,TAMSX3("B1_COD")[1],14))
Local oBrwDCTA
Local oBrowDCV
Local aColsDCV := {}
Local aColsDCT := {}
Local cCodVol  := "0000000184"
Local nQtd     := 1
Local lAlteraVol := .F.
Local cCodEmb  := ""
Local nCubag   := 0
Local cProduto := ""
Local cLoteCtl := ""
Local cSubLote := ""
Local aBeeps   := {}
Local nOpc     := 0
Local aProdutos:= {} 
Local cLocImp  := "" 

//Perguntar o tipo de embalagem e cubatem
aRetEmb := u_PegCodEmb(cCodEmb)

If Len(aRetEmb) == 4
	cCodEmb := aRetEmb[1]
	nCubag  := aRetEmb[2]
	nOpc    := aRetEmb[3]
    cLocImp := aRetEmb[4]

	If nOpc == 2

		u_A391MANU(cProduto,cLoteCtl,cSubLote,nQtd,cCodBar,cCodMNT, cCodVol,cPedido,aBeeps, cCodEmb, nCubag, cLocImp)
		Return //Retornar nil para nao entrar na vieww do padrao
	EndIf
EndIf

//Verificar o status e se ainda estiver aberto, deixar o usuario finaliar
If DCS->DCS_STATUS <> "3" 

	DbSelectArea("DCV")
	DbSetOrder(1) //DCV_FILIAL+DCV_CODMNT+DCV_CODVOL+DCV_PRDORI+DCV_CODPRO+DCV_LOTE+DCV_SUBLOT+DCV_ITEM+DCV_SEQUEN
	If DCV->(DbSeek(xFilial("DCV")+DCU->DCU_CODMNT+DCU->DCU_CODVOL )) 
		If Empty(DCV->DCV_STATUS) //<> "2" // os status de uma é o mesmo das outras
			
			lAlteraVol := .T. //:= Aviso("Atenção!","Reabrir Volume "+ DCU->DCU_CODVOL + " ?", {"Sim","Não"}) == 1
			While !DCV->(Eof()) .AND. xFilial("DCV")+DCU->DCU_CODMNT+DCU->DCU_CODVOL == DCV->(DCV_FILIAL+DCV_CODMNT+DCV_CODVOL)
				
				//RecLock("DCV",.F.)
				//DCV->DCV_STATUS := ""
				//DCV->(MsUnlock())

				

				//Carregar a quantidade ja lida
				aAdd(aBeeps,{.F.,DCV->DCV_CODPRO,DCV->DCV_QUANT})
				DCV->(DbSkip())
			EndDo
		
		//Else
		//	lAlteraVol := Aviso("Atenção!","Continuar no Volume "+ DCU->DCU_CODVOL + " ?", {"Sim","Não"}) == 1
		EndIf
	EndIf

EndIf

If lAlteraVol
	cCodVol  := DCU->DCU_CODVOL //oModelDCU:SetValue("DCU_CODVOL",DCU->DCU_CODVOL)
	cCodEmb  := DCU->DCU_XCODEM // oModelDCU:SetValue("DCU_XCODEM",DCU->DCU_XCODEM)
	cEmbaDesc:= Posicione("CB3",1,xFilial("CB3")+cCodEmb,"CB3_DESCRI")
	nCubag   := DCU->DCU_XCUBAG //oModelDCU:SetValue("DCU_XCUBAG",DCU->DCU_XCUBAG)
Else
	
	cCodVol  := U_ALUCBProxCod()
	//Utilizar a mesma embalagem anterior
	//cCodEmb  := DCU->DCU_XCODEM // oModelDCU:SetValue("DCU_XCODEM",DCU->DCU_XCODEM)
	//nCubag   := DCU->DCU_XCUBAG //oModelDCU:SetValue("DCU_XCUBAG",DCU->DCU_XCUBAG)

	cEmbaDesc:= Posicione("CB3",1,xFilial("CB3")+cCodEmb,"CB3_DESCRI")

EndIf

oMntVolItem:oMntVol:SetCodMnt(cCodMNT)
//oMntVolItem:oMntVol:SetCarga(oModelDCU:GetValue("DCU_CARGA"))
oMntVolItem:oMntVol:SetPedido(cPedido)
oMntVolItem:oVolume:SetCodVol(cCodVol)
//oMntVolItem:oVolume:SetDtIni(oModelDCU:GetValue("DCU_DATINI"))
//oMntVolItem:oVolume:SetHrIni(oModelDCU:GetValue("DCU_HORINI"))
//oModelDCV:LoadValue("DCV_CODVOL",oModelDCU:GetValue("DCU_CODVOL"))
//oView:EnableTitleView("WMSA391ADCVF", STR0006+oModelDCU:GetValue("DCU_CODVOL")) // "Produto - Volume: "



//TButton():New( [ nRow ], [ nCol ], [ cCaption ], [ oWnd ], [ bAction ], [ nWidth ], [ nHeight ], [ uParam8 ], [ oFont ], [ uParam10 ], [ lPixel ], [ uParam12 ], [ uParam13 ], [ uParam14 ], [ bWhen ], [ uParam16 ], [ uParam17 ] )
//TGet():New( [ nRow ], [ nCol ], [ bSetGet ], [ oWnd ], [ nWidth ], [ nHeight ], [ cPict ], [ bValid ], [ nClrFore ], [ nClrBack ], [ oFont ], [ uParam12 ], [ uParam13 ], [ lPixel ], [ uParam15 ], [ uParam16 ], [ bWhen ], [ uParam18 ], [ uParam19 ], [ bChange ], [ lReadOnly ], [ lPassword ], [ uParam23 ], [ cReadVar ], [ uParam25 ], [ uParam26 ], [ uParam27 ], [ lHasButton ], [ lNoButton ], [ uParam30 ], [ cLabelText ], [ nLabelPos ], [ oLabelFont ], [ nLabelColor ], [ cPlaceHold ], [ lPicturePriority ], [ lFocSel ] )
//TSay():New( [ nRow ], [ nCol ], [ bText ], [ oWnd ], [ cPicture ], [ oFont ], [ uParam7 ], [ uParam8 ], [ uParam9 ], [ lPixels ], [ nClrText ], [ nClrBack ], [ nWidth ], [ nHeight ], [ uParam15 ], [ uParam16 ], [ uParam17 ], [ uParam18 ], [ uParam19 ], [ lHTML ], [ nTxtAlgHor ], [ nTxtAlgVer ] )
//TPanel():New( [ nRow ], [ nCol ], [ cText ], [ oWnd ], [ oFont ], [ lCentered ], [ uParam7 ], [ nClrText ], [ nClrBack ], [ nWidth ], [ nHeight ], [ lLowered ], [ lRaised ] )
DEFINE MSDIALOG oDlgTela TITLE cTitulo FROM nSuperior, nEsquerda TO nInferior, nDireita PIXEL	

oPanelBAR:= tPanel():New(110,01,"Barra de botoes",oDlgTela,oFont1,.T.,,CLR_HGRAY,CLR_HGRAY,1024,020)
oPanelBAR:Align :=CONTROL_ALIGN_TOP

oButFechar := TButton():New( 010, 002, "FECHAR EMBALAGEM",oPanelBAR,{||FecharEmb(oBrowDCV, nQtd,oDlgTela,cCodEmb, nCubag, cCodVol,cCodMNT, aProdutos,cLocImp)},;
                        090,020,,oFont16,.F.,.T.,.F.,,.F.,{|| .T.},,.F. )  

oButFechar:SetCss("QPushButton { background: #149FC1; border: 1px solid #096A82;outline:0; border-radius: 5px; font: bold 12px Arial; padding: 6px;color: #FFFFFF;} QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #149FC1); }")
oButFechar:Align :=CONTROL_ALIGN_RIGHT

oButCancelar := TButton():New( 010, 002, "SAIR",oPanelBAR,{||Cancelar(oDlgTela)},;
                        070,020,,oFont16,.F.,.T.,.F.,,.F.,{|| .T.},,.F. )  
oButCancelar:SetCss("QPushButton { background: #F9F9F9; border: 1px solid #096A82;outline:0; border-radius: 5px; font: bold 12px Arial; padding: 6px;color: #4F545E;} QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #F9F9F9, stop: 1 #F9F9F9); }")
oButCancelar:Align :=CONTROL_ALIGN_RIGHT

oButExcluir := TButton():New( 010, 002, "Excluir",oPanelBAR,{||Excluir(oBrowDCV, aBeeps)},;
                        070,020,,oFont16,.F.,.T.,.F.,,.F.,{|| .T.},,.F. )  
oButExcluir:SetCss("QPushButton { background: #F9F9F9; border: 1px solid #096A82;outline:0; border-radius: 5px; font: bold 12px Arial; padding: 6px;color: #4F545E;} QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #F9F9F9, stop: 1 #F9F9F9); }")
oButExcluir:Align :=CONTROL_ALIGN_RIGHT

oButEstornar := TButton():New( 010, 002, "ESTORNAR",oPanelBAR,{||EstornarEmb(aBeeps, cCodMNT, cCodVol,oBrowDCV)},;
                        070,020,,oFont16,.F.,.T.,.F.,,.F.,{|| .T.},,.F. )  
oButEstornar:SetCss("QPushButton { background: #F9F9F9; border: 1px solid #096A82;outline:0; border-radius: 5px; font: bold 12px Arial; padding: 6px;color: #4F545E;} QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #F9F9F9, stop: 1 #F9F9F9); }")
oButEstornar:Align :=CONTROL_ALIGN_RIGHT


oPanelDCU:= tPanel():New(110,01,"Volume",oDlgTela,oFont1,.T.,,CLR_WHITE,CLR_WHITE,300,030)
oPanelDCU:Align :=CONTROL_ALIGN_TOP

//Objetos do painel
oSayVol:= TSay():New(002,002,{||'Volume'},oPanelDCU,,oFont2,,,,.T.,CLR_BLUE,CLR_WHITE,50,10)
oTGetVol := TGet():New( 012,002,{ |u|Iif (PCount()==0,cCodVol,cCodVol:=u)},oPanelDCU,60,012,"@!",{ |u| If(PCount()>0,VldCodVol(cCodVol, oMntVolItem, oBrowDCV, @cDCVQry, cCodMNT,cPedido,oTGetVol),.T.) },0,,oFont16,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.F.,.F.,"","cCodVol",,,, )

oSayTipo:= TSay():New(002,062,{||'Tipo Emb.'},oPanelDCU,,oFont2,,,,.T.,CLR_BLUE,CLR_WHITE,50,10)
oTGetTipo := TGet():New( 012,062,{ |u|Iif (PCount()==0,cCodEmb,cCodEmb:=u)},oPanelDCU,30,012,"@!", { |u| If(PCount()>0,VldEmba(cCodEmb, @nCubag, @cEmbaDesc), .T.) },0,,oFont16,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.F.,.F.,"","cCodEmb",,,, )
oTGetTipo:cTooltip   := 'Tipo de embalagem para calculo da cubagem'
oTGetTipo:cF3        := 'CB3'
oTGetTipo:bHelp      := {|| ShowHelpCpo( 'Ajuda', {' Informar o codigo do tipo de embalagem. Caso não exista, cadastrar em ACD\Tipos de Embalagens'}, 0 ) }

oSayEMBA:= TSay():New(002,100,{||'Embalagem'},oPanelDCU,,oFont2,,,,.T.,CLR_BLUE,CLR_WHITE,50,10)
oTGetEMBA := TGet():New( 012,100,{ |u|Iif (PCount()==0,cEmbaDesc,cEmbaDesc:=u)},oPanelDCU,65,012,"@!",{ |u| If(PCount()>0,.T., .T.) },0,,oFont16,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.T.,.F.,"","cEmbaDesc",,,, )

oSayCUBA:= TSay():New(002,180,{||'Cubagem'},oPanelDCU,,oFont2,,,,.T.,CLR_BLUE,CLR_WHITE,50,10)
oTGetCUBA := TGet():New( 012,180,{ |u|Iif (PCount()==0,nCubag,nCubag:=u)},oPanelDCU,40,012,"@!",{ |u| If(PCount()>0,.T., .T.) },0,,oFont16,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.T.,.F.,"","nCubag",,,, )

oPanelDCV:= tPanel():New(110,01,"Itens do Volume",oDlgTela,oFont1,.T.,,CLR_BLUE,CLR_WHITE,300,110)
oPanelDCV:Align :=CONTROL_ALIGN_ALLCLIENT
 
oPanelMNT:= tPanel():New(110,01,"Montagem",oDlgTela,oFont1,.T.,,CLR_WHITE,CLR_WHITE,250,030)
oPanelMNT:Align :=CONTROL_ALIGN_LEFT

oSayQtd:= TSay():New(030,082,{||'Quantidade'},oPanelMNT,,oFont16,,,,.T.,CLR_BLUE,CLR_WHITE,50,10)
oTGetQtd := TGet():New( 042,082,{ |u|Iif (PCount()==0,nQtd,nQtd:=u)},oPanelMNT,40,022,"@E 999,999 ",{ |u| iIf(PCount()>0,.T., .T.) },0,,oFont22,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.F.,.F.,"","nQtd",,,, )
//TGet():New( [ nRow ], [ nCol ], [ bSetGet ], [ oWnd ], [ nWidth ], [ nHeight ], [ cPict ], [ bValid ], [ nClrFore ], [ nClrBack ], [ oFont ], [ uParam12 ], [ uParam13 ], [ lPixel ], [ uParam15 ], [ uParam16 ], [ bWhen ], [ uParam18 ], [ uParam19 ], [ bChange ], [ lReadOnly ], [ lPassword ], [ uParam23 ], [ cReadVar ], [ uParam25 ], [ uParam26 ], [ uParam27 ], [ lHasButton ], [ lNoButton ], [ uParam30 ], [ cLabelText ], [ nLabelPos ], [ oLabelFont ], [ nLabelColor ], [ cPlaceHold ], [ lPicturePriority ], [ lFocSel ] )

oSayCod:= TSay():New(070,082,{||'Cod Produto'},oPanelMNT,,oFont16,,,,.T.,CLR_BLUE,CLR_WHITE,50,10)
oTGetCod := TGet():New( 82,082,{ |u|Iif (PCount()==0,cCodBar,cCodBar:=u)},oPanelMNT,90,022,"@!",{ |u| iIf(PCount()>0,VldPrdLot(@cProduto,@cLoteCtl,@cSubLote,nQtd,@cCodBar, oTGetCod, oBrowDCV, cCodMNT, cCodVol,cPedido,aBeeps), .T.) },0,,oFont22,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,,.F.,.F.,"","cCodBar",,,, )

cTpQry   := "DCV"
aColsDCV := PegColunas(@cQryCpo, cTpQry)
cDCVQry  := PegQuery(cCodMNT, cPedido, cQryCpo, cTpQry, cCodVol)

oBrowDCV := FWFormBrowse():New(oPanelDCV)
oBrowDCV:SetDescription("") 
oBrowDCV:SetAlias(cAliasDCV)
oBrowDCV:SetDataQuery()
oBrowDCV:SetQuery(cDCVQry)
oBrowDCV:SetOwner(oPanelDCV)
oBrowDCV:DisableDetails()
oBrowDCV:SetColumns(aColsDCV)
oBrowDCV:DisableReports()
oBrowDCV:DisableFilter()
oBrowDCV:DisableConfig()
oBrowDCV:DisableReport()
oBrowDCV:DisableSeek()
oBrowDCV:DisableSaveConfig()

oBrowDCV:Activate()


//oPanelDCV:= tPanel():New(110,01,"Itens do volume",oDlgTela,oFont1,.T.,,CLR_WHITE,CLR_GRAY,1024,110)
//oPanelDCV:Align :=CONTROL_ALIGN_ALLCLIENT

//oPanelRodap:= tPanel():New(001,001,"Rodape",oDlgTela,oFont1,.T.,,CLR_BLUE,CLR_WHITE,1024,25)
//oPanelRodap:Align :=CONTROL_ALIGN_BOTTOM

oPanelDCT:= tPanel():New(110,01,"Itens do Pedido",oDlgTela,oFont1,.T.,,CLR_WHITE,CLR_GRAY,1024,100)
oPanelDCT:Align :=CONTROL_ALIGN_BOTTOM

cTpQry := "DCT"
aColsDCT := PegColunas(@cQryCpo, cTpQry)
cDCTQry := PegQuery(cCodMNT, cPedido, cQryCpo, cTpQry, cCodVol)

oBrwDCTA := FWFormBrowse():New(oPanelDCT)
oBrwDCTA:SetDescription("") 
oBrwDCTA:SetAlias(cAliasDCT)
oBrwDCTA:SetDataQuery()
oBrwDCTA:SetQuery(cDCTQry)
oBrwDCTA:SetOwner(oPanelDCT)
oBrwDCTA:DisableDetails()
oBrwDCTA:SetColumns(aColsDCT)
oBrwDCTA:DisableReports()
oBrwDCTA:DisableFilter()
oBrwDCTA:DisableConfig()
oBrwDCTA:DisableReport()
oBrwDCTA:DisableSeek()
oBrwDCTA:DisableSaveConfig()

oBrwDCTA:Activate()

ACTIVATE MSDIALOG oDlgTela CENTERED ON INIT (A391Inicio(oTGetCod,aBeeps, oBrowDCV)) 

oBrwDCTA:Destroy()

Return



/*/{Protheus.doc} A391Inicio
description
@type function
@version  
@author Deosdete Deo
@since 08/08/2023
@return variant, return_description
/*/
Static Function A391Inicio(oTGetCod, aBeeps, oBrowDCV) 
Local cAlias := oBrowDCV:GetAlias()

/* com o obejto nao funcionaou contar com o aBeep
While !(cAlias)->(Eof())

	oMntVolItem:SetProduto((cAlias)->DCV_CODPRO)
	oMntVolItem:SetLoteCtl("")
	oMntVolItem:SetNumLote("")
	oMntVolItem:SetPrdOri((cAlias)->DCV_CODPRO)
	If !oMntVolItem:LoadPrdVol(aProdutos,(cAlias)->DCV_QUANT)
		//oModel:SetErrorMessage(oModelDCVG:GetId(),"DCV_CODPRO",,,WMSA391A15,oMntVolItem:GetErro(),STR0016) //
		MsgStop("Verifique os dados informados","Atencao")
		lRet := .F.
		Exit
	EndIf

	(cAlias)->(DbSkip())

EndDo
*/
//Carregar saldo ja beepado anteriormente
While !(cAlias)->(Eof())

		//nPos := aScan(aBeeps, {|x| x[2] == (cAlias)->DCV_CODPRO} )

		//If nPos > 0
		//	aBeeps[nPos][3] += (cAlias)->DCV_QUANT
		//Else
			aAdd(aBeeps,{.F.,(cAlias)->DCV_CODPRO, (cAlias)->DCV_QUANT})
		//EndIf


	(cAlias)->(DbSkip())

EndDo

oTGetCod:SetFocus()

Return




/*/{Protheus.doc} AtuQuery
description
@type function
@version  
@author Deosdete Deo
@since 11/07/2023
@return variant, return_description
/*/
Static Function PegQuery(cCodMNT, cPedido, cQryCpo, cTpQry, cCodVol)
Local cQry      := ""

If cTpQry == "DCV"
	
	cQry := " SELECT " + cQryCpo  + " " + CRLF
	cQry += "FROM "+RetSqlName('DCV')+" DCV "+CRLF
	cQry += "WHERE DCV_FILIAL = '" + xFilial("DCV")+ "' "
	cQry += "  AND DCV_CODMNT =  '" + cCodMNT +"' "+CRLF
	cQry += "  AND DCV_PEDIDO =  '" + cPedido +"' "+CRLF
	cQry += "  AND DCV_CODVOL =  '" + cCodVol +"' "+CRLF
	cQry += "  AND DCV.D_E_L_E_T_ = '' "+CRLF
	cQry += "ORDER BY DCV_CODVOL,DCV_CODPRO " 


EndIf

If cTpQry == "DCT"
	
	cQry := " SELECT " + cQryCpo  + " " + CRLF
	cQry += "FROM "+RetSqlName('DCT')+" DCT "+CRLF
	cQry += "JOIN "+RetSqlName('SB1')+" SB1 "+CRLF
	cQry += "    ON SB1.D_E_L_E_T_='' "+CRLF
	cQry += "    AND B1_FILIAL = '" + xFilial("SB1") + "' " +CRLF
	cQry += "    AND  B1_COD = DCT_PRDORI "+CRLF
	cQry += "WHERE DCT_FILIAL = '" + xFilial("DCT")+ "' "
	cQry += "  AND DCT_CODMNT =  '" + cCodMNT +"' "+CRLF
	cQry += "  AND DCT_PEDIDO =  '" + cPedido +"' "+CRLF
	cQry += "  AND DCT.D_E_L_E_T_ = '' "+CRLF
	cQry += "ORDER BY DCT_CODMNT, DCT_PEDIDO, DCT_CODPRO " 

EndIf



Return cQry



/*/{Protheus.doc} PegColunas
description
@type function
@version  
@author Deosdete Deo
@since 11/07/2023
@return variant, return_description
/*/
Static Function PegColunas(cQryCpo, cTpQry)
Local nI        := 0
Local aStru     := {}
Local oStru     
Local aRet      := {}
Local aColumns  := {}

cQryCpo := ""

If cTpQry = "DCV"
	
	DbSelectArea("DCV")
	DbSetorder(1)
	
	oStru     := FWFormStruct(1,"DCV")
	aStru     := oStru:GetFields()

	//Campos para a quey e para o Browse
	For nI := 1 To Len(aStru)

		If AllTrim(aStru[nI][03]) $ "DCV_CODVOL,DCV_CODPRO, DCV_QUANT,DCV_STATUS,DCV_CODOPE "

			If !Empty(cQryCpo)
				cQryCpo += ","  
			EndIf

			cQryCpo += aStru[nI][03]	
		
			aRet := TamSX3(aStru[nI][03])
					
			AAdd(aColumns,FWBrwColumn():New())
			
			If aRet[3] == "N"
				aColumns[Len(aColumns)]:SetData( &("{||"+aStru[nI][03]+"}") )
				aColumns[Len(aColumns)]:SetAlign(2)
				aColumns[Len(aColumns)]:SetType("N")								
			ElseIf aRet[3] == "D"
				aColumns[Len(aColumns)]:SetData( &("{||SToD("+aStru[nI][03]+")}") )
				aColumns[Len(aColumns)]:SetType("D")	
			Else
				aColumns[Len(aColumns)]:SetData( &("{||"+aStru[nI][03]+"}") )
				aColumns[Len(aColumns)]:SetType("C")	
			EndIf

			aColumns[Len(aColumns)]:SetTitle(RetTitle(AllTrim(aStru[nI][03]))) 
			//aColumns[Len(aColumns)]:SetSize(aRet[1]) 
			aColumns[Len(aColumns)]:nSize := Int((aRet[1])/2)
			//oColumn:nSize := aEstrut[nAtual][7]

			aColumns[Len(aColumns)]:SetDecimal(aRet[2]) 
			aColumns[Len(aColumns)]:SetPicture(PesqPict("DCV", aStru[nI][03]))
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

	cQryCpo += ",R_E_C_N_O_ AS RECNO" 

EndIf

If cTpQry = "DCT"
	
	DbSelectArea("DCT")
	DbSetorder(1)
	
	oStru     := FWFormStruct(1,"DCT")
	aStru     := oStru:GetFields()

	//Campos para a quey e para o Browse
	For nI := 1 To Len(aStru)

		If AllTrim(aStru[nI][03]) $ "DCT_CODMNT, DCT_PEDIDO, DCT_CODPRO, B1_DESC, DCT_STATUS, DCT_QTORIG, DCT_QTSEPA, DCT_QTEMBA "

			If !Empty(cQryCpo)
				cQryCpo += ","  
			EndIf

			cQryCpo += aStru[nI][03]	
		
			aRet := TamSX3(aStru[nI][03])
					
			AAdd(aColumns,FWBrwColumn():New())
			
			If aRet[3] == "N"
				aColumns[Len(aColumns)]:SetData( &("{||"+aStru[nI][03]+"}") )
				aColumns[Len(aColumns)]:SetAlign(2)
				aColumns[Len(aColumns)]:SetType("N")								
			ElseIf aRet[3] == "D"
				aColumns[Len(aColumns)]:SetData( &("{||SToD("+aStru[nI][03]+")}") )
				aColumns[Len(aColumns)]:SetType("D")	
			Else
				aColumns[Len(aColumns)]:SetData( &("{||"+aStru[nI][03]+"}") )
				aColumns[Len(aColumns)]:SetType("C")	
			EndIf

			aColumns[Len(aColumns)]:SetTitle(RetTitle(AllTrim(aStru[nI][03]))) 
			//aColumns[Len(aColumns)]:SetSize(aRet[1]) 
			aColumns[Len(aColumns)]:nSize := Int((aRet[1])/2)
			//oColumn:nSize := aEstrut[nAtual][7]

			aColumns[Len(aColumns)]:SetDecimal(aRet[2]) 
			aColumns[Len(aColumns)]:SetPicture(PesqPict("DCT", aStru[nI][03]))
			//aColumns[Len(aColumns)]:SetEdit(.F.)

		EndIf

	Next nI

EndIf


Return aClone(aColumns)






//-----------------------------------------------------------------//
//--------Função responsável por validar a edição do campo---------//
//-----------------------------------------------------------------//
/*/{Protheus.doc} WhenField
description
@type function
@version  
@author Deosdete Deo
@since 01/04/2023
@param oModel, object, param_description
@param cField, character, param_description
@return variant, return_description
/*/
Static Function WhenField(oModel,cField)
Local lRet    := .T.
	If cField == "DCV_LOTE"
		lRet :=  __lHasLot .And. Rastro(oModel:GetValue("DCV_CODPRO"))
	ElseIf cField == "DCV_SUBLOT"
		lRet := __lHasLot .And. Rastro(oModel:GetValue("DCV_CODPRO"),"S")
	EndIf
Return lRet


//----------------------------------------------------------------------------------
// Valida o produto informado, verificando se é um código de barras ou etiqueta CB0
//----------------------------------------------------------------------------------
/*/{Protheus.doc} VldPrdLot
description
@type function
@version  
@author Deosdete Deo
@since 01/04/2023
@param oModel, object, param_description
@param oView, object, param_description
@param cProduto, character, param_description
@param cLoteCtl, character, param_description
@param cSubLote, character, param_description
@param nQtde, numeric, param_description
@param cCodBar, character, param_description
@return variant, return_description
/*/
Static Function VldPrdLot(cProduto,cLoteCtl,cSubLote,nQtd,cCodBar, oTGetCod, oBrowDCV,cCodMNT,cCodVol,cPedido,aBeeps)
Local lRet      := .T.
Local aProduto  := {}
Local lAchou    := .F.
Local cCarga    := " "
Local lQtdEtiq  := nQtd == 1 //Sobrepor com a quantidade da etiqueta somente se a quantidade for igual a 1
Local nSldaEmb := 0

If Empty(cCodBar)
	Return //.F.
EndIf

If nQtd <= 0
	MsgStop("Verifique a quantidade","Erro")
	Return
EndIf

If oTGetCod:lModified

	// Deve zerar estas informações, pois pode haver informação de outra etiqueta
	cProduto := Space(TamSx3("DCV_CODPRO")[1])
	cLoteCtl := Space(TamSx3("DCV_LOTE")[1])
	cSubLote := Space(TamSx3("DCV_SUBLOT")[1])
	aProduto := CBRetEtiEAN(cCodBar)
	If Len(aProduto) > 0
		cProduto := aProduto[1]
		If ValType(aProduto[2]) == 'N'
			If lQtdEtiq
				nQtd := Iif(aProduto[2] == 0,nQtd,aProduto[2])
			EndIf
		EndIf
		cLoteCtl := Padr(aProduto[3],TamSx3("DCV_LOTE")[1])
	Else
		aProduto := CBRetEti(cProduto, '01')
		If Len(aProduto) > 0
			cProduto := aProduto[1]
			If lQtdEtiq
				nQtd    := Iif(aProduto[2] == 0,nQtd,aProduto[2])
			EndIf
			cLoteCtl := Padr(aProduto[16],TamSx3("DCV_LOTE")[1])
			cSubLote := Padr(aProduto[17],TamSx3("DCV_SUBLOT")[1])
		EndIf
		If Empty(aProduto)
			MsgStop("Código do produto é invalido!","Informe o código do produto ou o código de barras do produto desejado.") 
			lRet := .F.
		EndIf
	EndIf
	// Deve validar se o produto informado é um produto partes ou componente
	If lRet
		oMntVolItem:SetProduto(cProduto)
		oMntVolItem:SetLoteCtl(cLoteCtl)
		oMntVolItem:SetNumLote(cSubLote)
		lAchou := oMntVolItem:VldPrdCmp()

		If !lAchou
			MsgStop("Produto não pertence a montagem de volumes do documento.","Verifique os dados informados.") 
			lRet := .F.
		Else
			//lRet := oModel:LoadValue("DCV_PRDORI",oMntVolItem:GetPrdOri())
		EndIf
	EndIf

	If lRet
		// Carregar as quantidades para o produto
		oMntVolItem:QtdPrdVol()
		//Deve validar se o produto possui quantidade para separada para ser embalada
		If QtdComp(oMntVolItem:GetQtdSep()) == 0
			MsgStop("Produto não possui quantidade separada para montagem de volumes.","Aguarde a finalização do processo de separação.") 
			lRet := .F.
		EndIf
		//Deve validar se o produto possui quantidade para separada pendente para ser embalada
		If lRet .And. QtdComp(oMntVolItem:GetQtdOri()-oMntVolItem:GetQtdEmb()) == 0
			MsgStop("Montagem de volumes do produto finalizada.","Verifique os dados informados.") 
			lRet := .F.
		EndIf
		//Deve validar se o produto possui quantidade para separada pendente para ser embalada
		If lRet .And. QtdComp(oMntVolItem:GetQtdSep()-oMntVolItem:GetQtdEmb()) == 0
			MsgStop("Produto não possui quantidade separada pendente para montagem de volumes.","Aguarde a finalização do processo de separação.")
			lRet := .F.
		EndIf
		
		
		nSldaEmb := oMntVolItem:GetQtdSep()-oMntVolItem:GetQtdEmb()

		//Deve validar se para este produto a qtd ainda nao confirmada nao ultrapassa o saldo total
		//nQtdaConfirmar := PegQtdaConfirmar(cProduto,cCodMnt,cCodVol)
		//nPos := aScan(aBeeps, {|x| x[2] == cProduto} )
		//If nPos > 0 
			nSldaEmb := nSldaEmb - PegSldBeeps(aBeeps,cProduto)//[nPos][3]
		//EndIf 
		
		If lRet .And. (nSldaEmb - nQtd) < 0
			MsgStop("Produto não possui quantidade separada pendente suficiente SALDO:" + Transform(nSldaEmb,PesqPict("DCV","DCV_QUANT")) + " QTD LIDA:" + Transform(nQtd,PesqPict("DCV","DCV_QUANT")),"Aguarde a finalização do processo de separação.")
			lRet := .F.
		EndIf
		

	EndIf


	//Adiciono a leitura no browse dos itens do volume pra depois processar no objeto e montar o volume, o que tiver com status em branco
	//é que ainda nao foi processado
	If lRet

		//Poscionar no SC9 correspondente
		DbSelectArea("SC9")
		DbSetOrder(1) //C9_FILIAL+C9_PEDIDO

		DbSelectArea("DCV")
		DCV->(DbSetOrder(1)) // DCV_FILIAL+DCV_CODVOL+DCV_PRDORI+DCV_CODPRO+DCV_LOTE+DCV_SUBLOT+DCV_ITEM+DCV_SEQUEN+DCV_CODMNT
		lAchou := DCV->(dbSeek(xFilial("DCV")+cCodMNT+cCodVol+cProduto))

		Reclock('DCV',!lAchou)
		If !lAchou
			DCV->DCV_Filial := xFilial("DCT")
			DCV->DCV_CODVOL := cCodVol
			DCV->DCV_CODMNT := cCodMNT
			DCV->DCV_CARGA  := cCarga	
			DCV->DCV_PEDIDO := cPedido
			DCV->DCV_STATUS := " "
			DCV->DCV_PRDORI := cProduto
			DCV->DCV_CODPRO := cProduto
			DCV->DCV_LOTE   := cLoteCtl
			DCV->DCV_SUBLOT := cSubLote
			DCV->DCV_QUANT  := nQtd
			DCV->DCV_CODOPE := __cUserID
			//DCV->DCV_ITEM   := Self:cItem
			//DCV->DCV_SEQUEN := Self:cSequen
			//DCV->DCV_DATINI := Self:dDtInicio
			//DCV->DCV_HORINI := Self:cHrInicio
			DCV->DCV_DATINI := dDataBase
			DCV->DCV_HORINI := Time()
		Else
			//DCV->DCV_STATUS := Self:cStatus
			//DCV->DCV_DATFIM := dDataBase
			//DCV->DCV_HORFIM := Time()
			DCV->DCV_QUANT  += nQtd
		EndIf
		DCV->(MsUnLock())	


		
		//If nPos > 0
		//	aBeeps[nPos][3] += nQtd
		//Else
			aAdd(aBeeps,{.F.,cProduto, nQtd})
		//EndIf

	EndIf


	oBrowDCV:Refresh()
	

EndIf

//Voltar para o campo de qualquer jeito mesmo que nao tenha modificado
cCodBar := Space(iIf(TAMSX3("B1_COD")[1] > 14,TAMSX3("B1_COD")[1],14))

//oTGetCod:Refresh()

oTGetCod:SetFocus()

Return lRet


/*/{Protheus.doc} FecharEmb
description
@type function
@version  
@author Deosdete Deo
@since 10/08/2023
@return variant, return_description
/*/
Static Function FecharEmb(oBrowDCV, nQtd, oDlgTela, cCodEmb, nCubag,cCodVol,cCodMNT, aProdutos,cLocImp)
Local cAlias      := oBrowDCV:GetAlias()
Local lRet        := .T.
Local lIndividual := .F.


//oDlgTela
//cAlias      := "" //oBrowDCV:GetAlias()


(cAlias)->(DbGoTop())

While !(cAlias)->(Eof())

	oMntVolItem:SetProduto((cAlias)->DCV_CODPRO)
	oMntVolItem:SetLoteCtl("")
	oMntVolItem:SetNumLote("")
	oMntVolItem:SetPrdOri((cAlias)->DCV_CODPRO)
	If !oMntVolItem:LoadPrdVol(aProdutos,(cAlias)->DCV_QUANT)
		//oModel:SetErrorMessage(oModelDCVG:GetId(),"DCV_CODPRO",,,WMSA391A15,oMntVolItem:GetErro(),STR0016) //
		MsgStop("Verifique os dados informados","Atencao")
		lRet := .F.
		Exit
	EndIf

	(cAlias)->(DbSkip())

EndDo


If lRet
	
	//Se o sistema nao encontrou o primeiro volume gravado na validacao do procuto, entao ele criou um novo e velho deve ser deletado
	(cAlias)->(DbGoTop())
	While !(cAlias)->(Eof())

		DCV->(DbGoTo((cAlias)->RECNO))	
		
		If Empty(DCV->DCV_STATUS)  .AND. Empty(DCV->DCV_ITEM)
			RecLock("DCV",.F.)
			DCV->(DbDelete())
			DCV->(MsUnlock())	
		EndIf
		
		(cAlias)->(DbSkip())

	EndDo

	oMntVolItem:SetStatus("2")

	If !oMntVolItem:MntPrdVol(aProdutos)
		//oModel:SetErrorMessage(oModelDCVG:GetId(),"DCV_CODPRO",,,WMSA391A21,oMntVolItem:GetErro(),STR0016) // 
		MsgStop("Verifique os dados informados","Atencao")
		lRet := .F.
	EndIf

	//pega a DCU gerada 
	DbSelectArea("DCU")
	DbSetOrder(1) //DCU_FILIAL+DCU_CODVOL+DCU_CODMNT                                                                                                                                
	If DCU->(DbSeek(xFilial("DCU")+cCodVol+cCodMNT))
		RecLock("DCU",.F.)
		DCU->DCU_XCODEM  := cCodEmb  // oModelDCU:SetValue("DCU_XCODEM",DCU->DCU_XCODEM)
		DCU->DCU_XCUBAG  := nCubag   //oModelDCU:SetValue("DCU_XCUBAG",DCU->DCU_XCUBAG)
		DCU->(MsUnlock())

		//Gravar informacoes da montagem no pedido
		U_PESOVOL(DCU->DCU_PEDIDO)

	EndIf


EndIf

If lRet //.And. oMntVolItem:oMntVol:GetStatus() == "3"
	lIndividual := .T.
	GerEtqVol(lIndividual, cLocImp) // Se não gerar as etiquetas, não impede a gravação
EndIf
If lRet //.And. oView != Nil
	MsgInfo("Volume","Inserido com sucesso.")
EndIf



oDlgTela:End()

Return



//-----------------------------------------------------------------------------
// Valida o produto/lote informado, verificando se o mesmo possui saldo no endereço
//-----------------------------------------------------------------------------
/*/{Protheus.doc} VldLoteCtl
description
@type function
@version  
@author Deosdete Deo
@since 01/04/2023
@param oModel, object, param_description
@param cLoteCtl, character, param_description
@return variant, return_description
/*/
Static Function VldLoteCtl(oModel,cLoteCtl)

	If Empty(cLoteCtl)
		Return .F.
	EndIf
	oMntVolItem:SetLoteCtl(cLoteCtl)
	// Carregar as quantidades para o produto
	oMntVolItem:QtdPrdVol()
	//Deve validar se o produto/lote possui quantidade para separada para ser embalada
	If QtdComp(oMntVolItem:GetQtdOri()) == 0
		oModel:GetModel():SetErrorMessage(oModel:GetId(),"DCV_LOTE",,,ALUA391A03,"Produto/Lote não pertence a montagem de volumes do documento.","Verifique os dados informados.") //"Produto/Lote não pertence a montagem de volumes do documento."##"Verifique os dados informados."
		Return .F.
	EndIf
	//Deve validar se o produto/lote possui quantidade para separada para ser embalada
	If QtdComp(oMntVolItem:GetQtdSep()) == 0
		oModel:GetModel():SetErrorMessage(oModel:GetId(),"DCV_LOTE",,,ALUA391A04,"Produto/Lote não possui quantidade separada para montagem de volumes.","Aguarde a finalização do processo de separação.") // "Produto/Lote não possui quantidade separada para montagem de volumes."##"Aguarde a finalização do processo de separação."
		Return .F.
	EndIf
	//Deve validar se o produto/lote já foi todo montado volume
	If QtdComp(oMntVolItem:GetQtdOri()-oMntVolItem:GetQtdEmb()) == 0
		oModel:GetModel():SetErrorMessage(oModel:GetId(),"DCV_LOTE",,,ALUA391A05,"Montagem de volumes do Produto/Lote finalizada.","Verifique os dados informados.") // "Montagem de volumes do Produto/Lote finalizada."##"Verifique os dados informados."
		Return .F.
	EndIf
	//Deve validar se o produto/lote possui quantidade pendente para ser separada
	If QtdComp(oMntVolItem:GetQtdSep()-oMntVolItem:GetQtdEmb()) == 0
		oModel:GetModel():SetErrorMessage(oModel:GetId(),"DCV_LOTE",,,ALUA391A06,"Montagem de volumes do Produto/Lote da quantidade separada finalizada.","Aguarde a finalização do processo de separação.") // "Montagem de volumes do Produto/Lote da quantidade separada finalizada."##"Aguarde a finalização do processo de separação."
		Return .F.
	EndIf
Return .T.

//-----------------------------------------------------------------------------
// Valida o produto/rastro informado, verificando se o mesmo possui saldo no endereço
//-----------------------------------------------------------------------------
/*/{Protheus.doc} VldSubLote
description
@type function
@version  
@author Deosdete Deo
@since 01/04/2023
@param oModel, object, param_description
@param cSubLote, character, param_description
@return variant, return_description
/*/
Static Function VldSubLote(oModel,cSubLote)

	If Empty(cSubLote)
		Return .F.
	EndIf
	oMntVolItem:SetNumLote(cSubLote)
	// Carregar as quantidades para o produto
	oMntVolItem:QtdPrdVol()
	//Deve validar se o produto/lote possui quantidade para separada para ser embalada
	If QtdComp(oMntVolItem:GetQtdOri()) == 0
		oModel:GetModel():SetErrorMessage(oModel:GetId(),"DCV_SUBLOT",,,ALUA391A07,"Produto/Rastro não pertence a montagem de volumes do documento.","Verifique os dados informados.") //"Produto/Rastro não pertence a montagem de volumes do documento."##"Verifique os dados informados."
		Return .F.
	EndIf
	//Deve validar se o produto/lote possui quantidade para separada para ser embalada
	If QtdComp(oMntVolItem:GetQtdSep()) == 0
		oModel:GetModel():SetErrorMessage(oModel:GetId(),"DCV_SUBLOT",,,ALUA391A08, "Produto/Rastro não possui quantidade separada para montagem de volumes.","Aguarde a finalização do processo de separação.") // "Produto/Rastro não possui quantidade separada para montagem de volumes."##"Aguarde a finalização do processo de separação."
		Return .F.
	EndIf
	//Deve validar se o produto/lote já foi todo montado volume
	If QtdComp(oMntVolItem:GetQtdOri()-oMntVolItem:GetQtdEmb()) == 0
		oModel:GetModel():SetErrorMessage(oModel:GetId(),"DCV_SUBLOT",,,ALUA391A09,"Montagem de volumes do Produto/Rastro finalizada.","Verifique os dados informados.") // "Montagem de volumes do Produto/Rastro finalizada."##"Verifique os dados informados."
		Return .F.
	EndIf
	//Deve validar se o produto/lote possui quantidade pendente para ser separada
	If QtdComp(oMntVolItem:GetQtdSep()-oMntVolItem:GetQtdEmb()) == 0
		oModel:GetModel():SetErrorMessage(oModel:GetId(),"DCV_SUBLOT",,,ALUA391A10,"Montagem de volumes do Produto/Rastro da quantidade separada finalizada.","Aguarde a finalização do processo de separação.") // "Montagem de volumes do Produto/Rastro da quantidade separada finalizada."##"Aguarde a finalização do processo de separação."
		Return .F.
	EndIf
Return .T.

//------------------------------------------------------------------------------
// Valida se a quantidade informada não ultrapassa o saldo no endereço
//-----------------------------------------------------------------------------
Static Function VldQtdSld(oModel,nQtde)
Local lRet       := .T.
Local nQtdResVol := 0
Local lWmsNew    := SuperGetMV("MV_WMSNEW",.F.,.F.)
// Qtde. de tolerancia p/calculos com a 1UM. Usado qdo o fator de conv gera um dizima periodica
Local nToler1UM := QtdComp(SuperGetMV("MV_NTOL1UM",.F.,0))
Local lValDisSep := .T.
	If Empty(nQtde)
		Return .F.
	EndIf
	If lRet
		nQtdResVol := oMntVolItem:GetQtdSep() - nQtde
		//If QtdComp(nQtde) > QtdComp(nQtdResVol) .And.;
		If QtdComp(nQtde) > oMntVolItem:GetQtdSep() .And.;
			QtdComp(Abs(nQtdResVol)) > QtdComp(nToler1UM)
			WmsMessage(WmsFmtMsg("Quantidade em volumes mais informada ultrapassa a quantidade separada do produto [VAR01]. Saldo disponível: [VAR02].",{{"[VAR01]",oMntVolItem:GetProduto()},{"[VAR02]",AllTrim(Str(nQtdResVol))}}),ALUA391A11,5,.T.,,"Informe uma quantidade menor para incluir no volume.") // "Quantidade em volumes mais informada ultrapassa a quantidade separada do produto [VAR01]. Saldo disponível: [VAR02].","Informe uma quantidade menor para incluir no volume."
			oModel:ClearField("DCV_CODPRO")
			oModel:ClearField("DCV_DESCR")
			oModel:ClearField("DCV_LOTE")
			oModel:ClearField("DCV_SUBLOT")
			lRet := .F.
		EndIf
	EndIf
	If lWmsNew
		// Verifica se produto controla lote e não obriga a informação no processo WMS
		// Caso não obrigue não irá realizar as validações referente a quantidade distribuida de separação se houver
		If lRet .And. Rastro(oMntVolItem:GetProduto()) .And. !__lHasLot
			lValDisSep := .F.
		EndIf		
		If lRet .And. lValDisSep .And. !WMA391AQTD(oMntVolItem:GetCarga(),oMntVolItem:GetPedido(),oMntVolItem:GetPrdOri(),oMntVolItem:GetProduto(),oMntVolItem:GetLoteCtl(),oMntVolItem:GetNumLote(),nQtde)
			lRet := .F.
		EndIf
	EndIf
Return lRet

//------------------------------------------------------------------------------
// Valida a transferência dos dados digitados pelo usuário no formulário para
// o grid sumarizando as quantidades quando necessário.
//------------------------------------------------------------------------------
/*/{Protheus.doc} RegItnVol
description
@type function
@version  
@author Deosdete Deo
@since 01/04/2023
@param oModel, object, param_description
@param oView, object, param_description
@return variant, return_description
/*/
Static Function RegItnVol(oModel,oView)
Local oModelDCVF := oModel:GetModel("ALUA391ADCVF")
Local oModelDCVG := oModel:GetModel("ALUA391ADCVG")
Local oModelDCTG := oModel:GetModel("ALUA391ADCTG")
Local cPrdOri    := oModelDCVF:GetValue("DCV_PRDORI")
Local cProduto   := oModelDCVF:GetValue("DCV_CODPRO")
Local cLoteCtl   := oModelDCVF:GetValue("DCV_LOTE")
Local cNumLote   := oModelDCVF:GetValue("DCV_SUBLOT")
Local nQuant     := 0
Local lConfirma  := .T.
Local nLinha     := 0 

//Local oModelDCU  := oModel:GetModel("ALUA391ADCU")

	// Verifica produto
	If Empty(cProduto)
		lConfirma := .F.
	EndIf

	If lConfirma
		If __lHasLot
			// Verifica lote
			If Rastro(cProduto) .And. Empty(cLoteCtl)
				oView:Refresh()
				oView:GetViewObj("ALUA391ADCVF")[3]:getFWEditCtrl("DCV_LOTE"):oCtrl:SetFocus()
				lConfirma := .F.
			EndIf
			// Verifica sub-lote
			If lConfirma .And. Rastro(cProduto,"S") .And. Empty(cNumLote)
				oView:Refresh()
				oView:GetViewObj("ALUA391ADCVF")[3]:getFWEditCtrl("DCV_SUBLOT"):oCtrl:SetFocus()
				lConfirma := .F.
			EndIf
		Else
			oMntVolItem:QtdPrdVol() // Deve carregar as quantidades neste ponto
		EndIf
	EndIf

	// Verifica quantidade
	If lConfirma .And. oModelDCVF:GetValue("DCV_QUANT") <= 0
		oView:Refresh()
		oView:GetViewObj("ALUA391ADCVF")[3]:getFWEditCtrl("DCV_QUANT"):oCtrl:SetFocus()
		lConfirma := .F.
	EndIf

	If lConfirma
		// Deve validar contra a quantidade que já está tela inclusive
		If oModelDCVG:SeekLine({{"DCV_PRDORI", cPrdOri},{"DCV_CODPRO", cProduto},{"DCV_LOTE", cLoteCtl},{"DCV_SUBLOT", cNumLote}})
			nQuant := oModelDCVG:GetValue("DCV_QUANT") + oModelDCVF:GetValue("DCV_QUANT")
		Else
			nQuant := oModelDCVF:GetValue("DCV_QUANT") //total virtual
		EndIf
		If !VldQtdSld(oModelDCVF,nQuant)
			oView:Refresh()
			oView:GetViewObj("ALUA391ADCVF")[3]:getFWEditCtrl("DCV_CODPRO"):oCtrl:SetFocus()
			lConfirma := .F.
		EndIf
	EndIf

	// Preenche modelo de dados
	If lConfirma
		oModelDCVG:SetNoInsertLine(.F.)
		// Cria itens na DCY
		If oModelDCVG:SeekLine({{"DCV_PRDORI", cPrdOri},{"DCV_CODPRO", cProduto},{"DCV_LOTE", cLoteCtl},{"DCV_SUBLOT", cNumLote}})
			oModelDCVG:SetValue("DCV_QUANT", nQuant)
		Else
			oModelDCVG:GoLine(oModelDCVG:Length())
			If !oModelDCVG:IsEmpty()
				oModelDCVG:AddLine()
			EndIf

			oModelDCVG:SetValue("DCV_PRDORI", cPrdOri)
			oModelDCVG:SetValue("DCV_CODPRO", cProduto)
			oModelDCVG:SetValue("DCV_DESCR",  Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC"))
			oModelDCVG:SetValue("DCV_LOTE", cLoteCtl)
			oModelDCVG:SetValue("DCV_SUBLOT", cNumLote)
			oModelDCVG:SetValue("DCV_QUANT" , nQuant)
		EndIf
		oModelDCVG:SetNoInsertLine(.T.)
		oModelDCVG:GoLine(1)
		// Inicializa valores
		oModelDCVF:LoadValue("DCV_QUANT",1)
		oModelDCVF:ClearField("DCV_CODPRO")
		oModelDCVF:ClearField("DCV_DESCR")
		oModelDCVF:ClearField("DCV_LOTE")
		oModelDCVF:ClearField("DCV_SUBLOT")
	
		//Atualizar a quantidade embalada nos itens do pedido
		//If 
		//oModelDCVG:SeekLine({{"DCT_PRDORI", cPrdOri},{"DCT_CODPRO", cProduto},{"DCT_LOTE", cLoteCtl},{"DCT_SUBLOT", cNumLote}}) 
	
		//oModelDCTG:SetOnlyQuery(.F.)
		//oModelDCTG:SetValue("DCT_QTEMBA", nQuant)
		//oModelDCTG:SetOnlyQuery(.T.)
		//EndIf

		For nLinha := 1 To oModelDCTG:Length()

			//Posicionando na linha atual
			oModelDCTG:GoLine(nLinha)

			If oModelDCTG:GetValue("DCT_PRDORI") == cProduto .AND. ;
				oModelDCTG:GetValue("DCT_PRDORI") == cPrdOri  .AND. ;
				oModelDCTG:GetValue("DCT_LOTE") == cLoteCtl
				oModelDCTG:SetValue("DCT_QTEMBA", nQuant )
				oModelDCTG:SetValue("DCT_STATUS", "2" )
			EndIf 
			
			oModelDCTG:GoLine(1)

		Next




		oView:Refresh()
		oView:GetViewObj("ALUA391ADCVF")[3]:getFWEditCtrl("DCV_CODPRO"):oCtrl:SetFocus()
	EndIf
Return lConfirma

//------------------------------------------------------------------------------
// Efetua as validações do módel antes da inclusão, reavaliando o saldo e não
// deixa incluir um volume sem ter itens informados.
//------------------------------------------------------------------------------
/*/{Protheus.doc} ValidMdl
description
@type function
@version  
@author Deosdete Deo
@since 01/04/2023
@param oModel, object, param_description
@return variant, return_description
/*/
/*
Static Function ValidMdl(oModel)
Local oModelDCU  := oModel:GetModel("ALUA391ADCU")
Local oModelDCVG := oModel:GetModel("ALUA391ADCVG")
Local nI         := 0
Local lRet       := .T.
Local lAchou     := .F.
Local nQtde      := 0
Local nQtdResVol := 0
// Qtde. de tolerancia p/calculos com a 1UM. Usado qdo o fator de conv gera um dizima periodica
Local nToler1UM := QtdComp(SuperGetMV("MV_NTOL1UM",.F.,0))

	If oModel:GetOperation() == MODEL_OPERATION_INSERT
		For nI := 1 To oModelDCVG:Length()
			oModelDCVG:GoLine(nI)
			If !Empty(oModelDCVG:GetValue("DCV_CODPRO"))
				lAchou := .T.
				oMntVolItem:SetProduto(oModelDCVG:GetValue("DCV_CODPRO"))
				oMntVolItem:SetLoteCtl(oModelDCVG:GetValue("DCV_LOTE"))
				oMntVolItem:SetNumLote(oModelDCVG:GetValue("DCV_SUBLOT"))
				oMntVolItem:SetPrdOri(oModelDCVG:GetValue("DCV_PRDORI"))
				oMntVolItem:QtdPrdVol() // Valida novamente a quantidade em estoque
				nQtde := oModelDCVG:GetValue("DCV_QUANT")
				nQtdResVol := oMntVolItem:GetQtdSep() - nQtde
				//If QtdComp(nQtde) > QtdComp(nQtdResVol) .And.;
				If QtdComp(nQtde) > QtdComp(oMntVolItem:GetQtdSep()) .And.;
					QtdComp(Abs(nQtdResVol)) > QtdComp(nToler1UM)
					oModel:SetErrorMessage(oModelDCVG:GetId(),"DCV_CODPRO",,,ALUA391A12,WmsFmtMsg("Quantidade em volumes mais informada ultrapassa a quantidade separada do produto [VAR01]. Saldo disponível: [VAR02].",{{"[VAR01]",oMntVolItem:GetProduto()},{"[VAR02]",AllTrim(Str(nQtdResVol))}}),"Informe uma quantidade menor para incluir no volume.") // // "Quantidade em volumes mais informada ultrapassa a quantidade separada do produto [VAR01]. Saldo disponível: [VAR02].","Informe uma quantidade menor para incluir no volume."
					lRet := .F.
					Exit
				EndIf
			EndIf
		Next nI

		If !lAchou
			oModel:SetErrorMessage(oModelDCVG:GetId(),"DCV_CODPRO",,,ALUA391A14,"Não é possível inserir volumes sem itens.","Informe pelo menos um item para montagem de volumes.") // "Não é possível inserir volumes sem itens.","Informe pelo menos um item para montagem de volumes."
			lRet := .F.
		EndIf

		If lRet
			oModelDCU:SetValue("DCU_DATFIM",dDataBase)
			oModelDCU:SetValue("DCU_HORFIM",Time())
		EndIf
	EndIf
Return lRet
*/
//------------------------------------------------------------------------------
// Efetua a gravação dos dados do modelo nas tabelCommitMdlas oficiais
//------------------------------------------------------------------------------
/*/{Protheus.doc} CommitMdl
description
@type function
@version  
@author Deosdete Deo
@since 01/04/2023
@param oModel, object, param_description
@return variant, return_description
/*/
/*Static Function CommitMdl(oModel)
Local lRet       := .T.
Local oModelDCVG := oModel:GetModel("ALUA391ADCVG")
Local oModelDCU  := oModel:GetModel("ALUA391ADCU")
Local aProdutos  := {}
Local nI         := 0
Local oView      := FWViewActive()


	For nI := 1 To oModelDCVG:Length()
		oModelDCVG:GoLine(nI)
		oMntVolItem:SetProduto(oModelDCVG:GetValue("DCV_CODPRO"))
		oMntVolItem:SetLoteCtl(oModelDCVG:GetValue("DCV_LOTE"))
		oMntVolItem:SetNumLote(oModelDCVG:GetValue("DCV_SUBLOT"))
		oMntVolItem:SetPrdOri(oModelDCVG:GetValue("DCV_PRDORI"))
		
		oMntVolItem:QtdPrdVol() // Valida novamente a quantidade em estoque -
		
		//Caso seja alteracao deve ser retirada a quantidade ja embalada anteriormente para passar pela validacao do padrao
		//Chamar load somente se houve acrescimo no item no volume
		If Abs((oModelDCVG:GetValue("DCV_QUANT") - oMntVolItem:GetQtdEmb())) > 0
			If !oMntVolItem:LoadPrdVol(aProdutos,oModelDCVG:GetValue("DCV_QUANT") - oMntVolItem:GetQtdEmb() )
				oModel:SetErrorMessage(oModelDCVG:GetId(),"DCV_CODPRO",,,ALUA391A15,oMntVolItem:GetErro(),"Verifique os dados informados") // Verifique os dados informados
				lRet := .F.
				Exit
			EndIf
		EndIf

	Next nI

	If lRet
		If !oMntVolItem:MntPrdVol(aProdutos)
			oModel:SetErrorMessage(oModelDCVG:GetId(),"DCV_CODPRO",,,ALUA391A21,oMntVolItem:GetErro(),'Verifique os dados informados') // Verifique os dados informados
			lRet := .F.
		EndIf
	EndIf
	
	//Grava os campos customizados pois o objeto oMntVolItem do padrao utilizado aqui pra regitrar a montagem nao salva
	//Posicionar, pois o objeto de gravacao nao preservou o posicionamento
	DbSelectArea("DCU")
	DbSetOrder(1) // DCU_FILIAL+DCU_CODVOL+DCU_CODMNT                                                                                                                                
	If DCU->(DbSeek(xFilial("DCU")+oModelDCU:GetValue("DCU_CODVOL")+oModelDCU:GetValue("DCU_CODMNT")))
		RecLock("DCU", .F.)
		DCU->DCU_XCODEM := oModelDCU:GetValue("DCU_XCODEM")
		DCU->DCU_XCUBAG := oModelDCU:GetValue("DCU_XCUBAG") 
		DCU->(MsUnlock())
	EndIf

	If lRet //.And. oMntVolItem:oMntVol:GetStatus() == "3"
		
		GerEtqVol(lIndividual) // Se não gerar as etiquetas, não impede a gravação

	EndIf
	If lRet .And. oView != Nil
		oView:setInsertMessage("SIGAWMS",WmsFmtMsg("Volume [VAR01] inserido com sucesso.",{{"[VAR01]",oMntVolItem:oVolume:GetCodVol()}})) // "Volume [VAR01] inserido com sucesso."
	EndIf
Return lRet

//-------------------------------------------------------------------//
//------------Função de geração de etiquetas dos volumes-------------//
//-------------------------------------------------------------------//
*/


/*/{Protheus.doc} GerEtqVol
description
@type function
@version  
@author Deosdete Deo
@since 01/04/2023
@return variant, return_description
/*/
Static Function GerEtqVol(lIndividual, cLocImp)
Local aAreaAnt  := GetArea()
Local lRet      := .T.
Local lLocImp   := .T.
Local cQuery    := ""
Local cAliasDCU := ""
Local lExecBlc  := !SuperGetMV("MV_WMSNEW",.F.,.F.) .And. ExistBlock("WMSR410A")

Default cLocImp   := SuperGetMV('MV_WMSLOCI',.F.,'')

	// Pergunta se será feita a impressão da Etiqueta
	If !lIndividual
		lRet := WmsQuestion("Deseja imprimir as etiquetas de Volume?","SIGAWMS") // Deseja imprimir as etiquetas de Volume?
	EndIf
	
	If lRet
		If Empty(cLocImp)
			cLocImp := Space(TamSX3("CB5_CODIGO")[1])
			DEFINE MSDIALOG oDlgLI TITLE "Informe local da impressão" From 50,50 to 120,280 PIXEL // Informe local da impressão

				@ 06,05 SAY "Local de Impressão:" SIZE 50,8 OF oDlgLI PIXEL // Local de Impressão:"
				@ 05,60 MSGET oGetLI VAR cLocImp F3 'CB5' SIZE 50,06 WHEN .T. PICTURE '@!' OF oDlgLI PIXEL
				DEFINE SBUTTON FROM 21,083 TYPE 1 ACTION (nOpcLI := 1,oDlgLI:End()) ENABLE Of oDlgLI

			ACTIVATE DIALOG oDlgLI CENTERED

			If !CB5SetImp(cLocImp,IsTelNet())
				WmsMessage("Local de impressão inválido!",ALUA391A16,1) // Local de impressão inválido!
				lLocImp := .F.
			EndIf

		ElseIf !CB5SetImp(cLocImp,IsTelNet())
			WmsMessage("Local de impressão inválido!",ALUA391A17) // Local de impressão inválido!
			lLocImp := .F.
		EndIf
		If lLocImp
			cQuery := "SELECT DCU_CODVOL"
			cQuery +=  " FROM "+RetSqlName('DCU')+" DCU"
			cQuery += " WHERE DCU_FILIAL = '"+xFilial('DCU')+"'"
			cQuery +=   " AND DCU_CARGA = '"+oMntVolItem:GetCarga()+"'"
			cQuery +=   " AND DCU_PEDIDO = '"+oMntVolItem:GetPedido()+"'"
			cQuery +=   " AND DCU_CODMNT = '"+oMntVolItem:GetCodMnt()+"'"
			
			If lIndividual
				cQuery +=   " AND DCU_CODVOL = '"+oMntVolItem:oVolume:GetCodVol()+"'"
			EndIf

			cQuery +=   " AND DCU.D_E_L_E_T_ = ' '"
			cAliasDCU := GetNextAlias()
			DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasDCU,.F.,.T.)
			Do While (cAliasDCU)->(!Eof())
				If lExecBlc
					ExecBlock("WMSR410A",.F.,.F.,{(cAliasDCU)->DCU_CODVOL,.T.})
				Else
					WMSR410A((cAliasDCU)->DCU_CODVOL,.T.)
				Endif
				(cAliasDCU)->(DbSkip())
			EndDo

			(cAliasDCU)->(DbCloseArea())
			MSCBCLOSEPRINTER()
		EndIf
	EndIf

	RestArea(aAreaAnt)
Return lRet


//------------------------------------------------------------------
// Verifica se o produto distribuição realizada
//------------------------------------------------------------------
/*/{Protheus.doc} WMA391AQTD
description
@type function
@version  
@author Deosdete Deo
@since 01/04/2023
@param cCarga, character, param_description
@param cPedido, character, param_description
@param cPrdori, character, param_description
@param cProduto, character, param_description
@param cLoteCtl, character, param_description
@param cNumLote, character, param_description
@param nQtdMnt, numeric, param_description
@return variant, return_description
/*/
User Function WMA391AQTD(cCarga,cPedido,cPrdori,cProduto,cLoteCtl,cNumLote,nQtdMnt)
Local lRet        := .T.
Local oMntVolItem := Nil
Local oDisSepItem := Nil
Local oProdComp   := Nil
Local aDisSep     := {}
Local nQtdOriMnt  := 0
Local nQtdEmbal   := 0
Local nQtdDis     := 0
Local nQtdOri     := 0
Local nQtdSDi     := 0
Local nQtdMult    := 0
Local nQtdMntAux  := 0
Local nI          := 0
Local cProdutAux  := ""
Local cPrdOriAux  := ""

Default cCarga   := Space(TamSX3("DCT_CARGA")[1])
Default cPedido  := Space(TamSX3("DCT_PEDIDO")[1])
Default cPrdOri  := Space(TamSX3("DCT_PRDORI")[1])
Default cProduto := Space(TamSX3("DCT_CODPRO")[1])
Default cLoteCtl := Space(TamSX3("DCT_LOTE")[1])
Default cNumLote := Space(TamSX3("DCT_SUBLOT")[1])
Default nQtdMnt  := 0

	oProdComp := WMSDTCProdutoComponente():New()
	oProdComp:SetPrdOri(cPrdOri)
	oProdComp:SetProduto(cProduto)
	oProdComp:EstProduto()
	aProduto := oProdComp:GetArrProd()

	For nI := 1 To Len(aProduto)
		cProdutAux := aProduto[nI][1]
		cPrdOriAux := aProduto[nI][3]
		nQtdMult   := aProduto[nI][2]
		nQtdMntAux := nQtdMnt * nQtdMult

		//Valida se possui distribuição de separação, apenas se já não foi validado o volume
		If QtdComp(nQtdMnt) > QtdComp(0)
			oMntVolItem := WMSDTCMontagemVolumeItens():New()
			oMntVolItem:SetCarga(cCarga)
			oMntVolItem:SetPedido(cPedido)
			oMntVolItem:SetPrdOri(cPrdOriAux)
			oMntVolItem:SetProduto(cProdutAux)
			oMntVolItem:SetLoteCtl(cLoteCtl)
			oMntVolItem:SetNumLote(cNumLote)
			// Atribui o codigo da montagem do modelo de dados
			oMntVolItem:SetCodMnt(oMntVolItem:oMntVol:FindCodMnt())
			// Busca a quantidade origem
			aMntVol := oMntVolItem:CalcQtdMnt()
			nQtdOriMnt := aMntVol[1] // Quantidade total origem
			nQtdEmbal  := aMntVol[2] // Quantidade total montada
			If QtdComp(nQtdOriMnt) > QtdComp(0)
				oDisSepItem := WMSDTCDistribuicaoSeparacaoItens():New()
				//Valida se possui distribuição de separação, apenas se já não foi validado o volume
				oDisSepItem:SetCarga(cCarga)
				oDisSepItem:SetPedido(cPedido)
				oDisSepItem:SetPrdOri(cPrdOriAux)
				oDisSepItem:SetProduto(cProdutAux)
				oDisSepItem:SetLoteCtl(cLoteCtl)
				oDisSepItem:SetNumLote(cNumLote)
				// Busca quantidade sumarizada da distribuição de separação
				aDisSep := oDisSepItem:ChkQtdDis(oMntVolItem:GerAIdDCF())
				nQtdOri := aDisSep[1] // Quantidade original de montagens de volume com distribuição de separação
				nQtdDis := aDisSep[2] - nQtdEmbal // Quantidade distribuida
				nQtdSDi := nQtdOriMnt - nQtdOri // Calcula a diferença entre a quantidade a montar e a distribuir.
				If QtdComp(nQtdOri) > QtdComp(0) .And. QtdComp(nQtdMntAux) > QtdComp(nQtdDis + nQtdSDi)
					WmsMessage(WmsFmtMsg("Quantidade do produto [VAR01] da montagem não possui distribuição de separação, primeiro realize a distribuição!",{{"[VAR01]",cProdutAux}}),ALUA391A13)  //Quantidade do produto [VAR01] da montagem não possui distribuição de separação, primeiro realize a distribuição!
					lRet := .F.
				EndIf
			EndIf
		EndIf
		If !lRet
			Exit
		EndIf
	Next nI
Return lRet



/*/{Protheus.doc} PegCodEmb
description
@type function
@version  
@author Deosdete Deo
@since 01/04/2023
@return variant, return_description
/*/
User Function PegCodEmb(cCodEmb)
Local oGetCodEmb
Local cEmbPad := SuperGetMV("MV_XEMBPAD",.F.,"CX1")
Local aRetEmb := {"",0,0,""}
Local oBtn1
Local oBtn2
Local nOpc    := 0 
Local oDlgLI
Local nCubag := 0
Local cEmbaDesc := ""
Local cLocImp   := SuperGetMV('MV_WMSLOCI',.F.,'')

If Empty(cCodEmb)
	cCodEmb := Space(TamSX3("DCU_XCODEM")[1]) 
EndIf	

DEFINE MSDIALOG oDlgLI TITLE "Informe o Tipo de Embalagem" From 50,50 to 200,300 PIXEL

	@ 06,05 SAY "Tipo de Embalagem:" SIZE 50,8 OF oDlgLI PIXEL 
	@ 05,60 MSGET oGetCodEmb VAR cCodEmb F3 'CB3' SIZE 50,06 WHEN .T. VALID VldEmba(cCodEmb, @nCubag, @cEmbaDesc) PICTURE '@!' OF oDlgLI PIXEL
	@ 21,05 SAY "Local de Impressão:" SIZE 50,8 OF oDlgLI PIXEL // Local de Impressão:"
	@ 20,60 MSGET oGetLI VAR cLocImp F3 'CB5' SIZE 50,06 WHEN .T. PICTURE '@!' OF oDlgLI PIXEL
	
	//DEFINE SBUTTON FROM 21,083 TYPE 2 ACTION (nOpcLI := 2,oDlgLI:End()) ENABLE Of oDlgLI
	//DEFINE SBUTTON FROM 21,083 TYPE 1 ACTION (nOpcLI := 1,oDlgLI:End()) ENABLE Of oDlgLI
	@ 048,010 BUTTON oBtn1 PROMPT "Conf. Manual" SIZE 040,012 OF oDlgLI PIXEL ACTION (oDlgLI:End(), nOpc := 2)
	@ 048,080 BUTTON oBtn2 PROMPT "Ok" SIZE 040,012 OF oDlgLI PIXEL ACTION (oDlgLI:End(), nOpc := 1)

ACTIVATE DIALOG oDlgLI CENTERED

If !Empty(cCodEmb)
	aRetEmb[1] := cCodEmb
	aRetEmb[2] := nCubag //CB3->CB3_ALTURA * CB3->CB3_LARGUR * CB3->CB3_PROFUN
	aRetEmb[3] := nOpc
	aRetEmb[4] := cLocImp
Else
	WmsMessage("Tipo de embalagem inválido! Será considerado o tipo padrão informado no parametor MV_XEMBPAD = "+ cEmbPad,ALUA391A16,1) 
	cCodEmb := cEmbPad
EndIf



Return aRetEmb



/*/{Protheus.doc} VldEmba
description
@type function
@version  
@author Deosdete Deo
@since 10/23/2023
@param cCodEmb, character, param_description
@return variant, return_description
/*/
Static Function VldEmba(cCodEmb, nCubag, cEmbaDesc)
Local lRet   := .T.

If !Empty(cCodEmb) 

	DbSelectArea("CB3")
	DbSetOrder(1) //CB3_FILIAL+CB3_CODEMB
	If CB3->(DbSeek(xFilial("CB3")+cCodEmb))
		cEmbaDesc := CB3->CB3_DESCRI
		nCubag  := CB3->CB3_ALTURA * CB3->CB3_LARGUR * CB3->CB3_PROFUN
	
	Else	
		lRet := .F.
	EndIf
Else
	MsgStop("Embalagem invalida","Erro!!!")
	lRet := .F.
EndIf


Return lRet




/*/{Protheus.doc} A391MANU
description
@type function
@version  
@author Deosdete Deo
@since 18/04/2023
@return variant, return_description
/*/
User Function A391MANU(cProduto,cLoteCtl,cSubLote,nQtd,cCodBar,cCodMNT, cCodVol,cPedido,aBeeps, cCodEmb, nCubag, cLocImp)
Local oGetCodBar
Local oGetCod
Local oGetProd
Local oDlgTela
Local oFont16:= TFont():New('Arial',,16,.T.)
Local oFont20:= TFont():New('Arial',,20,.T.)
Local cCodPro := Space(TamSX3("B1_COD")[1]+20)
Local cDesPro := Space(TamSX3("B1_DESC")[1]) 
Local nQtdEmb := 0
Local nQtdVol := 1
Local nI    := 0
Local aProdutos := {}
Local lRet      := .T.
Local oMntVolManu := WMSDTCMontagemVolumeItens():New()
Local lIndividual := .T.
Local oBrwDCTA 
Local oPanelMNT
Local nQtdGerado := 0
Local nOpc      := 0 


DEFINE MSDIALOG oDlgTela TITLE "Conferência Manual" From 00,00 to 500,700 PIXEL


//Disponibilidade de estoque
//TGet(): New ( [ nRow], [ nCol], [ bSetGet], [ oWnd], [ nWidth], [ nHeight], [ cPict], [ bValid], [ nClrFore], [ nClrBack], [ oFont], [ uParam12], [ uParam13], [ lPixel], [ uParam15], [ uParam16], [ bWhen], [ uParam18], [ uParam19], [ bChange], [ lReadOnly], [ lPassword], [ uParam23], [ cReadVar], [ uParam25], [ uParam26], [ uParam27], [ lHasButton], [ lNoButton], [cLabelText] ,[nLabelPos], [oLabelFont], [nLabelColor]  ) --> oObjeto
oSayCodBar  := TSay():New(015,005,{||"Cod de Barras"},oDlgTela,,oFont16,,,,.T.,CLR_GRAY,CLR_WHITE,050,012)
oGetCodBar	:= TGet():New(015,080		,{|u| if(PCount()>0,cCodBar:=u,cCodBar)},oDlgTela,Len(cCodBar)*10,12,,{|| Empty(cCodBar)  .OR.  VldPrdManu(@cCodPro,@cLoteCtl,@nQtdEmb,cCodBar, oGetCodBar,oGetQtdVol,@cDesPro)},,,,,,.T.,,,{|| .T.},,,,,,,'cCodBar')

oSayCod     := TSay():New(030,005,{||"Cod Produto"},oDlgTela,,oFont16,,,,.T., CLR_GRAY,CLR_WHITE,50,012)
oGetCod	    := TGet():New(030,080		,{|u| if(PCount()>0,cCodPro:=u,cCodPro)},oDlgTela,Len(cCodPro),10,,,,,,,,.T.,,,{|| .F.},,,,,,,'cCodPro')
oGetProd	:= TGet():New(030,120		,{|u| if(PCount()>0,cDesPro:=u,cDesPro)},oDlgTela,Len(cDesPro),10,,,,,,,,.T.,,,{|| .F.},,,,,,,'cDesPro')

oSayQtdEmb  := TSay():New(045,005,{||"Qtd por Embalagem"},oDlgTela,,oFont16,,,,.T., CLR_GRAY,CLR_WHITE,075,012)
oGetQtdEmb  := TGet():New(045,080		,{|u| if(PCount()>0,nQtdEmb:=u,nQtdEmb)},oDlgTela,90,10,,,,,,,,.T.,,,{|| .F.},,,,,,,'nQtdEmb')

oSayQtdVol := TSay():New(060,005,{||"Qtd de Volumes"},oDlgTela,,oFont16,,,,.T., CLR_GRAY,CLR_WHITE,075,012)
oGetQtdVol := TGet():New(060,080,{|u| if(PCount()>0,nQtdVol:=u,nQtdVol)},oDlgTela,90,10,"@E 999,999",{||nQtdVol>0},,,,,,.T.,,,{|| .T.},,,,,,,'nQtdVol')

oButConfirmar := TButton():New( 100, 085, "Confirmar",oDlgTela,{||nOpc := 1,oDlgTela:End()}, 040,016,,oFont20,.F.,.T.,.F.,,.F.,,,.F. )
oButCancelar  := TButton():New( 100, 130, "Sair",oDlgTela,{|| nOpc := 0,oDlgTela:End()}, 040,016,,oFont20,.F.,.T.,.F.,,.F.,,,.F. )


oPanelMNT:= tPanel():New(001,001,"Itens do Pedido",oDlgTela,oFont16,.T.,,CLR_WHITE,CLR_WHITE,150,100)
oPanelMNT:Align :=CONTROL_ALIGN_BOTTOM


// Define Browse Documento (DCT)
oBrwDCTA := FWMBrowse():New()
oBrwDCTA:SetOwner(oPanelMNT)
oBrwDCTA:SetDescription("Itens dos Docs. na Mont. Volume") 
oBrwDCTA:SetAlias('DCT')
oBrwDCTA:SetFilterDefault("@ DCT_FILIAL = '"+xFilial('DCT')+"' AND DCT_CODMNT = '"+cCodMNT+"'")
oBrwDCTA:SetMenuDef('')
//If nAcao == 1
//	oBrwDCTA:AddButton(STR0014, {|| oTimer:DeActivate(), WmA391Esto(), oTimer:Activate()},, 4, 0) // Estornar Documento
//EndIf
oBrwDCTA:AddLegend("DCT->DCT_STATUS=='1'", "RED"   , "Nao Iniciado") 
oBrwDCTA:AddLegend("DCT->DCT_STATUS=='2'", "YELLOW", "Em Andamento") 
oBrwDCTA:AddLegend("DCT->DCT_STATUS=='3'", "GREEN" , "Em Andamento")
oBrwDCTA:SetAmbiente(.F.)
oBrwDCTA:SetWalkThru(.F.)
oBrwDCTA:DisableDetails()
oBrwDCTA:SetFixedBrowse(.T.)
oBrwDCTA:SetProfileID('DCT')
oBrwDCTA:DisableReports()
oBrwDCTA:DisableFilter()
oBrwDCTA:DisableConfig()
oBrwDCTA:DisableReport()
oBrwDCTA:DisableSeek()
oBrwDCTA:DisableSaveConfig()
oBrwDCTA:SetOnlyFields({'DCT_PEDIDO','DCT_CODPRO','DCT_QTORIG','DCT_QTSEPA','DCT_QTEMBA'})
oBrwDCTA:Activate()

ACTIVATE DIALOG oDlgTela CENTERED

If nOpc == 1 

	If !Empty(cCodPro) .AND. !Empty(nQtdEmb)
		
		//Perguntar o tipo de embalagem e cubatem
		//aRetEmb := u_PegCodEmb(DCU->DCU_XCODEM)

		//Acrescentar volumes usando o componente da montagem de volumes
		//Alert("Em desenvolvimento")
		nQtdGerado := 0
		
		
		For nI := 1 To nQtdVol

			//Limpara arrray para o proximo volume
			aProdutos := {}

			//Pegar proximo volume
			cCodVol  := U_ALUCBProxCod()
			oMntVolManu:oMntVol:SetCodMnt(cCodMNT)
			//oMntVolManu:oMntVol:SetCarga(oModelDCU:GetValue("DCU_CARGA"))
			oMntVolManu:oMntVol:SetPedido(cPedido)
			oMntVolManu:oVolume:SetCodVol(cCodVol)

			//Validar
			//VldPrdLot(cProduto,cLoteCtl,cSubLote,nQtd,cCodBar, , , cCodMNT, cCodVol,cPedido,aBeeps)
			// Deve validar se o produto informado é um produto partes ou componente
			oMntVolManu:SetProduto(cCodPro)
			oMntVolManu:SetLoteCtl(cLoteCtl)
			oMntVolManu:SetNumLote(cSubLote)
			lAchou := oMntVolManu:VldPrdCmp()

			If !lAchou
				MsgStop("Produto não pertence a montagem de volumes do documento.","Verifique os dados informados.") 
				lRet := .F.
			Else
				//lRet := oModel:LoadValue("DCV_PRDORI",oMntVolManu:GetPrdOri())
			EndIf

			If lRet
				// Carregar as quantidades para o produto
				oMntVolManu:QtdPrdVol()
				//Deve validar se o produto possui quantidade para separada para ser embalada
				If QtdComp(oMntVolManu:GetQtdSep()) == 0
					MsgStop("Produto não possui quantidade separada para montagem de volumes.","Aguarde a finalização do processo de separação.") 
					lRet := .F.
				EndIf
				//Deve validar se o produto possui quantidade para separada pendente para ser embalada
				If lRet .And. QtdComp(oMntVolManu:GetQtdOri()-oMntVolManu:GetQtdEmb()) == 0
					MsgStop("Quantidade total conferida ultrapassa a quantidade do item.","Erro!!!") 
					lRet := .F.
				EndIf
				//Deve validar se o produto possui quantidade para separada pendente para ser embalada
				If lRet .And. QtdComp(oMntVolManu:GetQtdSep()-oMntVolManu:GetQtdEmb()) == 0
					MsgStop("Produto não possui quantidade separada pendente para montagem de volumes.","Aguarde a finalização do processo de separação.")
					lRet := .F.
				EndIf
				
				
				nSldaEmb := oMntVolManu:GetQtdSep()-oMntVolManu:GetQtdEmb()

				//Deve validar se para este produto a qtd ainda nao confirmada nao ultrapassa o saldo total
				//nQtdaConfirmar := PegQtdaConfirmar(cProduto,cCodMnt,cCodVol)
				//nPos := aScan(aBeeps, {|x| x[2] == cCodPro} )
				//If nPos > 0 
				nSldaEmb := nSldaEmb - PegSldBeeps(aBeeps,cCodPro) //[nPos][3] aBeeps[nPos][3]
				//EndIf 
				
				If lRet .And. (nSldaEmb - nQtd) < 0
					MsgStop("Produto não possui quantidade separada pendente suficiente SALDO:" + Transform(nSldaEmb,PesqPict("DCV","DCV_QUANT")) + " QTD LIDA:" + Transform(nQtd,PesqPict("DCV","DCV_QUANT")),"Aguarde a finalização do processo de separação.")
					lRet := .F.
				EndIf
				

			EndIf
			
			//Fechar embalagem
			If lRet

				oMntVolManu:SetProduto(cCodPro)
				oMntVolManu:SetLoteCtl("")
				oMntVolManu:SetNumLote("")
				oMntVolManu:SetPrdOri(cCodPro)
				If !oMntVolManu:LoadPrdVol(aProdutos,nQtdEmb)
					//oModel:SetErrorMessage(oModelDCVG:GetId(),"DCV_CODPRO",,,WMSA391A15,oMntVolManu:GetErro(),STR0016) //
					MsgStop(oMntVolManu:GetErro() + ".Verifique os dados informados","Erro")
					lRet := .F.
					Exit
				EndIf

				oMntVolManu:SetStatus("2")

				If oMntVolManu:MntPrdVol(aProdutos)
					nQtdGerado++ 
					
					//pega a DCU gerada 
					DbSelectArea("DCU")
					DbSetOrder(1) //DCU_FILIAL+DCU_CODVOL+DCU_CODMNT                                                                                                                                
					If DCU->(DbSeek(xFilial("DCU")+cCodVol+cCodMNT))
						RecLock("DCU",.F.)
						DCU->DCU_XCODEM  := cCodEmb  // oModelDCU:SetValue("DCU_XCODEM",DCU->DCU_XCODEM)
						DCU->DCU_XCUBAG  := nCubag   //oModelDCU:SetValue("DCU_XCUBAG",DCU->DCU_XCUBAG)
						DCU->(MsUnlock())

						//Gravar informacoes da montagem no pedido
						U_PESOVOL(DCU->DCU_PEDIDO)

					EndIf

				Else
					//oModel:SetErrorMessage(oModelDCVG:GetId(),"DCV_CODPRO",,,WMSA391A21,oMntVolItem:GetErro(),STR0016) // 
					MsgStop("Verifique os dados informados","Erro!!!")
					lRet := .F.
				EndIf

			EndIf

			/*
				//Poscionar no SC9 correspondente
				DbSelectArea("SC9")
				DbSetOrder(1) //C9_FILIAL+C9_PEDIDO

				DbSelectArea("DCV")
				DCV->(DbSetOrder(1)) // DCV_FILIAL+DCV_CODVOL+DCV_PRDORI+DCV_CODPRO+DCV_LOTE+DCV_SUBLOT+DCV_ITEM+DCV_SEQUEN+DCV_CODMNT
				lAchou := DCV->(dbSeek(xFilial("DCV")+cCodMNT+cCodVol+cProduto))

				Reclock('DCV',!lAchou)
				If !lAchou
					DCV->DCV_Filial := xFilial("DCT")
					DCV->DCV_CODVOL := cCodVol
					DCV->DCV_CODMNT := cCodMNT
					DCV->DCV_CARGA  := cCarga	
					DCV->DCV_PEDIDO := cPedido
					DCV->DCV_STATUS := " "
					DCV->DCV_PRDORI := cProduto
					DCV->DCV_CODPRO := cProduto
					DCV->DCV_LOTE   := cLoteCtl
					DCV->DCV_SUBLOT := cSubLote
					DCV->DCV_QUANT  := nQtd
					DCV->DCV_CODOPE := __cUserID
					//DCV->DCV_ITEM   := Self:cItem
					//DCV->DCV_SEQUEN := Self:cSequen
					//DCV->DCV_DATINI := Self:dDtInicio
					//DCV->DCV_HORINI := Self:cHrInicio
					DCV->DCV_DATINI := dDataBase
					DCV->DCV_HORINI := Time()
				Else
					//DCV->DCV_STATUS := Self:cStatus
					//DCV->DCV_DATFIM := dDataBase
					//DCV->DCV_HORFIM := Time()
					DCV->DCV_QUANT  += nQtd
				EndIf
				DCV->(MsUnLock())	


				
				If nPos > 0
					aBeeps[nPos][2] += nQtd
				Else
					aAdd(aBeeps,{cProduto, nQtd})
				EndIf

			EndIf
			*/
			//oBrowDCV:Refresh()
			//oTGetCod:SetFocus()

			//EndIf





			//Fechar embalagem
			//FecharEmb(, nQtd,,cCodEmb, nCubag, cCodVol,cCodMNT)

			If lRet //.And. oMntVolItem:oMntVol:GetStatus() == "3"
				oMntVolItem := oMntVolManu
				GerEtqVol(lIndividual, cLocImp) // Se não gerar as etiquetas, não impede a gravação
			Else
				Exit
			EndIf

		Next nI

		If lRet .AND. nQtdGerado > 0
			MsgInfo("Volumes","Inserido com sucesso. " + AllTrim(Str(nQtdGerado)) )
		EndIf
	Else
		MsgStop("Volumes","Codigo de barras ou quantidade de volumes nao informado!")

	EndIf

EndIf

oBrwDCTA:Destroy()

Return 




/*/{Protheus.doc} VldPrdMnu
description
@type function
@version  
@author Deosdete Deo
@since 18/04/2023
@param oModel, object, param_description
@param oView, object, param_description
@param cProduto, character, param_description
@param cLoteCtl, character, param_description
@param cSubLote, character, param_description
@param nQtde, numeric, param_description
@param cCodBar, character, param_description
@return variant, return_description
/*/
Static Function VldPrdManu(cProduto,cLoteCtl,nQtde,cCodBar,oGetCodBar,oGetQtdVol,cDesPro)
                
Local lRet      := .T.
Local aProduto  := {}
Local lAchou    := .F.

	If Empty(cCodBar)
		Return .F.
	EndIf
	// Deve zerar estas informações, pois pode haver informação de outra etiqueta
	cProduto := Space(TamSx3("DCV_CODPRO")[1])
	nQtde    := 0
	aProduto := CBRetEtiEAN(cCodBar)
	If Len(aProduto) > 0
		cProduto := aProduto[1]
		If ValType(aProduto[2]) == 'N'
			nQtde := Iif(aProduto[2] == 0,1,aProduto[2])
		EndIf
		cLoteCtl := Padr(aProduto[3],TamSx3("DCV_LOTE")[1])
	Else
		aProduto := CBRetEti(cProduto, '01')
		If Len(aProduto) > 0
			cProduto := aProduto[1]
			nQtde    := Iif(aProduto[2] == 0,1,aProduto[2])
			cLoteCtl := Padr(aProduto[16],TamSx3("DCV_LOTE")[1])
			//cSubLote := Padr(aProduto[17],TamSx3("DCV_SUBLOT")[1])
		EndIf
		If Empty(aProduto)
			MsgStop("Informe o código do produto ou o código de barras do produto desejado.", "Código do produto é invalido!")
			lRet := .F.
		EndIf
	EndIf
	// Deve validar se o produto informado é um produto partes ou componente
	If lRet
		//oMntVolManu:SetProduto(cProduto)
		//oMntVolManu:SetLoteCtl(cLoteCtl)
		//oMntVolManu:SetNumLote(cSubLote)
		lAchou := .t. //oMntVolManu:VldPrdCmp()

		If !lAchou
			MsgStop("Verifique os dados informados.", "Produto não pertence a montagem de volumes do documento.") 
			lRet := .F.
		EndIf
	EndIf

	If lRet
		cCodBar := Space(iIf(TAMSX3("B1_COD")[1] > 14,TAMSX3("B1_COD")[1],14))
		cDesPro := SB1->B1_DESC   //Considera que o cbretean posicionou no produto
		oGetQtdVol:SetFocus()
	Else
		cCodBar := Space(iIf(TAMSX3("B1_COD")[1] > 14,TAMSX3("B1_COD")[1],14))
		oGetCodBar:SetFocus()
	EndIf


Return lRet




//exemplo



//#Include "Totvs.ch"
 
/*/{Protheus.doc} User Function zGrid
Visualizacao de Grupos de Produtos com FWBrowse e Array
@type  Function
@author Atilio
@since  14/06/2020
@version version
/*/
 
User Function zGrid()
    Local aArea := GetArea()
    //Fontes
    Local cFontUti    := "Tahoma"
    Local oFontAno    := TFont():New(cFontUti,,-38)
    Local oFontSub    := TFont():New(cFontUti,,-20)
    Local oFontSubN   := TFont():New(cFontUti,,-20,,.T.)
    Local oFontBtn    := TFont():New(cFontUti,,-14)
    //Janela e componentes
    Private oDlgGrp
    Private oPanGrid
    Private oGetGrid
    Private aHeaderGrid := {}
    Private aColsGrid := {}
    //Tamanho da janela
    Private    aTamanho := MsAdvSize()
    Private    nJanLarg := aTamanho[5]
    Private    nJanAltu := aTamanho[6]
 
    //Monta o cabecalho
    fMontaHead()
 
    //Criando a janela
    DEFINE MSDIALOG oDlgGrp TITLE "Grupos de Produtos" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Labels gerais
        @ 004, 003 SAY "FAT"                      SIZE 200, 030 FONT oFontAno  OF oDlgGrp COLORS RGB(149,179,215) PIXEL
        @ 004, 050 SAY "Listagem de"              SIZE 200, 030 FONT oFontSub  OF oDlgGrp COLORS RGB(031,073,125) PIXEL
        @ 014, 050 SAY "Grupos de Produtos"       SIZE 200, 030 FONT oFontSubN OF oDlgGrp COLORS RGB(031,073,125) PIXEL
 
        //Botões
        @ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"        SIZE 050, 018 OF oDlgGrp ACTION (oDlgGrp:End())   FONT oFontBtn PIXEL
        @ 006, (nJanLarg/2-001)-(0052*02) BUTTON oBtnLege  PROMPT "Ver Grupo"     SIZE 050, 018 OF oDlgGrp ACTION (fGrupo()) PIXEL
 
        //Dados
        @ 024, 003 GROUP oGrpDad TO (nJanAltu/2-003), (nJanLarg/2-003) PROMPT "Grupos (Para ver a legenda basta clicar duas vezes em alguma bolinha): " OF oDlgGrp COLOR 0, 16777215 PIXEL
        oGrpDad:oFont := oFontBtn
            oPanGrid := tPanel():New(033, 006, "", oDlgGrp, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2 - 13),     (nJanAltu/2 - 45))
            oGetGrid := FWBrowse():New()
            oGetGrid:DisableFilter()
            oGetGrid:DisableConfig()
            oGetGrid:DisableReport()
            oGetGrid:DisableSeek()
            oGetGrid:DisableSaveConfig()
            oGetGrid:SetFontBrowse(oFontBtn)
            oGetGrid:SetDataArray()
            oGetGrid:lHeaderClick :=.f.
            oGetGrid:AddLegend("oGetGrid:oData:aArray[oGetGrid:At(), 4] == '0'", "RED",    "Nao Original")
            oGetGrid:AddLegend("oGetGrid:oData:aArray[oGetGrid:At(), 4] == '1'", "GREEN",  "Original")
            oGetGrid:AddLegend("Empty(oGetGrid:oData:aArray[oGetGrid:At(), 4])", "BLACK",  "Sem Classificacao")
            oGetGrid:SetColumns(aHeaderGrid)
            oGetGrid:SetArray(aColsGrid)
            oGetGrid:SetOwner(oPanGrid)
            oGetGrid:Activate()
 
        FWMsgRun(, {|oSay| fMontDados(oSay) }, "Processando", "Buscando grupos")
    ACTIVATE MsDialog oDlgGrp CENTERED
 
    RestArea(aArea)
Return
 
Static Function fMontaHead()
    Local nAtual
    Local aHeadAux := {}
 
    //Adicionando colunas
    //[1] - Titulo
    //[2] - Tipo
    //[3] - Tamanho
    //[4] - Decimais
    //[5] - Máscara
    aAdd(aHeadAux, {"Código",            "C", TamSX3('BM_GRUPO')[01],   0, ""})
    aAdd(aHeadAux, {"Descricao",         "C", TamSX3('BM_DESC')[01],    0, ""})
    aAdd(aHeadAux, {"Status Grupo",      "C", TamSX3('BM_STATUS')[01],  0, ""})
    aAdd(aHeadAux, {"Procedencia",       "C", TamSX3('BM_PROORI')[01],  0, ""})
    aAdd(aHeadAux, {"Total de Produtos", "N", 18,                       0, "@E 999,999,999,999,999,999"})
    aAdd(aHeadAux, {"SBM RecNo",         "N", 18,                       0, "@E 999,999,999,999,999,999"})
 
    //Percorrendo e criando as colunas
    For nAtual := 1 To Len(aHeadAux)
        aAdd(aHeaderGrid, FWBrwColumn():New())
        aHeaderGrid[nAtual]:SetData(&("{||oGetGrid:oData:aArray[oGetGrid:At(),"+Str(nAtual)+"]}"))
        aHeaderGrid[nAtual]:SetTitle( aHeadAux[nAtual][1] )
        aHeaderGrid[nAtual]:SetType(aHeadAux[nAtual][2] )
        aHeaderGrid[nAtual]:SetSize( aHeadAux[nAtual][3] )
        aHeaderGrid[nAtual]:SetDecimal( aHeadAux[nAtual][4] )
        aHeaderGrid[nAtual]:SetPicture( aHeadAux[nAtual][5] )
    Next
Return
 
Static Function fMontDados(oSay)
    Local aArea := GetArea()
    Local cQry  := ""
    Local nAtual := 0
    Local nTotal := 0
 
    //Zera a grid
    aColsGrid := {}
     
    //Montando a query
    oSay:SetText("Montando a consulta")
    cQry := " SELECT "                                                  + CRLF
    cQry += "     BM_GRUPO, "                                           + CRLF
    cQry += "     BM_DESC, "                                            + CRLF
    cQry += "     BM_STATUS, "                                          + CRLF
    cQry += "     BM_PROORI, "                                          + CRLF
    cQry += "     ( "                                                   + CRLF
    cQry += "         SELECT "                                          + CRLF
    cQry += "             COUNT(*) "                                    + CRLF
    cQry += "         FROM "                                            + CRLF
    cQry += "             " + RetSQLName('SB1') + " SB1 "               + CRLF
    cQry += "         WHERE "                                           + CRLF
    cQry += "             B1_FILIAL = '" + FWxFilial('SB1') + "' "      + CRLF
    cQry += "             AND B1_GRUPO = BM_GRUPO "                     + CRLF
    cQry += "             AND B1_MSBLQL != '1' "                        + CRLF
    cQry += "             AND SB1.D_E_L_E_T_ = ' ' "                    + CRLF
    cQry += "     ) AS TOT_PROD, "                                      + CRLF
    cQry += "     SBM.R_E_C_N_O_ AS SBMREC "                            + CRLF
    cQry += " FROM "                                                    + CRLF
    cQry += "     " + RetSQLName('SBM') + " SBM "                       + CRLF
    cQry += " WHERE "                                                   + CRLF
    cQry += "     BM_FILIAL = '" + FWxFilial('SBM') + "' "              + CRLF
    cQry += "     AND SBM.D_E_L_E_T_ = ' ' "                            + CRLF
    cQry += " ORDER BY "                                                + CRLF
    cQry += "     BM_GRUPO "                                            + CRLF
 
    //Executando a query
    oSay:SetText("Executando a consulta")
    PLSQuery(cQry, "QRY_SBM")
 
    //Se houve dados
    If ! QRY_SBM->(EoF())
        //Pegando o total de registros
        DbSelectArea("QRY_SBM")
        Count To nTotal
        QRY_SBM->(DbGoTop())
 
        //Enquanto houver dados
        While ! QRY_SBM->(EoF())
 
            //Muda a mensagem na regua
            nAtual++
            oSay:SetText("Adicionando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
 
            aAdd(aColsGrid, {;
                QRY_SBM->BM_GRUPO,;
                QRY_SBM->BM_DESC,;
                QRY_SBM->BM_STATUS,;
                QRY_SBM->BM_PROORI,;
                QRY_SBM->TOT_PROD,;
                QRY_SBM->SBMREC,;
                .F.;
            })
 
            QRY_SBM->(DbSkip())
        EndDo
 
    Else
        MsgStop("Nao foi encontrado registros!", "Atencao")
 
        aAdd(aColsGrid, {;
            "",;
            "",;
            "",;
            "",;
            0,;
            0,;
            .F.;
        })
    EndIf
    QRY_SBM->(DbCloseArea())
 
    //Define o array
    oSay:SetText("Atribuindo os dados na tela")
    oGetGrid:SetArray(aColsGrid)
    oGetGrid:Refresh()
 
    RestArea(aArea)
Return
 
Static Function fGrupo()
    Local nLinha   := oGetGrid:At()   
    Local nColCod  := 1
 
    MsgInfo("Estou no grupo: " + aColsGrid[nLinha][nColCod], "Atencao")
Return



Static Function Cancelar(oDlgTela)
oDlgTela:End()
Return


Static Function PegQtdaConfirmar(cProduto,cCodMnt,cCodVol)
Local nQtdaConfirmar := 0
Local cQuery      := ""
Local cQryDCV   := GetNextAlias()
	
cQuery := " SELECT SUM(DCV_QUANT) AS QTD "  + CRLF
cQuery += "FROM "+RetSqlName('DCV')+" DCV "+CRLF
cQuery += "WHERE DCV_FILIAL = '" + xFilial("DCV")+ "' "
cQuery += "  AND DCV_CODMNT =  '" + cCodMNT +"' "+CRLF
//cQry += "  AND DCV_PEDIDO =  '" + cPedido +"' "+CRLF
cQuery += "  AND DCV_CODPRO =  '" + cProduto +"' "+CRLF
cQuery += "  AND DCV_CODVOL =  '" + cCodVol +"' "+CRLF
cQuery += "  AND DCV_STATUS =  '' "+CRLF
cQuery += "  AND DCV.D_E_L_E_T_ = '' "+CRLF
//cQuery += "ORDER BY DCV_CODVOL,DCV_PRDORI " 

DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cQryDCV,.F.,.T.)

If !(cQryDCV)->(Eof())
	nQtdaConfirmar := (cQryDCV)->QTD	
EndIf

(cQryDCV)->(DbCloseArea())

Return nQtdaConfirmar


/*/{Protheus.doc} Excluir
description
@type function
@version  
@author Deosdete Deo
@since 12/08/2023
@param oBrowDCV, object, param_description
@return variant, return_description
/*/
Static Function Excluir(oBrowDCV, aBeeps)
Local cAlias := oBrowDCV:getAlias()

If Empty((cAlias)->DCV_STATUS) 
	If  (cAlias)->RECNO > 0
		If Aviso("Atençao!!!","Confirma exclusão do item " + (cAlias)->DCV_CODPRO ,{"SIM","NAO"}) == 1
			
			DCV->(DbGoTo((cAlias)->RECNO))	
			
			RecLock("DCV",.F.)
			DCV->(DbDelete())
			DCV->(MsUnlock())

			//Se excluir da DCV tem que excluir tmbem do array de beeps
			
			nPos := aScan(aBeeps, {|x| x[2] == (cAlias)->DCV_CODPRO} )
			While nPos > 0
				aDel(aBeeps, nPos)
				aSize(aBeeps, Len(aBeeps)-1)
				nPos := aScan(aBeeps, {|x| x[2] == (cAlias)->DCV_CODPRO} )
			EndDo


			If nPos > 0

			EndIf
			
			MsgInfo("Excluido com sucesso","EXCLUSAO")

		EndIF
	Else
		Alert("Registro Invalido")
	EndIf

Else
	MsgStop("O item " + (cAlias)->DCV_CODPRO + " ja foi montado e nao pode ser excluido" ,"Erro")
EndIf

oBrowDCV:Refresh()

Return



/*/{Protheus.doc} LstBxMr2
description
@type function
@version  
@author Deosdete Deo
@since 8/31/2023
@return variant, return_description
/*/
Static Function EstornarEmb(aBeeps, cCodMNT, cCodVol,oBrowDCV)

Local oDlg
Local cTitulo  := "Estorno Beeps"
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local nI 
Local nOpc   := 0
Local nEstorno := 0

Private lChk1 := .F.
Private oLbx
//Private aBeeps := {}

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aBeeps ) == 0
   Aviso( cTitulo, "Nao existe beeps a estornar", {"Ok"} )
   Return
Endif

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,315 PIXEL
   
@ 10,10 LISTBOX oLbx FIELDS HEADER ;
   " ", "Produto", "Qtd";
   SIZE 138,095 OF oDlg PIXEL ON dblClick( Marca(aBeeps, oLbx) )

oLbx:SetArray( aBeeps )
oLbx:bLine := {|| {Iif(aBeeps[oLbx:nAt,1],oOk,oNo),;
                       aBeeps[oLbx:nAt,2],;
                       aBeeps[oLbx:nAt,3]}}
	 
@ 110,10 SAY "Confirma estorno?" SIZE 160,7 PIXEL OF oDlg

DEFINE SBUTTON FROM 107,100 TYPE 1 ACTION (nOpc := 1, oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 107,130 TYPE 2 ACTION (nOpc := 2, oDlg:End()) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

//Gravar estorno
If nOpc == 1

	For nI := 1 To Len(aBeeps)
		
		If ValType(aBeeps[nI]) == "A"
			
			If aBeeps[nI][1] //Se estiver maracado
				
				DbSelectArea("DCV")
				DCV->(DbSetOrder(1)) // DCV_FILIAL+DCV_CODVOL+DCV_PRDORI+DCV_CODPRO+DCV_LOTE+DCV_SUBLOT+DCV_ITEM+DCV_SEQUEN+DCV_CODMNT
				If DCV->(dbSeek(xFilial("DCV")+cCodMNT+cCodVol+aBeeps[nI][2]))

					Reclock('DCV',.F.)
					DCV->DCV_QUANT -= aBeeps[nI][3]	
					DCV->(MsUnlock())
				
				EndIf

				aDel(aBeeps, nI)
				nEstorno++ //aSize(aBeeps, Len(aBeeps)-1)

				//If Type(aBeeps) == Nil
 				//	Exit // Vai estornar sempre um de cada vez - sair do laco para nao dar pau por conta do array diminuido
				//EndIf
			EndIf
		
		EndIf

	Next nI

	aSize(aBeeps, Len(aBeeps)-nEstorno)
	
	oBrowDCV:Refresh()

EndIf

Return


/*/{Protheus.doc} Marca
description
@type function
@version  
@author Deosdete Deo
@since 8/31/2023
@return variant, return_description
/*/
Static Function Marca(aBeeps, oLbx)
Local nPos := 0

//Marcar todos
//If oLbx:nColPos == 1

//	aEval(aBeeps,{|x| x[1] := !x[1] })

//EndIf

nPos := AScan( aBeeps, {|x| x[1] == .T. } )

If nPos == 0
	aBeeps[ oLbx:nAt, 1 ] := .T.
Else
	If nPos == oLbx:nAt
		aBeeps[ nPos, 1 ] := ! aBeeps[ nPos, 1 ]
	Else
		//aBeeps[ nPos, 1 ] := .F.
		aBeeps[ oLbx:nAt, 1 ] := .T.
	Endif
Endif

oLbx:Refresh()
Return



/*/{Protheus.doc} PegSldBeeps
description
@type function
@version  
@author Deosdete Deo
@since 9/1/2023
@param aBeeps, array, param_description
@param cProduto, character, param_description
@return variant, return_description
/*/
Static Function PegSldBeeps(aBeeps,cProduto)
Local nSldBeeps := 0

aEval(aBeeps,{|x| iIf(x[2] == cProduto, nSldBeeps += x[3], nSldBeeps += 0)})

Return nSldBeeps


/*/{Protheus.doc} VldCodVol
description
@type function
@version  
@author Deosdete Deo
@since 11/6/2023
@param cCodVol, character, param_description
@param oMntVolItem, object, param_description
@return variant, return_description
/*/
Static Function VldCodVol(cCodVol, oMntVolItem, oBrowDCV,cDCVQry, cCodMNT,cPedido, oTGetVol)
Local lRet       := .T.
Local nTamCodVol := TamSX3("DCU_CODVOL")[1]
Local cAlias     := oBrowDCV:GetAlias()
Local cTpQry     := ""
Local cQryCpo    := ""

If oTGetVol:lModified

	cTpQry   := "DCV"
	PegColunas(@cQryCpo, cTpQry)
	cDCVQry  := PegQuery(cCodMNT, cPedido, cQryCpo, cTpQry, cCodVol)
	oBrowDCV:SetQuery(cDCVQry)
	oBrowDCV:Refresh()

	(cAlias)->(DbGoTop())
	If !(cAlias)->(Eof())
		MsgStop("Já existe beepagem com o codigo atual")

		//Volta o codigo do volume
		cCodVol  := U_ALUCBProxCod()
		cDCVQry  := PegQuery(cCodMNT, cPedido, cQryCpo, cTpQry, cCodVol)
		oBrowDCV:SetQuery(cDCVQry)
		oBrowDCV:Refresh()

		lRet := .F.
	EndIf

	If lRet 

		If nTamCodVol == Len(AllTrim(cCodVol)) 	
			oMntVolItem:oVolume:SetCodVol(cCodVol)
		Else	
			MsgStop("Codigo de Volume Invalido")
			lRet := .F.
		EndIf

	EndIf

EndIf

Return lRet
