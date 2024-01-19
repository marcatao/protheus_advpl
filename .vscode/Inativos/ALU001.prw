#INCLUDE "PROTHEUS.CH"
#INCLUDE 'APVT100.CH'

/*/
protheus advpl vt100 manual
https://aprendendoadvpl.wordpress.com/download/

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Funcao   ::CONALUM :: Autor:: ACD                  :: Data ::17/07/03   ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Descrição:: Programa de exemplo de uso das funcoes de VT100             ::
::          ::                                                             ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Parametros::                                                            ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::  Uso     :: PROGRAMA EXEMPLO DE UMA APLICACAO PARA MICROTERMINAL        ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
/*/
User Function ALU001()
Local nI,nPos  := 1        
Local cOpcao	:= ''
Local cCodigo	:= Space(6)
Local dData		:= CtoD("")
 
Local nValor	:= 0
Local aOpcoes	
Local	aItens, acab,aSize 
Local aFields,aHeader



VTSetSize(2,20)

While .T.
   VTClear()

   cCodigo  := Space(6)
   dData    := CtoD("")
   nValor   := 0                 
   
	
	VTClearBuffer()
	While .T.
		cOpcao:= "1"
		VTClear()    
		@ 0,0 VTSAY "1.RF 2.MT44 3.MT16"
		@ 1,0 VTSAY "Selecione: " VTGET cOpcao pict "9"
		VTRead                           

	   If VTLastKey() == 27
	      Exit
	   EndIF
	
		If cOpcao =="1"
		   VTSetSize(8,20)
		   Exit
		ElseIf cOpcao =="2"
		   VTSetSize(2,40)
		   Exit
		ElseIf cOpcao =="3"
		   VTSetSize(2,20)
		   Exit
		Else
		   Vtclear()
		   @ 0,0 VtSay "Opcao invalida          "
		   VTInkey(1000)
		EndIf
		
	 EndDo

   @ 00,00 VTSay PadC("Demo de VT100", If(VTModelo()=="MT16" .or. VTModelo()=="RF",19,39))
   @ 01,00 VTSay "Modelo:" + VTModelo()
   
	// Se o tecla pressionada for <ESC>
   If VTLastKey() == 27
      Exit
   EndIF
	VTInkey(0)
	VTClear()

	VTClearBuffer() 
   
   @ 00,00 VTSay "Codigo: "
   @ 00,08 VTGet cCodigo Pict "@!" Valid  ValidCod(cCodigo) When WhenCod() 
	VTRead  
		// Se o tecla pressionada for <ESC>
   If VTLastKey() == 27
      Loop
   EndIF
   
	@ 01,00 VTSay "Data: "
   @ 01,07 VTGet dData Pict "99/99/99" Valid ValidData(dData) When	WhenData()
		VTRead
		// Se o tecla pressionada for <ESC>
   If VTLastKey() == 27
      Loop
   EndIF

	VTClear()
	VTClearBuffer() 

   @ 00,00 VTSay "Valor: "
   @ 00,07 VTGet nValor Pict "@E 999.99"  When WhenValor()
   VTRead       
   
	If TerEsc() 
      Loop
   EndIF

  
	// Se o tecla pressionada for <ESC>
   If VTLastKey() == 27
      Loop
   EndIF
   
	VTClear()                                
	VTAlert("Entrando no Achoice....","[-]",.T.,1500)
	VTClear()

   VTClearBuffer() 
   aOpcoes	:= {	"Opcao 1", ;
						"Opcao 2", ;
						"Opcao 3", ;
						"Opcao 4", ;
						"Opcao 5"}      

  	npos	:=	VTaChoice(0,0,VTMaxRow(),VTMaxCol(),aOpcoes,,'U_VldAchVT',npos)   
  	
	VTAlert("Entrando no aBrowser... aguarde...","[-]",.T.,1500)  	
   aItens :={{"1010 ",10, "DESCRICAO1","UN "},;
          {"2010 ",20,"DESCRICAO2","CX "},;         
          {"2020 ",30,"DESCRICAO3","CX "},;                   
          {"2010 ",40,"DESCRICAO4","CX "},;         
          {"2020 ",50,"DESCRICAO5","CX "},;                   
          {"3010 ",60,"DESCRICAO6","CX "},;         
          {"3020 ",70,"DESCRICAO7","CX "},;
          {"3030 ",80,"DESCRICAO7","CX "},;
          {"3040 ",90,"DESCRICAO7","CX "},;          
          {"2010 ",100,"DESCRICAO4","CX "},;                   
          {"2010 ",110,"DESCRICAO4","CX "},;         
          {"2020 ",120,"DESCRICAO5","CX "},;                   
          {"3010 ",130,"DESCRICAO6","CX "},;         
          {"3020 ",140,"DESCRICAO7","CX "},;
          {"3030 ",150,"DESCRICAO7","CX "},;
          {"3050 ",160,"DESCRICAO7","CX "}}
          
	acab :={"Codigo","Cod            ","Descricao                     ","UM"}
	aSize   := {10,4,20,10}                                  
	nPos := 1
	npos := VTaBrowse(,,,,aCab,aItens,aSize,,nPos)   
	
	VTAlert("Entrando no DBBrowser... aguarde...","[-]",.T.,2000)
	aFields := {"B1_COD","B1_DESC","B1_UM","B1_PICM"}
	aSize   := {16,20,10,15}          
	aHeader := {'COD','DESCRICAO     ','UM',"% ICM"}       
	sb1->(dbseek(xfilial()))
	npos := VTDBBrowse(,,,,"SB1",aHeader,aFields,aSize)
	  	
  	
             
	VTClearBuffer() 
   If VTYesNo("Deseja finalizar?","Pergunta")
   	Exit
   EndIf
  
   If VTLastKey() == 27
      Loop
   EndIF

   VTClearBuffer()
   
EndDo

Return .T.


Static Function ValidCod(cCodigo)
Local aTela
	VTSAVE SCREEN TO aTela
   VTAlert("Total de bytes:"+	AllTrim(Str(Len(AllTrim(cCodigo)))), ;
   			"Validando:",.T., 2000)
   VTClear()
	VTRestore Screen FROM aTela
Return .T.

Static Function WhenCod()
Local aTela
	VTSAVE SCREEN TO aTela
	VTAlert("Exemplo de Get"+chr(13)+chr(10)+"com Caracter","[-]ATENCAO",.T.,2000)
   VTClear()
	VTRestore Screen FROM aTela
Return .T.


Static Function WhenData()
Local aTela
	VTSAVE SCREEN TO aTela
	VTAlert("Exemplo de Get"+chr(13)+chr(10)+"com Data","[-]ATENCAO",.T.,2000)
   VTClear()
	VTRestore Screen FROM aTela
Return .T.

Static Function WhenValor()
Local aTela
	VTSAVE SCREEN TO aTela
	VTAlert("Exemplo de Get"+chr(13)+chr(10)+"com Numerico","[-]ATENCAO",.T.,2000)
   VTClear()
	VTRestore Screen FROM aTela
Return .T.

Static Function WhenSenha()
Local aTela
	VTSAVE SCREEN TO aTela
	VTAlert("Exemplo de Get"+chr(13)+chr(10)+"com Senha","[-]ATENCAO",.T.,2000)
   VTClear()
	VTRestore Screen FROM aTela
Return .T.

Static Function ValidData(dData)
Local lRet := .T.
	If Empty(dData)
	   lRet	:= .F.
	   VTAlert("Data Invalida", "Atencao",.T.,2000)
	EndIf
Return lRet


                                    

User Function VldAchVT(modo,nElem,nElemW)

If modo == 1 
   VTAlert('Inicio do Achoice','-',.T.,1000)
Elseif Modo == 2 
   VTAlert('Fim do Achoice','-',.T.,1000)
Else
	If VTLastkey() == 27 
	   VTAlert('Saindo do Achoice','-',.T.,1000)
   	VTBeep(1)
   	return 0  
   elseIf VTLastkey() == 13      
       VTAlert('Tecla <ENTER> precionada','-',.T.,1000)
       VTBeep(1)
      return 1          
   Endif      
       
EndIf        

Return 2
