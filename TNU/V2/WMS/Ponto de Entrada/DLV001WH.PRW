#Include "PROTHEUS.CH"
#INCLUDE "APVT100.CH"
/*/{Protheus.doc} DLV001WH
description
@type function
@version  
@author Deosdete Deo
@since 16/07/2023
@return variant, return_description
/*/
User Function DLV001WH()
Local cRecHum    := PARAMIXB[1]
//Local cFuncao    := PARAMIXB[2]
Local cQueryAux  :=  ""
Local aOSMov     := {}
Local cIDMov     := ""
Local aArea      := GetArea() 
Local cStatusMov := ""


//cRecHum    := ""
//cFuncao    := ""

If Type("_lAluModo_") == "U"
    Public _lAluModo_  := .F.
    Public _cDocWMS_    := ""
EndIf

If _lAluModo_  // Modo alumbra

    If Empty(_cDocWMS_) 
        aOSMov    := PegMov()
        If Len(aOSMov) > 0
            _cDocWMS_ := aOSMov[1]
            cIDMov    := aOSMov[2]
        EndIf
    EndIf

    If Empty(cIDMov) .AND. Empty(_cDocWMS_)  .AND.  !VTLastkey() == 27
        cIDMov := ALUV001Browse(_cDocWMS_,cRecHum)
    EndIf


    /*Se for um documento / pedido - listar na tela todos os movimentos do pedido
        e se o usuario selecionar um trazer o IDmovimento, se nao selecionar, trazer o ID do primeiro movimento do pedido
        */
    
    If !Empty(_cDocWMS_) 
        cIDMov := ALUV001Browse(_cDocWMS_,cRecHum)

        //Se nao econtrar registros com este documento, limpar o documento
        //If Empty(cIDMov)
        //    _cDocWMS_ := ""
        //EndIf    
    EndIf

     
   If !Empty(AllTrim(_cDocWMS_))
        cQueryAux += " AND D12_DOC = '" + _cDocWMS_ + "' "
    EndIf

    If !Empty(AllTrim(cIDMov))
 
        //Verificar se este movimento ja foi atendido
        cStatusMov :=  MovStatus(cIDMov)
        
        If !Empty(cStatusMov) 
            If cStatusMov == "1"
                VTAlert("Movimento Ja Finalizado","MODO ALUMBRA",.T.,2000,3)
            EndIf 
            
        //Se nao encontar emitir alerta de movimento nao encontrado            
        Else //Se em branco é porque nao encontrou registro   
            VTAlert("Movimento Não Encontrado","MODO ALUMBRA",.T.,2000,3)    
        EndIf 

        cQueryAux += " AND D12_IDMOV = '" + cIDMov + "' "

    EndIf

    //Sair da tela e habilitar o abondono da convocaçao
    If VTLastkey() == 27
        __nOpcESC := 1 // FLAG de Abandono   
    EndIf

    //Se estiver no modo alumbra e nao encontrar registro passar qualquer coisa pra nao encontrar regisro
    If Empty(AllTrim(_cDocWMS_)) .AND. Empty(AllTrim(cIDMov))
       // VTAlert("Nao foi possivel convocar este item. Verifique","MODO ALUMBRA",.T.,2000,3)
        cQueryAux := " AND D12_IDMOV = 'xxxxxxxx' "   
    EndIf

EndIf

RestArea(aArea)

Return cQueryAux


/*/{Protheus.doc} ALUV001
description
@type function
@version  
@author Deosdete Deo
@since 16/07/2023
@return variant, return_description
/*/
Static Function ALUV001Browse(cDoc, cRecHum)
Local cIdMov   := Space(TamSX3("D12_IDMOV")[1])
Local aSave  := VTSave(00, 00, VTMaxRow(), VTMaxCol())

//User Function TRI10V28()

Local aCab    := {"ENDERECO","COD","DOC","QTD","QTD_LIDA", "TAR","ATIV", "DATA", "RECNO", "ID_MOV"} 
Local aSize   := {10,15,9,7,7,4,4,8,9,10}
Local aOS     := {}
//Local aOS_Sel := {}
Local cQuery  := ""
Local cQryD12 := GetNextAlias()
Local nI_OS   := 0
//Local lIMG01  := ExistBlock('IMG01')
Local aArea   := GetArea()
Local lMsgStatus := .F.
//Local aRet    := {} //{ Documento , Movimento }
Local cQtdPict := "99,999.9"

Default cDoc :=    ""
Default cRecHum := ""

Set(_SET_DATEFORMAT, 'dd/mm/yy')

cQuery := "SELECT  "
cQuery += "D12_ENDORI, D12_PRODUT, D12_DOC, D12_QTDORI, D12_QTDLID, D12_TAREFA, D12_ATIVID, D12_DTGERA, D12.R_E_C_N_O_ AS RECNO, D12_IDMOV, D12_STATUS, D12_QTDLID "
cQuery += "FROM "+RetSqlName("D12")+" D12 "
//cQuery += "JOIN "+RetSqlName("SB1")+" SB1 "
//cQuery += "  ON B1_FILIAL = '"+xFilial("SB1")+"' "
//cQuery += "  AND B1_COD = D12_PRODUT "
//cQuery += "  AND SB1.D_E_L_E_T_ = '' "
cQuery += "WHERE D12_FILIAL = '"+xFilial("D12")+"' " 
cQuery += "  AND D12_STATUS IN('2','4') " //Somente movimento com pendentes

If !Empty(_cArmALU_)
    cQuery += " AND D12.D12_LOCORI = '"+_cArmALU_+"'"
EndIf

If !Empty(cDoc)
    cQuery += "  AND D12_DOC = '" + cDoc + "' " //Somente movimento do pedido informado
EndIf

cQuery += "  AND (D12_RECHUM = '' OR D12_RECHUM = '" + cRecHum + "') " //Somente movimento do pedido informado

cQuery += "  AND D12.D_E_L_E_T_ = '' "
cQuery += "ORDER BY D12_PRIORI DESC "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQryD12,.T.,.T.)

TCSetField(cQryD12, "D12_QTDORI", "N", 12, 2 )
TCSetField(cQryD12, "D12_QTDLID", "N", 12, 2 )
TCSetField(cQryD12, "D12_DTGERA", "D", 8, 0 )

While !(cQryD12)->(Eof())
	
    //Se estiver interrompido, mas nao foi lido nada, reiniciar serviçço
    If (cQryD12)->D12_STATUS == "2" 
        
        If  (cQryD12)->D12_QTDLID == 0 
            D12->(DbGoTo((cQryD12)->RECNO))
            
            RecLock("D12",.F.)
            D12->D12_STATUS := "4"
            D12->D12_RECHUM := ""
            D12->(MsUnlock())
        Else
            lMsgStatus := .T.    
        EndIf

	EndIf

    (cQryD12)->(DbSkip())
	       
EndDo

If lMsgStatus

    VTAlert("Existe atividade interrompida. Verifique no monitor","MODO ALUMBRA",.T.,2000,3)

EndIf

(cQryD12)->(DbGoTop())

While !(cQryD12)->(Eof())
	
    aAdd(aOS,{;
           (cQryD12)->D12_ENDORI,; 
           (cQryD12)->D12_PRODUT,; 
           (cQryD12)->D12_DOC,;                               //1
	       PadL(AllTrim(Transform((cQryD12)->D12_QTDORI,cQtdPict)),7),; //2 
	       PadL(AllTrim(Transform((cQryD12)->D12_QTDLID,cQtdPict)),7),; //3 
	       (cQryD12)->D12_TAREFA,;                       //4  
	       (cQryD12)->D12_ATIVID,;                       //5  
	       DToC((cQryD12)->D12_DTGERA),;                                 //6
	       (cQryD12)->RECNO,;                                 //7
	       (cQryD12)->D12_IDMOV;                                 //8
	       })
	
    (cQryD12)->(DbSkip())
	       
EndDo

VTClear()

If Len(aOS) > 0
    //Pegar a posiçao retornada para filtrar todos os apontamentos da op
    nI_OS := VTaBrowse(0,0,7,19,aCab,aOS,aSize)

    If nI_OS > 0
        cIDMov  := aOS[nI_OS][10]    
    EndIf

    If Len(aOS) == 1
        _lUltItAlu_ := .T.
    Else
        _lUltItAlu_ := .F.
    EndIf

Else  //se nao tem nada zera o campo do docuemnto

    _cDocWMS_ := ""

EndIf

VtRestore(,,,,aSave)

RestArea(aArea)

VtClearBuffer()

//VTKeyBoard(chr(83)) //Passando sim para nao seguir com ESC
If VTLastkey() == 27
    VTKeyBoard(chr(83)) //Passando sim para nao seguir com ESC
    VTYesNo("?","Continuar",.T.) //"Confirma a saida?"###"Atencao"
EndIf

Return cIDMov

/*/{Protheus.doc} PegMov
description
@type function
@version  
@author Deosdete Deo
@since 8/18/2023
@return variant, return_description
/*/
Static Function PegMov()
//Local aTelaAnt  := VTSave(00, 00, VTMaxRow(), VTMaxCol())
Local cEtiqueta := Space(18)
Local cDoc      := Space(TamSX3("D12_DOC")[1])
Local cIDMov    := Space(TamSX3("D12_IDMOV")[1])
Local aRet      := {}
Local lRet      := .T.

VTClear()

VtKeyboard(Chr(20))  // zera o get

@ 00,00 VtSay "|---WMS ALUMBRA----|" 
@ 01,00 VtSay "|"
@ 01,19 VtSay "|"
@ 02,00 VtSay "|Doc/Mov:"
@ 02,19 VtSay "|"
@ 03,01 VTGet cEtiqueta Picture '@!' Valid VldMov(cEtiqueta, @cIDMov, @cDoc)
@ 03,00 VtSay "|"
@ 03,19 VtSay "|"
@ 04,00 VtSay "|"
@ 04,19 VtSay "|"
@ 05,00 VtSay "|------------------|"
@ 06,00 VtSay "| [ESC] [ENTER]    |"
@ 07,00 VtSay "|------------------|"
VTRead()  

If VTLastkey() == 27
    aRet := {"", ""}
    lRet := .F.
EndIf

//VTRestore(00, 00, VTMaxRow(), VTMaxCol(), aTelaAnt)

If lRet 

    aRet := {cDoc, cIDMov}

EndIf

Return aClone(aRet)

/*/{Protheus.doc} VldMov
description
@type function
@version  
@author Deosdete Deo
@since 8/18/2023
@param cIDMov, character, param_description
@return variant, return_description
/*/
Static Function VldMov(cEtiqueta, cIDMov, cDoc)
Local lRet    := .T.

//Tirar os espacos da etiqueta para que ela seja caracterizada conforme o tamnho 12 = UNITIZADOR
cEtiqueta := AllTrim(cEtiqueta) 
If !Empty(cEtiqueta)
    //Verificar se é um movimento 
    If Len(cEtiqueta) == TamSX3("D12_IDMOV")[1]
        cIDMov   := cEtiqueta
        cDoc := ""
    Else //ElseIf Len(cEtiqueta) == TamSX3("D12_DOC")[1]
        cIdMov  := ""
        cDoc := cEtiqueta 
    //Else
    //    VTAlert("Id invalido", "Atencao") 
    //    lRet := .F.
    EndIf
Else
    //VTAlert("Id em branco", "Atencao")
    //lRet := .F.
EndIf

Return lRet

/*/{Protheus.doc} MovStatus
description
@type function
@version  
@author Deosdete Deo
@since 11/10/2023
@param cIDMov, character, param_description
@return variant, return_description
/*/
Static Function MovStatus(cIDMov)
Local cStatusMov := ""
Local cQuery     := ""
Local cQryD12    := GetNextAlias()

cQuery := "SELECT D12_STATUS 
cQuery += "FROM " + RetSqlName("D12") + " D12 " 
cQuery += " WHERE D12_IDMOV = '" + cIDMov + "' "
cQuery += "  AND D12.D_E_L_E_T_ = '' "
cQuery += "ORDER BY D12_IDMOV "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQryD12,.T.,.T.)

If !(cQryD12)->(Eof())
    cStatusMov := (cQryD12)->D12_STATUS
EndIf

(cQryD12)->(DbCloseArea())

Return cStatusMov
