#INCLUDE "matrur2.ch"
#INCLUDE "Protheus.ch"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Defines das posicoes do array aItens �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
#DEFINE _DATA		1
#DEFINE _DOCTO		2
#DEFINE _CLIENTE	3
#DEFINE _VALTOT		4
#DEFINE _PERCEP		5
#DEFINE _IVAMAIOR	6
#DEFINE _IVAMENOR	7
#DEFINE _COFIS		8
#DEFINE _FIS		9
#DEFINE _INAC		10
#DEFINE _VALBASE	11
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  쿘ATRUR2   � Autor 쿞ergio S. Fuzinaka     � Data � 24.05.06 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escricao 쿗ivros Fiscais de Vendas                                    낢�
굇�          �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿝etorno   쿙enhum                                                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros쿙enhum                                                      낢�
굇�          �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       쿢ruguai                                                     낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�   DATA   � Programador   쿘anutencao efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� 09/11/15 쿌lf. Medrano   쿛CREQ-4263� se realiza merge 12.1.8         낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
Function MATRUR2()

Local oReport
Local cPerg := "MTRUR2"

If FindFunction("TRepInUse") .And. TRepInUse()
	Pergunte(cPerg,.F.)
	oReport:=ReportDef()
	oReport:PrintDialog()
Else
	MatrUr2R3()
EndIf

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇쿛rograma  쿝eportDef  � Autor 쿞ergio S. Fuzinaka     � Data � 24.05.06 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escricao 쿌 funcao estatica ReportDef devera ser criada para todos os  낢�
굇�          퀁elatorios que poderao ser agendados pelo usuario.           낢�
굇�          �                                                             낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿝etorno   쿐xpO1: Objeto do relat�rio                                   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿛arametros쿙enhum                                                       낢�
굇�          �                                                             낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇�   DATA   � Programador   쿘anutencao efetuada                          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇�          �               �                                             낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/
Static Function ReportDef()

Local oReport
Local oEmpresa
Local oLinha
Local cReport	:= "MATRUR2"
Local cPerg		:= "MTRUR2"
Local cTitulo	:= OemToAnsi(STR0021)
Local cDesc		:= OemToAnsi(STR0022)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿎riacao do componente de impressao                                      �
//�                                                                        �
//쿟Report():New                                                           �
//쿐xpC1 : Nome do relatorio                                               �
//쿐xpC2 : Titulo                                                          �
//쿐xpC3 : Pergunte                                                        �
//쿐xpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//쿐xpC5 : Descricao                                                       �
//�                                                                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
oReport := TReport():New(cReport,cTitulo,cPerg,{|oReport| ReportPrint(oReport)},cDesc)
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)
Pergunte(oReport:uParam,.F.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿎riacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//쿟RSection():New                                                         �
//쿐xpO1 : Objeto TReport que a secao pertence                             �
//쿐xpC2 : Descricao da se�ao                                              �
//쿐xpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se豫o.                   �
//쿐xpA4 : Array com as Ordens do relat�rio                                �
//쿐xpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//쿐xpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿎riacao da celulas da secao do relatorio                                �
//�                                                                        �
//쿟RCell():New                                                            �
//쿐xpO1 : Objeto TSection que a secao pertence                            �
//쿐xpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//쿐xpC3 : Nome da tabela de referencia da celula                          �
//쿐xpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//쿐xpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//쿐xpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//쿐xpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//쿐xpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿞ecao 1 - Cabecalho          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
oEmpresa := TRSection():New(oReport,OemToAnsi(STR0037),{"SM0"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oEmpresa,"M0_NOMECOM","SM0",OemToAnsi(STR0037),/*Picture*/,40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oEmpresa,"M0_ENDENT","SM0",OemToAnsi(STR0038),/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oEmpresa,"M0_CGC","SM0",OemToAnsi(STR0039),/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿞ecao 2 - Detalhe            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
oLinha := TRSection():New(oReport,OemToAnsi(STR0040),{"SF3","SA2"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oLinha,"F3_ENTRADA","SF3",OemToAnsi(STR0026),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"F3_NFISCAL","SF3",OemToAnsi(STR0027),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"A1_NOME","",OemToAnsi(STR0028),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"VALTOT","",OemToAnsi(STR0029),PesqPict("SF3","F3_VALCONT"),TamSx3("F3_VALCONT")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"PERCEP","",OemToAnsi(STR0030),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"IVAMAIOR","",OemToAnsi(STR0031),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"IVAMENOR","",OemToAnsi(STR0032),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"COFIS","",OemToAnsi(STR0033),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"VALBASE","",OemToAnsi(STR0034),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"FIS","",OemToAnsi(STR0035),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"INAC","",OemToAnsi(STR0036),PesqPict("SF3","F3_VALCONT"),TamSx3("F3_VALCONT")[1],/*lPixel*/,/*{|| code-block de impressao }*/)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿟otais                       �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
TRFunction():New(oLinha:Cell("VALTOT"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("PERCEP"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("IVAMAIOR"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("IVAMENOR"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("COFIS"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("VALBASE"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("FIS"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("INAC"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)

Return(oReport)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇쿛rograma  쿝eportPrint� Autor 쿞ergio S. Fuzinaka     � Data � 24.05.06 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escricao 쿌 funcao estatica ReportDef devera ser criada para todos os  낢�
굇�          퀁elatorios que poderao ser agendados pelo usuario.           낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿝etorno   쿙enhum                                                       낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿛arametros쿐xpO1: Objeto Report do Relatorio                            낢�
굇�          �                                                             낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/
Static Function ReportPrint(oReport)

Local cCabec	:= OemToAnsi(STR0021)+OemToAnsi(STR0024)+DtoC(mv_par01)+OemToAnsi(STR0025)+DtoC(mv_par02)
Local aImpostos	:= {}
Local cAliasSF3	:= "SF3"
Local cChave	:= ""
Local cClieFor	:= ""
Local nI		:= 0
Local nZ		:= 0
Local cNomeCom	:= ""
Local cEndEnt	:= ""
Local cCGC		:= ""
Local dEntrada	:= CtoD("")
Local cNFiscal	:= ""
Local cNome		:= ""
Local nVALTOT	:= 0
Local nPERCEP	:= 0
Local nIVAMAIOR	:= 0
Local nIVAMENOR	:= 0
Local nCOFIS	:= 0
Local nVALBASE	:= 0
Local nFIS		:= 0
Local nINAC		:= 0
Local aItens	:= {}

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿌ltera o titulo para impressao                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
oReport:SetTitle(cCabec)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿘onta aImpostos com as informacoes de cada imposto     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
dbSelectArea("SFB")
dbSetOrder(1)
dbGoTop()

AAdd(aImpostos,{"IVA|IV3",""}) 
AAdd(aImpostos,{"IV2|IV4",""}) 
AAdd(aImpostos,{"COF",""})
AAdd(aImpostos,{"PVI",""})                
AAdd(aImpostos,{"PFI",""})
AAdd(aImpostos,{"FIS",""})                
AAdd(aImpostos,{"INC",""})                

While !SFB->(Eof()) 
	If aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]}) > 0
		aImpostos[aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]})][2] := SFB->FB_CPOLVRO
	EndIf	
	DbSkip()
EndDo                 
aSort(aImpostos,,,{|x,y| x[2] < y[2]})

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿑iltragem do relatorio                                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea("SF3")
dbSetOrder(1)

#IFDEF TOP
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿟ransforma parametros Range em expressao SQL                            �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	MakeSqlExpr(oReport:uParam)

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿜uery do relat�rio da secao 1                                           �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	oReport:Section(2):BeginQuery()	
	
	cAliasSF3 := GetNextAlias()
		
	BeginSql Alias cAliasSF3
		SELECT SF3.*
		FROM %table:SF3% SF3
		WHERE F3_FILIAL = %xFilial:SF3%	AND 
			F3_ENTRADA	>=	%Exp:mv_par01%	AND 
			F3_ENTRADA	<=	%Exp:mv_par02%	AND 
			F3_TIPOMOV	=	'V'				AND 
			SF3.%NotDel% 
		ORDER BY %Order:SF3%
	EndSql 

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿘etodo EndQuery ( Classe TRSection )                                    �
	//쿛repara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//쿐xpA1 : Array com os parametros do tipo Range                           �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	oReport:Section(2):EndQuery(/*Array com os parametros do tipo Range*/)
		
#ELSE

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿟ransforma parametros Range em expressao SQL                            �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	MakeAdvplExpr(oReport:uParam)

	cCondicao := "F3_FILIAL == '"+xFilial("SF3")+"' .And. "
	cCondicao += "F3_TIPOMOV == 'V' .And. "
	cCondicao += "Dtos(F3_ENTRADA) >= '"+Dtos(mv_par01)+"' .And. "
	cCondicao += "Dtos(F3_ENTRADA) <= '"+Dtos(mv_par02)+"'"

	oReport:Section(2):SetFilter(cCondicao,IndexKey())
	
#ENDIF		

oReport:Section(1):Cell("M0_NOMECOM"):SetBlock({|| cNomeCom})
oReport:Section(1):Cell("M0_ENDENT"):SetBlock({|| cEndEnt})
oReport:Section(1):Cell("M0_CGC"):SetBlock({|| cCGC})

oReport:Section(2):Cell("F3_ENTRADA"):SetBlock({|| dEntrada})
oReport:Section(2):Cell("F3_NFISCAL"):SetBlock({|| cNFiscal})
oReport:Section(2):Cell("A1_NOME"):SetBlock({|| cNome})
oReport:Section(2):Cell("VALTOT"):SetBlock({|| nValTot})
oReport:Section(2):Cell("PERCEP"):SetBlock({|| nPercep})
oReport:Section(2):Cell("IVAMAIOR"):SetBlock({|| nIVAMaior})
oReport:Section(2):Cell("IVAMENOR"):SetBlock({|| nIVAMenor})
oReport:Section(2):Cell("COFIS"):SetBlock({|| nCOFIS})
oReport:Section(2):Cell("VALBASE"):SetBlock({|| nValBase})
oReport:Section(2):Cell("FIS"):SetBlock({|| nFIS})
oReport:Section(2):Cell("INAC"):SetBlock({|| nINAC})

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿔nclui as posicoes dos campos de impostos no array aImpostos �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
For nZ:=1 To Len(aImpostos)
	AAdd(aImpostos[nZ],FieldPos("F3_BASIMP"+aImpostos[nZ][2]))
	AAdd(aImpostos[nZ],FieldPos("F3_VALIMP"+aImpostos[nZ][2]))
Next	          

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿘etodo TrPosition()                                                     �
//�                                                                        �
//쿛osiciona em um registro de uma outra tabela. O posicionamento ser�     �
//퀁ealizado antes da impressao de cada linha do relat�rio.                �
//�                                                                        �
//쿐xpO1 : Objeto Report da Secao                                          �
//쿐xpC2 : Alias da Tabela                                                 �
//쿐xpX3 : Ordem ou NickName de pesquisa                                   �
//쿐xpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexe-�
//�        cutada.                                                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿛osicionamento das tabelas                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
SA1->(dbSelectArea("SA1"))
SA1->(dbSetOrder(1))

SA2->(dbSelectArea("SA2"))
SA2->(dbSetOrder(1))

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿔nicio da impressao do fluxo do relatorio                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cNomeCom	:= SM0->M0_NOMECOM
cEndEnt		:= SM0->M0_ENDENT
cCGC		:= SM0->M0_CGC
oReport:SetMeter(1)
oReport:Section(1):Init()
oReport:Section(1):PrintLine() 	
oReport:Section(1):Finish()	

dbSelectArea(cAliasSF3)
dbGoTop()
oReport:SetMeter((cAliasSF3)->(LastRec()))
oReport:Section(2):Init()

While !oReport:Cancel() .And. !(cAliasSF3)->(Eof())

	aItens := {}
	oReport:IncMeter()

	cChave := (cAliasSF3)->F3_FILIAL+DTOS((cAliasSF3)->F3_ENTRADA)+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+;
				(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_CFO+(cAliasSF3)->F3_ESPECIE+(cAliasSF3)->F3_TIPOMOV
				
	dEntrada	:= (cAliasSF3)->F3_ENTRADA                                                   
	cNFiscal	:= (cAliasSF3)->F3_NFISCAL

    If Empty((cAliasSF3)->F3_DTCANC)

		cClieFor := (cAliasSF3)->F3_CLIEFOR
		If Len(cClieFor) > 0
			If (cAliasSF3)->F3_TIPO <> "B"
				SA1->(dbGoTop())
				If SA1->(dbSeek(xFilial("SA1")+cClieFor))
					cNome := SA1->A1_NOME
				Else 
					cNome := cClieFor
				EndIf           
			Else	
				SA2->(dbGoTop())
				If SA2->(dbSeek(xFilial("SA2")+cClieFor))
					cNome := SA2->A2_NOME
				Else 
					cNome := cClieFor
				EndIf
			EndIf	
		EndIf	
		
		AAdd(aItens,{dEntrada,cNFiscal,cNome,(cAliasSF3)->F3_VALCONT,0,0,0,0,0,0,0,(cAliasSF3)->F3_TIPO})
		
		For nI:=1 To Len(aImpostos)
			Do Case
				Case  aImpostos[nI][1] $ "PVI|PFI" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_PERCEP]   += FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "IV2|IV4" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IVAMAIOR] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "IVA|IV3" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IVAMENOR] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "COF" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_COFIS]    := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "FIS" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_FIS]      := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "INC" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_INAC]     := FieldGet(aImpostos[nI][4])
			EndCase							
		Next  
	
		(cAliasSF3)->(dbSkip())
	
		While (cAliasSF3)->F3_FILIAL+DTOS((cAliasSF3)->F3_ENTRADA)+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_CFO+;
			  (cAliasSF3)->F3_ESPECIE+(cAliasSF3)->F3_TIPOMOV == cChave 
			  
			aItens[Len(aItens)][_VALTOT] += FieldGet(FieldPos("F3_VALCONT"))
			
			For nI:=1 To Len(aImpostos)
				Do Case
					Case  aImpostos[nI][1] $ "PVI|PFI" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_PERCEP] += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "IV2|IV4" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IVAMAIOR]  += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "IVA|IV3" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IVAMENOR]  += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "COF" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_COFIS]  += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "FIS" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_FIS]    += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "INC" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_INAC]   += FieldGet(aImpostos[nI][4])
				EndCase							
			Next  
			(cAliasSF3)->(dbSkip())        
		Enddo	                

		aItens[Len(aItens)][_VALBASE] += aItens[Len(aItens)][_VALTOT] - (aItens[Len(aItens)][_PERCEP] + aItens[Len(aItens)][_IVAMAIOR] +;
										aItens[Len(aItens)][_IVAMENOR] + aItens[Len(aItens)][_COFIS])
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		//� Faz a somatoria dos totais a serem apresentados no relatorio        �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		If aItens[1][Len(aItens[1])] <> "D"
			nValTot		:= aItens[1][_VALTOT]
			nPercep		:= aItens[1][_PERCEP]
			nIVAMaior	:= aItens[1][_IVAMAIOR]
			nIVAMenor	:= aItens[1][_IVAMENOR]
			nCOFIS		:= aItens[1][_COFIS]
			nValBase	:= aItens[1][_VALBASE]
			nFIS		:= aItens[1][_FIS]
			nINAC		:= aItens[1][_INAC]
		Else                               
			nValTot		:= (aItens[1][_VALTOT] * -1)
			nPercep		:= (aItens[1][_PERCEP] * -1)
			nIVAMaior	:= (aItens[1][_IVAMAIOR] * -1)
			nIVAMenor	:= (aItens[1][_IVAMENOR] * -1)
			nCOFIS		:= (aItens[1][_COFIS] * -1)
			nValBase	:= (aItens[1][_VALBASE] * -1)
			nFIS		:= (aItens[1][_FIS] * -1)
			nINAC		:= (aItens[1][_INAC] * -1)
		EndIf	
	
    Else
    
		cNome := "********** "+ STR0023 +" **********"
		(cAliasSF3)->(dbSkip())

	Endif
	
	oReport:Section(2):PrintLine() 	

Enddo	

oReport:Section(2):Finish()	

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿘ATRUR2R3 � Autor � Paulo Eduardo      � Data �  31/10/03   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒escricao � Funcao para impressao de livros fiscais de vendas para o   볍�
굇�          � Uruguai.                                                   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � Localizacoes                                               볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

Function MatrUR2R3()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Local cDesc1       := STR0001 //"Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := STR0002 //"de Livros Fiscais de Compras e Vendas para o"
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := STR0003 //"Livro Fiscal de Vendas"
Local nLin         := 80
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "MATRUR2" 
Private nTipo      := 18
Private aReturn    := { STR0004, 1, STR0005, 2, 2, 1, "", 1} //"Zebrado"###"Administracao"
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "MATRUR2" 
Private cPerg      := "MTRUR2"
Private cString    := ""
Private cAliasSF3
Private aItens, aImpostos
Private nTotal    := 0, nTotPerc  := 0, nTotIVA23 := 0
Private nTotIVA14 := 0, nTotCOFIS := 0, nTotBase  := 0
Private nTotFIS   := 0, nTotINAC  := 0


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Monta a interface padrao com o usuario...                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
cString := "SF3"

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho,,.T.)

Pergunte(cPerg,.F.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿘onta aImpostos com as informacoes de cada imposto     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
DbSelectArea("SFB")
DbSetOrder(1)
DbGoTop()

aImpostos := {}
AAdd(aImpostos,{"IVA|IV3",""})                
AAdd(aImpostos,{"IV2|IV4",""})                
AAdd(aImpostos,{"COF",""})
AAdd(aImpostos,{"PVI",""})                
AAdd(aImpostos,{"PFI",""})
AAdd(aImpostos,{"FIS",""})                
AAdd(aImpostos,{"INC",""})                
While !SFB->(EOF()) 
	If aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]}) > 0
		aImpostos[aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]})][2] := SFB->FB_CPOLVRO
	EndIf	
	DbSkip()
EndDo                 
aSort(aImpostos,,,{|x,y| x[2] < y[2]})

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Monta os cabecalhos do relatorio                                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�                        
titulo := STR0006 +space(1)+ DTOC(mv_par01) +space(1)+ STR0007 +space(1)+ DTOC(mv_par02) //"Livro de Vendas de"###"a"
                                  
Cabec1 := Padr(STR0008,10," ") +space(3)+ Padr(STR0009,12," ") +space(3)+ Padr(STR0010,30," ") +space(3)+ PadL(STR0011,17," ") +space(3)+ PadL(STR0012,17," ") +space(3)+; //"Data"###"Documento"###"Cliente"###"Valor Total"###"Percepcion"
		PadL("IVA 23%",17," ") +space(3)+ PadL("IVA 14%",17," ") +space(3)+ PadL("COFIS",17," ") +space(3)+ PadL(STR0013,17," ") +space(3)+ PadL("FIS",17," ") +space(3)+ PadL("INAC",17," ") //"Valor Base"
	
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)		

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

RptStatus({|| MUr2Imprime(Cabec1,Cabec2,Titulo,nLin) },Titulo)								

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇�袴袴袴袴袴佶袴袴袴袴袴箇袴袴袴佶袴袴袴袴袴袴袴袴袴藁袴袴袴佶袴袴袴袴袴袴뺑�
굇튔un뇙o    쿘UR2IMPRIME� Autor � AP6 IDE            � Data �  31/10/03   볍�
굇勁袴袴袴袴曲袴袴袴袴袴菰袴袴袴賈袴袴袴袴袴袴袴袴袴袴姦袴袴賈袴袴袴袴袴袴攷굇
굇튒escri뇙o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS  볍�
굇�          � monta a janela com a regua de processamento.                볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴攷굇
굇튧so       � Programa principal                                          볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/

Static Function MUr2Imprime(Cabec1,Cabec2,Titulo,nLin)

Local nY := 1
Local cbcont:=0,cbtxt:=space(10)
Local cCond, cArqTrab, cOrdem, cChave
Local cCliLivro, cCliente
Local dDataEntr, dDataCanc
Local nValTot 	   :=0
Local nOrdSF3      := 1, nZ:= 1, nI:=1
Local cCGCDesc := Rtrim(RetTitle("A1_CGC"))
Local aCabec := {STR0014 +space(1)+ SM0->M0_NOMECOM +Padc("",130)+padL(STR0015+space(1)+STRZERO(m_pag,3,0),81),; //"Empresa:"###"Pagina:"
		STR0016 +space(1)+ Alltrim(SM0->M0_ENDENT)+" - "+ AllTrim(SM0->M0_CIDENT)+" - "+ AllTrim(SM0->M0_ESTENT)+; //"Endereco:"
		Padc(Titulo,130) + PadL(STR0008+": "+DTOC(dDataBase),111),; //"Data"
		cCGCDesc + ": " + Transform(SM0->M0_CGC,PesqPict("SA1","A1_CGC"))}

#IFDEF TOP
Local cQuery := ""

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿘onta query para selecao dos itens a serem mostrados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	cAliasSF3:="F3TMP"
	If Select(cAliasSF3)<>0
   		DbSelectArea(cAliasSF3)
   		DbCloseArea()
	Endif            
	
	cQuery := "SELECT * FROM "+RetSqlName("SF3")+" "+cAliasSF3+" "
    cQuery += "WHERE F3_FILIAL='"+ xFilial("SF3")+"'"+" AND F3_TIPOMOV = 'V' AND "
    cQuery += "F3_ENTRADA >= '"+Dtos(mv_par01)+"'"+" AND F3_ENTRADA <= '"+Dtos(mv_par02)+"'"
	cQuery +=" AND D_E_L_E_T_<>'*' ORDER BY " 
	cQuery +="F3_ENTRADA,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_CFO"
	cQuery :=ChangeQuery(cQuery)
	MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasSF3,.F.,.T.)},STR0017) //"Selecionando registros..."
	TCSetField(cAliasSF3,"F3_ENTRADA","D",8,0)
#ELSE
	
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿘onta IndRegua para selecao do itens�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	cAliasSF3:="SF3"
	DbSelectArea(cAliasSF3)
	DbGoTop()         

	nOrdSF3 := IndexOrd()

	cCond := cAliasSF3+"->F3_FILIAL == '"+ xFilial(cAliasSF3) + "' "
	cCond += ".and. "+cAliasSF3+"->F3_TIPOMOV =='V' .and."
	cCond += "Dtos("+cAliasSF3+"->F3_ENTRADA) >= '"+ Dtos(mv_par01) +"' .and. "
	cCond += "Dtos("+cAliasSF3+"->F3_ENTRADA) <= '"+ Dtos(mv_par02) +"'"
	cArqTrab := CriaTrab(Nil,.F.)
	cOrdem:=SF3->(IndexKey())
	IndRegua(cAliasSF3,cArqTrab,cOrdem,,cCond,STR0017) //"Selecionando registros..."
#ENDIF    

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿔nclui as posicoes dos campos de impostos no array aImpostos �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
For nZ:=1 To Len(aImpostos)
	AAdd(aImpostos[nZ],FieldPos("F3_BASIMP"+aImpostos[nZ][2]))
	AAdd(aImpostos[nZ],FieldPos("F3_VALIMP"+aImpostos[nZ][2]))
Next	          

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿘onta array contendo as informacoes do cabecalho             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
SetRegua(RecCount())

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿘onta array de com os itens do SF3  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

aItens := {}
While !(cAliasSF3)->(EOF())
	cChave := (cAliasSf3)->F3_FILIAL+DTOS((cAliasSF3)->F3_ENTRADA)+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+;
				(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_CFO+(cAliasSF3)->F3_ESPECIE+(cAliasSF3)->F3_TIPOMOV
	dDataEntr := (cAliasSF3)->F3_ENTRADA                                                   
	dDataCanc := (cAliasSF3)->F3_DTCANC
	cDocumento:= (cAliasSF3)->F3_NFISCAL
    If !Empty(dDataCanc)
    	AAdd(aItens,{dDataEntr,cDocumento,"********** "+ STR0020 +" **********"})
    Else
		cCliLivro := (cAliasSF3)->F3_CLIEFOR
		If Len(cCliLivro) > 0
			If (cAliasSf3)->F3_TIPO <> "B"
				SA1->(DbGoTop())
				If SA1->(MsSeek(xFilial()+cCliLivro))
					cCliente := TransForm(SubStr(SA1->A1_NOME,1,30),PesqPict("SA1","A1_NOME"))
				Else 
					cCliente := SubStr(cCliLivro,1,30)
				EndIf           
			Else	
				SA2->(DbGoTop())
				If SA2->(MsSeek(xFilial()+cCliLivro))
					cCliente := TransForm(SubStr(SA2->A2_NOME,1,30),PesqPict("SA2","A2_NOME"))
				Else 
					cCliente := SubStr(cCliLivro,1,30)
				EndIf
			EndIf	
		EndIf	
		nValTot  := (cAliasSF3)->F3_VALCONT
		AAdd(aItens,{dDataEntr,cDocumento,cCliente,nValTot,0,0,0,0,0,0,0,(cAliasSF3)->F3_TIPO})
		
		For nI:=1 To Len(aImpostos)
			Do Case
				Case  aImpostos[nI][1] $ "PVI|PFI" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_PERCEP]   += FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "IV2|IV4" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IVAMAIOR] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "IVA|IV3" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IVAMENOR] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "COF" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_COFIS]    := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "FIS" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_FIS]      := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "INC" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_INAC]     := FieldGet(aImpostos[nI][4])
			EndCase							
		Next  
	EndIf	
	
	(cAliasSF3)->(DbSkip())
	
	While (cAliasSF3)->F3_FILIAL+DTOS((cAliasSF3)->F3_ENTRADA)+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_CFO+;
		  (cAliasSF3)->F3_ESPECIE+(cAliasSF3)->F3_TIPOMOV == cChave 
		If Empty(dDataCanc)  
			aItens[Len(aItens)][_VALTOT] += FieldGet(FieldPos("F3_VALCONT"))
			For nI:=1 To Len(aImpostos)
				Do Case
					Case  aImpostos[nI][1] $ "PVI|PFI" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_PERCEP] += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "IV2|IV4" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IVAMAIOR]  += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "IVA|IV3" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IVAMENOR]  += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "COF" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_COFIS]  += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "FIS" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_FIS]    += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "INC" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_INAC]   += FieldGet(aImpostos[nI][4])
				EndCase							
			Next  
		EndIf
		(cAliasSF3)->(DbSkip())        
	EndDo	                
	If Empty(dDataCanc)
		aItens[Len(aItens)][_VALBASE] += aItens[Len(aItens)][_VALTOT] - (aItens[Len(aItens)][_PERCEP] + aItens[Len(aItens)][_IVAMAIOR] +;
									aItens[Len(aItens)][_IVAMENOR] + aItens[Len(aItens)][_COFIS])
	EndIf								
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Faz a somatoria dos totais a serem apresentados no relatorio        �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	If Len(aItens[Len(aItens)]) > 3
		If aItens[1][Len(aItens[1])] <> "D"
			nTotal    += aItens[1][_VALTOT]
			nTotPerc  += aItens[1][_PERCEP]
			nTotIVA23 += aItens[1][_IVAMAIOR]
			nTotIVA14 += aItens[1][_IVAMENOR]
			nTotCOFIS += aItens[1][_COFIS]
			nTotBase  += aItens[1][_VALBASE]
			nTotFIS   += aItens[1][_FIS]
			nTotINAC  += aItens[1][_INAC]
		Else                               
			nTotal    -= aItens[1][_VALTOT]
			nTotPerc  -= aItens[1][_PERCEP]
			nTotIVA23 -= aItens[1][_IVAMAIOR]
			nTotIVA14 -= aItens[1][_IVAMENOR]
			nTotCOFIS -= aItens[1][_COFIS]
			nTotBase  -= aItens[1][_VALBASE]
			nTotFIS   -= aItens[1][_FIS]
			nTotINAC  -= aItens[1][_INAC]
		EndIf	
	EndIf	
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Verifica o cancelamento pelo usuario...                             �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	
	If lAbortPrint
		@nLin,00 PSAY STR0018 //"*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Impressao do cabecalho do relatorio. . .                            �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	
	If nLin > 58 // Salto de P�gina. Neste caso o formulario tem 58 linhas...
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,aCabec)
		nLin ++
	Endif
	If Len(aItens[Len(aItens)]) > 3
		@nLin,00   PSAY Padr(aItens[nY][_DATA],10)
		@nLin,13   PSAY aItens[nY][_DOCTO]
		@nLin,28   PSAY aItens[nY][_CLIENTE]
		If aItens[1][Len(aItens[1])] <> "D"
			@nLin,61   PSAY Transform(aItens[nY][_VALTOT],PesqPict("SF3","F3_VALCONT"))
			@nLin,80   PSAY Transform(aItens[nY][_PERCEP],PesqPict("SF3","F3_VALIMP1"))
			@nLin,100  PSAY Transform(aItens[nY][_IVAMAIOR],PesqPict("SF3","F3_VALIMP1"))
			@nLin,120  PSAY Transform(aItens[nY][_IVAMENOR],PesqPict("SF3","F3_VALIMP1"))
			@nLin,140  PSAY Transform(aItens[nY][_COFIS],PesqPict("SF3","F3_VALIMP1"))
			@nLin,161  PSAY Transform(aItens[nY][_VALBASE],PesqPict("SF3","F3_VALCONT"))
			@nLin,180  PSAY Transform(aItens[nY][_FIS],PesqPict("SF3","F3_VALIMP1"))
			@nLin,200  PSAY Transform(aItens[nY][_INAC],PesqPict("SF3","F3_VALIMP1"))
		Else                                                                            
			@nLin,61   PSAY Transform(aItens[nY][_VALTOT]*-1,PesqPict("SF3","F3_VALCONT"))
			@nLin,80   PSAY Transform(aItens[nY][_PERCEP]*-1,PesqPict("SF3","F3_VALIMP1"))
			@nLin,100  PSAY Transform(aItens[nY][_IVAMAIOR]*-1,PesqPict("SF3","F3_VALIMP1"))
			@nLin,120  PSAY Transform(aItens[nY][_IVAMENOR]*-1,PesqPict("SF3","F3_VALIMP1"))
			@nLin,140  PSAY Transform(aItens[nY][_COFIS]*-1,PesqPict("SF3","F3_VALIMP1"))
			@nLin,161  PSAY Transform(aItens[nY][_VALBASE]*-1,PesqPict("SF3","F3_VALCONT"))
			@nLin,180  PSAY Transform(aItens[nY][_FIS]*-1,PesqPict("SF3","F3_VALIMP1"))
			@nLin,200  PSAY Transform(aItens[nY][_INAC]*-1,PesqPict("SF3","F3_VALIMP1"))
		EndIf	
	Else                                           
		@nLin,00   PSAY Padr(aItens[nY][_DATA],10)
		@nLin,13   PSAY aItens[nY][_DOCTO]
		@nLin,28   PSAY aItens[nY][_CLIENTE]
	EndIf	
	
	nLin := nLin + 1 // Avanca a linha de impressao
	aItens := {}
EndDo	

If nTotal <> 0
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Monta linha de totais do relatorio.                                 �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�                                    
	nLin := nLin + 2
	                 
	@nLin,00   PSAY STR0019                                        //"TOTAIS GERAIS"
	@nLin,61   PSAY Transform(nTotal,PesqPict("SF3","F3_VALCONT"))
	@nLin,80   PSAY Transform(nTotPerc,PesqPict("SF3","F3_VALIMP1"))
	@nLin,100  PSAY Transform(nTotIVA23,PesqPict("SF3","F3_VALIMP1"))
	@nLin,120  PSAY Transform(nTotIVA14,PesqPict("SF3","F3_VALIMP1"))
	@nLin,140  PSAY Transform(nTotCOFIS,PesqPict("SF3","F3_VALIMP1"))
	@nLin,161  PSAY Transform(nTotBase,PesqPict("SF3","F3_VALCONT"))
	@nLin,180  PSAY Transform(nTotFIS,PesqPict("SF3","F3_VALIMP1"))
	@nLin,200  PSAY Transform(nTotINAC,PesqPict("SF3","F3_VALIMP1"))	
		
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Monta rodape da pagina                                              �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	roda(cbcont,cbtxt,"G")
EndIf                     

#IFDEF TOP                                              
	DbSelectArea(cAliasSF3)
	DbCloseArea()
#ELSE	
	RetIndex(cAliasSF3)
	(cAliasSF3)->(DbSetOrder(nOrdSF3))
	cArqTrab+=OrdBagExt()
	File(cArqTrab)
	Ferase(cArqTrab)
#ENDIF	
	
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Finaliza a execucao do relatorio...                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	
SET DEVICE TO SCREEN
	
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Se impressao em disco, chama o gerenciador de impressao...          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
	
MS_FLUSH()
Fim := .F.
	
Return

