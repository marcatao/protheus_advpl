#INCLUDE "PROTHEUS.CH"

user function docasai(filial, cli, loja, armazem)
 Local aArea   := GetArea()
   local cret
 
   cli := cli
   filial := ALLTRIM(filial) 
   if(filial == '')
        filial := '010101'
   ENDIF
   cret := posicione('D10',1, xfilial('D10')+cli+loja+armazem, 'D10_ENDER')

   if(ALLTRIM(cret) == '')
     dbSelectArea("SA1")
	    SA1->(dbSetOrder(1))	//FILIAL + CLI  + LOJA
	    SA1->(dbGoTop())
	    SA1->(dbSeek(xfilial('SA1')+cli+loja))
	        If Found()
                if(SA1->A1_EST == 'SP' .and. SUBSTR(SA1->A1_CEP,1,1) == '0')
                    cret := 'DOCA01'
                elseif(SA1->A1_EST == 'SP' .and. SUBSTR(SA1->A1_CEP,1,1) == '1')     
                    cret := 'DOCA02'
                elseif(SA1->A1_EST == 'SC' .or. SA1->A1_EST == 'PR' .or. SA1->A1_EST == 'RS' .or. SA1->A1_EST == 'MG' .or. SA1->A1_EST == 'RJ')
                     cret := 'DOCA03'
                else
                     cret := 'DOCA04'
                endif

            endif
   endif

   if(ALLTRIM(cret) == '')
     cret := "DOCA01"
   endif
  RestArea(aArea)
return cret
