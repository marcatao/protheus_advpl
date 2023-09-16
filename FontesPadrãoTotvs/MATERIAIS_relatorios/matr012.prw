#INCLUDE "MATR012.CH"
#Include "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR012  � Autor � Marco Bianchi         � Data � 04/06/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Correlacao                                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR012()                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MATR012()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	MATR012R3()	
EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Marco Bianchi         � Data �04/06/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport	:= Nil
Local nSaldo 	:= 0
Local cAliasSD9 := GetNextAlias()

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
oReport := TReport():New("MATR012",STR0001,"MTR012", {|oReport| ReportPrint(oReport,cAliasSD9)},STR0002 + " " + STR0003)	// "Relatorio de Correlacao"###"Este relatorio ir� imprimir o Relatorio de Correla-"###"��es em ordem cronol�gica de acordo com o NSU.     "
oReport:SetTotalInLine(.F.)
oReport:SetPortrait() 
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
oNSU := TRSection():New(oReport,STR0001,{"SD9","SF2"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oNSU:SetTotalInLine(.F.)

TRCell():New(oNSU,"D9_NSU"		,cAliasSD9,/*Titulo*/ ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,SerieNfId("SD9",3,"D9_SERIE")	,cAliasSD9,SerieNfId("SD9",7,"D9_SERIE") ,/*Picture*/,SerieNfId("SD9",6,"D9_SERIE"),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"D9_DOC"		,cAliasSD9,/*Titulo*/ ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"D9_DTUSO"	,cAliasSD9,/*Titulo*/ ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"D9_HORA"		,cAliasSD9,/*Titulo*/ ,"@R 99:99" ,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"D9_MOTIVO"	,cAliasSD9,/*Titulo*/ ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNSU,"F2_VALBRUT" 	,"SF2"    ,STR0004    ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	// "Vr.Bruto (Saida)"
TRCell():New(oNSU,"F1_VALBRUT" 	,"SF1"    ,STR0005    ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	// "Vr.Bruto (Entrada)"

oProduto := TRSection():New(oNSU,STR0001,{"SD2","SB1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oProduto:SetTotalInLine(.F.)
TRCell():New(oProduto,"B1_COD"		,"SB1"    ,/*Titulo*/ ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oProduto,"B1_DESC"		,"SB1"    ,/*Titulo*/ ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oProduto,"NSALDO" 		,/*Alias*/,STR0006    ,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| nSaldo })	// "Saldo R$"

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Marco Bianchi          � Data �04/05/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasSD9)

Local cAlias   	:= "SF2"
Local bEval
Local aSalAlmox	:= {}
Local lPrint   	:= .F.
Local cNomArq  	:= ""
Local lGrpCNPJ	:= MaIsNumCgc() // Verifica a utilizacao da numeracao por Agrupamento por CNPJ
Local aFilCGC	:= {"",""}
Local cFilCGC	:= ""
Local cSelect 	:= ""

oReport:Section(1):Section(1):Cell("NSALDO" ):SetBlock({|| nSaldo })	
                 
//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SD9")

cSelect := "%D9_NSU,"
cSelect += Iif(SerieNfId("SD9",3,"D9_SERIE")<>"D9_SERIE",SerieNfId("SD9",3,"D9_SERIE")+","," ")
cSelect += "D9_SERIE,D9_DOC,D9_DTUSO,D9_HORA,D9_MOTIVO%"

If lGrpCNPJ
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1 utilizando Agrupamento por CNPJ
	//��������������������������������������������������������������������������
	cFilCGC := SM0->M0_CGC

	oReport:Section(1):BeginQuery()
	BeginSql Alias cAliasSD9
	SELECT %Exp:cSelect%
		FROM %table:SD9% SD9
		WHERE SD9.D9_FILIAL = %xFilial:SD9%
			AND SD9.D9_NSU >= %Exp:mv_par01%
			AND SD9.D9_NSU <= %Exp:mv_par02%
			AND	SD9.D9_DTUSO >= %Exp:Dtos(mv_par03)%
			AND SD9.D9_DTUSO <= %Exp:Dtos(mv_par04)%
			AND SD9.D9_CNPJ = %Exp:cFilCGC%
			AND SD9.%notdel%

	ORDER BY SD9.D9_FILIAL,SD9.D9_NSU,SD9.D9_SERIE,SD9.D9_DOC
	EndSql

Else

	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1
	//��������������������������������������������������������������������������

	oReport:Section(1):BeginQuery()
	BeginSql Alias cAliasSD9
	SELECT %Exp:cSelect%
		FROM %table:SD9% SD9
		WHERE SD9.D9_FILIAL = %xFilial:SD9%
			AND SD9.D9_NSU >= %Exp:mv_par01%
			AND SD9.D9_NSU <= %Exp:mv_par02%
			AND	SD9.D9_DTUSO >= %Exp:Dtos(mv_par03)%
			AND SD9.D9_DTUSO <= %Exp:Dtos(mv_par04)%
			AND SD9.%notdel%

	ORDER BY SD9.D9_FILIAL,SD9.D9_NSU,SD9.D9_SERIE,SD9.D9_DOC
	EndSql

Endif



//������������������������������������������������������������������������Ŀ
//�Metodo EndQuery ( Classe TRSection )                                    �
//�                                                                        �
//�Prepara o relat�rio para executar o Embedded SQL.                       �
//�                                                                        �
//�ExpA1 : Array com os parametros do tipo Range                           �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
oReport:SetMeter((cAliasSD9)->(LastRec()))
oReport:Section(1):Init()

While !oReport:Cancel() .And. !(cAliasSD9)->(Eof())

	//������������������������������������������������������������������������Ŀ
	//�Verifica se a nota e saida ou entrada                                   �
	//��������������������������������������������������������������������������
	cAlias := ""
	SF2->(dbSetOrder(1))                   
	If SF2->(dbSeek(xFilial("SF2")+(cAliasSD9)->D9_DOC+(cAliasSD9)->D9_SERIE))
		cAlias := "SF2"
		oReport:Section(1):Cell("F2_VALBRUT"):Show()
		oReport:Section(1):Cell("F1_VALBRUT"):Hide()
		SD2->(dbSetOrder(3))
		SD2->(dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)) 
		bEval := {||  xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ==  xFilial("SD2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA  }
	Else
		SF1->(dbSetOrder(1))
		If SF1->(dbSeek(xFilial("SF1")+(cAliasSD9)->D9_DOC+(cAliasSD9)->D9_SERIE))
			cAlias := "SF1"
			oReport:Section(1):Cell("F1_VALBRUT"):Show()
			oReport:Section(1):Cell("F2_VALBRUT"):Hide()
			SD1->(dbSetOrder(1))
			SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			bEval := {||  xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ==  xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA  }		
		EndIf
	EndIf
	oReport:Section(1):PrintLine()
	
	//������������������������������������������������������������������������Ŀ
	//�Verifica se a nota deixou o saldo do produto negativo, em caso positivo,�
	//�imprime o item da nota.                                                 �
	//��������������������������������������������������������������������������
	If !Empty(cAlias)
		oReport:Section(1):Section(1):Init()
		While Eval(bEval)
			aSalAlmox:= {}
			If cAlias == "SF2" 		
				// Busca saldo do produto a partir da data do ultimo fechamento, ate a emissao
				// da nota + 1 dia (se nao somarmos 1 dia, a funcao na considera as notas do dia da emissao da nota)
				aSalAlmox:= CalcEst(SD2->D2_COD,SD2->D2_LOCAL,SD2->D2_EMISSAO+1)
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
			Else
				aSalAlmox:= CalcEst(SD1->D1_COD,SD1->D1_LOCAL,SD1->D1_EMISSAO+1)
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
			EndIf
	
			If (Len(aSalAlmox) > 0) .And. (aSalAlmox[2] < 0)
				nSaldo := aSalAlmox[2]
				oReport:Section(1):Section(1):PrintLine()	 				
				lPrint := .T.
			EndIf
			IIf(cAlias == "SF2",SD2->(dbSkip()),SD1->(dbSkip()))
			
		EndDo
		oReport:Section(1):Section(1):Finish()	
	EndIf
	
	If lPrint
		oReport:SkipLine()   
		lPrint := .F.
	EndIf
	
	dbSelectArea(cAliasSD9)
	dbSkip()
	oReport:IncMeter()
	
EndDo

oReport:Section(1):Finish()
oReport:Section(1):SetPageBreak(.T.)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MATR012   � Autor �Marco Bianchi          � Data �11/06/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impressao do Relatorio de Correlacao Release 3.             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MATR012R3()

LOCAL wnrel		:= "MATR012"
LOCAL cDesc1	:= STR0002	//"Este relatorio ir� imprimir o Relatorio de Correla-"
LOCAL cDesc2	:= STR0003	//"��es em ordem cronol�gica de acordo com o NSU.     "
LOCAL cDesc3	:= " "
LOCAL cString	:= "SD9"

PRIVATE Tamanho	:= "M"
PRIVATE titulo	:= STR0001										//"Relatorio de Correlacao"
PRIVATE aReturn := {STR0007, 1,STR0008, 2, 2, 1, "",0 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR012"
PRIVATE nLastKey:= 0
PRIVATE M_PAG	:= 1

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01               Da NSU                                �
//� mv_par02               Ate a NSU                             �
//� mv_par03               Da Emissao                            �
//� mv_par04               Ate Emissao                           �
//����������������������������������������������������������������
Pergunte("MTR012",.F.)

wnrel:=SetPrint(cString,wnrel,"MTR012",@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.F.)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C012Imp(@lEnd,wnRel,cString)},titulo)

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C012Imp  � Autor � Marco Bianchi         � Data � 11/06/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do relatorio                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR012			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C012Imp(lEnd,WnRel,cString)

//                                     1         2         3         4         5         6         7         8         9        10        11        12        13
//                            012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
Local Cabec1   := STR0009 // "NSU        Serie Documento Data Uso Hr Uso Motivo    							     V.Bruto (Saida) V. Bruto (Entrada)"
						  //  XXXXXXXXXX XXX   XXXXXX    99/99/99  99:99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999.999,99     999.999.999,99

Local Cabec2   := STR0010 // "Codigo          Descricao                            Saldo R$"
                          //  XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999.999,99
Local cIndex   :=""	
Local cCondicao:= ""
Local cAliasSD9:= "SD9"
Local cQuery   := ""
Local nSD9     := 0
Local aStruSD9 := {}
Local cAlias   := ""
Local nSaldo   := 0
Local aSalAlmox:= {}
Local li       := 99
Local bEval 

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SD9")
aStruSD9  := SD9->(dbStruct())			
cAliasSD9:= "C012Imp"
cQuery := "SELECT SD9.R_E_C_N_O_ SD9REC,"
cQuery += "SD9.D9_FILIAL,SD9.D9_NSU,SD9.D9_SERIE,SD9.D9_DOC,SD9.D9_DTUSO,"
cQuery += IIF(SerieNfId("SD9",3,"D9_SERIE")<>"D9_SERIE","SD9."+SerieNfId("SD9",3,"D9_SERIE")+",","")
cQuery += "SD9.D9_HORA,SD9.D9_MOTIVO"
cQuery += "FROM "
cQuery += RetSqlName("SD9") + " SD9 "
cQuery += "WHERE "
cQuery += "SD9.D9_FILIAL = '"+xFilial("SD9")+"' AND "		
cQuery += "SD9.D9_NSU >= '"+mv_par01+"' AND "
cQuery += "SD9.D9_NSU<= '"+mv_par02+"' AND "
cQuery += "SD9.D9_DTUSO >= '"+DtoS(mv_par03)+"' AND "
cQuery += "SD9.D9_DTUSO <= '"+DtoS(mv_par04)+"' AND "
cQuery += "SD9.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY SD9.D9_FILIAL,SD9.D9_NSU,SD9.D9_SERIE,SD9.D9_DOC"

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD9,.T.,.T.)

For nSD9 := 1 To Len(aStruSD9)
	If aStruSD9[nSd9][2] <> "C" .and.  FieldPos(aStruSd9[nSd9][1]) > 0
		TcSetField(cAliasSD9,aStruSD9[nSD9][1],aStruSD9[nSD9][2],aStruSD9[nSD9][3],aStruSD9[nSD9][4])
	EndIf
Next nSD9

While !Eof() 

	If li > 55
		li := (Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,IIF(aReturn[4]==1,15,18))+1)
	EndIf
	
	@ li,000 PSAY (cAliasSD9)->D9_NSU
	@ li,012 PSAY Alltrim((cAliasSD9)->&(SerieNfId("SD9",3,"D9_SERIE")))
	@ li,017 PSAY (cAliasSD9)->D9_DOC
	@ li,027 PSAY (cAliasSD9)->D9_DTUSO
	@ li,036 PSAY (cAliasSD9)->D9_HORA   Picture "@R 99:99"
	@ li,043 PSAY (cAliasSD9)->D9_MOTIVO

	//������������������������������������������������������������������������Ŀ
	//�Verifica se a nota e saida ou entrada                                   �
	//��������������������������������������������������������������������������
	cAlias := ""
	SF2->(dbSetOrder(1))                   
	If SF2->(dbSeek(xFilial("SF2")+(cAliasSD9)->D9_DOC+(cAliasSD9)->D9_SERIE))
		@ li,091 PSAY SF2->F2_VALBRUT Picture PesqPict("SF2","F2_VALBRUT",14)
		cAlias := "SF2"
		SD2->(dbSetOrder(3))
		SD2->(dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)) 
		bEval := {||  xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ==  xFilial("SD2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA  }
	Else
		SF1->(dbSetOrder(1))
		If SF1->(dbSeek(xFilial("SF1")+(cAliasSD9)->D9_DOC+(cAliasSD9)->D9_SERIE))
			@ li,109 PSAY SF1->F1_VALBRUT     Picture PesqPict("SF2","F2_VALBRUT",14)
			cAlias := "SF1"
			SD1->(dbSetOrder(1))
			bEval := {|| SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)) }
			bEval := {||  xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ==  xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA  }		
		EndIf
	EndIf
    li++
	
	//������������������������������������������������������������������������Ŀ
	//�Verifica se a nota deixou o saldo do produto negativo, em caso positivo,�
	//�imprime o item da nota.                                                 �
	//��������������������������������������������������������������������������
	If !Empty(cAlias)
		While Eval(bEval)
			aSalAlmox:= {}
			If cAlias == "SF2" 		
				// Busca saldo do produto a partir da data do ultimo fechamento, ate a emissao
				// da nota + 1 dia (se nao somarmos 1 dia, a funcao na considera as notas do dia da emissao da nota)
				aSalAlmox:= CalcEst(SD2->D2_COD,SD2->D2_LOCAL,SD2->D2_EMISSAO+1)
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
			Else
				aSalAlmox:= CalcEst(SD1->D1_COD,SD1->D1_LOCAL,SD1->D1_EMISSAO+1)
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
			EndIf
	
			If (Len(aSalAlmox) > 0) .And. (aSalAlmox[2] < 0)
				nSaldo := aSalAlmox[2]
				@ li,000 PSAY SB1->B1_COD
				@ li,016 PSAY PADR(SB1->B1_DESC,90)
				@ li,109 PSAY nSaldo		Picture PesqPict("SB2","B2_VATU1",14)
			    li+=2
			EndIf
			IIf(cAlias == "SF2",SD2->(dbSkip()),SD1->(dbSkip()))
			
		EndDo
	EndIf
	
	dbSelectArea(cAliasSD9)
	dbSkip()
	
EndDo
(cAliasSD9)->(dbCloseArea())
	
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	Ourspool(wnrel)
Endif

MS_FLUSH()

Return