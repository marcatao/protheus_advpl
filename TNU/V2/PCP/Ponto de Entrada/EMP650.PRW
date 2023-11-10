#include "rwmake.ch" 

/*/{Protheus.doc} EMP650
Ponto de entrada da geraça da Ordem de Producao
@type function
@version  
@author Deosdete Deo
@since 10/8/2023
@return variant, return_description
/*/
User Function EMP650()

Local aArea := GetArea()
//Local nI    := 0

RecLock("SC2",.F.)
SC2->C2_LOCAL := GetAdvFVal("SB1","B1_LOCPAD",xFilial("SB1")+SC2->C2_PRODUTO,1)           
MsUnlock()

//Nao precisa mexer nos itens
//For nI := 1 To Len(aCols)
//	aCols[nI,3] := Alltrim(GetMv("MV_ARMPROC"))
//Next

RestArea(aArea)

Return
