
/*/{Protheus.doc} WMSCONV
description
@type function
@version  
@author Deosdete Deo
@since 16/07/2023
@return variant, return_description
/*/
User Function WMSCONV()
//lRetPE := ExecBlock("WMSCONV",.F.,.F.,{__cUserID})
Local lRetPE  := .F.

//Public _cAluIdMov_   :=""
//Public _cAluOrdServ_ := ""

// Atribui a Funcao de Funcoes a Combinacao de Teclas <CTRL> + <U>
VTSetKey(21,{||u_ALUV001(2)},"Ctrl U -Modo Alumbra")  // Funcoes Atrib.      '

Return lRetPE



/*/{Protheus.doc} ALUV001
description
@type function
@version  
@author Deosdete Deo
@since 18/08/2023
@return variant, return_description
/*/
User Function ALUV001(nOpc)
//Local lRet := .T.

If Type("_lAluModo_") == "U"
    Public _lAluModo_   := .F.
    Public _cDocWMS_    := ""
    Public _lUltItAlu_  := .F.
Else  //As variaveis sempre tem que reiniciar quando o operador sair e voltar para a convocacao
    _lAluModo_   := .F.
    _cDocWMS_    := ""  
    _lUltItAlu_  := .F. 
EndIf

If nOPc == 1
    //If _lAluModo_
    _lAluModo_ :=  CBYesNo("Entrar?","MODO ALUMBRA",.T.)
Else
    VTAlert("Desabilitado","MODO ALUMBRA",.T.,2000,3)
EndIf

//Else
//    lRet :=  CBYesNo("Entrar?","MODO ALUMBRA",.T.)
//EndIf

//Para habilitar/desabilitar o modo alumbra retirando convocacao e pesquisando por movimento
//If lRet 
 //   _lAluModo_  := !_lAluModo_
//EndIf

Return


