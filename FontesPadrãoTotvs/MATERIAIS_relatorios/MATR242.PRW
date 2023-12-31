#INCLUDE "MATR242.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR242  � Autor � Ricardo Berti         � Data �14.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Comparativo de Custos                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function MATR242()

Local oReport

oReport := ReportDef()
oReport:PrintDialog()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Ricardo Berti 		� Data �14.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relatorio                                  ���
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

Local aOrdem	:= {STR0006}
Local cAliasQRY := "SB2"
Local cPerg		:= "MTR242"
Local cPicQ		:= PesqPict("SB2","B2_QATU")
Local cPicV		:= PesqPict("SB2","B2_CM1")
Local cTamQ		:= TamSX3("B2_QATU")[1]
Local cTamV		:= TamSX3("B2_CM1")[1]
Local oReport
Local oSection1

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
oReport := TReport():New("MATR242",STR0018,cPerg, {|oReport| ReportPrint(oReport,@cAliasQRY)},STR0002+" "+STR0003) //'Comparativo de Custos'##"Este programa ira' emitir um comparativo de custos, em valores e "##'quantidades, dos produtos em estoque.'
oReport:SetTotalInLine(.F.)
oReport:SetLandScape()

//�����������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                  �
//� mv_par01     // Filial De                                             �
//� mv_par02     // Filial Ate                                            �
//� mv_par03     // Armazem De                                            �
//� mv_par04     // Armazem Ate                                           �
//� mv_par05     // 1a.Data		                                          �
//� mv_par06     // 2a.Data		                                          �
//� mv_par07     // Produto De                                            �
//� mv_par08     // Produto Ate                                           �
//�������������������������������������������������������������������������
Pergunte(cPerg,.F.)

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
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao das celulas da secao do relatorio                               �
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
//�ExpB8 : Bloco de codigo para impressao.                                 �
//�        Default : ExpC2                                                 �
//��������������������������������������������������������������������������

oSection1 := TRSection():New(oReport,STR0019,{"SB2","SB1"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/)
oSection1:SetHeaderPage()
oSection1:SetTotalInLine(.F.)
oSection1:SetTotalText(STR0010) // "Total"

TRCell():New(oSection1,"B2_COD"		,"SB2",/*Titulo*/												,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_DESC"	,"SB1",/*Titulo*/												,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_TIPO"	,"SB1",/*Titulo*/												,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_UM"		,"SB1",/*Titulo*/												,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B2_LOCAL"	,"SB2",/*Titulo*/												,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"QTD1"		,"   ",STR0015	   												,cPicQ			,cTamQ		,/*lPixel*/,{|| CalcEst((cAliasQRY)->B2_COD, (cAliasQRY)->B2_LOCAL,mv_par05)[1] },,,"RIGHT") //"Quantidade"
TRCell():New(oSection1,"VLRUNIT1"	,"   ","["+AllTrim(STR0013)+dtoc(mv_par05)+"]"+CRLF+STR0016	,cPicV			,cTamV		,/*lPixel*/,{|| C242CalVU(@oReport,cAliasQRY,"QTD1","VALOR1") },,,"RIGHT")  //"Data: "##"Valor Unitario"
TRCell():New(oSection1,"VALOR1"		,"   ",STR0010													,cPicV			,cTamV		,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Total"
TRCell():New(oSection1,"QTD2"		,"   ",STR0015													,cPicQ			,cTamQ		,/*lPixel*/,{|| CalcEst((cAliasQRY)->B2_COD, (cAliasQRY)->B2_LOCAL,mv_par06)[1] },,,"RIGHT") //"Quantidade"
TRCell():New(oSection1,"VLRUNIT2"	,"   ","["+AllTrim(STR0013)+dtoc(mv_par06)+"]"+CRLF+STR0016		,cPicV			,cTamV		,/*lPixel*/,{|| C242CalVU(@oReport,cAliasQRY,"QTD2","VALOR2") },,,"RIGHT") //"Data: "##"Valor Unitario"
TRCell():New(oSection1,"VALOR2"		,"   ",STR0010													,cPicV			,cTamV		,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Total"
TRCell():New(oSection1,"DIFUNIT"	,"   ",STR0007+CRLF+STR0016										,cPicV			,cTamV		,/*lPixel*/,{|| C242CalDif(oReport,"VLRUNIT1","VLRUNIT2") },,,"RIGHT") //"Diferenca"##"Valor Unitario"
TRCell():New(oSection1,"VARIACAO"	,"   ",STR0017													,"@E 99999.99"	,/*Tamanho*/,/*lPixel*/,{|| C242CalVar(oReport,"VLRUNIT1","VLRUNIT2") }) //"Variacao(%)"

Return(oReport)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C242CalVU � Autor � Ricardo Berti         � Data �14.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula/retorna valor unitario (tb atualizando valor total)���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpN1 := C4242CalVU(ExpO1,ExpC1,ExpC2,ExpC3)	              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1: obj report										  ���
���          � ExpC1: alias do arq.										  ���
���          � ExpC2: nome do campo de qtde (celula)					  ���
���          � ExpC3: nome do campo de valor (celula)					  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpN1: valor unitario									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR242                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C242CalVU(oReport,cAliasQRY,cCpQtd,cCpValor)

Local nQtd		:= oReport:Section(1):Cell(cCpQtd):GetValue(.T.)
Local nTotal	:= CalcEst( (cAliasQRY)->B2_COD, (cAliasQRY)->B2_LOCAL,If(Upper(cCpValor)=="VALOR2",mv_par06,mv_par05))[mv_par09+1]
//������������������������������������������������������������������������Ŀ
//�Atualiza celula VALOR1 ou VALOR2 (valor total)	                       �
//��������������������������������������������������������������������������
oReport:Section(1):Cell(cCpValor):SetValue(nTotal)

Return ( nTotal / nQtd )


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C242CalDif� Autor � Ricardo Berti         � Data �14.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula a diferenca entre os valores unitarios			  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpN1 := C4242CalDif(ExpO1,ExpC1,ExpC2)                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1: obj report										  ���
���          � ExpC1: nome do campo valor unitario 1 (celula)			  ���
���          � ExpC2: nome do campo valor unitario 2 (celula)			  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpN1: diferenca entre valores unitarios (sempre positiva) ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR242                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C242CalDif(oReport,cCpValor1,cCpValor2)

Local nVlrUnit1 := oReport:Section(1):Cell(cCpValor1):GetValue(.T.)
Local nVlrUnit2 := oReport:Section(1):Cell(cCpValor2):GetValue(.T.)
Return ( ABS( nVlrUnit1 - nVlrUnit2 ) )


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C242CalVar� Autor � Ricardo Berti         � Data �14.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula a porcentagem de Variacao entre valores unitarios  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpN1 := C4242CalVar(ExpO1,ExpC1,ExpC2)                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1: obj report										  ���
���          � ExpC1: nome do campo valor unitario 1 (celula)			  ���
���          � ExpC2: nome do campo valor unitario 2 (celula)			  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpN1: porcentagem de variacao 							  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR242                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C242CalVar(oReport,cCpValor1,cCpValor2)

Local nVlrUnit1 := oReport:Section(1):Cell(cCpValor1):GetValue(.T.)
Local nVlrUnit2 := oReport:Section(1):Cell(cCpValor2):GetValue(.T.)
Local nPerc := 0
If ! (nVlrUnit1 == 0 .OR. nVlrUnit2 == 0 .or. (nVlrUnit1 == nVlrUnit2))
	nPerc := (nVlrUnit2/nVlrUnit1)*100
Endif   
Return (nPerc)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Ricardo Berti         � Data �14.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
���          �ExpC1: Alias do arquivo principal                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasQRY)

Local oSection1	:= oReport:Section(1)
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSB2	:= SB2->(GetArea())


oSection1:Cell("VLRUNIT1"):SetTitle("["+AllTrim(STR0013)+dtoc(mv_par05)+"]"+CRLF+STR0016) //"Valor Unitario"
oSection1:Cell("VLRUNIT2"):SetTitle("["+AllTrim(STR0013)+dtoc(mv_par06)+"]"+CRLF+Padc(STR0016,18)) //"Valor Unitario"

oReport:SetTitle(oReport:Title()+" "+STR0014+Alltrim(Str(mv_par09))) //" na Moeda "

TRFunction():New(oSection1:Cell("VALOR1"),NIL,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndReport*/,.F./*lEndPage*/,/*Obj*/)
TRFunction():New(oSection1:Cell("VALOR2"),NIL,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndReport*/,.F./*lEndPage*/,/*Obj*/)

//������������������������������������������������������������������������Ŀ
//�Filtragem do relatorio                                                  �
//��������������������������������������������������������������������������

//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)
//������������������������������������������������������������������������Ŀ
//�Query do relat�rio da secao 1                                           �
//��������������������������������������������������������������������������
cAliasQRY := GetNextAlias()

oReport:Section(1):BeginQuery()	

BeginSql Alias cAliasQRY
SELECT	B2_FILIAL,B2_COD,B2_LOCAL
FROM %table:SB2% SB2
 	  WHERE	B2_FILIAL  >= %Exp:mv_par01% AND
 	       	B2_FILIAL  <= %Exp:mv_par02% AND
		B2_LOCAL   >= %Exp:mv_par03% AND 
		B2_LOCAL   <= %Exp:mv_par04% AND 
		B2_COD     >= %Exp:mv_par07% AND 
		B2_COD     <= %Exp:mv_par08% AND 
		SB2.%NotDel% 
ORDER BY %Order:SB2% 
		
EndSql 
//������������������������������������������������������������������������Ŀ
//�Metodo EndQuery ( Classe TRSection )                                    �
//�                                                                        �
//�Prepara o relat�rio para executar o Embedded SQL.                       �
//�                                                                        �
//�ExpA1 : Array com os parametros do tipo Range                           �
//��������������������������������������������������������������������������
oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)


//���������������������������������������Ŀ
//�Posicionamento das tabelas			  �
//�����������������������������������������
TRPosition():New(oSection1,"SB1",1,{|| xFilial("SB1")+(cAliasQRY)->B2_COD })

//���������������������������������������Ŀ
//�Inicio da impressao do relatorio		  �
//�����������������������������������������
oSection1:Print()

RestArea(aAreaSB2)
Return NIL