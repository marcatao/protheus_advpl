#Include "Protheus.ch"
#Include "FWMVCDEF.CH"
/*/{Protheus.doc} ARO04030
Analise do pedido de venda antes da geracao da Ordem de Serviço
@type function
@version 
@author Deosdete Deo
@since 28/09/2020
@return return_type, return_description
/*/
User Function ALUA440(cOrigem)

Local aArea := GetArea()
Local nSuperior	:= 0
Local nEsquerda	:= 0
Local nInferior	:= 315
Local nDireita	:= 500
Local oDlgTela	:= Nil
Local cSC6Qry	    := ""
Local oPanel
Local oFont1    := TFont():New('Arial',,10,.T.)
Local oFont2    := TFont():New('Arial',,14,.T.)
Local oFont16   := TFont():New('Arial',,16,.T.)
Local oFont20   := TFont():New('Arial',,20,.T.)
Local oFont22   := TFont():New('Arial',,22,.T.)
Local nI        := 0
Local cQryCpo   := ""
Local cPV       := SC5->C5_NUM  //Considero o pedido posicionado
Local cAnaFin   := "OK"
Local lCredito  := .T.
Local lEstoque  := .T.
Local cQryAlias := GetNextAlias()
Local nValAV    := 0
Local cBlCred   := 0
Local aEmpenho  := 0
Local nVlrCred  := 0
Local aItems    := {}
Local lRet      := .T.
Local aCabec    := {"Item", "Codigo", "Descrição", "Falta"}
Local aTamCol   := {TamSX3("C6_ITEM")[1], TamSX3("C6_PRODUTO")[1],TamSX3("C6_DESCRI")[1],TamSX3("C6_QTDVEN")[1] }

Default cOrigem := 0

DbSelectArea("SC6")
DbSetorder(1) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO                                                                                                                             
                                                                                          
oStruSC6  := FWFormStruct(1,"SC6")
aStruSC6 := oStruSC6:GetFields()

cTitulo := "Analise do Pedido de Venda "  + cPV

//Campos para a quey e para o Browse
For nI := 1 To Len(aStruSC6)
    
    If AllTrim(aStruSC6[nI][03]) $ "C6_ITEM+C6_PRODUTO+C6_DESCRI+C6_QTDVEN+B2_QATU+B2_RESERVA  "
        If !Empty(cQryCpo)
            cQryCpo += ","  
        EndIf
        cQryCpo += aStruSC6[nI][03]
   EndIf

Next nI
cQryCpo += ",B2_QATU"  
cQryCpo += ",B2_RESERVA"  
cQryCpo += ",B2_QACLASS"  

//Selecionando os produtos da tabela
cSC6Qry := " SELECT " + cQryCpo + " "
cSC6Qry +=   " FROM " + RetSqlName("SC6") + " SC6 "
cSC6Qry +=   " LEFT JOIN " + RetSqlName("SB2") + " SB2 "
cSC6Qry +=   "   ON B2_FILIAL = '" + xFilial("SB2") + "' "
cSC6Qry +=   "   AND B2_LOCAL = C6_LOCAL "
cSC6Qry +=   "   AND B2_COD = C6_PRODUTO "
cSC6Qry +=   "   AND SB2.D_E_L_E_T_ = '' "
cSC6Qry +=  "WHERE C6_FILIAL = '" + xFilial("SC6") + "' "
cSC6Qry +=  "AND C6_NUM = '" + cPV + "' "
//cSC6Qry +=  "AND (B2_QATU - B2_RESERVA - B2_QACLASS) - C6_QTDVEN < 0
cSC6Qry +=  "AND SC6.D_E_L_E_T_ = ' ' "

cSC6Qry := ChangeQuery(cSC6Qry)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cSC6Qry),cQryAlias,.T.,.T.)


While !(cQryAlias)->(Eof())
    
    nQtdLib := PegQtdLib((cQryAlias)->C6_ITEM,(cQryAlias)->C6_PRODUTO)
    nFALTA :=  nQtdLib - Max(((cQryAlias)->B2_QATU - (cQryAlias)->B2_RESERVA - (cQryAlias)->B2_QACLASS),0)

    If nFALTA > 0 
        aAdd(aItems, {(cQryAlias)->C6_ITEM,(cQryAlias)->C6_PRODUTO,(cQryAlias)->C6_DESCRI, nFALTA})
        lEstoque := .F.
    EndIf

    (cQryAlias)->(DbSkip())

EndDo

//Caso nao tenha itens criar uma linha em branco
If Len(aItems) == 0
    aAdd(aItems, {" "," "," ", 0})
EndIf

cAnaEst := iIf(lEstoque, "OK", "BLOQUEADO")

//Analise de Credito
nValAV := PegTotalPed(cPV) //10000
lCredito := MaAvalCred(SC5->C5_CLIENTE,SC5->C5_LOJACLI,nValAV,SC5->C5_MOEDA,.T.,@cBlCred,@aEmpenho,@nVlrCred)
cAnaFin := iIf(lCredito, "OK", "BLOQUEADO")


If !lEstoque.OR. !lCredito .OR. cOrigem == 1

    DEFINE MSDIALOG oDlgTela TITLE cTitulo FROM nSuperior, nEsquerda TO nInferior, nDireita PIXEL	
    //TButton():New( [ nRow ], [ nCol ], [ cCaption ], [ oWnd ], [ bAction ], [ nWidth ], [ nHeight ], [ uParam8 ], [ oFont ], [ uParam10 ], [ lPixel ], [ uParam12 ], [ uParam13 ], [ uParam14 ], [ bWhen ], [ uParam16 ], [ uParam17 ] )
    //TGet():New( [ nRow ], [ nCol ], [ bSetGet ], [ oWnd ], [ nWidth ], [ nHeight ], [ cPict ], [ bValid ], [ nClrFore ], [ nClrBack ], [ oFont ], [ uParam12 ], [ uParam13 ], [ lPixel ], [ uParam15 ], [ uParam16 ], [ bWhen ], [ uParam18 ], [ uParam19 ], [ bChange ], [ lReadOnly ], [ lPassword ], [ uParam23 ], [ cReadVar ], [ uParam25 ], [ uParam26 ], [ uParam27 ], [ lHasButton ], [ lNoButton ], [ uParam30 ], [ cLabelText ], [ nLabelPos ], [ oLabelFont ], [ nLabelColor ], [ cPlaceHold ], [ lPicturePriority ], [ lFocSel ] )
    //TSay():New( [ nRow ], [ nCol ], [ bText ], [ oWnd ], [ cPicture ], [ oFont ], [ uParam7 ], [ uParam8 ], [ uParam9 ], [ lPixels ], [ nClrText ], [ nClrBack ], [ nWidth ], [ nHeight ], [ uParam15 ], [ uParam16 ], [ uParam17 ], [ uParam18 ], [ uParam19 ], [ lHTML ], [ nTxtAlgHor ], [ nTxtAlgVer ] )
    // TPanel():New( [ nRow ], [ nCol ], [ cText ], [ oWnd ], [ oFont ], [ lCentered ], [ uParam7 ], [ nClrText ], [ nClrBack ], [ nWidth ], [ nHeight ], [ lLowered ], [ lRaised ] )

    oPanel:= tPanel():New(01,01,"",oDlgTela,oFont1,.T.,,CLR_WHITE,CLR_GRAY,400,80)
    oPanel:Align :=CONTROL_ALIGN_TOP
 
    //TWBrowse(): New ( [ nRow], [ nCol], [ nWidth], [ nHeight], [ bLine], [ aHeaders], [ aColSizes], [ oDlg], [ cField], [ uValue1], [ uValue2], [ bChange], [ bLDblClick], [ bRClick], [ oFont], [ oCursor], [ nClrFore], [ nClrBack], [ cMsg], [ uParam20], [ cAlias], [ lPixel], [ bWhen], [ uParam24], [ bValid], [ lHScroll], [ lVScroll] ) --> oObjeto
    oBrowse := TWBrowse():New( 00 , 00, 400,80,, aCabec, aTamCol,;                              
            oPanel,,,,,{||},,oFont2,,,,,.F.,,.T.,,.F.,,, )  
        
    oBrowse:SetArray(aItems) 
    oBrowse:bLine := &("{ || {aItems[oBrowse:nAt,01], aItems[oBrowse:nAt,02], aItems[oBrowse:nAt,03], aItems[oBrowse:nAt,04]  } } ")
    oBrowse:lColDrag	:= .T.
    oBrowse:Align :=CONTROL_ALIGN_TOP
    //Rodape
    oPanelRodap:= tPanel():New(001,001,"",oDlgTela,oFont1,.T.,,CLR_WHITE,CLR_WHITE,400,075)
    oPanelRodap:Align :=CONTROL_ALIGN_TOP

    oFont22:Bold := .T.
    oFont20:Bold := .T.

    //Disponibilidade de estoque
    oSayAnaFin:= TSay():New(005,030,{||'Analise de Estoque'},oPanelRodap,,oFont22,,,,.T.,CLR_GRAY,CLR_WHITE,200,010)
    oSayAnaFin:= TSay():New(015,030,{||"Situação:"},oPanelRodap,,oFont16,,,,.T.,CLR_GRAY,CLR_WHITE,050,012)
    oSayAnaFin:= TSay():New(015,060,{||cAnaEst},oPanelRodap,,oFont20,,,,.T., iIf(lEstoque, CLR_GREEN,CLR_RED),CLR_GREEN,075,012)


    //Credito financeiro
    oSayAnaFin:= TSay():New(030,030,{||'Analise de Credito Financeiro'},oPanelRodap,,oFont22,,,,.T.,CLR_GRAY,CLR_WHITE,200,010)
    oSayAnaFin:= TSay():New(040,030,{||"Situação:"},oPanelRodap,,oFont16,,,,.T.,CLR_GRAY,CLR_WHITE,050,012)
    oSayAnaFin:= TSay():New(040,060,{||cAnaFin},oPanelRodap,,oFont20,,,,.T., iIf(lCredito, CLR_GREEN,CLR_RED),CLR_GREEN,075,012)

    oButFechar := TButton():New( 055, 110, "Fechar",oPanelRodap,{||iIf(Fechar(),oDlgTela:End(), Nil)}, 040,016,,oFont2,.F.,.T.,.F.,,.F.,,,.F. )

    ACTIVATE MSDIALOG oDlgTela CENTERED 

    (cQryAlias)->(DbCloseArea())

    lRet := .F.

EndIf

RestArea(aArea)

Return lRet


/*/{Protheus.doc} Fechar
Validacao do fechamento da tela
@type function
@version 
@author Samsung
@since 08/10/2020
@return return_type, return_description
/*/
Static Function Fechar()
Local  lRet   := .T.

Return lRet


/*/{Protheus.doc} PegTotalPed
description
@type function
@version  
@author Deosdete Deo
@since 14/04/2023
@param cPV, character, param_description
@return variant, return_description
/*/
Static Function PegTotalPed(cPV)
Local nTotPed  := 0
Local cQuery   := ""
Local cAliasSC6 := GetNextAlias()

cQuery :=   " SELECT "
cQuery +=   " SUM(C6_VALOR) AS C6_VALOR  "
cQuery +=   " FROM " + RetSqlName("SC6") + " SC6 "
cQuery +=  "WHERE C6_FILIAL = '" + xFilial("SC6") + "' "
cQuery +=  "AND C6_NUM = '" + cPV + "' "
cQuery +=  "AND SC6.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC6,.T.,.T.)

If !(cAliasSC6)->(Eof())
    nTotPed := (cAliasSC6)->C6_VALOR
EndIf

(cAliasSC6)->(DbCloseArea())

Return nTotPed

/*/{Protheus.doc} PegQtdLib((cQryAlias)->C6_ITEM,
description
@type function
@version  
@author Deosdete Deo
@since 18/04/2023
@param cQryAlias->C6_PRODUTO, character, param_description
@return variant, return_description
/*/
Static Function PegQtdLib(cItem,cProduto)
Local nQtdLib   := 0
Local nPosQLib  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB"})
Local nPosProd := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
Local nPosItem := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"})
Local nPos      := 0

nPos := aScan(aCols,{|x| x[nPosItem] + x[nPosProd]  == cItem + cProduto})

nQtdLib := aCols[nPos][nPosQLib]

Return nQtdLib

