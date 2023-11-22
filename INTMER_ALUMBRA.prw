#include 'protheus.ch'
#include 'parmtype.ch'
#include 'fileio.ch'
#define CRLF Chr(13)+Chr(10)
/*
*******************************************************************
* @author      JULIANO SOUZA
* @name        INTMER_CICOPAL
* @date        21/09/2022
* @empresa     ALUMBRA
* @description Programa para geracao dos pedidos gerados no Mercanet
********************************************************************
* 09/08/2023 - JULIANO SOUZA   - DESENVOLVIMENTO
* 
*/
User Function TABSMERC()
	chkfile("ZZQ")
	chkfile("ZZR")
	chkfile("ZA1")
Return

User Function INTMER01(aParam)
	Local aArea := GetArea()
	Local lAuto := IsBlind() //Se for por Schedule, abre o ambiente
	Private lMSErroAuto := .F.
	Private cObsPed  := ""
	Private cLocaliz := ""
	Private cObsMerc := ""
	Private aObsItem := {}
	Private cPedFil	 := ""
	Private cFilBkp	 := ""
	//Private cTabPreco:= ""
/*  Codigo da Mercanet 
	If ! IsInCallStack("SIGAIXB")
		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv("02","03",,,"FAT",,{})
	EndIf
*/
	Conout("## MERCANETs - "+dtoc(date())+" - "+Time()+" INTMER01 ## Start #" )
	If lAuto   // Leef - Assis 27/08/21 09:02
		Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##  lAuto = .T.(schedule) - Iniciando ")
		Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##  Empresa "+cvaltochar(aParam[1])+" Filial " + cvaltochar(aParam[2]))
		RpcSetType(3)
		RpcSetEnv(aParam[1], aParam[2])
	else
		MsgInfo("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ## Start #","Iniciando a rotina")
	EndIf
	Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##  Abrindo ZZQ #")
	dbSelectArea("ZZQ")
	ZZQ->(dbSetOrder(1)) //FILIAL + PED MERC

	SET FILTER TO ZZQ->ZZQ_STATUS == 'INS'	//Filtra somente itens novos

	ZZQ->(dbGoTop())
	While !ZZQ->(Eof())
		If Upper(AllTrim(ZZQ->ZZQ_STATUS)) == "INS"	.And. Empty(ZZQ->ZZQ_NUM)	//Ainda nao gerado no Protheus
			//Grava horario de inicio de processo
			dbSelectArea("ZZQ")
			If RecLock("ZZQ",.F.)
				//ZZQ->ZZQ_DTINI := dDataBase
				ZZQ->ZZQ_HRINI := Time()
				MsUnlock()
			EndIf
			Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##  Pronto para incluir novo Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER)
			cPedFil := ZZQ->ZZQ_FILIAL
			//Verifica se pedido ja foi incluido no sistema
			dbSelectArea("SC5")
			SC5->(dbSetOrder(11))	//FILIAL + PEDMER
			SC5->(dbGoTop())
			SC5->(dbSeek(cPedFil+ZZQ->ZZQ_PEDMER))
			If Found()
				Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " ja incluso na SC5 ")
				If RecLock("ZZQ",.F.)
					ZZQ->ZZQ_VAOBSL := "Pedido ja incluido no sistema! Num. Ped. Protheus: " + AllTrim(SC5->C5_NUM)
					ZZQ->ZZQ_STATUS := "ERR"
					MsUnlock()
				EndIf
				ZZQ->(dbSkip())
				Loop	//Pula o pedido
			EndIf
			Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " Nao existe na SC5 - Ira incluir")
			If ValidGeral()
				//Gera Pedido de Venda

				GeraPedido()
				// Assis - 300821 0955 - há um desposicionamentgo da ZZQ dentro da função GeraPedido()  - falta getarea() e restarea() dentro da função.


			Else
				dbSelectArea("ZZQ")
				If RecLock("ZZQ",.F.)
					ZZQ->ZZQ_VAOBSL := cObsMerc
					ZZQ->ZZQ_STATUS := "ERR"
					MsUnlock()
				EndIf
				//MsgAlert("Pedido "+ AllTrim(ZZQ->ZZQ_PEDMER) +" nao gerado devido a  inconsistaªncias, verifique!")
			EndIf
			//Grava horario de fim de processo
			dbSelectArea("ZZQ")
			If RecLock("ZZQ",.F.)
				//ZZQ->ZZQ_DTFIM := dDataBase
				ZZQ->ZZQ_HRFIM := Time()
				MsUnlock()
			EndIf

		EndIf

		ZZQ->(dbSkip())
	End
	Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##  Saindo While da ZZQ #")
	RestArea(aArea)

	/*  Codigo da Mercanet  
	If ! IsInCallStack("SIGAIXB")
		RpcClearEnv()
	EndIf
	*/
	If lAuto  
		RpcClearEnv()
		aParam := ASize(aParam, 0)
		aParam := Nil
	EndIf
Return

/****************************
** GERA CLIENTES  		   **	
****************************/
User Function INTMER02(aParam)
	
	Local lAuto := IsBlind() //Se for por Schedule, abre o ambiente 
	Local aArea := GetArea()
	Private lMSErroAuto := .F.
	Private lMSHelpAuto := .F.
	Private _aAuto		:= {}
	Private nOpc		:= 0
	Private aDados		:= {}
	
	// Se estiver sendo executado sem interface com o usuario, eh por que trata-se
	// de execucao em batch e deve preparar o ambiente
	/* 
	If ! IsInCallStack("SIGAIXB")
		//Inicia ambiente
		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv("01","010101",,,"FAT",,{})
	EndIf
	*/ 
	Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 ## Start #")
	If lAuto   // Leef - Assis 27/08/21 10:06
		Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 ##  lAuto = .T.(schedule) - Iniciando ")
		Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 ##  Empresa "+cvaltochar(aParam[1])+" Filial " + cvaltochar(aParam[2]))
		RpcSetType(3)
		RpcSetEnv(aParam[1], aParam[2])
	EndIf
	Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 ##  Abrindo ZA1 #")
	dbSelectArea("ZA1")
	ZA1->(dbSetOrder(1)) //FILIAL + PED MERC + CLIENTE + LOJA
	SET FILTER TO ZA1->ZA1_STATUS == 'INS'	//Filtra somente itens inseridos
	CONOUT("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 - SET FILTER TO ZA1->ZA1_STATUS == 'INS'")
	ZA1->(dbGoTop())
	If ! Empty(ZA1->ZA1_CODMER)	//Se nao houver um registro preenchido, ou todos estao deletados, ou nao ha dados na tabela
		While !ZA1->(Eof())
            if ZA1->ZA1_STATUS <>'INS'
				ZA1->(Dbskip())
				Loop
			endif
			CONOUT("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 -  PASSOU ZA1->ZA1_STATUS <>'INS' RECNO DA ZA1-> "+ str(ZA1->(Recno()),8))
			If Upper(AllTrim(ZA1->ZA1_STATUS)) <> "PRO" .and. Empty(ZA1->ZA1_COD) //Ainda nao gerado no Protheus
				CONOUT("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 -  PASSOU Upper(AllTrim(ZA1->ZA1_STATUS)) <> 'PRO'-> "+Upper(AllTrim(ZA1->ZA1_STATUS))+" .and. Empty(ZA1->ZA1_COD) ->#"+ ZA1->ZA1_COD + "# ")
				//Grava horario de inicio de processo
				dbSelectArea("ZA1")
				If RecLock("ZA1",.F.)
					CONOUT("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 -  PASSOU ATUALIZA HORA E DATA INICIAL RECNOZA1-> "+ str(ZA1->(Recno()),8))
					ZA1->ZA1_DTINI := dDataBase
					ZA1->ZA1_HRINI := Time()
					CONOUT("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 -  PASSOU ATUALIZADA :"+dtoc(ZA1->ZA1_DTINI)+"#"+ZA1->ZA1_HRINI+"  RECNOZA1-> "+ str(ZA1->(Recno()),8))
					MsUnlock()
				EndIf
				aDados 	:= {}
				dbSelectArea("SA1")
				SA1->(dbSetOrder(3)) //FILIAL + CGC
				SA1->(dbGoTop())
    			CONOUT("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 -  PASSOU TESTE SA1 filial+cgc ->#"+xFilial("SA1") + ZA1->ZA1_CGC+"# RECNO DA ZA1-> "+ str(ZA1->(Recno()),8))
				if !(SA1->(dbSeek(xFilial("SA1") + ZA1->ZA1_CGC)))
					nOpc := 3
					aAdd(aDados, {"A1_FILIAL"	, xFilial("SA1")																				,	Nil})
					//aAdd(aDados, {"A1_COD"    , iif(ZA1->ZA1_PESSOA=="F",SubStr(ZA1->ZA1_CGC,01,09),PADR(SubStr(ZA1->ZA1_CGC,01,08),09," "))	,	Nil})
					aAdd(aDados, {"A1_COD"    	, GetSXENum("SA1","A1_COD")	,	Nil})
					aAdd(aDados, {"A1_LOJA"   	, '01'											,	Nil})
					aAdd(aDados, {"A1_NOME"   	, PADR(UPPER(ZA1->ZA1_NOME)			,TAMSX3("A1_NOME")[1])										,	Nil})
					aAdd(aDados, {"A1_NREDUZ" 	, PADR(UPPER(ZA1->ZA1_NREDUZ)			,TAMSX3("A1_NREDUZ")[1])									,	Nil})
					aAdd(aDados, {"A1_TIPO"   	, PADR("S"							,TAMSX3("A1_TIPO")[1])						,	Nil})
					aAdd(aDados, {"A1_PESSOA" 	, ZA1->ZA1_PESSOA																		,	Nil})
					aAdd(aDados, {"A1_CGC"    	, PADR(ZA1->ZA1_CGC				,TAMSX3("A1_CGC")[1])						,	Nil})
					aAdd(aDados, {"A1_END"    	, PADR(UPPER(ZA1->ZA1_END)			,TAMSX3("A1_END")[1])						,	Nil})
					aAdd(aDados, {"A1_BAIRRO" 	, PADR(UPPER(ZA1->ZA1_BAIRRO)		,TAMSX3("A1_BAIRRO")[1])					,	Nil})
					aAdd(aDados, {"A1_EST"    	, PADR(ZA1->ZA1_EST					,TAMSX3("A1_EST")[1])						,	Nil})
					aAdd(aDados, {"A1_MUN"    	, PADR(UPPER(ZA1->ZA1_MUN)			,TAMSX3("A1_MUN")[1])						,	Nil})
					aAdd(aDados, {"A1_CEP"    	, PADR(ZA1->ZA1_CEP					,TAMSX3("A1_CEP")[1])						,	Nil})
					aAdd(aDados, {"A1_COD_MUN"	, PADR(ZA1->ZA1_COD_MU				,TAMSX3("A1_COD_MUN")[1])					,	Nil})
					aAdd(aDados, {"A1_TEL"    	, PADR(ZA1->ZA1_TEL					,TAMSX3("A1_TEL")[1])						,	Nil})
					aAdd(aDados, {"A1_EMAIL"  	, PADR(lower(AllTrim(ZA1->ZA1_EMAIL)),TAMSX3("A1_EMAIL")[1])						,	Nil})
					aAdd(aDados, {"A1_PAIS"   	, PADR("105"						,TAMSX3("A1_PAIS")[1])						,	Nil})
					aAdd(aDados, {"A1_CODPAIS"	, PADR("01058"						,TAMSX3("A1_CODPAIS")[1])					,	Nil})
					aAdd(aDados, {"A1_VEND"   	, PADR(ZA1->ZA1_VEND					,TAMSX3("A1_VEND")[1])						,	Nil})
					aAdd(aDados, {"A1_COND"   	, PADR(ZA1->ZA1_COND				,TAMSX3("A1_COND")[1])						,	Nil})
					aAdd(aDados, {"A1_MSBLQL" 	, PADR("2"							,TAMSX3("A1_MSBLQL")[1])					,	Nil})
					aAdd(aDados, {"A1_INSCR"  	, UPPER(ZA1->ZA1_INSCR)														,	Nil})
					aAdd(aDados, {"A1_ENDCOB"	, ZA1->ZA1_ENDC																,	Nil})
					aAdd(aDados, {"A1_BAIRROC"	, ZA1->ZA1_BAIRRC																	,	Nil})
					aAdd(aDados, {"A1_CEPC"		, ZA1->ZA1_CEPC																,	Nil})
					aAdd(aDados, {"A1_ESTC"		, ZA1->ZA1_ESTC																	,	Nil})
					//************************************************
					//FWVetByDic Funçao ordenar um vetor conforme o
					//dicionario para uso em, por exemplo, rotinas de MSExecAuto.
					//************************************************
					aDados := FWVetByDic(aDados, "SA1")
					//Grava Cliente
					GeraCli(aDados, nOpc)
				Else
					dbSelectArea("ZA1")
					If RecLock("ZA1",.F.)
						ZA1->ZA1_STATUS := "ERR"	// ERR - Status utilizado quando o registro for processado pelo Protheus e ocorreu erro durante o processamento
						ZA1->ZA1_ERRO 	:= "Cliente ja cadastrado"
						MsUnlock()
					EndIf
				ENDIF
				//Grava horario de fim de processo
				If RecLock("ZA1",.F.)
					ZA1->ZA1_DTFIM := dDataBase
					ZA1->ZA1_HRFIM := Time()
					MsUnlock()
				EndIf
			EndIf
			ZA1->(dbSkip())
		End
	Else
		/*
		If IsInCallStack("SIGAIXB")	//So apresenta msg por menu
			MsgAlert("Nao existem para importar!")
		EndIf
		*/
		If !lAuto
			MsgAlert("Nao existem para importar!")
		EndIf
		Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 ##  Nenhum cliente para iomportar")
		GeraLog("Nao para importar !", '',2)
	endif
	RestArea(aArea)
	If lAuto  // Leef - Assis 27/08/21 09:10
		RpcClearEnv()
		aParam := ASize(aParam, 0)
		aParam := Nil
	EndIf
	/*
	If ! IsInCallStack("SIGAIXB")
		//Finaliza Ambiente
		RpcClearEnv()
	EndIf
	*/
Return

/****************************
** GERA PEDIDO DE VENDA	   **	
****************************/
Static Function ValidGeral()
	
	Local lRet 		:= .T.
	Local nTotSaldo := 0
	
	aObsItem := {}
	cObsMerc := ""
	
	Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " Iniciando Validacao. ValidGeral() - ZZR ")

	dbSelectArea("ZZR")
	ZZR->(dbSetOrder(1))	//FILIAL + PED MERC + ITEM PED MERC + PRODUTO + LOCAL
	ZZR->(dbGoTop())
	ZZR->(dbSeek(cPedFil+ZZQ->ZZQ_PEDMER))
	If Found()

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))	//FILIAL + PRODUTO
		While !ZZR->(Eof()) .And. AllTrim(ZZR->ZZR_PEDMER) == AllTrim(ZZQ->ZZQ_PEDMER)
			
			dbSelectArea("SB1")
			SB1->(dbGoTop())
			SB1->(dbSeek(xFilial("SB1") + AllTrim(ZZR->ZZR_PRODUT)))
			If Found()
				
				If SB1->B1_MSBLQL == "2"	//Nao bloqueado
					
					//Verifica Saldo
					dbSelectArea("SB2")
					SB2->(dbSetOrder(1))	//FILIAL + PRODUTO + LOCAL
					SB2->(dbGoTop())
					// SB2->(dbSeek(xFilial("SB2") + SB1->B1_COD + SB1->B1_LOCPAD))
					SB2->(dbSeek(ZZQ->ZZQ_FILIAL + SB1->B1_COD + SB1->B1_LOCPAD))
					If Found()
						//Saldo em estoque
						nSaldo := SB2->B2_QATU - SB2->B2_QEMP
						
						//Saldo em estoque deve ser maior ou igual ao requisitado
						If nSaldo < ZZR->ZZR_QTDVEN
							GeraLog("Nao ha saldo suficiente para o produto "+AllTrim(SB1->B1_COD), ZZQ->ZZQ_PEDMER, 1)
							ObsItem(aObsItem, AllTrim(SB1->B1_COD), "Nao ha saldo suficiente para o produto;", "SALDO")
							Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Nao ha saldo suficiente para o produto "+AllTrim(SB1->B1_COD))
						EndIf
						//Verifica Endereço
						If SB1->B1_LOCALIZ == "S"
							Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Produto controla endereço, deve ser informado um endereço. Produto "+AllTrim(SB1->B1_COD))
							ObsItem(aObsItem, AllTrim(SB1->B1_COD), " Produto controla endereço, deve ser informado um endereço. ", "ENDEREÇO")
							
						EndIf
						//Verifica Lote
						If SB1->B1_RASTRO == "S"
							Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Produto controla lote, deve ser informado um lote. "+AllTrim(SB1->B1_COD))
							ObsItem(aObsItem, AllTrim(SB1->B1_COD), " Produto controla lote, deve ser informado um lote. ", "LOTE")
						EndIf
					Else
						Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Nao ha registro de saldo para o produto. "+AllTrim(SB1->B1_COD))
						GeraLog("Nao ha registro de saldo para o produto "+AllTrim(SB1->B1_COD) ,ZZQ->ZZQ_PEDMER, 1)
						ObsItem(aObsItem, AllTrim(SB1->B1_COD), "Nao ha registro de saldo para o produto;", "SALDO")
					EndIf
					
				Else
					Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Produto se encontra bloqueado no sistema: "+AllTrim(SB1->B1_COD))
					GeraLog("Produto se encontra bloqueado no sistema: "+AllTrim(SB1->B1_COD), ZZQ->ZZQ_PEDMER, 1)
					cObsMerc += "Produto se encontra bloqueado no sistema: "+AllTrim(ZZR->ZZR_PRODUT)+";"
					lRet := .F.
				EndIf
				
			Else
				GeraLog("Produto nao encontrado: "+AllTrim(ZZR->ZZR_PRODUT), ZZQ->ZZQ_PEDMER, 1)
				cObsMerc += "Produto nao encontrado: "+AllTrim(ZZR->ZZR_PRODUT)+";"
				Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Produto nao encontrado: "+AllTrim(ZZR->ZZR_PRODUT))
				lRet := .F.
			EndIf
			
			dbSelectArea("ZZR")
			ZZR->(dbSkip())
		End
	Else
		GeraLog("Nenhum item encontrado para o pedido!", ZZQ->ZZQ_PEDMER, 1)
		cObsMerc += "Nenhum item encontrado para o pedido;"
		Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Nenhum item encontrado para o pedido  ")
		lRet := .F.
	EndIf

	//VERIFICAa‡aƒO DE TABELA DE PREa‡O
	//cTabPreco := ""
    /*
	If ! Empty(ZZQ->ZZQ_TABELA)
		dbSelectArea("DA0")
		DA0->(dbSetOrder(1))
		DA0->(dbGoTop())
		DA0->(dbSeek( xFilial("DA0")+ZZQ->ZZQ_TABELA ))
		If Found()
			cTabPreco := DA0->DA0_CODTAB
		Else
			GeraLog("Nao foi encontrada a tabela de preço "+AllTrim(ZZQ->ZZQ_TABELA)+" para a Filial: "+cPedFil+"!", ZZQ->ZZQ_PEDMER, 1)
			If RecLock("ZZQ",.F.)
				ZZQ->ZZQ_VAOBSL := AllTrim(ZZQ->ZZQ_VAOBSL) + " Nao foi encontrada a tabela de preço "+AllTrim(ZZQ->ZZQ_TABELA)+" para a Filial: "+cPedFil+";"
				MsUnlock()
			EndIf
		EndIf
	EndIf
	*/
	//VERIFICAa‡aƒO DE CONDIa‡aƒO DE PAGAMENTO
	If ! Empty(ZZQ->ZZQ_CONDPA)
		dbSelectArea("SE4")
		SE4->(dbSetOrder(1))
		SE4->(dbGoTop())
		SE4->(dbSeek( xFilial("SE4")+ZZQ->ZZQ_CONDPA ))
		If ! Found()
			GeraLog("Nao foi encontrada condiçao de pagamento "+AllTrim(ZZQ->ZZQ_CONDPA)+" para a Filial: "+cPedFil+"!", ZZQ->ZZQ_PEDMER, 1)
			cObsMerc += "Nao foi encontrada condiçao de pagamento "+AllTrim(ZZQ->ZZQ_CONDPA)+" para a Filial: "+cPedFil+";"
			Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - " + "Nao foi encontrada condiçao de pagamento "+AllTrim(ZZQ->ZZQ_CONDPA)+" para a Filial: "+cPedFil)
			lRet := .F.
		EndIf
	EndIf

	//VERIFICAa‡aƒO DE CLIENTE
	If ! Empty(ZZQ->ZZQ_CLIENT) .And. ! Empty(ZZQ->ZZQ_LOJACL)

		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(dbGoTop())	//FILIAL + CLIENTE + LOJA
		SA1->(dbSeek(xFilial("SA1") + ZZQ->ZZQ_CLIENT + ZZQ->ZZQ_LOJACL))
		If Found()

			If SA1->A1_MSBLQL == "1"
				 RECLOCK("SA1", .F.)
            		SA1->A1_MSBLQL := '2'
          		 MSUNLOCK()     // Destrava o registro
				//Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Cliente Bloqueado: "+AllTrim(ZZQ->ZZQ_CLIENT)+" Loja: "+AllTrim(ZZQ->ZZQ_LOJACL))
				//GeraLog("Cliente Bloqueado: "+AllTrim(ZZQ->ZZQ_CLIENT)+" Loja: "+AllTrim(ZZQ->ZZQ_LOJACL), ZZQ->ZZQ_PEDMER, 1)
				//cObsMerc += "Cliente Bloqueado: "+AllTrim(ZZQ->ZZQ_CLIENT)+" Loja: "+AllTrim(ZZQ->ZZQ_LOJACL)+";"
				//lRet := .F.
			EndIf

			/* 
			--- Não está faz sentido pegar todas duplicatas
			--- o limite de credito utilizamos o padrão pelo ponto de entrada
			-- M410STTS -> u_libsup
			//VERIFICAa‡aƒO DE LIMITE DE CRa‰DITO
			dbSelectArea("SE1")
			SE1->(dbSetOrder(2))	//FILIAL + CLIENTE + LOJA
			SE1->(dbGoTop())
			SE1->(dbSeek(cPedFil + AllTrim(ZZQ->ZZQ_CLIENT) + AllTrim(ZZQ->ZZQ_LOJACL)))

			bWhile := {|| !SE1->(Eof()) .And. cPedFil == SE1->E1_FILIAL .And.;
				AllTrim(ZZQ->ZZQ_CLIENT) == AllTrim(SE1->E1_CLIENTE) .And.;
				AllTrim(ZZQ->ZZQ_LOJACL) == AllTrim(SE1->E1_LOJA) }
			While ( Eval(bWhile) )
				If SE1->E1_SALDO > 0
					nTotSaldo += SE1->E1_SALDO
				EndIf
				dbSelectArea("SE1")
				SE1->(dbSkip())
			End

			If (nTotSaldo + ZZQ->ZZQ_VTOT) > SA1->A1_LC

				If !("Limite de credito do cliente ultrapassado." $ ZZQ->ZZQ_VAOBSL)
					//Permite gerar o Pedido, mas adiciona aviso caso tenha ultrapassado o limite de cra©dito
					If RecLock("ZZQ",.F.)
						ZZQ->ZZQ_VAOBSL := AllTrim(ZZQ->ZZQ_VAOBSL) + "; Limite de credito do cliente ultrapassado. "
						MsUnlock()
					EndIf
					Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Limite de credito ultrapassado, cliente: "+AllTrim(ZZQ->ZZQ_CLIENT)+" Loja: "+AllTrim(ZZQ->ZZQ_LOJACL))
					//MsgAlert("Limite de cra©dito ultrapassado, cliente: "+AllTrim(ZZQ->ZZQ_CLIENT)+" Loja: "+AllTrim(ZZQ->ZZQ_LOJACL))
					GeraLog("Limite de credito ultrapassado, cliente: "+AllTrim(ZZQ->ZZQ_CLIENT)+" Loja: "+AllTrim(ZZQ->ZZQ_LOJACL), ZZQ->ZZQ_PEDMER, 1)
				EndIf

			EndIf
			*/

		Else
			Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Cliente inexistente: "+AllTrim(ZZQ->ZZQ_CLIENT)+" Loja: "+AllTrim(ZZQ->ZZQ_LOJACL))
			GeraLog("Cliente inexistente: "+AllTrim(ZZQ->ZZQ_CLIENT)+" Loja: "+AllTrim(ZZQ->ZZQ_LOJACL), ZZQ->ZZQ_PEDMER, 1)
			cObsMerc += "Cliente inexistente: "+AllTrim(ZZQ->ZZQ_CLIENT)+" Loja: "+AllTrim(ZZQ->ZZQ_LOJACL)+";"
			lRet := .F.
		EndIf
	Else
		Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Campo cliente e/ou loja vazio! "+AllTrim(ZZQ->ZZQ_CLIENT)+" Loja: "+AllTrim(ZZQ->ZZQ_LOJACL))
		GeraLog("Campo cliente e/ou loja vazio!"+AllTrim(ZZQ->ZZQ_CLIENT)+" Loja: "+AllTrim(ZZQ->ZZQ_LOJACL), ZZQ->ZZQ_PEDMER, 1)
		cObsMerc += "Campo cliente e/ou loja vazio!"+AllTrim(ZZQ->ZZQ_CLIENT)+" Loja: "+AllTrim(ZZQ->ZZQ_LOJACL)+";"
		lRet := .F.
	EndIf


	//VERIFICAa‡aƒO DE TRANSPORTADORA
	If ! Empty(ZZQ->ZZQ_TRANSP)
		dbSelectArea("SA4")
		SA4->(dbSetOrder(1))	//FILIAL + CODIGO
		SA4->(dbGoTop())
		SA4->(dbSeek(xFilial("SA4") + ZZQ->ZZQ_TRANSP))
		If ! Found()
			GeraLog("Transportadora nao cadastrada: "+AllTrim(ZZQ->ZZQ_TRANSP), ZZQ->ZZQ_PEDMER, 1)
		EndIf
	EndIf

	//VERIFICAa‡aƒO DE VENDEDOR
	If ! Empty(ZZQ->ZZQ_VEND1)
		dbSelectArea("SA3")
		SA3->(dbSetOrder(1))	//FILIAL + CODIGO
		SA3->(dbGoTop())
		SA3->(dbSeek(xFilial("SA3") + ZZQ->ZZQ_VEND1))
		If ! Found()
			Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Vendedor nao cadastrado: "+AllTrim(ZZQ->ZZQ_VEND1))
			GeraLog("Vendedor nao cadastrado: "+AllTrim(ZZQ->ZZQ_VEND1), ZZQ->ZZQ_PEDMER, 1)
			cObsMerc += "Vendedor nao cadastrado: "+AllTrim(ZZQ->ZZQ_VEND1)+";"
			lRet := .F.
		EndIf
	Else
		Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Vendedor nao Informado")
		GeraLog("Vendedor nao informado!", ZZQ->ZZQ_PEDMER, 1)
		cObsMerc += "Vendedor nao informado;"
		lRet := .F.
	EndIf

	//VERIFICAa‡aƒO DO CAMPO TIPO DO PEDIDO
	If ! Empty(ZZQ->ZZQ_TIPVEN)
		If !(AllTrim(ZZQ->ZZQ_TIPVEN) $ "N|D|C|P|I|B")
			//N-> Pedidos Normais.
			//D-> Pedidos para Devoluçao de Compras. (Excl. Brasil)
			//C-> Compl. Preços.(Excl. Brasil)
			//P-> Compl. de IPI. (Excl. Brasil)
			//I-> Compl. de ICMS. (Excl. Brasil)
			//B-> Apres. Fornec. qdo material p/Benef.
		    Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - O tipo de venda informado no cabeçalho do pedido nao e reconhecido no Protheus! Os tipos reconhecidos sao N,D,C,P,I e B, foi informado o tipo: " + AllTrim(ZZQ->ZZQ_TIPVEN))
			GeraLog("O tipo de venda informado no cabeçalho do pedido nao e reconhecido no Protheus! Os tipos reconhecidos sao N,D,C,P,I e B, "+;
				"foi informado o tipo: " + AllTrim(ZZQ->ZZQ_TIPVEN), ZZQ->ZZQ_PEDMER, 1)
			cObsMerc += "O tipo de venda informado nao a© reconhecido no Protheus;"
			lRet := .F.
		EndIf
	Else
		Conout("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 ##   Pedido Mercanet -> "+ZZQ->ZZQ_PEDMER + " - Nao ha tipo de venda informado para o pedido!")
		GeraLog("Nao ha tipo de venda informado para o pedido!", ZZQ->ZZQ_PEDMER, 1)
		cObsMerc += "Nao ha tipo de venda informado para o pedido;"
		lRet := .F.
	EndIf


Return lRet

/****************************
** VALIDA CLIENTE		   **	
** Autor: Daniel Scheeren  **
** Data:  25/10/2017	   **
****************************/
/// Funçao Nao e utilizada -  comentadao por Assis em 270821 1015
/*
Static Function ValidCli()
	
	Local lRet    := .T.	//Valida total
	Local lFound  := .F.	//Encontrou campo
	Local lEmpty  := .F.	//Campo vazio
	Local aItensObr := {}
	Local nCampo, i
	//Monta array com campos obrigatorios
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("SA1"))
	While !SX3->(Eof()) .And. (X3_ARQUIVO == "SA1")
		If X3USO(X3_USADO) .And. X3Obrigat(X3_CAMPO) .And. cNivel >= X3_NIVEL
			
			aAdd(aItensObr, { Alltrim(X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_ARQUIVO,;
							SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		SX3->(dbSkip())
	End
	
	dbSelectArea("ZA1")
	For nCampo := 1 To ZA1->(FCount())
		lFound := .T.
		lEmpty := .F.
		
		For i := 1 To Len(aItensObr)
			cCampo := "A1" + SubStr(ZA1->(FieldName(nCampo)), 4)	//Retira o "ZA1" do inicio do campo para comparar
			
			If ( AllTrim(cCampo) == SubStr(AllTrim(aItensObr[i,2]),1,9) )	//Verifica se acha os campos nos obrigatorios, pois nao pode estar vazio
				lFound := .T.
				
				If "A1_COD" != AllTrim(cCampo) .And. "A1_LOJA" != AllTrim(cCampo)	//Campos que serao gerados depois
					
					xConteudo := ZA1->&(ZA1->(FieldName(nCampo)))
					If ! Empty(xConteudo)	//Se estiver vazio altera variavel para gerar log e avisar que o campo obrigatorio esta vazio
						aAdd (_aAuto, {AllTrim(aItensObr[i,2]), If((ValType(xConteudo)=="C"),AllTrim(NoAcento(xConteudo)),xConteudo), Nil})
					Else
						lEmpty := .T.
					EndIf
					Exit
				EndIf
				
			ElseIf "A1_COD" != AllTrim(cCampo) .And. "A1_LOJA" != AllTrim(cCampo)
				lFound := .F.	//Nao encontrou campo nos obrigatorios 
			EndIf
			
			
		Next
		
		If lEmpty	//Campo obrigatorio vazio
			lRet   := .F.
			lEmpty := .F.
			GeraLog("Campo "+AllTrim(ZA1->(FieldName(nCampo)))+" nao preenchido!", ZA1->ZA1_CODMER, 2)
			
			dbSelectArea("ZA1")
			If !(("Campo " + AllTrim(ZA1->(FieldName(nCampo))) + " nao preenchido") $ ZA1->ZA1_ERRO2)
				If RecLock("ZA1",.F.)
					ZA1->ZA1_ERRO2 := AllTrim(ZA1->ZA1_ERRO2) + "Campo " + AllTrim(ZA1->(FieldName(nCampo))) + " nao preenchido;"
					MsUnlock()
				EndIf
			EndIf
			//Atualiza mesmo se ja possuir o aviso
			If RecLock("ZA1",.F.)
				ZA1->ZA1_STATUS := "ERR"	// ERR - Status utilizado quando o registro for processado pelo Protheus e ocorreu erro durante o processamento
				MsUnlock()
			EndIf
		EndIf
		
		//Nao encontrou no array de campos obrigatorios, verifica se o campo esta presente nos campos nao obrigatorios
		If !lFound
			
			dbSelectArea("SX3")
			SX3->(dbGoTop())
			SX3->(dbSeek("SA1"))
			While !SX3->(Eof()) .And. (X3_ARQUIVO == "SA1")
				If X3USO(X3_USADO) .And. !X3Obrigat(X3_CAMPO) .And. cNivel >= X3_NIVEL
					
					If AllTrim(X3_CAMPO) == AllTrim(cCampo)
						aAdd(_aAuto, {cCampo, ZA1->&(ZA1->(FieldName(nCampo))), Nil})
					EndIf
					
				EndIf
				dbSelectArea("SX3")
				SX3->(dbSkip())
			End
			
		EndIf
		
	Next
	aAdd (_aAuto, {"A1_PAIS"	,"105"	, Nil})	//Fixo Brasil
	aAdd (_aAuto, {"A1_CODPAIS"	,"01058", Nil})	//Fixo Brasil
	aAdd (_aAuto, {"A1_MSBLQL"	,"2"	, Nil})	//Nasce bloqueado
	aAdd (_aAuto, {"A1_CONTATO"	,ZA1->ZA1_CONTAT	, Nil})	//Contato
Return lRet
*/

/****************************************
** MONTA ARRAY DE MSG DOS PRODUTOS	   **	
****************************************/
Static Function ObsItem(aObsItem, cProd, cMsg, cPalavChav)
	
	Local lFound := .F.
	local i := 0   // Assis 27/08/21 0955 - Schedule tem que inicializar variaveis.
	If Len(aObsItem) > 0
		For i := 1 To Len(aObsItem)
			
			If AllTrim(aObsItem[i,1]) == AllTrim(cProd)
				lFound := .T.
				
				//encontrou o produto no array ja com mensagem
				If At(cPalavChav, Upper(aObsItem[i,2])) == 0	//Nao encontrou a mesma mensagem, soma
					aObsItem[i,2] += cMsg
				EndIf
				
				Exit
			EndIf
		Next
		
		If !lFound	//Nao achou o produto com mensagem
			aAdd(aObsItem, {AllTrim(cProd),cMsg})
		EndIf
	Else	//Nenhum produto possui mensagem
		aAdd(aObsItem, {AllTrim(cProd),cMsg})
	EndIf
	
Return


/****************************
** GERA PEDIDO DE VENDA	   **
****************************/
Static Function GeraPedido()
	Local nX     := 0
	Local aCabec    := {}
	Local aCabec2   := {}
	Local aItens    := {}
	Local cDocMerc  := ""
	Local cObsItem  := ""
	Local cErroExec := ""
	Local cErroComp := ""
	Local i
	Local x // tem que declarar todas as variaveis em Schedule 
	Local aErroExec := {}
	Local lAuto     := IsBlind()
	Local xAgeraGP  := getarea() 
	Local cArquivo  := ""
	PUBLIC cDoc       := ""  

	lMsErroAuto := .F.
	
	dbSelectArea("ZZQ")
	cDocMerc := AllTrim(ZZQ->ZZQ_PEDMER)
	
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbGoTop())	//FILIAL + CLIENTE + LOJA
	SA1->(dbSeek(xFilial("SA1") + ZZQ->ZZQ_CLIENT + ZZQ->ZZQ_LOJACL))

	dbSelectArea("ZZR")
	ZZR->(dbSetOrder(1))	//FILIAL + PED MERC + PRODUTO + LOCAL
	ZZR->(dbGoTop())
	ZZR->(dbSeek(cPedFil + ZZQ->ZZQ_PEDMER))
	If Found()

		W_ENTREGA = ctod('19000101')
		While !ZZR->(Eof()) .And. AllTrim(ZZR->ZZR_PEDMER) == AllTrim(ZZQ->ZZQ_PEDMER)
			If W_ENTREGA < ctod(ZZR->ZZR_ENTREG)
				W_ENTREGA = ctod(ZZR->ZZR_ENTREG)
			EndIf
			ZZR->(dbSkip())				
		End
	End if
	
 	cDoc := GetSxeNum("SC5", "C5_NUM")

	aadd(aCabec2,{"C5_NUM"    , cDoc     , Nil})
	aAdd(aCabec2,{"C5_FILIAL"	,cPedFil			,Nil})
	aAdd(aCabec2,{"C5_TIPO" 	,ZZQ->ZZQ_TIPVEN	,Nil})
	aAdd(aCabec2,{"C5_CLIENTE"	,ZZQ->ZZQ_CLIENT	,Nil})		
	aAdd(aCabec2,{"C5_LOJACLI"	,ZZQ->ZZQ_LOJACL	,Nil})		
	aAdd(aCabec2,{"C5_CONDPAG"	,ZZQ->ZZQ_CONDPA	,Nil}) 
	aAdd(aCabec2,{"C5_TIPOCLI"	,SA1->A1_TIPO		,Nil})
	aAdd(aCabec2,{"C5_VEND1"  	,ZZQ->ZZQ_VEND1		,Nil})
	aAdd(aCabec2,{"C5_TPFRETE"	,ZZQ->ZZQ_TPFRET	,Nil})
	aAdd(aCabec2,{"C5_BANCO"	,ZZQ->ZZQ_BANCO		,Nil})
	aAdd(aCabec2,{"C5_PEDMER"	,ZZQ->ZZQ_PEDMER	,Nil})
	aAdd(aCabec2,{"C5_TRANSP"	,ZZQ->ZZQ_TRANSP	,Nil})
	aAdd(aCabec2,{"C5_FECENT"	,W_ENTREGA	        ,Nil})
	aAdd(aCabec2,{"C5_XSTEX"	,'AX'   	        ,Nil})
	aAdd(aCabec2,{"C5_COMENT"	,ZZQ->ZZQ_OBS       ,Nil})
 

	dbSelectArea("ZZR")
	ZZR->(dbSetOrder(1))	//FILIAL + PED MERC + PRODUTO + LOCAL
	ZZR->(dbGoTop())
	ZZR->(dbSeek(cPedFil + ZZQ->ZZQ_PEDMER))
	If Found()
		While !ZZR->(Eof()) .And. AllTrim(ZZR->ZZR_PEDMER) == AllTrim(ZZQ->ZZQ_PEDMER)
			
			cObsItem := ""
			
			For i := 1 To Len(aObsItem)
				
				If AllTrim(aObsItem[i,1]) == AllTrim(ZZR->ZZR_PRODUT)
					cObsItem := aObsItem[i,2]
				EndIf
			Next
			
			
			aLinha := {}
			aAdd(aLinha,{"C6_FILIAL"	,cPedFil			    ,Nil})
			aAdd(aLinha,{"C6_ITEM"		,STRZERO(val(ZZR->ZZR_ITPMER),2)	,Nil})
			aAdd(aLinha,{"C6_PRODUTO"	,PadR(AllTrim(ZZR->ZZR_PRODUT),TamSX3("C6_PRODUTO")[1]," "),Nil})   
			aAdd(aLinha,{"C6_QTDLIB"	,0              	    ,Nil}) 
			aAdd(aLinha,{"C6_QTDVEN"	,ZZR->ZZR_QTDVEN	    ,Nil}) 
		   	aAdd(aLinha,{"C6_PRCVEN"	,ZZR->ZZR_VLR_LI	    ,Nil}) 
		   	aAdd(aLinha,{"C6_PRUNIT"	,ZZR->ZZR_VLR_LI	    ,Nil})
			aAdd(aLinha,{"C6_VALOR"		,ZZR->ZZR_VALOR		    ,Nil})
			aAdd(aLinha,{"C6_OPER"		,ZZR->ZZR_OPER		    ,Nil})
			aAdd(aLinha,{"C6_TES"		,ZZR->ZZR_TES		    ,Nil})
			aAdd(aLinha,{"C6_TPOP"		,'F'	        	    ,Nil})
			aAdd(aLinha,{"C6_COMIS1"	,ZZR->ZZR_COMIS1	    ,Nil})
			aAdd(aLinha,{"C6_ENTREG"	,ctod(INVERDT(ZZR->ZZR_ENTREG))	,Nil})
			aAdd(aLinha,{"C6_UM"		,Posicione("SB1",1,xFilial("SB1")+ZZR->ZZR_PRODUT,"B1_UM")	,Nil})
			aAdd(aLinha,{"C6_LOCAL"		,ZZR->ZZR_LOCAL		    ,Nil})				


			aAdd(aItens, aClone(OrdCampos(aLinha)))
			
			ZZR->(dbSkip())
		End
		
	Endif
	
	cFilBkp := cFilAnt	//Bkp da filial do sistema
	cFilAnt := cPedFil	//Carrega a filial desejada para o pedido, para geraçao do numero do documento
	
	dbSelectArea("SM0")
    SM0->(dbSeek(cEmpAnt+cPedFil))    //M0_CODIGO + M0_CODFIL
    
    //cDoc := NextNumero("SC5",1,"C5_NUM",.T.)
    //aadd(aCabec2,{"C5_NUM"    ,cDoc            ,Nil})
    aCabec := aClone(OrdCampos(aCabec2))
	
	ConfirmSX8()
	
	// Inclusao 			                                         |
	dbSelectArea("SC5")
	MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItens,3) 
	
	If !lMsErroAuto		//Gravou
		
		//Pega ultimo numero registrado para o campo ZZQ_FILA
		dbSelectArea("ZZQ")
		ZZQ->(dbSetOrder(2)) //FILIAL + FILA + PED MERC
		ZZQ->(dbGoBottom())
		cFila := If((Empty(ZZQ->ZZQ_FILA)),"0000000000",ZZQ->ZZQ_FILA)	//Inicia em zero, pois a© somado 1 
		
		//Posiciona novamente no registro do pedido para gravar os dados
		ZZQ->(dbSetOrder(1)) //FILIAL + PED MERC + CLIENTE + LOJA
		ZZQ->(dbGoTop())
		ZZQ->(dbSeek(cPedFil + cDocMerc))
		If RecLock("ZZQ",.F.)
			ZZQ->ZZQ_STATUS := "PRO"	// PRO - Registro processado pelo Protheus e pedido Inserido com sucesso
			ZZQ->ZZQ_NUM 	:= cDoc
			If Empty(ZZQ->ZZQ_FILA)
				ZZQ->ZZQ_FILA	:= Soma1(cFila)
			EndIf
			MsUnlock()
		EndIf
		
		//LOG
		GeraLog("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER01 - Usuario "+AllTrim(cUserName)+" incluiu pedido: "+AllTrim(cDoc)+" no ambiente: "+Upper(GetEnvServer())+" na filial: "+cFilAnt, cDocMerc, 1)
		
	// Erro na gravaçao          |
	Else
		cArquivo  := "LOG_ERRO_PEDMER_" + StrTran(ZZQ->ZZQ_PEDMER,"/","_") + ".log"
		cErroExec := ""               
		If !lAuto
			// Erro Para Rotina Manual
			cErroComp := MostraErro()
			aErroExec := StrTokArr( cErroComp, Chr(13) + Chr(10))
		Else
            // Erro Para Rotina Automatica (Schedule)
			// \protheus_data\system\mercanet Não esta salvando funcionado
			cErroComp := MostraErro("\mercanet\", cArquivo)
		EndIf
		
		aErroExec := StrTokArr(cErroComp , Chr(13) + Chr(10))
		
		GeraLogFile(cArquivo, cErroComp)

		For i := 1 To Len(aErroExec)
			If At("INVALIDO", Upper(aErroExec[i])) > 0
				cErroExec := AllTrim(aErroExec[i]) + " | "
			EndIf
		Next
		For i := 1 To Len(aErroExec)
			If At("OBRIGAT", Upper(aErroExec[i])) > 0
				For x := i+1 To 4
					cErroExec += AllTrim(aErroExec[x]) + " | "
				Next
			EndIf
		Next
		// For i := 1 To Len(aErroExec)
		// 	If At("A410VZ", Upper(aErroExec[i])) > 0
		// 		For x := i+1 To 5
		// 			cErroExec += AllTrim(aErroExec[x]) + " "
		// 		Next
		// 			cErroExec += "-" + AllTrim(aErroExec[25]) + " "
		// 	EndIf
		// Next

		If (Len(cErroExec) < 500 .and. !Empty(aErroExec))
			For i := 1 To Len(aErroExec)
				If Len(cErroExec) < 500
					cErroExec += aErroExec[i] + " | "
				EndIf
			Next
		EndIf

		dbSelectArea("ZZQ")
		If RecLock("ZZQ",.F.)
			ZZQ->ZZQ_STATUS := "ERR"	// ERR - Status utilizado quando o registro for processado pelo Protheus e ocorreu erro durante o processamento
			ZZQ->ZZQ_VAOBSL	:= "Erro: " + Left(cErroExec, 145)
			MsUnlock()
		EndIf

		GeraLog("Pedido nao gerado devido ao seguinte erro: " + cErroExec, ZZQ->ZZQ_PEDMER, 1)
		
	EndIf
	
	cFilAnt := cFilBkp	//Retorna filial do sistema
	
	//Volta a  empresa inicial
	dbSelectArea("SM0")
	SM0->(dbSeek(cEmpAnt+cFilAnt))    //M0_CODIGO + M0_CODFIL
	RESTAREA(xAgeraGP)
Return

/****************************
** GERA CLIENTE			   **	
** Autor: Daniel Scheeren  **
** Data:  25/10/2017	   **
****************************/
Static Function GeraCli(aDados, nOpc)
	Local i, x
	Local lAuto := isBlind()
	Local xAreaGet:=GETAREA()
	lMSErroAuto := .F.
	dbSelectArea("ZA1")
	cCodMerc := ZA1->ZA1_CODMER
	cFiliall := ZA1->ZA1_FILIAL
	dbSelectArea("SA1")
	CONOUT("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 - GERACLI()  MSEXECAUTOSA1 filial+cgc ->#"+xFilial("SA1") + ZA1->ZA1_CGC+"# RECNO DA ZA1-> "+ str(ZA1->(Recno()),8))
	CONOUT("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 - GERACLI()  MSEXECAUTOSA1 aDados "+ VARINFO("aDados",aDados))
	// MSExecAuto({|x,y| Mata030(x,y)},aDados,nOpc) //3- Inclusao, 4- Alteraçao *** descontinuado, será usado o CRMA980
	MSExecAuto({|x,y| CRMA980(x,y)}, aDados, nOpc)
	
	If !lMsErroAuto		//Gravou
		cCli  := SA1->A1_COD
		cLoja := SA1->A1_LOJA
    	CONOUT("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 - GERACLI()  MSEXECAUTOSA1 OK! retorno Cod+LOJA->#"+cCli+"/"+cLoja+"# RECNO DA ZA1-> "+ str(ZA1->(Recno()),8))
		dbSelectArea("ZA1")
		If RecLock("ZA1",.F.)
          	CONOUT("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 - GERACLI()  MSEXECAUTOSA1 OK! retorno Cod+LOJA->#"+cCli+"/"+cLoja+"# RECNO DA ZA1-> "+ str(ZA1->(Recno()),8))
			ZA1->ZA1_STATUS := "PRO"	// PRO - Registro processado pelo Protheus e pedido Inserido com sucesso
			ZA1->ZA1_COD 	:= cCli
			ZA1->ZA1_LOJA	:= cLoja
			MsUnlock()
			CONOUT("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 -  GERACLI() ZA1_STATUS "+Upper(AllTrim(ZA1->ZA1_STATUS))+" .and. Empty(ZA1->ZA1_COD) ->#"+ ZA1->ZA1_COD + "#  ZA1_LOJA->#"+ZA1->ZA1_LOJA+"# RECNO DA ZA1-> "+ str(ZA1->(Recno()),8))
     		CONOUT("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 - incluiu cliente: "+AllTrim(cCli)+" loja: "+AllTrim(cLoja)+" no ambiente: "+Upper(GetEnvServer())+" na filial: "+cFilAnt + " MERCANET Cd.Cli: " + cCodMerc)
		EndIf
		//LOG
		GeraLog("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 - Usuario "+AllTrim(cUserName)+" incluiu cliente: "+AllTrim(cCli)+" loja: "+AllTrim(cLoja)+" no ambiente: "+Upper(GetEnvServer())+" na filial: "+cFilAnt, cCodMerc, 2)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//| Erro na gravaçao          |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Else
		cErroExec := ""
		if !lAuto
		// If IsInCallStack("SIGAIXB")	//Menu
			aErroExec := StrTokArr( MostraErro(), Chr(13) + Chr(10))
			
			For i := 1 To Len(aErroExec)
				If At("INVALIDO", Upper(aErroExec[i])) > 0	//Campo invalido
					cErroExec := AllTrim(aErroExec[i])
				EndIf
			Next
			For i := 1 To Len(aErroExec)
				If At("HELP: OBRIGAT", Upper(aErroExec[i])) > 0	//Campo obrigatorio
					For x := i+1 To 4
						cErroExec += AllTrim(aErroExec[i]) + " "
					Next
					Exit
				EndIf
			Next
			For i := 1 To Len(aErroExec)
				If At("HELP: A410VZ", Upper(aErroExec[i])) > 0	//Campo obrigatorio
					For x := i+1 To 4
						cErroExec += AllTrim(aErroExec[i]) + " "
					Next
					Exit
				EndIf
			Next
		Else	//Automatico
			aErroExec := StrTokArr( MemoRead(NomeAutoLog()), Chr(13) + Chr(10))
			
			For i := 2 To Len(aErroExec)
				If At("TABELA", Upper(aErroExec[i])) > 0
					Exit
				EndIf
				cErroExec += AllTrim(aErroExec[i]) + " "
			Next
			
		EndIf
		dbSelectArea("ZA1")
		If RecLock("ZA1",.F.)
			ZA1->ZA1_STATUS := "ERR"	// ERR - Status utilizado quando o registro for processado pelo Protheus e ocorreu erro durante o processamento
			ZA1->ZA1_ERRO 	:= "Inconformidade: " + cErroExec
			MsUnlock()
		EndIf
		GeraLog("## MERCANET - "+dtoc(date())+" - "+Time()+" INTMER02 - Cliente  nao gerado devido ao seguinte erro: " + cErroExec, ZA1->ZA1_CODMER, 1)
	EndIf
	RESTAREA(xAreaGet)
Return

/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since date
	@version version
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function GeraLogFile(cArq, cTexto)
	Local cDir		:= GetSrvProfString("StartPath","") + "\mercanet\"

	If !ExistDir(cDir)
		MakeDir(cDir)
	EndIf

	If !File(cDir + cArq)
		nHandle := FCreate(cDir + cArq, FC_NORMAL)
		FWrite(nHandle, cTexto + CRLF)
		FClose(nHandle)
	Else
		nHandle := FOpen(cDir + cArq , FO_READWRITE + FO_DENYWRITE )

		FWrite(nHandle, cTexto + CRLF) 
		FClose(nHandle)                   	//Fecha arquivo
	EndIf

Return


/****************************
** GERA LOG DE ERRO		   **	
****************************/
Static Function GeraLog(_cConteudo, _cCodigo, _nTipo)
	
	// Local cDir		:= "C:\Temp\Mercanet\"
	// \protheus_data\system\mercanet
	Local cDir		:= GetSrvProfString("StartPath","") + "\mercanet\"
	Local cArq		:= "LogErros.txt"
	//Local cContArq	:= ""
	Local lAuto := isblind()
	Local nHandle
	Default _nTipo := 1

	//If !IsInCallStack("SIGAIXB")
	if lAuto
//		cDir		:= "C:\Mercanet\Temp"   //  270821 1046 -  Assis - falta a barra no Final 
	    // \protheus_data\system\mercanet
		// cDir		:= GetSrvProfString("StartPath","") + "\mercanet\" //  cDir		:= "C:\Mercanet\Temp\" 
    else
		If !ExistDir(cDir)
			MakeDir(cDir)
		EndIf
	EndIF
	Conout("## "+dtoc(date())+"-"+time()+" MERCANET - GERALOG # nTipo = " + cValtochar(_nTipo)+ '  # cConteudo ' + cValtoChar(_cConteudo) + ' # '+ cvaltochar(_cCodigo))
	If ! File(cDir + cArq)
		nHandle := FCreate(cDir + cArq, FC_NORMAL)
		
		If _nTipo == 1
			FWrite(nHandle, "[ "+ DToC(dDataBase) + " | " + Time() + " ] Num. Pedido: " + AllTrim(_cCodigo) + " - " + _cConteudo + CRLF)
		Else
			FWrite(nHandle, "[ "+ DToC(dDataBase) + " | " + Time() + " ] Cod. Cliente: " + AllTrim(_cCodigo) + " - " + _cConteudo + CRLF)
		EndIf
		FClose(nHandle)
	Else
		nHandle := FOpen(cDir + cArq , FO_READWRITE + FO_DENYWRITE )
		FSeek(nHandle, 0, FS_END)         	//Posiciona no fim do arquivo
		
		If _nTipo == 1
			FWrite(nHandle, "[ "+ DToC(dDataBase) + " | " + Time() + " ] Num. Pedido: " + AllTrim(_cCodigo) + " - " + _cConteudo + CRLF) 	//Insere texto no arquivo
		Else
			FWrite(nHandle, "[ "+ DToC(dDataBase) + " | " + Time() + " ] Cod. Cliente: " + AllTrim(_cCodigo) + " - " + _cConteudo + CRLF)
		EndIf
		FClose(nHandle)                   	//Fecha arquivo
	EndIf
	
	
Return

/*********************************
** ORDENA CAMPOS CONFORME SX3   **	
*********************************/
Static Function OrdCampos(aOrdenar)

   Local _aMat     := {}
   Local _aMatNova := {}
   Local _nLinha   := 0
   Local _sOrdem   := ""
   Local _aAreaSX3 := SX3->(GetArea())
   
   // Monta uma matriz equivalente, com a ordem dos campos no SX3
   SX3->(dbSetOrder(2))
	For _nLinha := 1 To Len(aOrdenar)
   	
		If SX3->(dbSeek(aOrdenar[_nLinha, 1], .F.))
         _sOrdem = SX3->X3_ORDEM
		Else
         _sOrdem = IIf(_nLinha == 1, "  ", "ZZ")
		EndIf
      aAdd(_aMat, {aOrdenar[_nLinha,1], aOrdenar[_nLinha,2], aOrdenar[_nLinha,3], _sOrdem})
	next

   // Ordena campos cfe. SX3
   _aMat := aSort(_aMat,,, {|_x, _y| _x[4] < _y[4]})
   
   // Remonta a matriz original ordenada.
	For _nLinha = 1 To Len(_aMat)
      aAdd(_aMatNova, {_aMat[_nLinha,1], _aMat[_nLinha,2], _aMat[_nLinha,3]})
	Next

   RestArea(_aAreaSX3)
   
Return _aMatNova



/*********************************
** ATIVA OS CLIENTES NO PROTHEUS **	
*********************************/
static function AtvClix(cA1Cod,cA1Loja)
    Local aArea   := GetArea()
    dbSelectArea("SA1")
    dbSetOrder(1) // A1_FILIAL + A1_COD + A1_LOJA
    dbSeek(xFilial('SA1')+cA1Cod+cA1Loja)
    IF FOUND() // Avalia o retorno da pesquisa realizada
        IF(SA1->A1_MSBLQL = '1') 
          RECLOCK("SA1", .F.)
            SA1->A1_MSBLQL := '2'
          MSUNLOCK()     // Destrava o registro
        ENDIF
    ENDIF
    RestArea(aArea)
return

static function INVERDT(cdate)
  cdate := SUBSTR(cdate,7,2) +"/"+SUBSTR(cdate,5,2)+"/"+SUBSTR(cdate,1,4) 
return cdate
