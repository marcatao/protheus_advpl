User Function DV030CO4()
Local cEndereco := PARAMIXB[1]
Local cConfirma := Space(Len(cEndereco))

If !_lUltItAlu_ //Enquanto nao for ultimo confirma o endereço automatico
    cConfirma :=  cEndereco
    //VTKeyBoard(chr(13)) 
EndIf

Return cConfirma
