/*/{Protheus.doc} DV030CO4
Ponto de entrada para informar o endereço no final da atividade
@type function
@version  
@author Deosdete Deo
@since 11/27/2023
@return variant, return_description
/*/
User Function DV030CO4()
Local cEndereco := PARAMIXB[1]
Local cConfirma := Space(Len(cEndereco))

//If !_lUltItAlu_ //Enquanto nao for ultimo confirma o endereço automatico
    cConfirma :=  cEndereco
    //VTKeyBoard(chr(13)) 
//EndIf

Return cConfirma
