/*/{Protheus.doc} MA440MNU
Ponto de entrada do menu da Libera�ao do Pedido. Inclusao da op�ao Analisar
@type function
@version  
@author Deosdete Deo
@since 03/04/2023
@return variant, return_description
/*/
User Function A440BUT()
Local aUsButtons := {}
	
AADD(aUsButtons,{'Analisar',{|| u_ALUA440(1) },"Analisar","Analisar"})

	
Return aUsButtons
