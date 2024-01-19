#include 'Totvs.ch'
#include "Protheus.CH"
#include "Rwmake.ch"
#include "Topconn.ch"

#DEFINE STR0017 "Unitizador [VAR01]: "
#DEFINE STR0018 "Ordem de servicos nao pode ser excluida, somente unitizador com situacao '3=OS Gerada'."
#DEFINE STR0024 "Exclusao da ordem de servicos nao permitida, unitizador originado pela conferencia de recebimento [VAR01]."
#DEFINE STR0081 "Carga/Documento nao possui atividades a serem finalizadas!"	
#DEFINE STR0082 "Finalizar"
#DEFINE STR0079 "Atividade"
#DEFINE	STR0093 "Tarefa"
#DEFINE	STR0092 "Carga/Doc" 
#DEFINE	STR0103 "Carregando tela de confirmacao"	
#DEFINE	STR0104 "STR0104" 

/*/{Protheus.doc} Finaliz
Finalizacosão de Servicoso de Transferencia
@type function
@version  
@author Pedro Lima
@since 28/12/2023
@param cID, character, param_description
@return variant, return_description
/*/

//----------------------------------------------------------------------------------*/
User Function Finaliz(cIDUnit,cOrigem)
Local aAreaAnt  := GetArea()
Local aAreaD12  := D12->(GetArea())
Local cQuery    := ""
Local cAliasD12 := ""
Local lRet      := .T.

//Static cOrigem := D12->D12_ORIGEM
//Static cIDUnit := D12->D12_IDUNIT

Static oMovimento := WMSBCCMovimentoServico():New()

	    //TeclaAtalho(.F.) // Desativa teclas de atalho

        //IF DC5->TPEXEC = 2 // AUTOMATICO 1 DEVE EXECUTAR D12 /MANUAL DEVE EXECUTAR DCF
    
		// Monta Query de busca do servicoso de transferencia
			cQuery := u_MontaQuery(cIDUnit)
			cAliasD12 := GetNextAlias()
			dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasD12,.F.,.T.)

		//  Posiciona no servicoso de transferência para finaliza-lo

	lRet := IIF((cAliasD12)->D12RECNO > 0,.T.,.F.) // Retorna falso para cancelar a exclusão caso não ache.
		
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
		// Finalizar ou Apontar a movimentacosão
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
User Function WMSA570EOS(cMarca,lAuto)
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
			aAdd(aErro,WmsFmtMsg(STR0017,{{"[VAR01]",(cAliasQry)->D0R_IDUNIT}}) + STR0018) // "Unitizador [VAR01]: "##"Ordem de servicoso não pôde ser excluída, somente unitizador com situacosão '3=OS Gerada'."
			(cAliasQry)->(dbSkip())
			Loop
		EndIf

		If u_UnitInConf((cAliasQry)->D0R_IDUNIT,@cCodRec)
			aAdd(aErro,WmsFmtMsg(STR0017,{{"[VAR01]",(cAliasQry)->D0R_IDUNIT}}) + WmsFmtMsg(STR0024,{{"[VAR01]",cCodRec}})) // "Unitizador [VAR01]: "##"Exclusão da ordem de servicoso não permitida, unitizador originado pela conferência de recebimento [VAR01]."
			(cAliasQry)->(dbSkip())
			Loop
		EndIf

		// Seta a ordem de servicoso e exclui a mesma
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

User Function EstUnitiz(cArmazem,cEndereco,cIdUniAnt)

Local nQtde      := 0
Local aProdutos  := {}

	
Static oMntUniItem := WMSDTCMontagemUnitizadorItens():New()


			oMntUniItem:oUnitiz:SetArmazem(cArmazem)
			oMntUniItem:oUnitiz:SetEnder(cEndereco)
			oMntUniItem:oUnitiz:SetIdUnit(cIdUniAnt)

			IF U_LoadPrdEst(@aProdutos,nQtde,.T.)
				oMntUniItem:EstPrdUni(aProdutos,.T.)
			EndIf
	
			//If LoadPrdEst(aProdutos,nQtde,.F.)
			//	oMntUniItem:EstPrdUni(aProdutos,.F.)
			//EndIf
Return
