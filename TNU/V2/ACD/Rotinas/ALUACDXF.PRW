/*/{Protheus.doc} ALUACDXF
Funcoes genericas
@type function
@version  
@author Deosdete Deo
@since 17/04/2023
@return variant, return_description
/*/
User Function ALUACDXF()


Return



/*/{Protheus.doc} ALUSLDDISPO
Retorna o saldo disponivel para o pedido de venda
@type function
@version  
@author Deosdete Deo
@since 17/04/2023
@param cProduto, character, param_description
@param cArmOri, character, param_description
@return variant, return_description
/*/
User Function ALUSLDDISPO()
Local nSaldo   := 0
Local aArea    := GetArea()
Local cProduto := "" 
Local cArmOri  := ""
Local nPosProd := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
Local nPosArm  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOCAL"})
Local nPosQtd  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
Local nI       := 0
Local nLin     := Len(aCols)
Local nSldPed  := 0  

cProduto := aCols[nLin][nPosProd]
cArmOri  := aCols[nLin][nPosArm]

If ValType(aCols[nLin][nPosArm]) == "C" 
    cArmOri  := aCols[nLin][nPosArm]
EndIf

SB2->(DbSetOrder(1))
SB2->(DbSeek(xFilial("SB2")+cProduto+cArmOri))
//SaldoMov(lNecessida, lEmpenho, dDataFim, lConsTerc, nQtdEmp, nQtdPrj, lSaldoSemR, dDtRefSld,lConsEmpSA)
//nSaldo := SaldoMov(,,,,,,lSaldoSemR)
nSaldo := Max((SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QACLASS),0)

//Considerar o saldo de um item que ja tenha sido digitado neste pedido
For nI := 1 To Len(aCols)
    If nI <> nLin
        If aCols[nI][nPosProd] + aCols[nI][nPosArm] == (cProduto + cArmOri)
            nSldPed += aCols[nI][nPosQtd] 
        EndIf
    EndIf    
Next nI

nSaldo := nSaldo - nSldPed

RestArea(aArea)

Return nSaldo


/*/{Protheus.doc} CBProxCod
description
@type function
@version  
@author Deosdete Deo
@since 17/04/2023
@param cCodPar, character, param_description
@return variant, return_description
/*/
User Function ALUCBProxCod()
Local cQuery   := ""
Local cQryDCU  := GetNextAlias()
Local cProxVol := ""
Local cPedido  := DCS->DCS_PEDIDO
//Local cCodMnt  := DCS->DCS_CODMNT

//Localizar o ultimo volume dessa montagem
cQuery := "SELECT "
cQuery += "MAX(DCU_CODVOL) AS DCU_CODVOL  "
cQuery += "FROM " + RetSqlName("DCU") + " DCU "
cQuery += "WHERE DCU_PEDIDO = '" + cPedido + "' " 
//cQuery += "AND DCU_CODMNT = '" + cCodMnt + "' " // Vai ser por pedido e nao por onda
cQuery += "AND D_E_L_E_T_ = '' " 

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQryDCU,.T.,.T.)

If !(cQryDCU)->(Eof()) .AND. !Empty((cQryDCU)->DCU_CODVOL)
    cProxVol := Soma1((cQryDCU)->DCU_CODVOL)
Else //Primeiro volume
    cProxVol := cPedido + StrZero(1,TamSX3("DCU_CODVOL")[1]-TamSX3("DCU_PEDIDO")[1])
EndIf

(cQryDCU)->(DbCloseArea())

Return cProxVol

