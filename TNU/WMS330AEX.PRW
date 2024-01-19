#include 'totvs.ch'
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} WM330AEX
Ponto de entrada do estorno de serviço
@type function
@version  
@author Pedro Lima
@since 28/12/2023
@param cID, character, param_description
@return variant, return_description
/*/

#DEFINE STR0017 "Unitizador [VAR01]: "
#DEFINE STR0018 "Ordem de serviço nao pode ser excluida, somente unitizador com situacao '3=OS Gerada'."
#DEFINE STR0024 "Exclusao da ordem de serviço nao permitida, unitizador originado pela conferencia de recebimento [VAR01]."
#DEFINE STR0081 "Carga/Documento nao possui atividades a serem finalizadas!"	
#DEFINE STR0082 "Finalizar"
#DEFINE STR0079 "Atividade"
#DEFINE	STR0093 "Tarefa"
#DEFINE	STR0092 "Carga/Doc" 
#DEFINE	STR0103 "Carregando tela de confirmacao"	
#DEFINE	STR0104 "STR0104" 

User Function WM330AEX()

Local    cAcao := PARAMIXB[1]
Local  lExclui := .T.
Local  cIDUnit := D12->D12_IDUNIT
Local  cLocOri := D12->D12_LOCORI
Local  cEndOri := D12->D12_ENDORI
Local  lAuto   := .F.

IF cAcao == '1'
	cAcao := " 1 - Servico"
Else
	cAcao := " 2 - Carga & Documento"
EndIf

	// Avalia se o serviço estornado é UNITIZAÇÃO DE PALLETE
	If !Empty(D12->D12_IDUNIT) .and. D12->D12_ORIGEM == "D0R" // D0R UNITIZADO
		//MsgAlert("Ponto de entrada WM330AEX - Exclusao de Unitizador por:" + cAcao)
		
		// Busca do serviço de transferência para finaliza-lo
		lExclui := Finaliz(D12->D12_IDUNIT,D12->D12_ORIGEM) // Finalizar Carga/Docto
		
		// Se o serviço de transferência foi finalizado, exclui a ordem de serviço.
		If lExclui
			ExcluirOS(cIDUnit,lAuto)  
			EstUnitiz(cLocOri,cEndOri,cIDUnit)
		Else 
			MsgAlert("Ponto de entrada WM330AEX - Nao foi Possivel Finalizar Transferencia")
		EndIf

	EndIf

Return 

/*/{Protheus.doc} Finaliz
Finalização de Serviço de Transferencia
@type function
@version  
@author Pedro Lima
@since 28/12/2023
@param cID, character, param_description
@return variant, return_description
/*/

//----------------------------------------------------------------------------------*/
Static Function Finaliz(cIDUnit,cOrigem)
Local aAreaAnt  := GetArea()
Local aAreaD12  := D12->(GetArea())
Local cQuery    := ""
Local cAliasD12 := ""
Local lRet      := .T.

//Static cOrigem := D12->D12_ORIGEM
//Static cIDUnit := D12->D12_IDUNIT

Static oMovimento := WMSBCCMovimentoServico():New()



	TeclaAtalho(.F.) // Desativa teclas de atalho

        //IF DC5->TPEXEC = 2 // AUTOMATICO 1 DEVE EXECUTAR D12 /MANUAL DEVE EXECUTAR DCF
    
		// Monta Query de busca do serviço de transferencia
			cQuery := U_MontaQuery(cIDUnit)
			cAliasD12 := GetNextAlias()
			dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasD12,.F.,.T.)

		//  Posiciona no serviço de transferência para finaliza-lo

	lRet := IIF((cAliasD12)->D12RECNO>0,.T.,.F.) // Retorna falso para cancelar a exclusão caso não ache.
		
	Do While lRet .And. (cAliasD12)->(!Eof())
		oMovimento:GoToD12((cAliasD12)->D12RECNO)
		oMovimento:SetLog("2")
		oMovimento:SetStatus("1")
		oMovimento:SetPrAuto("2")
		oMovimento:SetDataIni(dDataBase)
		oMovimento:SetHoraIni(Time())
		oMovimento:SetDataFim(dDataBase)
		oMovimento:SetHoraFim(Time())
		oMovimento:SetRecHum(__cUserID)
		oMovimento:SetQtdLid(oMovimento:GetQtdMov())
		oMovimento:SetRadioF("2")
		oMovimento:UpdateD12()
		// Finalizar ou Apontar a movimentação
		If lRet .And. oMovimento:IsUltAtiv()
			If oMovimento:IsUpdEst()
				lRet := oMovimento:RecEnter()
			EndIf
		EndIf
		(cAliasD12)->(DbSkip())
	EndDo
	(cAliasD12)->(DbCloseArea())

	RestArea(aAreaD12) // Restaura D12
	RestArea(aAreaAnt) // Restaura TUDO
	
Return(lRet)

/*/{Protheus.doc} Finaliz
query para busca do Serviço de Transferencia
@type function
@version  
@author Pedro Lima
@since 28/12/2023
@param cID, character, param_description
@return variant, return_description
/*/


User Function MontaQuery(cIDUnit)
Local cQuery := ""
Local cSrvTra   := SuperGetMv('MX_XSRVTRA',.F.,'014')
//Local cParam := ""
//Local cOpc   := WmsOpc332()

	cQuery := "SELECT D12.R_E_C_N_O_ D12RECNO"
	cQuery +=  " FROM "+RetSqlName('D12')+" D12"
	cQuery += " WHERE D12.D12_FILIAL = '"+xFilial("D12")+"'"
	cQuery +=   " AND D12.D12_SERVIC = '"+cSrvTra+"'" // TRANSFERENCIA
	cQuery +=   " AND D12.D12_STATUS = '4' "
	cQuery +=   " AND D12.D12_ORIGEM = 'DCF' "
	cQuery +=   " AND D12.D12_UNIDES = '"+cIdUnit+"' "
	cQuery += " AND D12.D_E_L_E_T_ = ' '"
	cQuery := ChangeQuery(cQuery)

Return cQuery

/*/{Protheus.doc} TeclaAtalho
Destiva as teclas de atalho copiado do padrao;
@type function
@version  
@author Pedro Lima
@since 28/12/2023
@param cID, character, param_description
@return variant, return_description
/*/

Static Function TeclaAtalho(lAtiva)

Static __lRefresh := .F.
		__bKeyF5  := {|| RefreshBrw() }
		__bKeyF9  := {|| SaldoEnder() }
		__bKeyF10 := {|| HistLog()}

	If !lAtiva
		__bKeyF5   := SetKey(VK_F5 , Nil)
		__bKeyF9   := SetKey(VK_F9 , Nil)
		__bKeyF10  := SetKey(VK_F10, Nil)
		If oBrowse:oTimer <> Nil
			__lRefresh := oBrowse:oTimer:lActive // Salva o status do timer
			// Desliga o Refresh automatico para nao desposicionar o cursor
			oBrowse:oTimer:lActive := .F.
		EndIf
	Else
		// Reativa as teclas de atalho
		SetKey(VK_F5 , __bKeyF5)
		SetKey(VK_F9 , __bKeyF9)
		SetKey(VK_F10, __bKeyF10)
		If oBrowse:oTimer <> Nil
			// Retorna o status do timer do browse
			oBrowse:oTimer:lActive := __lRefresh
		EndIf
	EndIf
Return Nil

/*/{Protheus.doc} ExcluirOS
Exclui a OS |  Copiado do padrão;
@type function
@version  
@author Pedro Lima
@since 28/12/2023
@param cID, character, param_description
@return variant, return_description
/*/

Static Function ExcluirOS(cIDUnit,lAuto)
//--------------------------------------------------------------
	Processa({|| ProcRegua(0), WMSA570EOS(cIDUnit,lAuto) },"Excluir OS","Excluindo OS selecionada...",.T.) // "Excluir OS" ## "Excluindo OS selecionada..."
Return .T.
//--------------------------------------------------------------

/*/{Protheus.doc} WMSA570EOS
Exclui a OS |  Copiado do padrão;
@type function
@version  
@author Pedro Lima
@since 28/12/2023
@param cID, character, param_description
@return variant, return_description
/*/
//--------------------------------------------------------------
Static Function WMSA570EOS(cMarca,lAuto)
//--------------------------------------------------------------
Local aAreaAnt := GetArea()
Local cQuery := ""
Local cAliasQry := ""
Local cCodRec := ""
Local oMntUnitiz := Nil
Local oOrdServ := Nil

Default cMarca := Iif(oMarkBrw==Nil,"",oMarkBrw:cMark)
Default lAuto := .F.

	aErro := {}
	oMntUnitiz := WMSDTCMontagemUnitizador():New()
	// Busca os unitizadores marcados para exclusão da OS
	cQuery := " SELECT D0R_IDUNIT,"
	cQuery +=        " D0R_IDDCF,"
	cQuery +=        " D0R_STATUS"
	cQuery +=   " FROM "+RetSqlName("D0R")
	cQuery +=  " WHERE D0R_FILIAL = '"+xFilial("D0R")+"'"
	cQuery +=    " AND D0R_IDUNIT = '"+cMarca+"'"
	cQuery +=    " AND D_E_L_E_T_ = ' '"
	cAliasQry := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.T.)
	Do While (cAliasQry)->(!Eof())

		If !((cAliasQry)->D0R_STATUS == "3")
			aAdd(aErro,WmsFmtMsg(STR0017,{{"[VAR01]",(cAliasQry)->D0R_IDUNIT}}) + STR0018) // "Unitizador [VAR01]: "##"Ordem de serviço não pôde ser excluída, somente unitizador com situação '3=OS Gerada'."
			(cAliasQry)->(dbSkip())
			Loop
		EndIf

		If u_UnitInConf((cAliasQry)->D0R_IDUNIT,@cCodRec)
			aAdd(aErro,WmsFmtMsg(STR0017,{{"[VAR01]",(cAliasQry)->D0R_IDUNIT}}) + WmsFmtMsg(STR0024,{{"[VAR01]",cCodRec}})) // "Unitizador [VAR01]: "##"Exclusão da ordem de serviço não permitida, unitizador originado pela conferência de recebimento [VAR01]."
			(cAliasQry)->(dbSkip())
			Loop
		EndIf

		// Seta a ordem de serviço e exclui a mesma
		oMntUnitiz:SetIdDCF((cAliasQry)->D0R_IDDCF)
		If !oMntUnitiz:ExcludeOS()
			aAdd(aErro,WmsFmtMsg(STR0017,{{"[VAR01]",(cAliasQry)->D0R_IDUNIT}}) + oMntUnitiz:GetErro()) // "Unitizador [VAR01]: "
		EndIf

		(cAliasQry)->(dbSkip())
	EndDo
	(cAliasQry)->(dbCloseArea())
	FreeObj(oMntUnitiz)

	// Exibe aviso dos erros
	If !lAuto .And. !Empty(aErro)
		oOrdServ := WMSDTCOrdemServico():New()
		oOrdServ:aWmsAviso := aErro
		oOrdServ:ShowWarnig()
		oOrdServ:Destroy()
	EndIf

RestArea(aAreaAnt)
Return .T.

/*/{Protheus.doc} UnitInConf
Valida se esta em embarque |  Copiado do padrão;
@type function
@version  
@author Pedro Lima
@since 28/12/2023
@param cID, character, param_description
@return variant, return_description
/*/
//--------------------------------------------------------------
User Function UnitInConf(cIdUnit,cCodRec)
//--------------------------------------------------------------
Local aAreaAnt := GetArea()
Local lRet := .F.
Local cQuery := ""
Local cAliasQry := ""

	cQuery := "SELECT DCZ_EMBARQ"
	cQuery +=  " FROM "+RetSqlName("DCZ")
	cQuery += " WHERE DCZ_FILIAL = '"+xFilial("DCZ")+"'"
	cQuery +=   " AND DCZ_IDUNIT = '"+cIdUnit+"'"
	cQuery +=   " AND D_E_L_E_T_ = ' '
	cAliasQry := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.T.)
	If (cAliasQry)->(!Eof())
		lRet := .T.
		cCodRec := (cAliasQry)->DCZ_EMBARQ
	EndIf
	(cAliasQry)->(dbCloseArea())

RestArea(aAreaAnt)
Return lRet

/*/{Protheus.doc} UnitInConf
Valida se esta em embarque |  Copiado do padrão;
@type function
@version  
@author Pedro Lima
@since 28/12/2023
@param cID, character, param_description
@return variant, return_description
/*/


/*-----------------------------------------------------------------------------
Executa movimentação WMS
-----------------------------------------------------------------------------*/
Static Function ExeMovWMS()
Local lRet     := .T.
Local aAreaAnt := GetArea()
Local oMovimento := WMSBCCMovimentoServico():New()
Local cAliasQry:= GetNextAlias()

	BeginSql Alias cAliasQry
		SELECT D12.R_E_C_N_O_ RECNOD12
		FROM %Table:D12% D12
		WHERE D12.D12_FILIAL = %xFilial:D12%
		AND D12.D12_DOC = %Exp:SD1->D1_DOC%
		AND D12.D12_SERIE = %Exp:SD1->D1_SERIE%
		AND D12.D12_CLIFOR = %Exp:SD1->D1_FORNECE%
		AND D12.D12_LOJA = %Exp:SD1->D1_LOJA%
		AND D12.D12_SERVIC = %Exp:SD1->D1_SERVIC%
		AND D12.D12_IDDCF = %Exp:SD1->D1_IDDCF%
		AND D12.%NotDel%
		ORDER BY D12_ORDTAR,
					D12_IDMOV,
					D12_ORDATI
	EndSql
	Do While lRet .And. (cAliasQry)->(!Eof())
		oMovimento:GoToD12((cAliasQry)->RECNOD12)
		oMovimento:SetLog("2")
		oMovimento:SetStatus("1")
		oMovimento:SetPrAuto("2")
		oMovimento:SetDataIni(dDataBase)
		oMovimento:SetHoraIni(Time())
		oMovimento:SetDataFim(dDataBase)
		oMovimento:SetHoraFim(Time())
		oMovimento:SetRecHum(__cUserID)
		oMovimento:SetQtdLid(oMovimento:GetQtdMov())
		oMovimento:SetRadioF("2")
		oMovimento:UpdateD12()
		// Finalizar ou Apontar a movimentação
		If lRet .And. oMovimento:IsUltAtiv()
			If oMovimento:IsUpdEst()
				lRet := oMovimento:RecEnter()
			EndIf
		EndIf
		(cAliasQry)->(DbSkip())
	EndDo
	(cAliasQry)->(DbCloseArea())

	RestArea(aAreaAnt)
Return lRet

/*/{Protheus.doc} EstUnitiz
Estorna Unitizado |  Copiado do padrão;
@type function
@version  
@author Pedro Lima
@since 13/01/2023
@param cID, character, param_description
@return variant, return_description
/*/


Static Function EstUnitiz(cArmazem,cEndereco,cIdUniAnt)

Local nQtde      := 0
Local aProdutos  := {}

	
Static oMntUniItem := WMSDTCMontagemUnitizadorItens():New()


			oMntUniItem:oUnitiz:SetArmazem(cArmazem)
			oMntUniItem:oUnitiz:SetEnder(cEndereco)
			oMntUniItem:oUnitiz:SetIdUnit(cIdUniAnt)

			IF u_LoadPrdEst(@aProdutos,nQtde,.T.)
				oMntUniItem:EstPrdUni(aProdutos,.T.)
			EndIf
	
			//If LoadPrdEst(aProdutos,nQtde,.F.)
			//	oMntUniItem:EstPrdUni(aProdutos,.F.)
			//EndIf
Return

/*/{Protheus.doc} VldIdUnit
@type function
@version  
@author Pedro Lima
@since 28/12/2023
@param cID, character, param_description
@return variant, return_description
/*/

//----------------------------------------------------------------------------------
Static Function VldIdUnit(cUnitiz,cTipUni,lEstorno)

Local lRet := .T.
	
	oMntUniItem:SetIdUnit(cUnitiz)
	If !(lRet := oMntUniItem:VldIdUnit(1,@cTipUni,lEstorno))
		oMntUniItem:SetIdUnit("")
		If !Empty(oMntUniItem:GetErro())
			WmsFmtMsg("MSG1",{{" [VAR01] ",cTipUni +  oMntUniItem:GetErro()}})
		EndIf
	EndIf
Return lRet
//----------------------------------------------------------------------------------
/*/{Protheus.doc} VldIdUnit
@type function
@version  
@author Pedro Lima
@since 28/12/2023
@param cID, character, param_description
@return variant, return_description
/*/
//----------------------------------------------------------------------------------
User Function LoadPrdEst(aProdutos,nQtde,lTotal)
Local lRet      := .T.
Local lIsDad    := oMntUniItem:IsDad()
Local aAreaAnt  := GetArea()
Local aTamD0S   := TamSx3("D0S_QUANT")
Local cWhere    := ""
Local cCampos   := ""
Local cAliasQry := Nil
Local cCodAnt   := ""
Local nQtdPrd   := 0

Local nQtdAux   := nQtde
Local nPrdComp  := Len(oMntUniItem:GetArrProd())
Local nCount    := 0

Default nQtde  := 0
Default lTotal := .F.
	// Parâmetro Campos
	cCampos := "%"
	If WmsX312118("D13","D13_USACAL") .And. WmsX312118("D0S","D0S_IDMVUN")
		cCampos += "D0S.D0S_IDMVUN,"
	EndIf
	cCampos += "%"
	// Parâmetro Where
	cWhere := "%"
	If !Empty(oMntUniItem:GetLoteCtl())
		cWhere += " AND D0S.D0S_LOTECT = '"+oMntUniItem:GetLoteCtl()+"'"
	EndIf
	If !Empty(oMntUniItem:GetNumLote())
		cWhere += " AND D0S.D0S_NUMLOT = '"+oMntUniItem:GetNumLote()+"'"
	EndIf
	cWhere += "%"
	cAliasQry := GetNextAlias()
	If lIsDad
		If lTotal
			BeginSql Alias cAliasQry
				SELECT D0S.D0S_PRDORI,
						%Exp:cCampos%
						D0S.D0S_CODPRO,
						D0S.D0S_LOTECT,
						D0S.D0S_NUMLOT,
						D0S.D0S_QUANT,
						D0S.D0S_IDD0Q,
						D11.D11_QTMULT
				FROM %Table:D0S% D0S
				// Adiciona a estrutura na query, pois foi informado o produto pai para estornar,
				// portanto é necessário multiplicar a quantidade informado pelo multiplo do filho
				INNER JOIN %Table:D11% D11
				ON D11.D11_FILIAL = %xFilial:D11%
				AND D0S.D0S_FILIAL = %xFilial:D0S%
				AND D11.D11_PRODUT = D0S.D0S_PRDORI
				AND D11.D11_PRDORI = D0S.D0S_PRDORI
				AND D11.D11_PRDCMP = D0S.D0S_CODPRO
				AND D11.%NotDel%
				WHERE D0S.D0S_FILIAL = %xFilial:D0S%
				AND D0S.D0S_IDUNIT = %Exp:oMntUniItem:GetIdUnit()%
				AND D0S.%NotDel%
				ORDER BY D0S.D0S_CODPRO
			EndSql
		Else
			BeginSql Alias cAliasQry
				SELECT D0S.D0S_PRDORI,
						D0S.D0S_CODPRO,
						D0S.D0S_LOTECT,
						D0S.D0S_NUMLOT,
						D0S.D0S_QUANT,
						D0S.D0S_IDD0Q,
						D11.D11_QTMULT
				FROM %Table:D0S% D0S
				// Adiciona a estrutura na query, pois foi informado o produto pai para estornar,
				// portanto é necessário multiplicar a quantidade informado pelo multiplo do filho
				INNER JOIN %Table:D11% D11
				ON D11.D11_FILIAL = %xFilial:D11%
				AND D0S.D0S_FILIAL = %xFilial:D0S%
				AND D11.D11_PRODUT = D0S.D0S_PRDORI
				AND D11.D11_PRDORI = D0S.D0S_PRDORI
				AND D11.D11_PRDCMP = D0S.D0S_CODPRO
				AND D11.%NotDel%
				WHERE D0S.D0S_FILIAL = %xFilial:D0S%
				AND D0S.D0S_IDUNIT = %Exp:oMntUniItem:GetIdUnit()%
				AND D0S.D0S_PRDORI = %Exp:oMntUniItem:GetPrdOri()%
				AND D0S.%NotDel%
				%Exp:cWhere%
				ORDER BY D0S.D0S_CODPRO
			
			EndSql
		EndIf
	Else
		If lTotal
			BeginSql Alias cAliasQry
				SELECT D0S.D0S_PRDORI,
						%Exp:cCampos%
						D0S.D0S_CODPRO,
						D0S.D0S_LOTECT,
						D0S.D0S_NUMLOT,
						D0S.D0S_QUANT,
						D0S.D0S_IDD0Q
				FROM %Table:D0S% D0S
				WHERE D0S.D0S_FILIAL = %xFilial:D0S%
				AND D0S.D0S_IDUNIT = %Exp:oMntUniItem:GetIdUnit()%
				AND D0S.%Notdel%
				ORDER BY D0S.D0S_CODPRO
			EndSql
		Else
			BeginSql Alias cAliasQry
				SELECT D0S.D0S_PRDORI,
						%Exp:cCampos%
						D0S.D0S_CODPRO,
						D0S.D0S_LOTECT,
						D0S.D0S_NUMLOT,
						D0S.D0S_QUANT,
						D0S.D0S_IDD0Q
				FROM %Table:D0S% D0S
				WHERE D0S.D0S_FILIAL = %xFilial:D0S%
				AND D0S.D0S_IDUNIT = %Exp:oMntUniItem:GetIdUnit()%
				AND D0S.D0S_PRDORI = %Exp:oMntUniItem:GetPrdOri()%
				AND D0S.D0S_CODPRO = %Exp:oMntUniItem:GetProduto()%
				AND D0S.%NotDel%
				%Exp:cWhere%
				ORDER BY D0S.D0S_CODPRO
			EndSql
		EndIf
	EndIf
	TcSetField(cAliasQry,"D0S_QUANT","N",aTamD0S[1],aTamD0S[2])
	Do While (cAliasQry)->(!Eof())
		If !(cCodAnt == (cAliasQry)->D0S_CODPRO)
			cCodAnt := (cAliasQry)->D0S_CODPRO
			nQtde := Iif(!lIsDad,nQtdAux,(nQtdAux * (cAliasQry)->D11_QTMULT))
			nCount++
		EndIf
		If (!lTotal .And. QtdComp(nQtde) == 0)
			(cAliasQry)->(dbSkip())
			Loop
		EndIf
		If lTotal
			nQtdPrd := (cAliasQry)->D0S_QUANT
		Else
			// Calcula a quantidade que pode ser "rateada" para este produto
			If QtdComp(nQtde) > QtdComp((cAliasQry)->D0S_QUANT)
				nQtdPrd := (cAliasQry)->D0S_QUANT
				nQtde   -= (cAliasQry)->D0S_QUANT
			Else
				nQtdPrd := nQtde
				nQtde   := 0
			EndIf
		EndIf
		// Adiciona o produto no array de produtos a serem colocados no unitizador
		If QtdComp(nQtdPrd) > 0
			aAdd(aProdutos, {;
						(cAliasQry)->D0S_CODPRO,;
						(cAliasQry)->D0S_LOTECT,;
						(cAliasQry)->D0S_NUMLOT,;
						nQtdPrd,;
						(cAliasQry)->D0S_PRDORI,;
						(cAliasQry)->D0S_IDD0Q,;
						IIf(WmsX312118("D13","D13_USACAL") .And. WmsX312118("D0S","D0S_IDMVUN"),(cAliasQry)->D0S_IDMVUN,"");
						})
		EndIf
		// Se não é produto componente e zerou a quantidade, deve sair
		If (!lTotal .And. QtdComp(nQtde) == 0) .And. (QtdComp(nCount) == QtdComp(nPrdComp))
			Exit
		EndIf
		(cAliasQry)->(dbSkip())
	EndDo
	(cAliasQry)->(dbCloseArea())
	RestArea(aAreaAnt)
Return lRet
//----------------------------------------------------------------------------------
