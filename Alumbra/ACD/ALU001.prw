#INCLUDE "PROTHEUS.CH"
#INCLUDE 'APVT100.CH'
#Include "FWMVCDEF.CH"

/*/
protheus advpl vt100 manual
https://aprendendoadvpl.wordpress.com/download/
https://centraldeatendimento.totvs.com/hc/pt-br/articles/235301627-Log%C3%ADstica-Linha-Protheus-WMS-Servi%C3%A7os-que-o-WMS-disponibiliza-e-como-funcionam

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Funcao   ::ALU001 :: Autor:: Marcato               :: Data ::17/01/2024 ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Descri��o:: Sera��o por Demanda Alu001 requisi��es dinamicas            ::
::          ::                                                             ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Parametros::                                                            ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::  Uso     :: PROGRAMA EXEMPLO DE UMA APLICACAO PARA MICROTERMINAL        ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
/*/
User Function ALU001()
Local nPos  := 1        
Local aFields,aHeader
Local nQtdAte := 0
Local aArea   := GetArea()

While .T.
 
	VTSetSize(8,20)
	VTClear()
	VTClearBuffer() 

	aFields := {"ZZ8_CODPRO","ZZ8_ENDER","ZZ8_QUANT","ZZ8_LOCAL"}
	aSize   := {10,10,10,10}          
	aHeader := {'PROD','ENDER','QUANT',"LOCAL"}       
	npos := VTDBBrowse(,,,,"ZZ8",aHeader,aFields,aSize)
	  	


   If VTLastKey() == 13
		SelTran(npos)

		VTClear()
		aArea   := GetArea()
    	dbSelectArea('ZZ8')
		ZZ8->( dbGoTo( npos ) )

		@ 0,0 VTSAY "Transf #" + cValToChar(ZZ8->(Recno()))
		@ 1,0 VTSAY "Prod:  " + ZZ8->ZZ8_CODPRO
		@ 2,0 VTSAY "Qtd:   " + cValToChar(ZZ8->ZZ8_QUANT)
		@ 3,0 VTSAY "Ender: " + ZZ8->ZZ8_LOCAL+space(1)+ZZ8->ZZ8_ENDER
		@ 4,0 VTSAY "---------------------"
		@ 5,0 VTSAY "QTd:   " VTGET nQtdAte pict "@9999.9999"
		VTRead     
		if(AluTransWMS(1,nQtdAte))
			ZZ8->(RecLock("ZZ8",.F.))

				ZZ8->(DbDelete())
			ZZ8->(MsUnLock())
			ZZ8->(DbSkip(1))
		else
			VTAlert("Separa��o nao finalizada....","[-]",.T.,3500)
			RECLOCK("ZZ8", .F.)
       			ZZ8->ZZ8_ERRO := "Endere�o sem saldo, servi�o nao foi criado!!!"
    		MSUNLOCK()     // Destrava o registro
		ENDIF

	  RestArea(aArea)			
      VTClearBuffer()
	  nQtdAte := 0 
	  U_ALU001()
   EndIF


   If VTLastKey() == 27
      Exit
   EndIF


EndDo // wile principal

Return .T.



static function SelTran(npos)
Local nLido := Space(8)
 	VTClear()
		aArea   := GetArea()
    	dbSelectArea('ZZ8')
		ZZ8->( dbGoTo( npos ) )
		
		 @ 0,0 VTSAY "Transf #" + cValToChar(ZZ8->(Recno()))
		 @ 1,0 VTSAY "Leia:" + ZZ8->ZZ8_ENDER
		 while nLido <> alltrim(ZZ8->ZZ8_ENDER)
		   	@ 3,0 VTSAY "End.:   " VTGET nLido Pict "@!"
			VTRead 
	    	     If VTLastKey() == 27      
			     	Exit   
			     EndIF    
			if(nLido <> alltrim(ZZ8->ZZ8_ENDER))
				VTAlert("Endere�o invalido","[-]Endere�o invalido",.T.,1500)
				nLido := Space(8)
			else
				lisEnd(npos)
			ENDIF

		 end do 
		RestArea(aArea) 
	VTClearBuffer()
return .T.




static function lisEnd(npos)
Local cQuery    := ""
Local cLsUnitz := ""
Local nCont := 3
Local nLidoU := Space(12)
Local nTotal := 0
Local Continua := .T.
local RetUnSl := {"''","''"};
	
		aArea   := GetArea()
		dbSelectArea('ZZ8')
		ZZ8->( dbGoTo( npos ) )

		Do while Continua = .T.
		VTClear()
		If VTLastKey() == 27      
			If VTYesNo("Deseja Salvar?","Pergunta")
				 if(transAl() = .T.)
					VTAlert("Transferencia realizada...","[-]Sucesso!",.T.,1500)
					exit
				 ENDIF
			else
   				Exit
   			EndIf   
	    EndIF    

	    @ 0,0 VTSAY "#" + cValToChar(ZZ8->(Recno())) +" - " + ZZ8->ZZ8_CODPRO
		@ 1,0 VTSAY "Qtd.: "+cValToChar(nTotal)+" / " + cValToChar(ZZ8->ZZ8_QUANT)
		@ 2,0 VTSAY "|Unitizador   | QtD |"
		nCont := 3
			 cQuery:= " select D14.D14_IDUNIT,D14.D14_QTDEST,D14.R_E_C_N_O_ "
 			 cQuery+= " from "+RetSqlName('D14')+" as D14 "
			 cQuery+= " where     D14.D14_PRODUT = '"+alltrim(ZZ8->ZZ8_CODPRO)+"' "  
             cQuery+= "       and D14.D14_FILIAL = '"+xFilial("D14")+"'"
             cQuery+= "       and D14.D14_LOCAL  ='"+alltrim(ZZ8->ZZ8_LOCAL)+"' " 
	         cQuery+= "       and D14.D_E_L_E_T_ = '' "  
             cQuery+= "       and (D14.D14_QTDEST - D14.D14_QTDSPR) > 0 "
	         cQuery+= "       and D14.D14_ENDER = '"+alltrim(ZZ8->ZZ8_ENDER)+"' " "
			 cQuery+= "       and D14.D14_IDUNIT not in ("+RetUnSl[1]+") "

			 cQuery := ChangeQuery(cQuery)
			 cLsUnitz := GetNextAlias()
			 dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cLsUnitz,.F.,.T.)
			//Listando Unitizadores Disponiveis//
			 Do While  (cLsUnitz)->(!Eof())	
				@ nCont, 0 VTSAY "|"+alltrim((cLsUnitz)->D14_IDUNIT)+" | "+alltrim(cValToChar((cLsUnitz)->D14_QTDEST))+"|"
				nCont+= 1
				(cLsUnitz)->(DbSkip())
			 EndDo
			

			@ nCont + 1,0 VTSAY "Esc - Finalizar/Sair..."
			@ nCont,0 VTSAY "Caixa:" VTGET nLidoU Pict "@!"
			    VTRead
				if(alltrim(nLidoU)<> '')
					RetUnSl := setUnitz(nLidoU,RetUnSl)
					nTotal += RetUnSl[2]
			    	nLidoU :=Space(12)
				endif
			    //nCont+= 1

			//@ nCont,0 VTSAY "---------------------"
			//nCont+= 1
	
			

		VTClearBuffer()
		
		EndDo
		 RestArea(aArea) 
	
return .T.

static function setUnitz(cUnt,RetUnSl)
cQuery:= " select D14.D14_IDUNIT,D14.D14_QTDEST,D14.R_E_C_N_O_ "
 			 cQuery+= " from "+RetSqlName('D14')+" as D14 "
			 cQuery+= " where     D14.D14_PRODUT = '"+alltrim(ZZ8->ZZ8_CODPRO)+"' "  
             cQuery+= "       and D14.D14_FILIAL = '"+xFilial("D14")+"'"
             cQuery+= "       and D14.D14_LOCAL  ='"+alltrim(ZZ8->ZZ8_LOCAL)+"' " 
	         cQuery+= "       and D14.D_E_L_E_T_ = '' "  
             cQuery+= "       and (D14.D14_QTDEST - D14.D14_QTDSPR) > 0 "
	         cQuery+= "       and D14.D14_ENDER = '"+alltrim(ZZ8->ZZ8_ENDER)+"' " "
			 cQuery+= "       and D14.D14_IDUNIT  = '" + alltrim(cValToChar(cUnt)) + "' "

			 cQuery := ChangeQuery(cQuery)
			 cLsUnitz := GetNextAlias()
			 dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cLsUnitz,.F.,.T.)
			//Listando Unitizadores Disponiveis//
			 if  (cLsUnitz)->(!Eof())	
			    RetUnSl[1] += ",'"+(cLsUnitz)->D14_IDUNIT+"' "
				RetUnSl[2] := (cLsUnitz)->D14_QTDEST
			 endif

return RetUnSl

static function transAl()
	VTAlert("salvando:","Sanvando:",.T., 2000)
return .T.



Static Function AluTransWMS(nOpc,nQtdAte)

Local nModAux   := nModulo
Local lRet      := .T.
Local oTransf 

nModulo  := 42
oTransf  := WMSBCCTransferencia():New()
oTransf:oOrdServ := WMSDTCOrdemServicoCreate():New()
    
WmsOrdSer(oTransf:oOrdServ) // Atualiza referencia do objeto WMS

oTransf:oOrdServ:oServico:SetServico(ZZ8->ZZ8_SERVIC)
// Atribui produto/Lote/Sublote
oTransf:oOrdServ:oProdLote:SetArmazem(ZZ8->ZZ8_LOCAL)
oTransf:oOrdServ:oProdLote:SetPrdOri(ZZ8->ZZ8_CODPRO)
oTransf:oOrdServ:oProdLote:SetProduto(ZZ8->ZZ8_CODPRO)
oTransf:oOrdServ:oProdLote:SetLoteCtl('') 
oTransf:oOrdServ:oProdLote:SetNumLote('')
// Atribui endereco origem
oTransf:oOrdServ:oOrdEndOri:SetArmazem(AllTrim(ZZ8->ZZ8_LOCAL))
oTransf:oOrdServ:oOrdEndOri:SetEnder(AllTrim(ZZ8->ZZ8_ENDER))
// Atribui endereco destino
oTransf:oOrdServ:oOrdEndDes:SetArmazem(AllTrim(ZZ8->ZZ8_LOCDES))
oTransf:oOrdServ:oOrdEndDes:SetEnder(AllTrim(ZZ8->ZZ8_ENDDES))
oTransf:oOrdServ:SetIdUnit(ZZ8->ZZ8_UNITIZ)

If nOpc == 2 //Armazem unitizado
    oTransf:oOrdServ:SetUniDes("")
    oTransf:oOrdServ:SetTipUni("")
EndIf

oTransf:oOrdServ:SetQuant(nQtdAte)
oTransf:oOrdServ:SetOrigem('DCF')

If !oTransf:ChkEndOri()
    //oModel:GetModel():SetErrorMessage( , , oModel:GetId() , "", "", oMovimento:GetErro(), "", "", "")
    MsgStop(oTransf:GetErro() ,"Erro!!!")
    lRet := .F.
EndIf
If lRet .And. !Empty(oTransf:oOrdServ:oOrdEndDes:GetEnder())
    If !oTransf:ChkEndDes()
        //MsgStop("Endere�o de destino " + ZZ8->ZZ8_ENDDES + " invalido. " + oTransf:GetErro() )
    EndIf      
EndIf


BeginTran()
If !oTransf:oOrdServ:CreateDCF()
    oTransf:oOrdServ:GetErro()
    DisarmTransaction()

    lRet := .F.
Else
    If !WmsExeServ(.F.,.T.,.F.)
		lRet := .F.
	else
		 lRet := FinServ(DCF->DCF_SERVIC,DCF->DCF_DOCTO)
    EndIf
EndIf

EndTran()

//Destroi objetos
oTransf:Destroy()

nModulo := nModAux

Return lRet





Static Function FinServ(cServic,cDoc)
Local aAreaAnt  := GetArea()
Local aAreaD12  := D12->(GetArea())
Local cQuery    := ""
Local cAliasD12 := ""
Local lRet      := .T.

//Static cOrigem := D12->D12_ORIGEM
//Static cIDUnit := D12->D12_IDUNIT

Static oMovimento := WMSBCCMovimentoServico():New()

        //IF DC5->TPEXEC = 2 // AUTOMATICO 1 DEVE EXECUTAR D12 /MANUAL DEVE EXECUTAR DCF
		// Monta Query de busca do serviço de transferencia
			
				cQuery := "SELECT D12.R_E_C_N_O_ D12RECNO"
				cQuery +=  " FROM "+RetSqlName('D12')+" D12"
				cQuery += " WHERE D12.D12_FILIAL = '"+xFilial("D12")+"'"
				cQuery +=   " AND D12.D12_SERVIC = '"+cServic+"'" // TRANSFERENCIA
				cQuery +=   " AND D12.D12_STATUS = '4' "
				cQuery +=   " AND D12.D12_ORIGEM = 'DCF' "
				cQuery +=   " AND D12.D12_DOC = '"+cDoc+"' "
				cQuery += " AND D12.D_E_L_E_T_ = ' '"
				cQuery := ChangeQuery(cQuery)


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
	
 











        

 