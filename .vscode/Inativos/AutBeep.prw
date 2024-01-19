#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"        
#Include "RwMake.ch"
#Include "topconn.ch"
#Include "Totvs.ch"
#INCLUDE "FWMVCDEF.CH"


User Function MT241GRV() 
    Local cNumDOc  := PARAMIXB[1]     
    Local oModel    as object
    Local aErro     := {}
    Local lOk       := .F.
    Local nModAux   := nModulo
    Local cAliasD12 := GetNextAlias()
 

    Wm332Autom(.F.)
    WmsMsgExibe(.T.) //N�o exibe mensagens em tela
    WmsOpc332("4")   //Finalizar
    WmsAcao332("3")  //Docto / Carga
 
    oModel := FWLoadModel("WMSA332A")
    
    BeginSql Alias cAliasD12
        SELECT D12_DOC,
               D12_SERIE,
               D12_CLIFOR,
               D12_LOJA,
               D12_SERVIC,
			   R_E_C_N_O_
        FROM %Table:D12%
       WHERE D12_FILIAL = %xFilial:D12%
         AND D12_DOC = %exp:cNumDOc%
         AND %NotDel%
       GROUP BY D12_DOC,
                D12_SERIE,
                D12_CLIFOR,
                D12_LOJA,
                D12_SERVIC,
			    R_E_C_N_O_
    EndSql
    While (cAliasD12)->(!EoF())
        D12->(DbSetOrder(5))
        If D12->(DbSeek(xFilial('D12')+(cAliasD12)->D12_DOC+(cAliasD12)->D12_SERIE+(cAliasD12)->D12_CLIFOR+(cAliasD12)->D12_LOJA+(cAliasD12)->D12_SERVIC))
            If D12->D12_STATUS != '1'
            nModulo:= 42
            oModel:GotoD12(cAliasD12->R_E_C_N_O_)
                oModel:Deactivate()
                oModel:SetOperation(MODEL_OPERATION_UPDATE)
                If oModel:Activate()
   
                lOk := oModel:VldData()
                 If lOk
                   lOk := oModel:CommitData()
                ELSE
                    aErro := oModel:GetErrorMessage()
                 EndIf
                    
                EndIf
            EndIf
        EndIf
        (cAliasD12)->(DbSkip())
    EndDo
    (cAliasD12)->(DbCloseArea())
    oModel:Destroy()
    oModel := nil
      nModulo:= nModAux
Return(lOk)


 




