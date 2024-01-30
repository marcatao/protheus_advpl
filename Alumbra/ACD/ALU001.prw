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
:: Descrição:: Seração por Demanda Alu001 requisições dinamicas            ::
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
Local Continua := .T.
VTSetSize(8,20)

 
	
while Continua
	VTClear()
	npos := browse()

	   If VTLastKey() == 13
			SelTran(npos)
			VTClearBuffer()
    		U_ALU001()
   		EndIF

   		If VTLastKey() == 27
      		Continua := .F.
			return
   		EndIF
end	 
Return



static function SelTran(npos)
Local nLido 
 	VTClear()
		aArea   := GetArea()
    	dbSelectArea('ZZ8')
		ZZ8->( dbGoTo( npos ) )
		nLido := Space(Len(alltrim(ZZ8->ZZ8_ENDER)))

		 @ 0,0 VTSAY "Transferencia: #" + cValToChar(ZZ8->(Recno()))
		 @ 1,0 VTSAY "Leia:" + ZZ8->ZZ8_ENDER
		 while nLido <> alltrim(ZZ8->ZZ8_ENDER)
		   	@ 3,0 VTSAY "Ender.:   " VTGET nLido Pict "@!"
			VTRead 
	    	     If VTLastKey() == 27
				 	VTClear()      
			     	Exit   
			     EndIF    
			if(nLido <> alltrim(ZZ8->ZZ8_ENDER))
				VTAlert("Endereço invalido","[-]Endereço invalido",.T.,1500)
				nLido := Space(8)
			else
				lisEnd(npos)
			ENDIF

		 end do 
		RestArea(aArea) 
	VTClearBuffer()
return .T.








/////////////////   LENDO ENDERECO ///////////////////
/////////////////   LENDO ENDERECO ///////////////////
/////////////////   LENDO ENDERECO ///////////////////
/////////////////   LENDO ENDERECO ///////////////////
/////////////////   LENDO ENDERECO ///////////////////
static function lisEnd(npos)
Local cQuery    := ""
Local cLsUnitz := ""
Local nCont := 1
Local nLidoU := Space(12)
Local nTotal := 0
Local Continua := .T.
local RetUnSl := {"''","''"};
	
		aArea   := GetArea()
		dbSelectArea('ZZ8')
		ZZ8->( dbGoTo( npos ) )

		Do while Continua = .T.
		VTClear()
				//Se precionar esc para sair 
				If VTLastKey() == 27      
					If VTYesNo("Deseja Salvar?","Pergunta")
						 if(transAl(RetUnSl[1],npos) = .T.)
							VTClear()
							 VTAlert("Transferencia realizada...","[-]Sucesso!",.T.,1500)
							VTClear()
							U_ALU001()
						 ENDIF
					else
						VTClear()
   						U_ALU001()
						Continua = .F.
						exit
   					EndIf   
					Continua = .F.
					exit
				 EndIF    


			 cQuery:= " select D14.D14_IDUNIT, (D14.D14_QTDEST - D14.D14_QTDSPR) as D14_QTDEST,D14.R_E_C_N_O_ "
 			 cQuery+= " from "+RetSqlName('D14')+" as D14 "
			 cQuery+= " where     D14.D14_PRODUT = '"+alltrim(ZZ8->ZZ8_CODPRO)+"' "  
             cQuery+= "       and D14.D14_FILIAL = '"+xFilial("D14")+"'"
             cQuery+= "       and D14.D14_LOCAL  = '"+alltrim(ZZ8->ZZ8_LOCAL)+"' " 
	         cQuery+= "       and D14.D_E_L_E_T_ = '' "  
             cQuery+= "       and (D14.D14_QTDEST - D14.D14_QTDSPR) > 0 "
	         cQuery+= "       and D14.D14_ENDER = '"+alltrim(ZZ8->ZZ8_ENDER)+"' " "
			 if(len(alltrim(RetUnSl[1])) > 10)
			  cQuery+= "       and D14.D14_IDUNIT not in ("+RetUnSl[1]+") "
			 ENDIF

			 cQuery := ChangeQuery(cQuery)
			 cLsUnitz := GetNextAlias()
			 dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cLsUnitz,.F.,.T.)
			//Listando Unitizadores Disponiveis//
			 Do While  (cLsUnitz)->(!Eof())	
					 if(len(alltrim((cLsUnitz)->D14_IDUNIT)) ==  0 )
					 		//ler Quantidade manual
							Continua = .F.
							QtdManu(npos)
							U_ALU001()
					 ELSE
					 	if(nCont == 1 )//Primeiro laço exibe cabeçalho
						    @ 0,0 VTSAY "#" + cValToChar(ZZ8->(Recno())) +"| " + "Qtd:"+cValToChar(nTotal)+" / " + cValToChar(ZZ8->ZZ8_QUANT)
							//@ 1,0 VTSAY "Qtd.: "+cValToChar(nTotal)+" / " + cValToChar(ZZ8->ZZ8_QUANT)
							//@ 2,0 VTSAY "|Unitizador   | QtD |"
					 
						ENDIF
					 endif
				@ nCont, 0 VTSAY "|"+alltrim((cLsUnitz)->D14_IDUNIT)+" | "+alltrim(cValToChar((cLsUnitz)->D14_QTDEST))+"|"
				nCont+= 1
				(cLsUnitz)->(DbSkip())
			 EndDo
			

			//@ nCont + 1,0 VTSAY "Esc - Finalizar/Sair"
			@ nCont,0 VTSAY "Caixa:" VTGET nLidoU Pict "@!"
			    VTRead
				if(alltrim(nLidoU)<> '')
					RetUnSl := setUnitz(nLidoU,RetUnSl)
					nTotal += RetUnSl[2]
			    	nLidoU :=Space(12)
				endif

		nCont := 1
		EndDo
		 RestArea(aArea) 
	
return .T.
///////////////// FIM LENDO ENDERECO ///////////////////
///////////////// FIM LENDO ENDERECO ///////////////////
///////////////// FIM LENDO ENDERECO ///////////////////
///////////////// FIM LENDO ENDERECO ///////////////////
///////////////// FIM LENDO ENDERECO ///////////////////






//////////////// Selecionando UNITIZADOR PARA FILA ///////////////////
//////////////// Selecionando UNITIZADOR PARA FILA ///////////////////
//////////////// Selecionando UNITIZADOR PARA FILA ///////////////////
//////////////// Selecionando UNITIZADOR PARA FILA ///////////////////
//////////////// Selecionando UNITIZADOR PARA FILA ///////////////////
//////////////// Selecionando UNITIZADOR PARA FILA ///////////////////
//////////////// Selecionando UNITIZADOR PARA FILA ///////////////////
static function setUnitz(cUnt,RetUnSl)
cQuery:= " select D14.D14_IDUNIT, (D14.D14_QTDEST - D14.D14_QTDSPR) as D14_QTDEST,D14.R_E_C_N_O_ "
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
			 else
				RetUnSl[1] += ",''"
				RetUnSl[2] := 0
				VTAlert("Unitizador invalido ...","[-]Atencao!",.T.,,1)
			 endif

return RetUnSl
//////////////// FIM Selecionando UNITIZADOR PARA FILA ///////////////////
//////////////// FIM Selecionando UNITIZADOR PARA FILA ///////////////////
//////////////// FIM Selecionando UNITIZADOR PARA FILA ///////////////////
//////////////// FIM Selecionando UNITIZADOR PARA FILA ///////////////////
//////////////// FIM Selecionando UNITIZADOR PARA FILA ///////////////////
//////////////// FIM Selecionando UNITIZADOR PARA FILA ///////////////////














static function QtdManu(npos)
	Local nQtdAte := 0
	LOCAL aAreaMan   := GetArea()
	Local nEstoq := 0
	VTClear()

    	dbSelectArea('ZZ8')
		ZZ8->( dbGoTo( npos ) )
		nEstoq := U_ALU003(ZZ8->ZZ8_CODPRO,ZZ8->ZZ8_LOCAL)
		@ 0,0 VTSAY "Transf #" + cValToChar(ZZ8->(Recno()))
		@ 1,0 VTSAY "Prod:  " + ZZ8->ZZ8_CODPRO
		@ 2,0 VTSAY "Qtd:   " + cValToChar(ZZ8->ZZ8_QUANT) + " / " + cValToChar(nEstoq)
		@ 3,0 VTSAY "Ender: " + ZZ8->ZZ8_LOCAL+space(1)+ZZ8->ZZ8_ENDER
		@ 4,0 VTSAY "---------------------"
		@ 5,0 VTSAY "QTd:   " VTGET nQtdAte pict "@9999.9999"
		VTRead     
		
		if(nQtdAte > 0 .AND. nEstoq >= nQtdAte)
			//atualizando quantidade informada
			RECLOCK("ZZ8", .F.)
       		ZZ8->ZZ8_QUANT := nQtdAte
    		MSUNLOCK()    
				if(AluTransWMS(npos))
					ZZ8->( dbGoTo( npos ) )
					ZZ8->(RecLock("ZZ8",.F.))
					ZZ8->(DbDelete())
					ZZ8->(MsUnLock())
				else
					VTClear()
					 VTAlert("Separação nao finalizada....","[-]ERRO",.T.,,1)
					    RECLOCK("ZZ8", .F.)
       					ZZ8->ZZ8_ERRO := "Endereço sem saldo, serviço nao foi criado!!!"
    					MSUNLOCK() 
					
				ENDIF
		ELSE
			VTAlert("Quantidade estoque invalida...","[-]Cancelado...",.T.,,1)
		ENDIF
	  RestArea(aAreaMan)			
	VTClear()
return




/////////////////GERANDO TRANSFERENCIAS NO COLETOR///////////////////
/////////////////GERANDO TRANSFERENCIAS NO COLETOR///////////////////
/////////////////GERANDO TRANSFERENCIAS NO COLETOR///////////////////
/////////////////GERANDO TRANSFERENCIAS NO COLETOR///////////////////
/////////////////GERANDO TRANSFERENCIAS NO COLETOR///////////////////

static function transAl(Unitz,pos)


Local aArea   := GetArea()
Local aArea1
Local cQuery  := ""
Local SERVIC,LOCDES,ENDDES,posAnt


VTAlert("salvando:","Sanvando:",.T., 2000)

	 dbSelectArea('ZZ8')
	 ZZ8->( dbGoTo( pos ) )
	 SERVIC := ZZ8->ZZ8_SERVIC
	 LOCDES := ZZ8->ZZ8_LOCDES
	 ENDDES := ZZ8->ZZ8_ENDDES

	         cQuery:= " select D14.D14_ENDER , D14.D14_IDUNIT,  (D14.D14_QTDEST - D14.D14_QTDSPR) as D14_QTDEST, D14.D14_LOCAL,D14.D14_PRODUT"
 			 cQuery+= " from "+RetSqlName('D14')+" as D14 "
			 cQuery+= " where     D14.D14_PRODUT = '"+alltrim(ZZ8->ZZ8_CODPRO)+"' "  
             cQuery+= "       and D14.D14_FILIAL = '"+xFilial("D14")+"'"
             cQuery+= "       and D14.D14_LOCAL  ='"+alltrim(ZZ8->ZZ8_LOCAL)+"' " 
	         cQuery+= "       and D14.D_E_L_E_T_ = '' "  
             cQuery+= "       and (D14.D14_QTDEST - D14.D14_QTDSPR) > 0 "
	         cQuery+= "       and D14.D14_ENDER = '"+alltrim(ZZ8->ZZ8_ENDER)+"' " "
			 cQuery+= "       and D14.D14_IDUNIT  in ("+Unitz+") "

			 cQuery := ChangeQuery(cQuery)
			 cLsUnitz := GetNextAlias()
			 dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cLsUnitz,.F.,.T.)

			 BeginTran()
			 Do While  (cLsUnitz)->(!Eof())	
				 		aArea1   := GetArea()  
                   		RecLock("ZZ8",.T.)
                    		 ZZ8->ZZ8_CODPRO:=  (cLsUnitz)->D14_PRODUT
                     		 ZZ8->ZZ8_QUANT :=  (cLsUnitz)->D14_QTDEST
                     		 ZZ8->ZZ8_SERVIC:=  SERVIC
                     		 ZZ8->ZZ8_LOCAL :=  (cLsUnitz)->D14_LOCAL
                     		 ZZ8->ZZ8_ENDER :=  (cLsUnitz)->D14_ENDER
                     		 ZZ8->ZZ8_UNITIZ:=  (cLsUnitz)->D14_IDUNIT
                             ZZ8->ZZ8_LOCDES:=  LOCDES
                             ZZ8->ZZ8_ENDDES:=  alltrim(ENDDES)
                             ZZ8->ZZ8_RECORI := pos
                             ZZ8->ZZ8_RESP:= alltrim(UsrRetName(RetCodUsr()))
                        ZZ8->(MsUnlock())
						posAnt := ZZ8->(Recno())

						if(AluTransWMS(ZZ8->(Recno())))
						      ZZ8->( dbGoTo( posAnt ) )
				              ZZ8->(RecLock("ZZ8",.F.))
			  			      	ZZ8->(DbDelete())
			  				  ZZ8->(MsUnLock())	
							 
						else 
							 DisarmTransaction()
							 U_ALU001()
						endif
	                //ZZ8->(DbSkip(1)) 
                    RestArea(aArea1)	
				(cLsUnitz)->(DbSkip())
			 EndDo
			//excluindo registro original
			 dbSelectArea('ZZ8')
		      ZZ8->( dbGoTo( pos ) )
              ZZ8->(RecLock("ZZ8",.F.))
			  ZZ8->(DbDelete())
			  ZZ8->(MsUnLock())
		EndTran()

	 
	 RestArea(aArea)

 
return .T.
/////////////////FIM GERANDO TRANSFERENCIAS NO COLETOR///////////////////
/////////////////FIM GERANDO TRANSFERENCIAS NO COLETOR///////////////////
/////////////////FIM GERANDO TRANSFERENCIAS NO COLETOR///////////////////
/////////////////FIM GERANDO TRANSFERENCIAS NO COLETOR///////////////////
/////////////////FIM GERANDO TRANSFERENCIAS NO COLETOR///////////////////























Static Function AluTransWMS(nPos)

Local nModAux   := nModulo
Local lRet      := .T.
Local oTransf 
Local aArea2   := GetArea()

nModulo  := 42

dbSelectArea('ZZ8')
ZZ8->( dbGoTo( nPos ) )


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

//If nOpc == 2 //Armazem unitizado
//    oTransf:oOrdServ:SetUniDes("")
//    oTransf:oOrdServ:SetTipUni("")
//EndIf

oTransf:oOrdServ:SetQuant(ZZ8->ZZ8_QUANT)
oTransf:oOrdServ:SetOrigem('DCF')

If !oTransf:ChkEndOri()
    //oModel:GetModel():SetErrorMessage( , , oModel:GetId() , "", "", oMovimento:GetErro(), "", "", "")
    MsgStop(oTransf:GetErro() ,"Erro!!!")
    lRet := .F.
EndIf
If lRet .And. !Empty(oTransf:oOrdServ:oOrdEndDes:GetEnder())
    If !oTransf:ChkEndDes()
        //MsgStop("Endereço de destino " + ZZ8->ZZ8_ENDDES + " invalido. " + oTransf:GetErro() )
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
RestArea(aArea2)
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
		// Monta Query de busca do serviÃ§o de transferencia
			
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
		//  Posiciona no serviÃ§o de transferÃªncia para finaliza-lo

	lRet := IIF((cAliasD12)->D12RECNO>0,.T.,.F.) // Retorna falso para cancelar a exclusÃ£o caso nÃ£o ache.
		
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
		// Finalizar ou Apontar a movimentacosÃ£o
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


static function browse()
Local aFields,aHeader
Local aArea7   := GetArea()
    aFields := {"ZZ8_CODPRO","ZZ8_ENDER","ZZ8_QUANT","ZZ8_LOCAL"}
	aSize   := {10,10,10,10}          
	aHeader := {'PROD','ENDER','QUANT',"LOCAL"}       
	npos := VTDBBrowse(,,,,"ZZ8",aHeader,aFields,aSize)
RestArea(aArea7) 
return npos
	  	
	
 











        

 
