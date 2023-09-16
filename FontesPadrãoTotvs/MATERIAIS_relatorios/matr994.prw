#INCLUDE "PROTHEUS.CH"
#include "MATR994.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MATR994   � Autor �Sergio S. Fuzinaka     � Data � 05.06.06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Impressao da Tabela de Ganancias/Fondo Cooperativo          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Localizacoes                                                ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function Matr994()

Local oReport
Local cPerg   := "GAF020"

If TRepInUse()
	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	Matr994R3()
EndIf

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef  � Autor �Sergio S. Fuzinaka     � Data � 05.06.06 ���
��������������������������������������������������������������������������Ĵ��
���Descricao �A funcao estatica ReportDef devera ser criada para todos os  ���
���          �relatorios que poderao ser agendados pelo usuario.           ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                   ���
��������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                          ���
��������������������������������������������������������������������������Ĵ��
���          �               �                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport
Local oSecao1
Local oSecao2
Local cReport	:= "GANF020"
Local cPerg		:= "GAF020"
Local cTitulo	:= OemToAnsi(STR0047)	//"Tabela de Lucros/Fundo Cooperativo"
Local cDesc		:= OemToAnsi(STR0048)	//"Este programa vai imprimir os Impostos Nacionais, Valores de Lucros/Fundo Cooperativo, Quadro No. 4."

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New(cReport,cTitulo,cPerg,{|oReport| ReportPrint(oReport)},cDesc)
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)
Pergunte(oReport:uParam,.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oSecao1:=TRSection():New(oReport,STR0071,{"SFF"},{STR0073},/*Campos do SX3*/,/*Campos do SIX*/)
oSecao1:SetEditCell(.F.) 
TRCell():New(oSecao1,"FF_ITEM","SFF","",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"FF_CONCEPT","SFF",Upper(RetTitle("FF_CONCEPT")),/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"ALQINSC","",Upper(RetTitle("FF_ALQINSC")),"",15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"ALQNOIN","",Upper(RetTitle("FF_ALQNOIN")),/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"FF_IMPORTE","SFF",OemToAnsi(STR0049),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSecao2:=TRSection():New(oReport,STR0072,{"SFF"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSecao2:SetPageBreak()
oSecao2:SetEditCell(.F.)
TRCell():New(oSecao2,"FF_FXDE","SFF",OemToAnsi(STR0056),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"FXATE","","a $",/*Picture*/,18,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"FF_RETENC","SFF","$",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"FF_PERC","SFF",OemToAnsi(STR0057),/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"FF_EXCEDE","SFF",OemToAnsi(STR0058),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint� Autor �Sergio S. Fuzinaka     � Data �04.05.2006���
��������������������������������������������������������������������������Ĵ��
���Descricao �A funcao estatica ReportDef devera ser criada para todos os  ���
���          �relatorios que poderao ser agendados pelo usuario.           ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                            ���
���          �                                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)

Local cCondicao	:= ""
Local cAliasSFF	:= "SFF"
Local nLastRec	:= 0
Local cItem		:= 0
Local cConcept	:= ""
Local cAlqInsc	:= ""
Local cAlqNoIn	:= ""
Local nImporte	:= 0
Local nLinha	:= 0
Local nBegin	:= 0
Local cTexto	:= ""
Local cSubTit	:= ""
Local cAno		:= Str(Year(dDataBase),4)
Local nFxDe		:= 0
Local cFxAte	:= ""
Local nRetenc	:= 0
Local nPerc		:= 0
Local nExcede	:= 0

Private cMesExt	:= ""
MesExt()

//�������������������������������������������������������Ŀ
//�Secao 1                                                �
//���������������������������������������������������������
oReport:Section(1):Cell("FF_ITEM"):SetBlock({|| cItem})
oReport:Section(1):Cell("FF_CONCEPT"):SetBlock({|| cConcept})
oReport:Section(1):Cell("ALQINSC"):SetBlock({|| cAlqInsc})
oReport:Section(1):Cell("ALQNOIN"):SetBlock({|| cAlqNoIn})
oReport:Section(1):Cell("FF_IMPORTE"):SetBlock({|| nImporte})

//�������������������������������������������������������Ŀ
//�Secao 2                                                �
//���������������������������������������������������������
oReport:Section(2):Cell("FF_FXDE"):SetBlock({|| nFxDe})
oReport:Section(2):Cell("FXATE"):SetBlock({|| cFxAte})
oReport:Section(2):Cell("FF_RETENC"):SetBlock({|| nRetenc})
oReport:Section(2):Cell("FF_PERC"):SetBlock({|| nPerc})
oReport:Section(2):Cell("FF_EXCEDE"):SetBlock({|| nExcede})

//������������������������������������������������������������������������Ŀ
//�Filtragem do Relatorio - LUCROS                                         �
//��������������������������������������������������������������������������
dbSelectArea("SFF")
dbSetOrder(1)

#IFDEF TOP

	MakeSqlExpr(oReport:uParam)

	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	
	
	cAliasSFF := GetNextAlias()

	BeginSql Alias cAliasSFF
		SELECT FF_ITEM,FF_CONCEPT,FF_ALQINSC,FF_ALQNOIN,FF_IMPORTE,FF_ESCALA
		FROM %table:SFF% SFF
		WHERE FF_FILIAL = %xFilial:SFF%		AND 
			FF_NUM >= %Exp:mv_par01%		AND 
			FF_NUM <= %Exp:mv_par02%		AND 
			FF_ITEM < '12'					AND 
			FF_MESREF = %Exp:mv_par03%		AND 
			SFF.%NotDel% 
		ORDER BY %Order:SFF%
	EndSql 

	oReport:Section(1):EndQuery()
		
#ELSE

	MakeAdvplExpr(oReport:uParam)

	cCondicao := "FF_FILIAL == '"+xFilial("SFF")+"' .And. "
	cCondicao += "FF_NUM >= '"+mv_par01+"' .And. "
	cCondicao += "FF_NUM <= '"+mv_par02+"' .And. "
	cCondicao += "FF_ITEM < '12' .And. "	
	cCondicao += "FF_MESREF == '"+mv_par03+"'"

	oReport:Section(1):SetFilter(cCondicao,IndexKey())
	
#ENDIF		

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
oReport:PrintText(OemToAnsi(STR0051))
oReport:ThinLine()
oReport:PrintText(OemToAnsi(STR0052))
oReport:ThinLine()
oReport:PrintText(OemToAnsi(STR0053))
cSubTit := OemToAnsi(STR0054)+AllTrim(cMesExt)+",  "+cAno+OemToAnsi(STR0055)
oReport:PrintText(cSubTit)
oReport:ThinLine()

dbSelectArea((cAliasSFF))
dbGoTop()
nLastRec := (cAliasSFF)->(LastRec())
oReport:SetMeter(nLastRec)
oReport:Section(1):Init()

While !Eof()
	
	oReport:IncMeter()
	
	oReport:Section(1):Cell("FF_ITEM"):Show()
	oReport:Section(1):Cell("ALQINSC"):Show()
	oReport:Section(1):Cell("ALQNOIN"):Show()
	oReport:Section(1):Cell("FF_IMPORTE"):Show()

	//+--------------------------------------------------------------+
	//� Imprimi detalles.                                            �
	//+--------------------------------------------------------------+
	cItem		:= (cAliasSFF)->FF_ITEM
	cTexto 		:= (cAliasSFF)->FF_CONCEPT
	nLinha		:= MLCount(cTexto,30)
	cConcept	:= MemoLine(cTexto,30,1)

	If (cAliasSFF)->FF_ESCALA == "I"
		cAlqInsc	:= OemToAnsi(STR0050)  // "S./ESCALA(1)"
	Else
		cAlqInsc	:= Transform((cAliasSFF)->FF_ALQINSC,"@E 99,99")
	EndIf

	If (cAliasSFF)->FF_ESCALA == "N"
		cAlqNoIn	:= OemToAnsi(STR0050)  // "S./ESCALA(1)"
	Else
		cAlqNoIn	:= Transform((cAliasSFF)->FF_ALQNOIN,"@E 99,99")
	EndIf

	nImporte	:= (cAliasSFF)->FF_IMPORTE
	
	oReport:Section(1):PrintLine() 		
		
	//+--------------------------------------------------------------+
	//� Imprimi descricion del concepto n lineas.                    �
	//+--------------------------------------------------------------+
	For nBegin := 2 To nLinha
		cTexto1 := Memoline(cTexto,30,nBegin)
		If !Empty(cTexto1)
			cConcept := Subs(cTexto1,1,30)
			oReport:Section(1):Cell("FF_ITEM"):Hide()
			oReport:Section(1):Cell("ALQINSC"):Hide()
			oReport:Section(1):Cell("ALQNOIN"):Hide()
			oReport:Section(1):Cell("FF_IMPORTE"):Hide()
			oReport:Section(1):PrintLine() 		
		EndIf
	Next nBegin
	
	dbSelectArea((cAliasSFF))
	dbSkip()
	
Enddo 
oReport:Section(1):Finish()	

//������������������������������������������������������������������������Ŀ
//�Filtragem do Relatorio - ESCALA APLICABLE(1)                            �
//��������������������������������������������������������������������������
dbSelectArea("SFF")
dbSetOrder(1)

#IFDEF TOP

	MakeSqlExpr(oReport:uParam)

	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(2):BeginQuery()	
	
	cAliasSFF := GetNextAlias()

	BeginSql Alias cAliasSFF
		SELECT FF_FXDE,FF_FXATE,FF_RETENC,FF_PERC,FF_EXCEDE
		FROM %table:SFF% SFF
		WHERE FF_FILIAL = %xFilial:SFF%		AND 
			FF_NUM >= %Exp:mv_par01%		AND 
			FF_NUM <= %Exp:mv_par02%		AND 
			FF_ITEM > '12'					AND 
			SFF.%NotDel% 
		ORDER BY %Order:SFF%
	EndSql 

	oReport:Section(2):EndQuery()
		
#ELSE

	MakeAdvplExpr(oReport:uParam)

	cCondicao := "FF_FILIAL == '"+xFilial("SFF")+"' .And. "
	cCondicao += "FF_NUM >= '"+mv_par01+"' .And. "
	cCondicao += "FF_NUM <= '"+mv_par02+"' .And. "
	cCondicao += "FF_ITEM > '12'"	

	oReport:Section(2):SetFilter(cCondicao,IndexKey())
	
#ENDIF		

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
dbSelectArea((cAliasSFF))
dbGoTop()
nLastRec := (cAliasSFF)->(LastRec())

oReport:SetMeter(nLastRec)
oReport:Section(2):Init()

oReport:PrintText(OemToAnsi(STR0059))
oReport:ThinLine()
oReport:PrintText(OemToAnsi(STR0061))
oReport:ThinLine()
	
While !Eof()
	
	oReport:IncMeter()
	
	//+--------------------------------------------------------------+
	//� Imprime los detalles de la Escala Aplicable.                 �
	//+--------------------------------------------------------------+
	nFxDe	:= (cAliasSFF)->FF_FXDE

	If (cAliasSFF)->FF_FXATE >= 999999999.99
		cFxAte	:= OemToAnsi(STR0060)  // " en adelante "
	Else
		cFxAte	:= Transform((cAliasSFF)->FF_FXATE,"@E 999,999,999.99")
	EndIf

	nRetenc	:= (cAliasSFF)->FF_RETENC
	nPerc	:= (cAliasSFF)->FF_PERC
	nExcede	:= (cAliasSFF)->FF_EXCEDE

	oReport:Section(2):PrintLine()

	dbSelectArea((cAliasSFF))
	dbSkip()
	
Enddo 
oReport:ThinLine()
oReport:PrintText(OemToAnsi(STR0062))  // " (1) Escala aplicable una vez deducido el minimo no sujeto a retencion        "
oReport:PrintText(OemToAnsi(STR0063))  // " (2) Si bien la RG 2892 no estabelece especificamente ningun minimo no sujeto "
oReport:PrintText(OemToAnsi(STR0064))  // "     a retencion para los conceptos incluidos en esta columna, entendemos que "
oReport:PrintText(OemToAnsi(STR0065))  // "     corresponde la aplicacion del minimo estabelecido para locacion de servi-"
oReport:PrintText(OemToAnsi(STR0066))  // "     cios                                                                     "
oReport:PrintText(OemToAnsi(STR0067))  // " (3) Si bien la RG 2892 no estabelece especificamente ningun minimo no sujeto "
oReport:PrintText(OemToAnsi(STR0068))  // "     a retencion para los conceptos incluidos, entendemos que cuando el precio"
oReport:PrintText(OemToAnsi(STR0069))  // "     se abone en forma de regalia sera de aplicacion el minimo correspondente "
oReport:PrintText(OemToAnsi(STR0070))  // "     a este ultimo concepto.                                                  "

oReport:Section(2):Finish()	

Return

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
��� FUNCAO   � MATR994R3� AUTOR � Leonardo Ruben        � DATA � 17.04.00   ���
���������������������������������������������������������������������������Ĵ��
��� DESCRICAO� Impressao da tabela de Ganancias/Fondo cooperativo           ���
���������������������������������������������������������������������������Ĵ��
��� USO      � Generico - Localizacoes                                      ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                     ���
���������������������������������������������������������������������������Ĵ��
���              �        �      �                                          ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Function MatR994R3()        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CCBTXT,NCONTREG,CBCONT,NORDEM,ALFA,Z")
SetPrvt("M,TAMANHO,LIMITE,AORD,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,ARETURN,NOMEPROG,CPERG,NLASTKEY")
SetPrvt("NLIN,WNREL,LCONTINUA,M_PAG,NTAMRM,CSTRING")
SetPrvt("LI,CABEC1,CABEC2,CCONCEPT,NLINHA,NBEGIN")
SetPrvt("CCONCEITO,CANO,CMESEXT,NLININI,NOPC,CCOR")
SetPrvt("_SALIAS,AREGS,I,J,AMES,NI")

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o	 � Ganf020  � Autor � Jose Lucas				  � Data � 04.09.98 ���
��+----------+------------------------------------------------------------���
���Descri��o � Impressao da Tabela de Ganancias/Fondo Cooperativ.			  ���
��+----------+------------------------------------------------------------���
���Uso		 � RemitoC																	  ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//+--------------------------------------------------------------+
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Da Tabela                            �
//� mv_par02             // Ate Tabela		                       �
//� mv_par03             // M�s de Ref�rencia ?                  �
//+--------------------------------------------------------------+
cCbTxt  := OemToAnsi(STR0001) // "Tabla de Ganancias/Fondo Cooperativo"
nContReg:= 0
CbCont  := ""
nOrdem  := 0
Alfa    := 0
Z:=0
M:=0
tamanho := "P"
limite  := 80
aOrd    := {}
titulo  := PADC(OemToAnsi(STR0002),74) //"Impresion de la Tabla de Ganancias/Fondo Cooperativo"
cDesc1  := PADC(OemToAnsi(STR0003),74) //"Este programa imprimira los Impuestos Nacionales,   "
cDesc2  := PADC(OemToAnsi(STR0004),74) //"valores de Ganancias/Fondo Cooperativo, Cuadro No. 4"
cDesc3  := ""
aReturn := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1,"",1 } //"Especial","Administracion"
nomeprog:= "GANF020"
cPerg   := "GAF020"
nLastKey:= 0
nLin    := 0
wnrel   := "GANF020"
lContinua := .T.
m_pag   := 0

//+-----------------------------------------------------------+
//� Tamanho do Formulario do Tabla de Ganancias.              �
//+-----------------------------------------------------------+
nTamRm:=72

Pergunte(cPerg,.F.)

cString:="SFF"

//+-----------------------------------------------------------+
//� Envia controle para a funcao SETPRINT                     �
//+-----------------------------------------------------------+
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//+--------------------------------------------------------------+
//� Verifica Posicao do Formulario na Impressora                 �
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

VerImp()

//+--------------------------------------------------------------+
//� Inicio de la Impresi�n de la Tabla                           �
//+--------------------------------------------------------------+
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> 	RptStatus({|| Execute(RptDetail)})
RptStatus({|| RptDetail()})
Return

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> 	Function RptDetail
Static Function RptDetail()
Local nBegin:=0

dbSelectArea("SFF")
dbSetOrder(1)
dbSeek(xFilial("SFF")+mv_par01+mv_par03,.T.)

li := 80
nLin := 80

titulo := OemToAnsi(STR0001)  // "Tabla de Ganancias/Fondo Cooperativo"
cabec1 := "."
cabec2 := ""

//+-----------------------------------------------------------+
//� Impresion del conceptos                                   �
//+-----------------------------------------------------------+
SetRegua(RecCount())
While !Eof() .And. FF_FILIAL==xFilial("SFF");
	.And. FF_NUM <= mv_par02
	
	IF lAbortPrint
		@ 00,01 PSAY OemToAnsi(STR0007)  // "** CANCELADO POR EL OPERADOR **"
		lContinua := .F.
		Exit
	Endif
	
	If FF_MESREF != mv_par03
		dbSkip()
		Loop
	EndIf
	
	//+--------------------------------------------------------------+
	//� Imprime solamente los conceptos.                              �
	//+--------------------------------------------------------------+
	If Val(FF_ITEM) > 12
		Exit
	EndIf
	
	If nLin > 62
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		R020Cab()
	EndIf
	
	IncRegua()
	
	//+--------------------------------------------------------------+
	//� Imprimi detalles.                                            �
	//+--------------------------------------------------------------+
	cConcept := FF_CONCEPT
	nLinha   := MLCount(cConcept,30)
	@ nLin,001 PSAY FF_ITEM
	@ nLin,004 PSAY MemoLine(cConcept,30,1)
	@ nLin,036 PSAY "|"
	If FF_ESCALA == "I"
		@ nLin,037 PSAY OemToAnsi(STR0008)  // "S./ESCALA(1)"
	Else
		@ nLin,041 PSAY FF_ALQINSC		Picture "@E 99,99"
	EndIf
	@ nLin,049 PSAY "|"
	If FF_ESCALA == "N"
		@ nLin,050 PSAY OemToAnsi(STR0008)  // "S./ESCALA(1)"
	Else
		@ nLin,054 PSAY FF_ALQNOIN		Picture "@E 99,99"
	EndIf
	@ nLin,062 PSAY "|"
	@ nLin,064 PSAY FF_IMPORTE  	Picture "@E 999,999,999.99"
	nLin := nLin + 1
	
	//+--------------------------------------------------------------+
	//� Imprimi descricion del concepto n lineas.                    �
	//+--------------------------------------------------------------+
	For nBegin := 2 To nLinha
		cConceito := Memoline(cConcept,30,nBegin)
		If ! Empty(cConceito)
			@ nLin,004 PSAY Subs(cConceito,1,30)
			@ nLin,036 PSAY "|"
			@ nLin,049 PSAY "|"
			@ nLin,062 PSAY "|"
			nLin := nLin + 1
		EndIf
	Next nBegin
	
	If Val(FF_ITEM) > 12
		Exit
	Endif
	dbSkip()
	
End

If nLin > 62
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	R020Cab()
EndIf
@ nLin,000 PSAY "--------------------------------------------------------------------------------"
nLin := 80

If nLin > 62
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
EndIf
//+--------------------------------------------------------------+
//� Escala Aplicable (1).                                        �
//+--------------------------------------------------------------+
dbSelectArea("SFF")
dbSetOrder(1)
If dbSeek(xFilial("SFF")+mv_par01+mv_par03+"13",.T.)
	
	@ 08,000 PSAY "--------------------------------------------------------------------------------"
//	@ 09,000 PSAY "                     E S C A L A     A P L I C A B L E (1)                      "
	@ 09,000 PSAY OemToAnsi(STR0009)
	@ 10,000 PSAY "--------------------------------------------------------------------------------"
//	@ 11,000 PSAY "              IMPORTES            |                 RETENDRAN                   "
	@ 11,000 PSAY OemToAnsi(STR0010)
	@ 12,000 PSAY "----------------------------------|---------------------------------------------"
//	@ 13,000 PSAY "    De mas de $  |        a $     |       $        | Mas el % |  Execedente  $  "
	@ 13,000 PSAY OemToAnsi(STR0011)
	@ 14,000 PSAY "-----------------|----------------|----------------|----------|-----------------"
	//               999,999,999.99   999,999,999.99   999,999,999.99     999.99   999,999,999.99
	//             0         1         2         3         4         5         6        7          8
	//             012345678901234567890123456789012345678901234567890123456789012345678901234567890
	nLin := 15
	While !Eof() .And. FF_FILIAL==xFilial("SFF");
		.And. FF_NUM <= mv_par02
		
		IncRegua()
		
		//+--------------------------------------------------------------+
		//� Imprime los detalles de la Escala Aplicable.                 �
		//+--------------------------------------------------------------+
		@ nLin,002 PSAY FF_FXDE			Picture "@E 999,999,999.99"
		@ nLin,017 PSAY "|"
		If FF_FXATE >= 999999999.99
			@ nlin,019 PSAY OemToAnsi(STR0012)  // " en adelante "
		Else
			@ nLin,019 PSAY FF_FXATE	Picture "@E 999,999,999.99"
		EndIf
		@ nLin,034 PSAY "|"
		@ nLin,036 PSAY FF_RETENC		Picture "@E 999,999,999.99"
		@ nLin,051 PSAY "|"
		@ nLin,055 PSAY FF_PERC			Picture "@E 999.99"
		@ nLin,062 PSAY "|"
		@ nLin,064 PSAY FF_EXCEDE  	Picture "@E 999,999,999.99"
		nLin := nLin + 1
		dbSkip()
	End
EndIf
@ nLin,000 PSAY "--------------------------------------------------------------------------------"
nLin := nLin + 2

@ nLin+0,000 PSAY OemToAnsi(STR0013)  // " (1) Escala aplicable una vez deducido el minimo no sujeto a retencion        "
@ nLin+1,000 PSAY OemToAnsi(STR0014)  // " (2) Si bien la RG 2892 no estabelece especificamente ningun minimo no sujeto "
@ nLin+2,000 PSAY OemToAnsi(STR0015)  // "     a retencion para los conceptos incluidos en esta columna, entendemos que "
@ nLin+3,000 PSAY OemToAnsi(STR0016)  // "     corresponde la aplicacion del minimo estabelecido para locacion de servi-"
@ nLin+4,000 PSAY OemToAnsi(STR0017)  // "     cios                                                                     "
@ nLin+5,000 PSAY OemToAnsi(STR0018)  // " (3) Si bien la RG 2892 no estabelece especificamente ningun minimo no sujeto "
@ nLin+6,000 PSAY OemToAnsi(STR0019)  // "     a retencion para los conceptos incluidos, entendemos que cuando el precio"
@ nLin+7,000 PSAY OemToAnsi(STR0020)  // "     se abone en forma de regalia sera de aplicacion el minimo correspondente "
@ nLin+8,000 PSAY OemToAnsi(STR0021)  // "     a este ultimo concepto.                                                  "

If nLin != 80
	roda(nContReg,cCbtxt,"G")
EndIf

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return

/*
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Funcion   � R020Cab  � Autor � Jose Lucas            � Fecha� 18.08.98 ���
��+----------+------------------------------------------------------------���
���Descripcion Encabezado de la Tabla de Ganancias/Fondo Cooperativo      ���
��+----------+------------------------------------------------------------���
���Uso       � GANF020                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020Cab
Static Function R020Cab()

cAno    := Str(Year(dDataBase),4)
cMesExt := Space(09)
MesExt()

//             0         1         2         3         4         5         6         7         8
//             012345678901234567890123456789012345678901234567890123456789012345678901234567890
@ 08,000 PSAY "--------------------------------------------------------------------------------"
//            "IMPUESTOS NACIONALES                                 GANANCIAS/FONDO COOPERATIVO"
@ 09,000 PSAY OemToAnsi(STR0022)
@ 10,000 PSAY "--------------------------------------------------------------------------------"
@ 11,000 PSAY "                    ---------------------------------------                     "
//            "                               G A N A N C I A S                                "
@ 12,000 PSAY OemToAnsi(STR0023)
@ 13,000 PSAY "                    ---------------------------------------                     "
@ 14,000 PSAY "--------------------------------------------------------------------------------"
//            "                               C U A D R O No. 04                               "
@ 15,000 PSAY OemToAnsi(STR0024)
//            "              RETENCIONES GENERALES. "+AllTrim(cMesExt)+",  "+cAno+"  Y SS."
@ 16,000 PSAY OemToAnsi(STR0025)+AllTrim(cMesExt)+",  "+cAno+OemToAnsi(STR0026)
@ 17,000 PSAY "--------------------------------------------------------------------------------"
//            "                                    |        ALICUOTAS        |    IMPORTE NO   "
//            "              CONCEPTO              |-------------------------|      SUJETO     "
//            "                                    | INSCRIPTO% | NO INSCR.% |    A RETENCION  "
@ 18,000 PSAY OemToAnsi(STR0027)
@ 19,000 PSAY OemToAnsi(STR0028)
@ 20,000 PSAY OemToAnsi(STR0029)
@ 21,000 PSAY "------------------------------------|------------|------------|-----------------"
//              XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXX   |    999.99  |    999.99  | 999,999,999.99
//                                                  S./ESCALA(1) S./ESCALA(1)
//             0         1         2         3         4         5         6         7         8
//             012345678901234567890123456789012345678901234567890123456789012345678901234567890
nLin := 22
Return

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � VERIMP   � Autor �   Marcos Simidu       � Data � 20/12/95 ���
��+----------+------------------------------------------------------------���
���Descri��o � Verifica posicionamento de papel na Impressora             ���
��+----------+------------------------------------------------------------���
���Uso       � Nfiscal                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//+---------------------+
//� Inicio da Funcao    �
//+---------------------+
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function VerImp
Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==2
	
	nOpc       := 1
	While .T.
		
		SetPrc(0,0)
		dbCommitAll()
		
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."
		IF MsgYesNo(OemToAnsi(STR0030))  //"�El formulario est� colocado? "
			nOpc := 1
		ElseIF MsgYesNo(OemToAnsi(STR0031))  //"�Tenta Nuevamente? "
			nOpc := 2
		Else
			nOpc := 3
		Endif
		
		Do Case
			Case nOpc==1
				lContinua:=.T.
				Exit
			Case nOpc==2
				Loop
			Case nOpc==3
				lContinua:=.F.
				Return
		EndCase
	End
Endif
Return

/*
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � MesExt   � Autor � Jos� Lucas            � Data � 23/06/98 ���
��+----------+------------------------------------------------------------���
���Descri��o � Retornar o Mes por extenso.                                ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function MesExt
Static Function MesExt()
Local nI:=0

aMes:={}
AADD(aMes,OemToAnsi(STR0035))  //"ENERO    "
AADD(aMes,OemToAnsi(STR0036))  //"FEBRERO  "
AADD(aMes,OemToAnsi(STR0037))  //"MARZO    "
AADD(aMes,OemToAnsi(STR0038))  //"ABRIL    "
AADD(aMes,OemToAnsi(STR0039))  //"MAYO     "
AADD(aMes,OemToAnsi(STR0040))  //"JUNIO    "
AADD(aMes,OemToAnsi(STR0041))  //"JULIO    "
AADD(aMes,OemToAnsi(STR0042))  //"AGOSTO   "
AADD(aMes,OemToAnsi(STR0043))  //"SETIEMBRE"
AADD(aMes,OemToAnsi(STR0044))  //"OCTUBRE  "
AADD(aMes,OemToAnsi(STR0045))  //"NOVIEMBRE"
AADD(aMes,OemToAnsi(STR0046))  //"DICIEMBRE"
For nI := 1 To 12
	If nI == Val(Subs(mv_par03,1,2))
		cMesExt := aMes[nI]
		Exit
	EndIf
Next nI
Return
 