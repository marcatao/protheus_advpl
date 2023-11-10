
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'APVT100.CH'

/*/{Protheus.doc} CBRetEtiEAN
Ponto de entrada da Leitura da Etiqueta 
@type function
@version  
@author Deosdete Deo
@since 9/21/2023
@param cID, character, param_description
@return variant, return_description
/*/
User Function CBRETEAN()
Local cID       := PARAMIXB[1]
Local aRet      := {}
Local lEAN13OU8 := .F.
Local lEAN14    := .F.
Local lEAN128   := .F.
Local cCodBar   := ''
Local cDL       := ''
Local nQE       := 0
Local nPos      := 0
Local nOrdemSB1 := 0
Local aEan128   := {}
Local lEAN12813OU8 := .F.
Local lEAN12814    := .F.
Local lEAN12814VAR := .f.
Local cUnDespacho  := ''
Local nQtdeDespacho:= 0
Local cLote     := ''
Local dValid    := ctod('')
Local cNumSerie := Space(20)
Local uAux
Local lRet       := .T.
Local aArea      := GetArea()
Local lDetalhe   := .F. 
Local nQtdUser   := 0
Local nSldMov    := 0
Local lAchouPRD  := .F.

//Tirar espaços , pois a rotina de montagem de volume esta  trazendo espaço
cID := AllTrim(cID)

//Se não é EAN 128, primeiro verifica se o usuário bipou o código do produto
If Len(Alltrim(cID)) <= TamSX3("B1_COD")[1]
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial('SB1')+cID))
		SB5->(DbSetOrder(1))
		SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))
		If SB5->B5_TIPUNIT <> '0' //produtos com controle unitário
			nQE   := CBQEmb()
		Else
			nQE   := 1
		EndIf
		//Se encontrar pelo código do produto, retorna direto
		lAchouPRD := .T.
	EndIf
EndIf

If !lAchouPRD
	If Len(Alltrim(cID)) == 8  .or. Len(Alltrim(cID)) == 13
		cCodBar := Alltrim(cID)
		lEAN13OU8 :=.T.
	ElseIf Len(Alltrim(cID)) == 14
		cCodBar := Subs(Alltrim(cID),2,12)
		cUnDespacho := Left(cID,1) //-- checar o digito
		If Left(cCodBar,5) =="00000"
			cCodBar := Subs(cCodBar,6)
		EndIf
		lEAN14 := .T.
	ElseIf Len(Alltrim(cID)) > TamSX3("B1_COD")[1] .and. ! UsaCB0('01')
		aEan128 := CBAnalisa128(cID)
		If ! Empty(aEan128)
			lEAN128 := .T.
			nPos := Ascan(aEan128,{|x| x[1] == "01"})
			If nPos > 0
				cCodBar:= Subst(aEan128[nPos,2],2,12)
				cDL := Left(aEan128[nPos,2],1)
			EndIf
			nPos := Ascan(aEan128,{|x| x[1] == "02"})
			If nPos > 0
				cCodBar:= Subst(aEan128[nPos,2],2,12)
				cDL := Left(aEan128[nPos,2],1)
			EndIf
			nPos := Ascan(aEan128,{|x| x[1] == "8006"})
			If nPos > 0
				cCodBar:= Subst(aEan128[nPos,2],2,12)
				cDL := Left(aEan128[nPos,2],1)
			EndIf
			If cDL $ "12345678"
				cUnDespacho := cDL
				lEAN12814 := .T.
			ElseIf cDL =="0"
				lEAN12813OU8 := .T.
			ElseIf cDL =="9"
				lEAN12814VAR := .T.
			EndIf
			If Left(cCodBar,5) =="00000"
				cCodBar := Subs(cCodBar,6)
			EndIf
		EndIf
	Else
		cCodBar := Alltrim(cID)
		lEAN13ou8 := .T.
	EndIf
	If ! lEAN13ou8 .And. ! lEAN14 .and. !lEAN128 .or. Empty(cCodBar)
		Return {}
	EndIf
	
	nOrdemSB1:= SB1->(IndexOrd())
	SB1->(DbSetOrder(5))
	SB1->(DBSeek(xFilial("SB1")+cCodBar))
	SB1->(DbSetOrder(nOrdemSB1))
	If SB1->(Eof())
		dbSelectArea("SLK")
		SLK->( dbSetOrder(1) )
		If SLK->( DBSeek(xFilial("SLK")+cCodBar) )
			aRet := {LK_CODIGO, LK_QUANT,Padr(cLote,TamSX3("CB8_LOTECT")[1]),dValid,Padr(cNumSerie,20)}
			Return aRet
		Else
			Return aRet
		EndIf
	EndIf
	

	SB5->(DbSetOrder(1))
	SB5->(DBSeek(xFilial("SB5")+SB1->B1_COD))
	If lEAN13ou8 //se for EAN13 sempre vai retornar 1
		//If SB5->B5_TIPUNIT <> '0' //produtos com controle unitario
		//	nQE   := CBQEmb()
		//Else
			nQE   := 1
		//EndIf
	ElseIf lEAN14
		nQtdeDespacho := SB5->(FieldGet(FieldPos("B5_EAN14"+cUnDespacho)))
		nQE := nQtdeDespacho
	ElseIf lEAN128
		nPos := Ascan(aEan128,{|x| x[1] == "30"})  // Qtde variavel
		If nPos > 0
			nQtdeDespacho:= Val(aEan128[nPos,2])
		EndIf
		nPos := Ascan(aEan128,{|x| x[1] == "37"}) // Qtde de itens comerciais
		If nPos > 0
			nQE:= Val(aEan128[nPos,2])
			If lEAN12814
				nQE:= nQE*SB5->(FieldGet(FieldPos("B5_EAN14"+cUnDespacho)))
			ElseIf lEAN12814VAR
				If ! Empty(nQtdeDespacho)
					nQE:= nQE*nQtdeDespacho
				EndIf
			EndIf
		Else
			nQE := nQtdeDespacho
		EndIf
		nPos := Ascan(aEan128,{|x| x[1] == "10"})  // lote
		If nPos > 0
			cLote := aEan128[nPos,2]
		EndIf
		nPos := Ascan(aEan128,{|x| x[1] == "15"})  // data de durabilidade
		If nPos > 0
			uAux:= right(aEan128[nPos,2],2)+'/'+Subs(aEan128[nPos,2],3,2)+'/'+right(aEan128[nPos,2],2)
			If Left(uAux,2) =="00"
				uAux := "01"+Subs(uAux,3)
				dValid := ctod(StrZero(LastDay(ctod(uAux)),2)+Subs(uAux,3))
			Else
				dValid := ctod(uAux)
			EndIf
		EndIf
		nPos := Ascan(aEan128,{|x| x[1] == "17"})  // data de validade
		If nPos > 0
			uAux:= right(aEan128[nPos,2],2)+'/'+Subs(aEan128[nPos,2],3,2)+'/'+right(aEan128[nPos,2],2)
			If Left(uAux,2) =="00"
				uAux := "01"+Subs(uAux,3)
				dValid := ctod(StrZero(LastDay(ctod(uAux)),2)+Subs(uAux,3))
			Else
				dValid := ctod(uAux)
			EndIf
		EndIf
		nPos := Ascan(aEan128,{|x| x[1] == "21"})  // numero de serie
		If nPos > 0
			cNumSerie := aEan128[nPos,2]
		EndIf
	EndIf

EndIf //Se não achou por codigo do produto


If !FunName() == "WMSA391" // MOntagem de volume nao precisa detalhe

	lDetalhe  := !oMovimento:oMovServic:GetServico() $ SuperGetMv("MV_XWSERDET",.F.,"") //Exececao para nao mostrar a tela de detalhe na bepagem

	//Verificar se o produto encontrado é o produto do movimento, passar o array vazio pro sistema solicitar novamente
	If oMovimento:oMovPrdLot:GetProduto() == SB1->B1_COD
		aRet := {SB1->B1_COD,nQE,Padr(cLote,TamSX3("CB8_LOTECT")[1]),dValid,Padr(cNumSerie,20)}
	Else
		VTAlert("Produto invalido","MODO ALUMBRA",.T.,2000,3)
		aRet := {}
	EndIf


	//Abrir tela com os detalhes da leitura do EAN 13, caso seja seja expedicao - apanhe
	If lDetalhe .AND. Len(aRet) > 0
		
		nQtdUser := nQE 
		
		//While .T.
			
			VTClear()

			//VtKeyboard(Chr(20))  // zera o get
			nSldMov := oMovimento:GetQtdMov() - oMovimento:GetQtdLid()
			
			//Sugerir o saldo total a pegar
			nQtdUser := nSldMov

			@ 00,00 VtSay "|---WMS ALUMBRA----|" 
			//@ 01,00 VtSay "|" + PadR("Dados do Produto", VTMaxCol(),"-")
			@ 00,19 VtSay "|"
			@ 01,00 VtSay "|" + PadR("EAN: " + Alltrim(cID),VTMaxCol())
			@ 01,19 VtSay "|"
			@ 02,00 VtSay "|" + PadR("SKU: " + SB1->B1_COD,VTMaxCol())
			@ 02,19 VtSay "|" 
			@ 03,00 VtSay "|Qt:" 
			@ 03,07 VtSay  AllTrim(Transform(nSldMov, PesqPict('D12','D12_QTDMOV'))) +"/"+ AllTrim(Transform(oMovimento:GetQtdMov2(), PesqPict('D12','D12_QTDOR2')) )
			@ 03,19 VtSay "|" 
			@ 04,00 VtSay "|Qt Lida:" 
			@ 04,09 VtSay  AllTrim(Transform( nQE, PesqPict('D12','D12_QTDMOV')))
			@ 04,19 VtSay "|"  
			@ 05,00 VtSay "|Qt Mov:" 
			@ 05,09 VTGet  nQtdUser Picture  "@E 99,999,999" Valid nQE > 0   //PesqPict('D12','D12_QTDMOV')
			@ 05,19 VtSay "|"  
			@ 06,00 VtSay "| [ESC] [ENTER]    |"
			@ 07,00 VtSay "|------------------|"
			
			VTRead()  

			If !VTLastkey() == 27
				nQE := nQtdUser
			Else
				//aRet := {"", ""}
				lRet := .F.
			EndIf

		
		//EndDo

		If lRet 

			aRet := {SB1->B1_COD,nQE,Padr(cLote,TamSX3("CB8_LOTECT")[1]),dValid,Padr(cNumSerie,20)}

		EndIf
	EndIf
Else
	aRet := {SB1->B1_COD,nQE,Padr(cLote,TamSX3("CB8_LOTECT")[1]),dValid,Padr(cNumSerie,20)}	
EndIf

RestArea(aArea)

Return aRet

