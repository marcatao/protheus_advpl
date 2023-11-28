#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'
/*/{Protheus.doc} WMSA391
Ponto de entrada para correçao da quantidade embalada
@type function
@version  
@author Deosdete Deo
@since 11/6/2023
@return variant, return_description
/*/
User Function WMSA391()
Local aParam := PARAMIXB
Local xRet := .T.
Local oObj := ''
Local cIdPonto := ''
Local cIdModel := ''
Local lIsGrid := .F.
Local oModelx

Local nLinha := 0
Local nQtdLinhas := 0
Local cMsg := ''
local nome
 
Local aArea  := GetArea()

If aParam <> NIL

    oObj := aParam[1]
    cIdPonto := aParam[2]
    cIdModel := aParam[3]
    lIsGrid := ( Len( aParam ) > 3 )

    If cIdPonto == 'MODELCOMMITNTTS'

        oModelx := FWModelActive() 
        oModelDCS := oModelx:GetModel('A391DCS') 
        oModelDCT:= oModelx:GetModel('A391DCT')

        If oModelDCS:GetValue("DCS_QTEMBA") < 0 .OR. oModelDCT:GetValue("DCT_QTEMBA") < 0

            MsgStop("A quantidade embalada ficou negativo. O sistema vai corrigir.")

            cCodMNT  := oModelDCS:GetValue("DCS_CODMNT")

            DbSelectArea("DCT")
            If DCT->(DbSeek(xFilial("DCT")+cCodMNT)) //DCT_FILIAL+DCT_CODMNT+DCT_CARGA+DCT_PEDIDO
                
                While !DCT->(Eof())
                
                    If DCT->DCT_QTEMBA < 0
                        RecLock("DCT", .F.)
                        DCT->DCT_QTEMBA := 0 
                        DCT->(MsUnlock())     
                    EndIf  

                    DCT->(DbSkip())    
                EndDo 
            
            EndIf

            DbSelectArea("DCS")
            If DCS->(DbSeek(xFilial("DCS")+cCodMNT)) //DCT_FILIAL+DCT_CODMNT+DCT_CARGA+DCT_PEDIDO
                
                If DCS->DCS_QTEMBA < 0
                    RecLock("DCS", .F.)
                    DCS->DCS_QTEMBA := 0 
                    DCS->(MsUnlock())     
                EndIf  
            
            EndIf

        EndIf
    EndIf

EndIf

RestArea(aArea)

Return xRet
