#Include "Protheus.ch"
/*/{Protheus.doc} WMSA110E
Emissao de etiqueta a partir da balança e demais pontos onde é chamado o ponto de entrada
@type function
@version  
@author Deosdete Deo
@since 18/06/2023
@return variant, return_description
/*/
User Function WMSA110E()
Local aItens  := PARAMIXB[1] 
Local lRet    := .T.
Local nCont   := 0
Local oDlgLI  := Nil
Local oGetLI  := Nil
Local nOpcLI  := 0
Local cLocImp := Space(TamSX3("CB5_CODIGO")[01])
Local aArea   := GetArea()
Local cPicPeso := PesqPict('SZ3', 'Z3_PESO')
//Local cPicQtd := PesqPict('SZ3', 'Z3_QUANT')
Local cCodEti := ""
Local nQtdMov := 0

// Pergunta qual o volume terá a etiqueta impressa
DbSelectArea("D0Y")
If Empty(SuperGetMV("MV_WMSLOCI",.F.,""))
	DEFINE MSDIALOG oDlgLI TITLE "Informe o local de impressão" From 50,50 to 120,280 PIXEL 
	@ 06,05 SAY "Local de Impressão" SIZE 50,8 OF oDlgLI PIXEL 
	@ 05,60 MSGET oGetLI VAR cLocImp F3 "CB5" SIZE 50,06 WHEN .T. PICTURE "@!" OF oDlgLI PIXEL
	DEFINE SBUTTON FROM 21,083 TYPE 1 ACTION (nOpcLI := 1,oDlgLI:End()) ENABLE Of oDlgLI
	ACTIVATE DIALOG oDlgLI CENTERED		
	If nOpcLI == 0
		Return .F.	
	EndIf
	If !CB5SetImp(cLocImp,IsTelNet())
		WmsMessage("Local de Impressao invalido",WMSR13001,1)
		Return .F.
	EndIf
ElseIf !CB5SetImp(CBRLocImp("MV_WMSLOCI"),IsTelNet())
	WmsMessage("Local de Impressao invalido",WMSR13002,1) 
	Return .F.
EndIf

For nCont := 1 To Len(aItens)
	
	cCodEti:= Alltrim(aItens[nCont,1])
	
	//Garantir que a SZ3 esta posicionada
	If AllTrim(cCodEti) <> AllTrim(SZ3->Z3_CODETI)
		DbSelectArea("SZ3")
		DbSetOrder(3) //Z3_FILIAL+Z3_CODETI
		If !SZ3->(DbSeek(xFilial("SZ3")+cCodEti))
			lRet := .F.	
			MsgStop("Etiqueta não encontrada","Erro!")
		EndIf
	EndIf

	//Posicionar no produto
	If lRet
		DbSelectArea("SB1")
		DbSetOrder(1) //B1_FILIAL+B1_COD
		If !SB1->(DbSeek(xFilial("SB1")+SZ3->Z3_COD))
			lRet := .F.	
			MsgStop("Produto nao encontrado","Erro!")
		EndIf
	EndIf

	If lRet
	
		//Posicionar no primeiro movimento 
	    DbSelectArea("D12")
    	DbSetorder(4) //D12_FILIAL+D12_IDDCF+D12_IDMOV+D12_IDOPER+D12_STATUS+D12_SERVIC+D12_TAREFA                                                                                      
    	If D12->(DbSeek(xFilial("D12")+SZ3->Z3_IDDCF)) //+SZ3->Z3_IDMOV -- IMPRIMIR TODOS os movimentos independente do numero do movimento - deo 16/10/2023
			
			While !D12->(Eof()) .AND. xFilial("D12")+SZ3->Z3_IDDCF == D12->(D12_FILIAL+D12_IDDCF) //+D12_IDMOV
			
				cEtiq :="CT~~CD,~CC^~CT~    "
				cEtiq +="^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD10^JUS^LRN^CI0^XZ    "
				cEtiq +="^XA    "
				cEtiq +="^MMT    "
				cEtiq +="^PW799    "
				cEtiq +="^LL0623    "
				cEtiq +="^LS0    "
				
				If !Empty(SZ3->Z3_IDUNITZ)
					cEtiq +="^BY3,3,106^FT150,564^BCN,,N,N    "
					//cEtiq +="^FD>;123456789012^FS    "
					cEtiq +="^FD"+cCodEti+"^FS" //		cEtiq +="^FD>;123456789999^FS "
					cEtiq +="^FT293,592^A0N,28,36^FH\^FD"+cCodEti+"^FS    "
					nQtdMov := SZ3->Z3_QUANT   // A quantidade na D12 fica 1 por ser 1 unitizador entao mostrar a pesagem na etiqueta
				Else
					nQtdMov := D12->D12_QTDORI	//A quantidade da pesagem fica o total, mas quando nao for unitizado o mesmo movimento pode gerar varios itens
				EndIf	
				
				cEtiq +="^FT33,61^A0N,28,33^FH\^FDCodigo:^FS    "
				cEtiq +="^FT185,72^A0N,51,62^FH\^FD"+SZ3->Z3_COD+"^FS    "
				cEtiq +="^FT33,112^A0N,28,36^FH\^FDDescri\87ao:^FS    "
				cEtiq +="^FT185,112^A0N,39,40^FH\^FD"+SB1->B1_DESC+"^FS    "
				cEtiq +="^FT33,204^A0N,28,36^FH\^FDPeso:^FS    "
				cEtiq +="^FT25,199^ACN,36,20^FH\^FD"+Transform(SZ3->Z3_PESOL,cPicPeso)+"^FS    "
				cEtiq +="^FT403,155^A0N,28,36^FH\^FDResp.:^FS    "
				cEtiq +="^FT632,155^ACN,36,20^FH\^FD"+SZ3->Z3_RESP+"^FS    "
				cEtiq +="^FT33,244^A0N,28,36^FH\^FDQtd:^FS    "
				
				
				cEtiq +="^FT110,247^A0N,39,38^FH\^FD"+Transform(nQtdMov, "@E 999,999")+"^FS    "
				
				cEtiq +="^FT286,247^A0N,37,45^FH\^FDPC^FS    "
				cEtiq +="^FT33,287^A0N,28,36^FH\^FDTara:^FS    "
				cEtiq +="^FT38,287^ACN,36,20^FH\^FD"+Transform(SZ3->Z3_TARA,cPicPeso)+"^FS    "
				
				//Imprimir ID do movimento
				If !Empty(SZ3->Z3_IDMOV)
					cEtiq +="^BY3,3,101^FT180,416^BCN,,N,N    "
					//cEtiq +="^FD"+SZ3->Z3_IDMOV+"^FS    "
					cEtiq +="^FD"+D12->D12_IDMOV+"^FS    "
					//cEtiq +="^FT318,444^A0N,28,36^FH\^FD"+SZ3->Z3_IDMOV+"^FS    "
					cEtiq +="^FT318,444^A0N,28,36^FH\^FD"+D12->D12_IDMOV+"^FS    "
				EndIf
				cEtiq +="^FT403,287^A0N,28,36^FH\^FDUsuario:^FS    "
				cEtiq +="^FT536,287^ACN,36,20^FH\^FD"+SZ3->Z3_CODOPE+"^FS    "
				cEtiq +="^FT33,155^A0N,28,33^FH\^FDOP:^FS    "
				cEtiq +="^FT136,155^ACN,36,20^FH\^FD"+SZ3->Z3_DOC+"^FS    "
				cEtiq +="^FT403,244^A0N,28,36^FH\^FDDestino:^FS    "
				//cEtiq +="^FT545,249^A0N,39,33^FH\^FD"+SZ3->Z3_ENDDES+"^FS    "
				cEtiq +="^FT545,249^A0N,39,33^FH\^FD"+D12->D12_ENDDES+"^FS    "
				cEtiq +="^FT403,199^A0N,28,36^FH\^FDData:^FS    "
				cEtiq +="^FT536,199^ACN,36,20^FH\^FD"+DToC(SZ3->Z3_DATA)+"^FS    "
				cEtiq +="^FT59,543^A0B,21,26^FH\^FDUnitiz.^FS    "
				cEtiq +="^FT59,410^A0B,21,26^FH\^FDID Mov.^FS    "
				cEtiq +="^PQ1,0,1,Y^XZ    "

				MSCBWRITE(cEtiq)

				MSCBINFOETI("Etiqueta de Unitizador","100x80") //MSCBInfoEti("Unitizador","100X80")

				sConteudo:=MSCBEND()

				//MSCBBEGIN(1,6,70)
				
				//MSCBSAY(007,005,"Unitizador","N","F","1,2", , , ,.T.)
				//MSCBSAYBAR(007,011,ALLTRIM(cIdUnitiz),'N','MB07',9,.F.,.F.,,'B',2.3,2,) // Opcao B -> Utilizado no code128/ para aceitar letras e numeros.
				//MSCBSAY(007,021,cIdUnitiz,"N","C","1,2", , , ,.T.)
				
				D12->(DbSkip())

			EndDo
	
		EndIf

	EndIf

Next nCont
	
MSCBCLOSEPRINTER()
	
// Atualiza campo D0Y_IMPRES (Flag de Impressao)
If !Empty(SZ3->Z3_IDUNITZ)
	D0Y->(DbSetOrder(1))
	For nCont := 1 to len(aItens)
		cIdUnitiz := aItens[nCont,1]
		If D0Y->(DbSeek(xFilial("D0Y")+cIdUnitiz)) .And. D0Y->D0Y_IMPRES == '2'
			RecLock("D0Y",.F.)
			D0Y->D0Y_IMPRES := '1'
			D0Y->(MsUnlock())
			D0Y->(dbSkip())
		EndIf
	Next
EndIf

RestArea(aArea)

Return lRet
