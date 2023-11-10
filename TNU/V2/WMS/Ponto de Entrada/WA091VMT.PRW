#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
/*/{Protheus.doc} WA091VMT
description
@type function
@version  
@author Deosdete Deo
@since 25/03/2023
@return variant, return_description
/*/
User Function WA091VMT()
Local aAreaAnt := GetArea()
Local lRet     := .F.
//Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Fechar Embalagem"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
//Local nOpc     := MODEL_OPERATION_INSERT

//Verificar o status e se ainda estiver aberto, deixar o usuario finaliar
/*
If DCS->DCS_STATUS <> "3" 

    DbSelectArea("DCV")
    DbSetOrder(1) //DCV_FILIAL+DCV_CODMNT+DCV_CODVOL+DCV_PRDORI+DCV_CODPRO+DCV_LOTE+DCV_SUBLOT+DCV_ITEM+DCV_SEQUEN
    If DCV->(DbSeek(xFilial("DCV")+DCU->DCU_CODMNT+DCU->DCU_CODVOL )) 
        If DCV->DCV_STATUS <> "2"
            If Aviso("Atenção!","Reabrir Volume "+ DCU->DCU_CODVOL + " ?", {"Sim","Não"}) == 1
                nOpc := MODEL_OPERATION_UPDATE
            Else
                nOpc := MODEL_OPERATION_INSERT
            EndIf
        Else
            
            If Aviso("Atenção!","Continuar no Volume "+ DCU->DCU_CODVOL + " ?", {"Sim","Não"}) == 1
                nOpc := MODEL_OPERATION_UPDATE
            Else
                nOpc := MODEL_OPERATION_INSERT
            EndIf
        EndIf
    EndIf

EndIf
*/ //vai sempre icluir

//FWExecView("Montar Volume Alumbra",'ALUA391A',nOpc  ,,{||.T.}, , ,aButtons ,{||.T.}) //== 0 // Montar Volume Alumbra

//If Aviso("Atenção!","Modo alumbra?", {"Sim","Não"}) == 1
    U_ALUA391A()
//Else  
 //   lRet := .T.
//EndIf

RestArea(aAreaAnt)

Return lRet
