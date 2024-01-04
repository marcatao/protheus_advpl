#INCLUDE "PROTHEUS.CH"
 
user function M461LSF2()
 

Local aArea   := GetArea()
    RECLOCK("SF2", .F.)
     SF2->F2_MARCA1 := SC5->C5_MARCA1
     SF2->F2_NUMER1 := SC5->C5_NUMER1
    MSUNLOCK()
   RestArea(aArea)
return
