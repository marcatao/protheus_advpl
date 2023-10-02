/*/{Protheus.doc} WMSPOSDCF
//Gravar o ID da DCF e ORDSERV
@type function
@version  
@author Deosdete Deo
@since 16/07/2023
@return variant, return_description
/*/
User Function WMSPOSDCF()
//Local nRecDCF := PARAMIXB[1]
Local aArea := GetArea()

//Neste momento esta posicionado na DCF 
//Se estiver gerando a partir da balança, esta com SZ3 posicionada
If FWIsInCallStack("MontagEtiq") .OR. FWIsInCallStack("PESAR")

    RecLock("SZ3",.F.)
    SZ3->Z3_ORDSERV  := DCF->DCF_DOCTO
    SZ3->Z3_IDDCF    := DCF->DCF_ID
    SZ3->(MsUnlock())

EndIf

RestArea(aArea)

Return


