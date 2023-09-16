#INCLUDE "Protheus.ch"

User Function MT120VSC()
	ExpA1 := ParamIxb[1]
	ExpN2 := ParamIxb[2]
    if(ParamIxb[1][1] = 'C3_OK')
        aAdd(ExpA1,'C3_CC_DES')
    else
        aAdd(ExpA1,'C1_CC_DES')
    endif
	
Return ExpA1


User Function MT120ISC()  
  Local nPosProgram 	:= aScan(aHeader,{|x| Trim(x[2])=="C7_CC_DES"}) 
  If OMARK:AFIELDSCOLUMNS[11] = "C3_CC_DES"
	ACOLS[n,nPosProgram] := SC3->C3_CC_DES
  else
    ACOLS[n,nPosProgram] := SC1->C1_CC_DES
  endif  
	
Return .T.

User Function MT103IP2()
   local n :=PARAMIXB[1]
      //nPosCod   := AScan(aHeader,{|x| AllTrim(x[2]) == 'D1_COD'})
      nPosPed   := AScan(aHeader,{|x| AllTrim(x[2]) == 'D1_PEDIDO'})
      nPosITEMPC:= AScan(aHeader,{|x| AllTrim(x[2]) == 'D1_ITEMPC'})
      nPosCC    := AScan(aHeader,{|x| AllTrim(x[2]) == 'D1_CC'})
      aCols[n,nPosCC] :=posicione('SC7', 1, xfilial('SC7')+aCols[n, nPosPed]+aCols[n, nPosITEMPC]+'', 'C7_CC_DES' )
      //alert(aCols[n, nPosCod] +' '+ aCols[n, nPosPed] +' '+aCols[n, nPosITEMPC])
Return Nil
