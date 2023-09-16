#INCLUDE 'MATR851.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR851  � Autor � Ricardo Berti         � Data �26.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o de OPs FIFO                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function MATR851()

Local oReport
Private cAliasQry

oReport := ReportDef()
oReport:PrintDialog()

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Ricardo Berti 		� Data �26.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relatorio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATR851			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Private cCampoCus

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
oReport:= TReport():New("MATR851",STR0001,"MTR851", {|oReport| ReportPrint(oReport)},STR0002+STR0003) //'RELACAO POR ORDEM DE PRODUCAO FIFO'##'O objetivo deste relat�rio � exibir detalhadamente todas as movimenta-'##'��es feitas para cada Ordem de Produ��o ,mostrando inclusive os custos.'
oReport:SetLandscape() //Define a orientacao de pagina do relatorio como paisagem.

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte(oReport:uParam,.F.)
//�������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                    	�
//� mv_par01     // OP inicial   	                            �
//� mv_par02     // OP final                   	                �
//� mv_par03     // Moeda Selecionada (1 a 5)              		�
//� mv_par04     // De  Data Movimentacao					    �
//� mv_par05     // Ate Data Movimentacao                       �
//���������������������������������������������������������������
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

//�������������������������������������������������������������Ŀ
//� Secao 1 (oSection1)                                         �
//���������������������������������������������������������������
oSection1 := TRSection():New(oReport,STR0027,{"SD8","SB1"},/*Ordem*/) //"Movimentos por Lote Custo FIFO"
oSection1:SetHeaderPage()
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,'B1_CC'    	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'D8_OP'	  	,'SD8')
TRCell():New(oSection1,'D8_CF'   	,'SD8')
TRCell():New(oSection1,'D8_PRODUTO'	,'SD8')
TRCell():New(oSection1,'B1_DESC'  	,'SB1',,,25)
TRCell():New(oSection1,'D8_QUANT' 	,'SD8',,,,,{|| If(Substr((cAliasQry)->D8_CF,1,2)== 'DE',-(cAliasQry)->D8_QUANT ,(cAliasQry)->D8_QUANT) })
TRCell():New(oSection1,'B1_UM'  	,'SB1')
TRCell():New(oSection1,'CusUnit' 	,'',STR0020	,PesqPict("SD8","D8_CUSTO1"),,,{|| (cAliasQry)->&(cCampoCus) / (cAliasQry)->D8_QUANT }) //"Custo Unitario"
TRCell():New(oSection1,'CusTotal'  	,'',STR0021	,PesqPict("SD8","D8_CUSTO1"),,,{|| If(Substr((cAliasQry)->D8_CF,1,2)== 'DE',-(cAliasQry)->&(cCampoCus),(cAliasQry)->&(cCampoCus)) }) //"Custo Total"
TRCell():New(oSection1,'D8_DOC'   	,'SD8')
TRCell():New(oSection1,'D8_DATA'	,'SD8')
TRCell():New(oSection1,'B1_CUSTD'  	,'SB1',,,,,{|| RetFldProd((cAliasQry)->D8_PRODUTO,"B1_CUSTD",cAliasQry) })
TRCell():New(oSection1,'VlProSTD'	,'',,PesqPict("SB1","B1_CUSTD" ),,,{|| CalR851Pro(oReport,cAliasQry) })

Return(oReport)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor � Ricardo Berti 	    � Data �26/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR860			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)

Local oSection1  := oReport:Section(1)
Local oBreak, oBreak2
Local cOrderBy

//��������������������������������Ŀ
//�Definicao do titulo do relatorio�
//����������������������������������
oReport:SetTitle(STR0001+" - "+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par03)))))

//������������������������������������������������������������������������Ŀ
//�Filtragem do relatorio                                                  �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//�Query do relatorio da secao 1                                           �
//��������������������������������������������������������������������������

oSection1:BeginQuery()	

cAliasQry := GetNextAlias()

cOrderBy := "% D8_FILIAL,D8_OP,D8_CF,D8_SEQ,D8_PRODUTO %"

BeginSql Alias cAliasQry

SELECT SD8.*,
       SB1.B1_COD, SB1.B1_DESC, SB1.B1_CUSTD, SB1.B1_CC

FROM %table:SD8% SD8, %table:SB1% SB1 

WHERE SD8.D8_FILIAL   = %xFilial:SD8%	 AND 
      SB1.B1_FILIAL   = %xFilial:SB1%	 AND 
  		  SD8.D8_PRODUTO  = SB1.B1_COD     	 AND
  		  SD8.D8_OP    	 >= %Exp:mv_par01%	 AND 
 	  SD8.D8_OP      <= %Exp:mv_par02%	 AND 
 	  SD8.D8_DATA    >= %Exp:DtoS(mv_par04)% AND 
 	  SD8.D8_DATA    <= %Exp:DtoS(mv_par05)% AND 
	  SD8.D8_OP      <> ' '            	 AND
	  SD8.%NotDel%						 AND
	  SB1.%NotDel%						 

ORDER BY %Exp:cOrderBy%

EndSql 

oSection1:EndQuery()

oBreak := TRBreak():New(oSection1,oSection1:Cell("D8_OP"),NIL,.F.)
TRFunction():New(oSection1:Cell('D8_QUANT'),NIL,"SUM",oBreak,NIL,/*Picture*/,{|| If(!IsProdMod((cAliasQry)->D8_PRODUTO) .And. SubStr((cAliasQry)->D8_CF,1,2)$"DE,RE",oSection1:Cell('D8_QUANT'):GetValue(.t.), 0)  },.F.,.F.)
TRFunction():New(oSection1:Cell('CusTotal'),NIL,"SUM",oBreak,NIL,/*Picture*/,{|| If(!IsProdMod((cAliasQry)->D8_PRODUTO) .And. SubStr((cAliasQry)->D8_CF,1,2)$"DE,RE",oSection1:Cell('CusTotal'):GetValue(.t.), 0)  },.F.,.F.)

//�����������������������������������������Ŀ
//�Definindo a Quebra Por Ordem de Producao �
//�������������������������������������������
oBreak2   := TRBreak():New(oSection1,oSection1:Cell("D8_OP"),STR0022,.T.) //"Total OP"

//�����������������������������������������Ŀ
//�Totalizando Por Ordem de Producao        �
//�������������������������������������������
TRFunction():New(oSection1:Cell('B1_CUSTD'),NIL,"MAX",oBreak2,STR0026,/*Picture*/,/*uFormula*/,.F.,.F.) //"Custo STD"
TRFunction():New(oSection1:Cell('VlProSTD'),NIL,"SUM",oBreak2,STR0023,/*Picture*/,/*uFormula*/,.F.,.F.) //"Custo Producao STD"
TRFunction():New(oSection1:Cell('D8_QUANT'),NIL,"SUM",oBreak2,STR0024,/*Picture*/,{|| If(IsProdMod((cAliasQry)->D8_PRODUTO), oSection1:Cell('D8_QUANT'):GetValue(.t.) , 0 ) },.F.,.F.) //"Qtde.Mao de Obra"
TRFunction():New(oSection1:Cell('CusTotal'),NIL,"SUM",oBreak2,STR0025,/*Picture*/,{|| If(IsProdMod((cAliasQry)->D8_PRODUTO), oSection1:Cell('CusTotal'):GetValue(.t.), 0 ) },.F.,.F.)  //"Custo Mao de Obra"

//�����������������������������������������Ŀ
//�Totais Gerais                            �
//�������������������������������������������
TRFunction():New(oSection1:Cell('CusTotal'),NIL,"SUM",NIL,STR0013,/*Picture*/,{|| If(!IsProdMod((cAliasQry)->D8_PRODUTO) .And. SubStr((cAliasQry)->D8_CF,1,2)=="RE", oSection1:Cell('CusTotal'):GetValue(.t.), 0) },.F.,.T.) //"TOTAL REQUISICOES ---->"
TRFunction():New(oSection1:Cell('CusTotal'),NIL,"SUM",NIL,STR0014,/*Picture*/,{|| If(SubStr((cAliasQry)->D8_CF,1,2)=="PR",oSection1:Cell('CusTotal'):GetValue(.t.),0) },.F.,.T.) //"TOTAL PRODUCAO    ---->"
TRFunction():New(oSection1:Cell('CusTotal'),NIL,"SUM",NIL,STR0015,/*Picture*/,{|| If(!IsProdMod((cAliasQry)->D8_PRODUTO) .And. SubStr((cAliasQry)->D8_CF,1,2)=="DE", -(oSection1:Cell('CusTotal'):GetValue(.t.)), 0) },.F.,.T.) //"TOTAL DEVOLUCOES  ---->"
TRFunction():New(oSection1:Cell('CusTotal'),NIL,"SUM",NIL,STR0016,/*Picture*/,{|| If(IsProdMod((cAliasQry)->D8_PRODUTO) .And. SubStr((cAliasQry)->D8_CF,1,2)=="RE", oSection1:Cell('CusTotal'):GetValue(.t.), 0) },.F.,.T.) //"TOTAL REQUISICOES MAO DE OBRA ---->"
TRFunction():New(oSection1:Cell('CusTotal'),NIL,"SUM",NIL,STR0017,/*Picture*/,{|| If(IsProdMod((cAliasQry)->D8_PRODUTO) .And. SubStr((cAliasQry)->D8_CF,1,2)=="DE", -(oSection1:Cell('CusTotal'):GetValue(.t.)), 0) },.F.,.T.) //"TOTAL DEVOLUCOES  MAO DE OBRA ---->"

//������������������������������������������������������Ŀ
//�Inibindo celulas, utilizadas apenas para totalizadores�
//��������������������������������������������������������
oSection1:Cell('B1_CUSTD'):Hide()
oSection1:Cell('B1_CUSTD'):HideHeader()
oSection1:Cell('VlProSTD'):Hide()
oSection1:Cell('VlProSTD'):HideHeader()

//��������������������������������������������������������������������������Ŀ
//� Define o campo a ser impresso no valor de acordo com a moeda selecionada �
//����������������������������������������������������������������������������
cCampoCus := "D8_CUSTO"+STR(mv_par03,1)

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do relatorio 		                               �
//��������������������������������������������������������������������������
oSection1:Print()

//��������������������������������������������������������������Ŀ
//� Devolve a condicao original do arquivo principal             �
//����������������������������������������������������������������
dbSelectArea('SD8')
RetIndex('SD8')
dbClearFilter()
dbSetOrder(1)

Return NIL



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CalR851Pro� Autor � Ricardo Berti         � Data �26.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calculo do Custo Total de Producao da OP					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpN1 := CalR851Pro(ExpO1,ExpC1)		                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1: obj report										  ���
���          � ExpC1: Alias do arq.										  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpN1: calculo do custo total producao					  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR242                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CalR851Pro(oReport,cAliasQry)

Local nTotPro := 0
If SubStr((cAliasQry)->D8_CF,1,2)=="PR"
	nTotPro := oReport:Section(1):Cell('B1_CUSTD'):GetValue(.t.) * oReport:Section(1):Cell('D8_QUANT'):GetValue(.t.)
EndIf
Return (nTotPro)