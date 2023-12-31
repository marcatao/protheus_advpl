#INCLUDE "RWMAKE.CH"
#INCLUDE "TMKMAIL.CH"

/*
  旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  �     Retorno Esperado apos a conversao do mailing						 �
  �                       							                         �
  �     Estrutura do array :								                 �
  �                       							                         �
  �     01- Nome															 �
  �     02- Nome Fantasia													 �
  �     03- Endereco														 �
  �		04- Municipio														 �
  �		05- Cep																 �
  �		06- Estado															 �
  �		07- Telefone														 �
  �		08- Fax																 �
  �		09- EMAIL															 �
  �		10- Url																 �
  �		11- CGC																 �
  �		12- Contato															 �
  �		13- Cargo do Cont.													 �
  �                       							                         �
  읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*/


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿟MKMAIL   튍utor  쿘icrosiga           � Data �  24/10/03   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     쿣erifica os diferentes tipos de mailing para estruturacao   볍�
굇� 		 쿭o array que sera importado para o browse da tela de 	  	  볍�
굇� 		 쿬adastro de suspect                                  	  	  볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       쿎ALL CENTER                                                 볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
User Function  TMKMAIL(cArquivo,nQtdCol)

Local cBuffer     := ""
Local cAux        := ""
Local cString     := ""
Local cSeparador  := ""  //Verifica o tipo de separador do arquivo texto
Local aTmp        := {}
Local aEstrutura  := {}
Local nCont       := 0
Local cEof        := Chr(10)+ Chr(13)
Local nRec        := 0
Local lAspa       := .F.

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Leitura da quantidade de Registros do Arquivo                       �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
FT_FUSE(cArquivo)
FT_FGOTOP()
While !FT_FEOF()
	nRec++
	FT_FSKIP()
End

ProcRegua(nRec)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Leitura do mailing e verificacao do ultimo caracter da linha lida para  consistencia da pesquisa �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
FT_FGOTOP()

While !FT_FEOF()
	cBuffer:= AllTrim(FT_FREADLN())
	
	If At(";",cBuffer) > 0
		cSeparador:= ";"
	ElseIf At(",",cBuffer) > 0
		cSeparador:= ","
	Else //linha de arquivo incorreta.
		IncProc()
		FT_FSKIP()
		Loop
	Endif
	
	If (SubStr(cBuffer,Len(cBuffer),1)<>cSeparador)
		cBuffer+= cSeparador + cEof + cSeparador
	Else
		cBuffer+= cEof + cSeparador
	Endif
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Incrementa a regua                                                  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	IncProc()
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//�  Carrega o array aEstrutura com o resultado da Importacao           �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	cLinha:= cBuffer
	lAspa := .F.
	For nCont := 1 To Len(cBuffer)

		cAux   := SubStr(cLinha,1,1)
		cLinha := SubStr(cLinha,2)
		If (cAux == cEof)
			Exit
		Endif
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//�  Sao verificadas as marcacoes feitas pelo Excel para concatenacao de strings �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		Do Case
			Case cAux == '"'
				lAspa := !lAspa
			Case cAux == cSeparador .And. !lAspa
				Aadd(aTmp,cString)
				cString := ""
			OtherWise
				cString += cAux
		EndCase

	Next nCont
	
	For nCont := Len(aTmp)+1 To nQtdCol
		Aadd(aTmp,"")
	Next nCont
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿣alidacao para nao salvar registros sem entidades �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If !Empty(aTmp[1]) .OR. !Empty(aTmp[2])
		Aadd(aEstrutura,aTmp)
		aTmp := {}
	Endif
	FT_FSKIP()
End

FT_FUSE()
MsgInfo(STR0001) //Importacao concluida com sucesso

Return (aEstrutura)
