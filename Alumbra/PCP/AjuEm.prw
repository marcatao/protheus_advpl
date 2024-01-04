#INCLUDE "totvs.ch"
 
User Function MT241SE()
 
Local aCols       := ParamIXB
Local nPosProduto := 0
Local nLinhas     := 0


   Local aArea   := GetArea()
   nPosProduto := ascan(aHeader,{|x|Upper(Alltrim(x[2]))=="D3_COD"})
   nPosQtd := ascan(aHeader,{|x|Upper(Alltrim(x[2]))=="D3_QUANT"})
   nPosLocal := ascan(aHeader,{|x|Upper(Alltrim(x[2]))=="D3_LOCAL"})
   nPosLOCALIZ := ascan(aHeader,{|x|Upper(Alltrim(x[2]))=="D3_LOCALIZ"})

   for nLinhas := 1 to len(aCols)
      if nPosProduto > 0
        aCols[nLinhas,nPosQtd] := (NQTDORIGES * aCols[nLinhas,nPosQtd]) / SC2->C2_QUANT
        if(aCols[nLinhas,nPosLocal] == '099')
            aCols[nLinhas,nPosLOCALIZ] := 'PRD'
        endIF
      EndIf
   next nLinhas
 RestArea(aArea)
return aCols
