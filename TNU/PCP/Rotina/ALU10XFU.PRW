#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"        
#Include "RwMake.ch"
#Include "topconn.ch"
#Include "Totvs.ch"
#INCLUDE "FWMVCDEF.CH"

#Define ESPERA_WAIT  500   //Tempo de espera


/*/{Protheus.doc} ARO04XFU
Funcoes genericas do ACD
@type function
@version 
@author Deosdete Deo
@since 28/09/2020
@return return_type, return_description
/*/
User Function ALU10XFU()

Return

/*/{Protheus.doc} getBalanca
Funcao paa leitura do peso da balan√ßa
@type function
@version 
@author Deosdete Deo
@since 28/09/2020
@param nSaldo, numeric, param_description
@return return_type, return_description
/*/

User Function ALU10Balanca(nOpc, cBalanca, lLeitura) 
Local nPeso       := 0//Val(SubStr(Time(),7,2)) 
Local nTara       := 0
Local nQtd        := 0
Local cPorta      := "COM3"
Local cBps        := "2400"
Local cParidade   := "N"
Local cBits       := "7"
Local cBitsParada := "2"
Local cPesoAux    := ""
//Local cUn         := ""
Local nI          := 0
Local nHandle     := 0 
Local aSettings   := {}
Local nPosIni     := 0
Local lRet        := .F.

Default nOpc := 1   //1-Conectar 2- Desconectar 3 - Ler peso X - Erro de configuracao da 


If lLeitura


	/* Abre a porta serial. Os parametros passados entre aspas sao (na ordem da direita para a esquerda):
	- Porta Serial
	- Velocida de transmissao em bps
	- Paridade s/n
	- Quantidade de bits de dados
	- Bits de parada*/
	If nOpc == 1 // Conectar e reconectar
	
		//Posicionar na balanÁa padr„o do operador
		DbSelectArea("CB5")
		DBSetOrder(1) //CB5_FILIAL+CB5_CODIGO                                                                                                                                           
		If CB5->(DbSeek(xFilial("CB5")+SubStr(cBalanca,1,6) ))
			lRet := .T.
		Else
			MsgStop("BalanÁa " + cBalanca + " n„o encontrada. Verifique cadastro Local de Impressora/Dispositivo",ProcName()+" - Erro!!!")
			//RestArea(aAreaCB5)
			lRet := .F.
		EndIf

/*

Velocidade: 4.800 bps
ï Paridade: Par
ï N˙mero de Stop bits: 1
ï N˙mero de bits de dados: 7
ï Checksum: Desabilitado

*/

		If lRet
			//Pegar dados balan√ßa posicionada
			If !Empty(CB5->CB5_SETSER)

				/*aSettings[01]  cPorta  - "COM3"      COM1;2400;N;7;2  COM1;4800;N;7;1
				aSettings[02]  cBps    - "2400"	
				aSettings[03]  cParidade   "N"
				aSettings[03]  cBits       "7"
				aSettings[03]  cBitsParada "2"
				*////////////////////////////// 
				//Pegar dados da balan√ßa no cadastro
				aSettings := StrToKarr(CB5->CB5_SETSER, ";")

				If Len(aSettings) == 5 
					cPorta      := aSettings[01]
					cBps        := aSettings[02]
					cParidade   := aSettings[03]
					cBits       := aSettings[04]
					cBitsParada := aSettings[05]
				Else
					MsgStop(OemToAnsi("ConfiguraÁ„o da balanÁa incorreta. Verifique cadastro Local de Impressora/Dispositivo"),ProcName()+" - Erro!!!")
					lRet := .F.
				EndIf

			Else
				MsgStop(OemToAnsi("ConfiguraÁ„o da balanÁa nao definida. Verifique cadastro Local de Impressora/Dispositivo"),ProcName()+" - Erro!!!")
				lRet := .F.
			EndIf

			If lPort // se ja houver uma balnÁa conectada
				MsClosePort(nHandle)
				Sleep(ESPERA_WAIT)
				lPort := .F.
			EndIf

			//nHandle     := 0 //deve ser private para armazenar a configuracao da impressora

			lPort := MSOpenPort(nHandle,cPorta+":"+cBps+","+cParidade+","+cBits+","+cBitsParada) // "COM3:2400,N,7,2"
			
			//ForÁar presenÁa da balanÁa
			//lPort := .T.

			If !lPort 
				MsgStop("N„o foi possivel conectar a balanÁa. Verifique","AtenÁ„o!!!")
				lRet := .F.
			EndIf
		EndIf	

	ElseIf nOpc = 2 //Ler Peso

		If lPort	
			For nI := 1 To 3 //Tentar at√© ler
				
				Sleep(ESPERA_WAIT)
				MsRead(nHandle,@cPesoAux)

				//AutoGrLog("----------Leitura da balanÁa----------")
				//AutoGrLog(cPesoAux)
				//AutoGrLog("--------------------------------------")
				
				//MostraErro()

				//Exit

				If !Empty(cPesoAux)  //Leu
				
					//LAYOUT BALAN«A CONTADORA

					//Trocar , por . 
					cPesoAux := StrTran(cPesoAux,",",".")

					//Localizar posiÁ„o inicial
					nPosIni   := At("EK*", cPesoAux)

					nPosPeso  := nPosIni + 3  //Tamanho 7
					nPosTara  := nPosIni + 10 //Tamanho 7
					nPosQtd   := nPosIni + 17 //Tamanho 5

					//Pegar o peso
					nPeso    := Val(SubStr(cPesoAux,nPosPeso,7))
					nTara    := Val(SubStr(cPesoAux,nPosTara,7))
					nQtd     := Val(SubStr(cPesoAux,nPosQtd,7))

					//Pegar a unidade de medida
					//cUn := AllTrim(SubStr(cPesoAux,At(" ",cPesoAux), Len(cPesoAux)))
					
					//Converter sempre para Kg
					/*If nPeso > 0
						If Upper(SubStr(cUn,1,1)) == "G"
							nPeso := nPeso/1000
							cUn   := "KG"
						EndIf
					EndIf 
					*/
					lRet := .T.
					Exit
				EndIf

			Next nI	
		EndIf


	ElseIf nOpc == 3 //Desconectar


		MsClosePort(nHandle)
		lPort := .F.
		lRet := .T.

	EndIf

EndIf

/* Fecha a porta serial
*/

//FreeLibrary(nHandle)
/* Libera o handle (controle) da porta serial
*/

//Se deu erro, para a leitura automatica
If !lRet 
	lLeitura := .F.
EndIf

Return ({nPeso,nTara,nQtd,lRet})


/*



	//MsClosePort(nHandle)

	/*
	If !lPort
		
		MsClosePort(nHandle)
		lPort := MSOpenPort(nHandle,"COM2:9600,N,8,1") // paridade NENHUMA
		If lPort 
			MsgAlert("COM2")
		EndIf
		
		If !lPort 
			
			MsClosePort(nHandle)
			lPort := MSOpenPort(nHandle,"COM3:9600,N,8,1") // paridade NENHUMA
			
			If lPort
				MsgAlert("COM3")
			EndIf 
		EndIf
	EndIf
		
	//lPort := MSOpenPort(nHandle,"COM2:9600,N,8,1") // paridade NENHUMA

	If !lPort
		Alert("N√£o foi poss√≠vel se conectar √† porta")
		Return
	EndIf

	cPesoAux := space(20)
	nCont := 0

	nPeso := 0
	//While nPesoL != nSaldo .and. nCont <= 30
	Sleep(200)
	
	//Le informacoes da porta e coloca na variavel informada no segundo parametro (cTexto no exemplo)
	MsRead(nHandle,@cPesoAux)

	aPeso:={}
	cPesoaux2 := substr(cPesoAux,5,6)
	conout(cPesoAux)
	/*
	nLin2 := mlcount(cPesoAux,20,,.F.)
	conout(cPesoAux)
	Conout(nLin2)
	cPesoaux2:= memoline(cPesoAux,20,1,,.F.)
	Conout(cPesoaux2)
	*/
	/*
	nPesoL := val(StrTran( cPesoaux2, ",", "." ))
	conout(nPesoL)
	nGetBalan := nPesoL
	MsClosePort(nHandle)
	
	//Alert("N√£o foi poss√≠vel se conectar √† porta da balan√ßa")

	*/



/*/{Protheus.doc} AROX04Lote
Formacao do proximo lote 
@type function
@version 
@author Deosdete Deo
@since 17/10/2020
@param cTipo, character, param_description
@return return_type, return_description
/*/
User Function AROX04Lote(cProduto)
Local aRet     := {}
Local cSeq     := ""
Local aArea    := getArea()
Local aAreaSB1 := SB1->(getArea())
Local cLote    := ""
Local dValid   := CToD("")
Local cTipo    := ""

DbSelectArea("SB1")
DbSetorder(1) //B1_FILIAL+B1_COD
If SB1->(DbSeek(xFilial("SB1")+cProduto))
	If SB1->B1_TIPO == "PA"
		cSeq   :=  AllTrim(GetMV("MV_XLOTEPA"))
		PUTMV("MV_XLOTEPA", Soma1(cSeq) )
		cTipo  := "P"
	Else
		cSeq   :=  AllTrim(GetMV("MV_XLOTEMP"))
		PUTMV("MV_XLOTEMP", Soma1(cSeq) )
		cTipo  := "F"
	EndIf
Else
	MsgStop("Produto n√£o encontrado",ProcName()+"-Aten√ßao!!!")
EndIf

/*
O numero do lote √© composto data YYMMDDSSSSS 
Onde:
YY = 20 = ANO
MM = 08 = MES
DD = 03 = DIA
SSSSS = 00001 = SEQUENCIAL
Quando for produto adquirido, o numero do lote tem que ter um F no inicio
Se fornecedor
F20080300001
*/
If !Empty(cSeq)
	cLote := cTipo
	cLote += DToS(dDataBase)
	cLote += cSeq
	If !Empty(SB1->B1_PRVALID)
		dValid := dDataBase + SB1->B1_PRVALID
	Else
		dValid := CToD("")
	EndIf
	aRet := {cLote, dValid} 
else
	aRet := {"",CToD("")}
EndIf

RestArea(aArea)    
RestArea(aAreaSB1)

Return aRet






/*/{Protheus.doc} A04Localizalote
Localizar por meio do lote, o produto e local
@type function
@version 
@author Marcelo Fran√ßa
@since 29/09/2020
/*/

User Function A04Localizalote(cTipo, cLoteAut)

//cTipo - 1 - PCP ; 2 - RECEBIMENTO ; 3 - INVENTARIO
Local cQuery    := ""
Local nRegistro := 0
//Fontes
Local cFontUti    := "Tahoma"
Local oFontSubN   := TFont():New(cFontUti,,-20,,.T.)
Local oFontBtn    := TFont():New(cFontUti,,-14)
Local cLocal      := ""
Local cProduto    := ""
Local oTempTable 
Local cTitulo     := ""

//Janela e componentes
Private oDlgGrp
Private oPanGrid
Private oGetGrid
Private aColunas := {}
Private cAliasTab := "TMP2"
//Tamanho da janela
Private    aTamanho := MsAdvSize()
Private    nJanLarg := aTamanho[5]/2
Private    nJanAltu := aTamanho[6]/2

//Private cArqTRB
Private cLote   := Space(TamSX3("B8_LOTECTL")[1]) //"AUTO000019"//Space(12)
Private oLote
Private ocLote
Private nOpc      := 0

If cTipo == "2"
	cTitulo :=	"Novo Lote"
	cLote   := cLoteAut
Else
	cTitulo :=	"Localizador de Lote"
EndIf

Define MsDialog oLote Title cTitulo From C(130),C(270) To C(270),C(550) Pixel
	
@ C(005),C(005) Say "N√∫mero do Lote"
@ C(015),C(005) MsGet ocLote Var cLote Size C(050),C(010) Pixel Of oLote VALID (A04SLOT(cTipo) ) 
@ C(045),C(035) Button "Ok"	 		Size C(030),C(010) Pixel Action (nOpc:=1,oLote:End() )
@ C(045),C(080) Button "Cancelar" 	Size C(030),C(010) Pixel Action (nOpc:=2,oLote:End() )
	
Activate MsDialog oLote Centered   

If nOpc == 1

	If cTipo <> "2"  //Lote novo para orecebimento - nao buscar
		
		DbSelectArea("TMP1")
		TMP1->(DbGoTop())

		cProduto :=  TMP1->B8_PRODUTO 
		cLocal   :=  TMP1->B8_LOCAL

		While TMP1->(!EOF())

			TMP1->(DbSkip())
			nRegistro++
			
			If nRegistro > 1
				Exit
			EndIf

		EndDo

		If nRegistro > 1
			//Pesquisar e posicionar CBA - Mestre de Invent√°rio
			
			//Cria a tempor√°ria
			oTempTable := FWTemporaryTable():New(cAliasTab)
			//Adiciona no array das colunas as que ser√£o incluidas (Nome do Campo, Tipo do Campo, Tamanho, Decimais)
			aFields := {}
		
			aAdd(aFields, {"B8_FILIAL"  , "C", TamSX3('B8_FILIAL')[01]  ,0})
			aAdd(aFields, {"B8_LOTECTL" , "C", TamSX3('B8_LOTECTL')[01] ,0})
			aAdd(aFields, {"B8_PRODUTO" , "C", TamSX3('B8_PRODUTO')[01] ,0})
			aAdd(aFields, {"B8_LOCAL"   , "C", TamSX3('B8_LOCAL')[01]   ,0})
		
			//Define as colunas usadas, adiciona indice e cria a temporaria no banco
			oTempTable:SetFields( aFields )
			oTempTable:AddIndex("1", {"B8_LOCAL"} )
			oTempTable:Create()
	
			//Monta o cabecalho
			fMontaHead()
	
			//Montando os dados, eles devem ser montados antes de ser criado o FWBrowse
			FWMsgRun(, {|oSay| fMontDados(oSay) }, "Processando", "Buscando grupos")
			
			//Criando a janela
			DEFINE MSDIALOG oDlgGrp TITLE "Sele√ß√£o de Armazem" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
				//Labels gerais
				@ 014, 003 SAY "Listagem de Armaz√©m do Lote" SIZE 200, 030 FONT oFontSubN OF oDlgGrp COLORS RGB(031,073,125) PIXEL
		
				//Bot√µes
				@ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Selecionar"        SIZE 050, 018 OF oDlgGrp ACTION (oDlgGrp:End())   FONT oFontBtn PIXEL
		
				//Dados
				oPanGrid := tPanel():New(033, 006, "", oDlgGrp, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2 - 13),     (nJanAltu/2 - 45))
				oGetGrid := FWBrowse():New()
				oGetGrid:DisableFilter()
				oGetGrid:DisableConfig()
				oGetGrid:DisableReport()
				oGetGrid:DisableSeek()
				oGetGrid:DisableSaveConfig()
				oGetGrid:SetFontBrowse(oFontBtn)
				oGetGrid:SetAlias(cAliasTab)
				oGetGrid:SetDataTable()
				oGetGrid:SetInsert(.F.)
				oGetGrid:SetDelete(.F., { || .F. })
				oGetGrid:lHeaderClick := .F.
				oGetGrid:SetColumns(aColunas)
				oGetGrid:SetOwner(oPanGrid)
				oGetGrid:Activate()
			ACTIVATE MsDialog oDlgGrp CENTERED

			//TMP1->(DbGoTo((cAliasTab)->(Recno())))

			cLocal   := (cAliasTab)->B8_LOCAL
			cProduto := (cAliasTab)->B8_PRODUTO
			
			If Select(cAliasTab) > 0
				(cAliasTab)->(dbCloseArea())
			EndIf

						//Deleta a temporaria
			oTempTable:Delete()
			
		
		EndIf
	
		
		DbSelectArea("SB8")
		DbSetOrder(1) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE                                                                                            
		If !SB8->(DbSeek(xFilial("SB8")+cProduto+cLocal))
			MsgStop("Erro ao posicionar LCOAL/lote")
		EndIf

		If cTipo == "3" //Inventario
			cQuery:= "SELECT CBA.CBA_FILIAL, CBA.CBA_LOCAL, CBA.CBA_PROD, CBA.CBA_STATUS, R_E_C_N_O_ "
			cQuery+= "FROM " + RetSqlName("CBA") + " CBA "
			cQuery+= "Where "
			cQuery+= "(CBA.CBA_STATUS <= '2' OR (CBA.CBA_STATUS = '3' AND CBA.CBA_ANALIS = '2' ) )   AND " //caso tenha divergencia √© possivel recontar
			cQuery+= "CBA.CBA_FILIAL = '" + xFilial("CBA") + "' AND "
			cQuery+= "CBA.CBA_PROD = '" + cProduto + "' AND "
			cQuery+= "CBA.CBA_LOCAL = '" + cLocal + "' AND "
			cQuery+= "CBA.D_E_L_E_T_ = ' ' "

			cQuery := ChangeQuery(cQuery) 

			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPCBA",.T.,.T.)

			TMPCBA->(DbGoTop())

			If TMPCBA->(!EOF())

				CBA->(DbGoTo(TMPCBA->R_E_C_N_O_))
				//SB8->(DbGoTo(TMP1->R_E_C_N_O_))

			Else
				MsgStop('Mestre de Invent√°rio n√£o existe para o Lote "' + AllTrim(cLote) + '", Armaz√©m "' + cLocal + '" e Produto "' + AllTrim(cProduto) + '"',"Mestre de Invent√°rio n√£o encontrado")
				cLote:=""
			EndIf 


			If Select("TMP1") > 0
				TMP1->(dbCloseArea())
				// apaga a tabela tempor√°rio 
				//MsErase(cArqTRB + GetDBExtension(),,"DBFCDX") 
			EndIf

			If Select("TMPCBA") > 0
				TMPCBA->(dbCloseArea())
			EndIf

		EndIf

	EndIf
else
	cLote := ""
EndIF

Return cLote

Static Function A04SLOT(cTipo)

    Local lRet:= .T.
    Local cQuery

	If !Empty(cLote)
    
		If Select("TMP1") > 0
			TMP1->(dbCloseArea())
			// apaga a tabela tempor√°rio 
			//MsErase(cArqTRB+GetDBExtension(),,"DBFCDX") 
		EndIf

		cQuery:= "SELECT SB8.B8_FILIAL, SB8.B8_LOTECTL, SB8.B8_PRODUTO, SB8.B8_LOCAL, R_E_C_N_O_ "
		cQuery+= "FROM " + RetSqlName("SB8") + " SB8 "
		cQuery+= "Where "
		cQuery+= "SB8.B8_LOTECTL = '" + AllTrim(cLote) + "' AND "
		cQuery+= "SB8.B8_FILIAL = '" + xFilial("SB8") + "' AND "
		cQuery+= "SB8.D_E_L_E_T_ = ' ' " 
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP1",.T.,.T.)
		//TCQuery cQuery ALIAS "TMP1" NEW
		//cArqTRB := CriaTrab(NIL,.F.)
		//Copy To &cArqTRB

		//dbCloseArea()
		//dbUseArea(.T.,,cArqTRB,"TMP1",.T.)
	
		//DbSelectArea("TMP1")
		
		//TMP1->(DbGoTop())

		
		If TMP1->(EOF())
			If cTipo == "2" //Recebimento
				//Ok se nao encontrou o lote pois √© novo
			Else
				MsgStop("Lote '" + AllTrim(cLote) + "', n√£o encontrado no Saldo de Lote (SB8)","Lote n√£o encontrado")
				lRet:= .F.
			EndIf
		Else
			If cTipo == "2" //recebimento
				//Erro se  encontrou o lote pois √© novo
				MsgStop("Lote '" + AllTrim(cLote) + "', ja existe no Saldo de Lote (SB8)",ProcName()+ " - Aten√ß√£o")
				lRet:= .F.
			Else
				//Ok se encontrou o lote pois √© producao ou inventario e tem que buscar
			EndIf
		
		EndIf

	Else
		
		MsgStop("Lote n√£o informado","Lote n√£o encontrado")
		lRet := .F.		
	EndIf

    If lRet
        nOpc:=1
        oLote:End()
    EndIf

Return(lRet)

Static Function fMontaHead()
    Local nAtual
    Local aHeadAux := {}
 
    //Adicionando colunas
    //[1] - Campo da Temporaria
    //[2] - Titulo
    //[3] - Tipo
    //[4] - Tamanho
    //[5] - Decimais
    //[6] - M√°scara

    aAdd(aHeadAux, {"B8_FILIAL" , "Filial"  ,"C", TamSX3('B8_filial')[01]   ,  0, ""})
    aAdd(aHeadAux, {"B8_LOTECTL", "Lote"    ,"C", TamSX3('B8_LOTECTL')[01]  ,  0, ""})
    aAdd(aHeadAux, {"B8_PRODUTO", "Produto" ,"C", TamSX3('B8_PRODUTO')[01]  ,  0, ""})
    aAdd(aHeadAux, {"B8_LOCAL"  , "Armazem" ,"C", TamSX3('B8_LOCAL')[01]    ,  0, ""})
   
    //Percorrendo e criando as colunas
    For nAtual := 1 To Len(aHeadAux)
        oColumn := FWBrwColumn():New()
        oColumn:SetData(&("{|| " + cAliasTab + "->" + aHeadAux[nAtual][1] +"}"))
        oColumn:SetTitle(aHeadAux[nAtual][2])
        oColumn:SetType(aHeadAux[nAtual][3])
        oColumn:SetSize(aHeadAux[nAtual][4])
        oColumn:SetDecimal(aHeadAux[nAtual][5])
        oColumn:SetPicture(aHeadAux[nAtual][6])
        aAdd(aColunas, oColumn)
    Next
Return

Static Function fMontDados(oSay)

    Local aArea := GetArea()
    //Local cQry  := ""
    Local nAtual := 0
    //Local nTotal := 0
 
    //Zera a grid
    aColsGrid := {}
     
    TMP1->(DbGoTop())

    While  TMP1->(!EoF())
        //Muda a mensagem na regua
        nAtual++
        oSay:SetText("Adicionando registro...")
 
        RecLock(cAliasTab, .T.)
        (cAliasTab)->B8_FILIAL  := TMP1->B8_FILIAL
        (cAliasTab)->B8_LOTECTL := TMP1->B8_LOTECTL
        (cAliasTab)->B8_LOCAL   := TMP1->B8_LOCAL
        (cAliasTab)->B8_PRODUTO := TMP1->B8_PRODUTO
        (cAliasTab)->(MsUnlock())

        TMP1->(DbSkip())

    EndDo
 
    (cAliasTab)->(DbGoTop())
 
    RestArea(aArea)

Return



/*/{Protheus.doc} ALUAFAtiv
description
@type function
@version  
@author Deosdete Deo
@since 24/07/2023
@param cDocSD3, character, param_description
@param cCodPrd, character, param_description
@param cCodServ, character, param_description
@return variant, return_description
/*/
User Function ALUAFAtiv() //cDocSD3, cCodPrd, cCodServ

   // Local cAliD12   := GetNextAlias()
    Local oModel    as object
    Local aErro     := {}
    Local lOk       := .F.
    //Local cSeek     := ''
    //Local cQuery    := ''
    Local nModAux   := nModulo
/*
    cQuery:=Chr(13)+Chr(10)+"SELECT D12_FILIAL, D12_STATUS, D12_PRIORI, D12_CARGA, D12_DOC, D12_SERIE, D12_CLIFOR, "
    cQuery+=Chr(13)+Chr(10)+"D12_LOJA, D12_SERVIC, D12_ORDTAR, D12_ORDATI "
    cQuery+=Chr(13)+Chr(10)+"FROM "+RetSqlName('D12')+" WITH (NOLOCK)"
    cQuery+=Chr(13)+Chr(10)+"WHERE D12_DOC      = '"+cDocSD3+"' "
    cQuery+=Chr(13)+Chr(10)+"AND D12_SERVIC     = '"+cCodServ+"' "
    cQuery+=Chr(13)+Chr(10)+"AND D12_PRODUT     = '"+cCodPrd+"' "
    cQuery+=Chr(13)+Chr(10)+"AND D12_STATUS     = '4' " //-- A executar
    cQuery+=Chr(13)+Chr(10)+"AND D_E_L_E_T_     = ' ' "

    dbUseArea(.T., 'TOPCONN', TcGenQry(,, cQuery), cAliD12, .F., .T. )

    (cAliD12)->(DbGoTop())
    cSeek:=(cAliD12)->(D12_FILIAL+D12_STATUS+D12_PRIORI+D12_CARGA+D12_DOC+D12_SERIE+D12_CLIFOR+D12_LOJA+D12_SERVIC+D12_ORDTAR+D12_ORDATI)                                              
    D12->(DbSetOrder(01))
    If D12->(DbSeek(cSeek))
 */       
        //--Muda variavel para automatico      
        Wm332Autom(.F.)
        //--Intancia modelo
        oModel    := FWLoadModel("WMSA332A")
        WmsOpc332("4")
        WmsAcao332('4')//--Finalizar Documento //se der erro tentar passar 1 que È finalizar atividade
        
        oModel:SetOperation(MODEL_OPERATION_UPDATE) //oModel:SetOperation(MODEL_OPERATION_INSERT) //-- Seta operaÁ„o de inclus„o
        oModel:Activate() //-- Ativa o Modelo

        nModulo:= 42

        //-- ValidaÁ„o e GravaÁ„o do Modelo
        lOk := oModel:VldData()
        If lOk
            lOk := oModel:CommitData()
        EndIf

        If !lOk
            aErro := oModel:GetErrorMessage()
        EndIf

        oModel:DeActivate() //desativa modelo

        nModulo:= nModAux
    
 //   EndIf
    //--Fecha tabela
   // (cAliD12)->(DbCloseArea())

Return(lOk)
