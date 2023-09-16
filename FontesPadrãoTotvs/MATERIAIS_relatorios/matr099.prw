#Include "MATR099.CH"
#Include "FIVEWIN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MATR099  � Autor � Liber De Esteban      � Data � 24/05/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Relacao de Empresas x Zonas Fiscais - SFH                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �MATR099()                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
FUNCTION MATR099()

Local oReport

If TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	MATR099R3()
EndIf

Return

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���FUNCAO    �ReportDef � Autor � Liber de Esteban      � Data � 24/05/2006 ���
���������������������������������������������������������������������������Ĵ��
���DESCRICAO � Definicao do componente                                      ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                     ���
���������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function ReportDef()

Local oReport
Local oSection

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

oReport := TReport():New("MATR099",OemToAnsi(STR0011),"MTR099",; //"Rela��o de Empresas x Zonas Fiscais"
{|oReport| ReportPrint(oReport)},STR0012) //"Imprimir� os dados das Empresas x Zonas Fiscais de acordo com a configura��o do usu�rio."

oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)
Pergunte("MTR099",.F.)

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
oSection := TRSection():New(oReport,STR0011,{"SFH"},,.T.,.T.) //"Rela��o de Empresas x Zonas Fiscais"
oSection:SetTotalInLine(.F.)

TRFunction():New(oSection:Cell(2),NIL,"COUNT",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.,.F.)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint� Autor �Liber de Esteban       � Data �24/05/2006���
��������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os  ���
���          �relatorios que poderao ser agendados pelo usuario.           ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                            ���
��������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                          ���
��������������������������������������������������������������������������Ĵ��
���          �               �                                             ���
���������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)

Local cAliasSFH := "SFH"
Local cDeZona   := mv_par01
Local cAteZona  := mv_par02
Local cDeImp    := mv_par03
Local cAteImp   := mv_par04

nOrder := oReport:Section(1):GetOrder()

dbSelectArea(cAliasSFH)
dbSetOrder(nOrder)

#IFDEF TOP

	cAliasSFH := GetNextAlias()
	
	oReport:Section(1):BeginQuery()	
	BeginSql alias cAliasSFH
		SELECT * FROM %table:SFH% SFH
		WHERE FH_FILIAL = %xFilial:SFH% AND
		FH_ZONFIS >= %Exp:cDeZona%      AND
		FH_ZONFIS <= %Exp:cAteZona%     AND		 
		FH_IMPOSTO >= %Exp:cDeImp%      AND
		FH_IMPOSTO <= %Exp:cAteImp%     AND
		SFH.%notDel%
		ORDER BY %Order:SFH%
	EndSql
	oReport:Section(1):EndQuery()
	
#ELSE

	cCondicao := 'FH_FILIAL =='+"'"+xFilial()+"'"+' .And. '
	cCondicao += 'FH_ZONFIS  >='+"'"+cDeZona+"'"+' .And. FH_ZONFIS <='+"'"+cAteZona+"'"+' .And. '
	cCondicao += 'FH_IMPOSTO >='+"'"+cDeImp+"'"+' .And. FH_IMPOSTO <='+"'"+cAteImp+"'"

	oReport:Section(1):SetFilter(cCondicao,IndexKey())
	
#ENDIF

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������

oReport:Section(1):Print()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MATR099R3 � Autor � Sergio S. Fuzinaka    � Data � 20.11.01 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Relacao de Empresas x Zonas Fiscais - SFH (Release 3)       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �MATR099R3()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
�������������������������������������������������������������������������Ĵ��
���           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
���              �        �      �                                        ��� 
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MATR099R3()

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local wnrel, CbCont,Cabec1,Cabec2,Cabec3,nPos
Local cTamanho := "M"
Local limite   := 132
Local cTitulo  := OemToAnsi(STR0001)	// "Relacao de Empresas x Zonas Fiscais"
Local cDesc1   := OemToAnsi(STR0002)	// "Imprimira os dados das Empresas x Zonas Fiscais de acordo com a"
Local cDesc2   := OemToAnsi(STR0003)	// "configuracao do usuario."
Local cDesc3   := OemToAnsi(STR0004)	// ""

Private aReturn  := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
Private aLinha   := {}
Private nomeprog := "MATR099"
Private nLastKey := 0
Private cPerg    := "MTR099"
Private aParDef  := {}
Private cZFisDe  := ""
Private cZFisAte := ""
Private cImpDe   := ""
Private cImpAte  := ""

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
Cabec1   := Upper(OemToAnsi(STR0001))		//"Relacao de Empresas x Zonas Fiscais"
Cabec2   := Replicate("-",limite)
Cabec3   := ""
cString  := "SFH"
li       := 80
m_pag    := 1
aOrd     := {OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009),OemToAnsi(STR0010)}		// # Fornecedor # Imposto+Fornecedor # Cliente # Imposto+Cliente
wnrel    := "MATR099"        // Nome default do relatorio em disco

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte("MTR099",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01      	 // Zona Fiscal De                           �
//� mv_par02         // Zona Fiscal Ate                          �
//� mv_par03         // Imposto De                               �
//� mv_par04         // Imposto Ate                              �
//����������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,,cTamanho)

If nLastKey = 27 
   DbClearFilter()
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
   DbClearFilter()
   Return
Endif

cZFisDe  := mv_par01
cZFisAte := mv_par02
cImpDe   := mv_par03
cImpAte  := mv_par04

//��������������������������������������������������������������Ŀ
//� Monta Array para identificacao dos campos dos arquivos       �
//����������������������������������������������������������������
RptStatus({|lEnd| R099Imp(@lEnd,Cabec1,Cabec2,Cabec3,limite,cTamanho,cbCont,wnrel)},cTitulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � R099IMP  � Autor � Sergio S. Fuzinaka    � Data � 20.11.01 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Chamada do Relatorio                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATR099()                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function R099Imp(lEnd,Cabec1,Cabec2,Cabec3,limite,cTamanho,cbCont,wnrel)

Local cFilter := 'FH_FILIAL =='+"'"+xFilial()+"'"+' .And. '
	  cFilter += 'FH_ZONFIS  >='+"'"+cZFisDe+"'"+' .And. FH_ZONFIS <='+"'"+cZFisAte+"'"+' .And. '
	  cFilter += 'FH_IMPOSTO >='+"'"+cImpDe+"'"+' .And. FH_IMPOSTO <='+"'"+cImpAte+"'"

If Len(aReturn) > 8
    Mont_dic(cString)
else
    Mont_Array(cString)
endif

dbSelectArea("SFH")
dbSetOrder(aReturn[8])
Set Filter to &cFilter

ImpCadast(Cabec1,Cabec2,Cabec3,NomeProg,cTamanho,Limite,cString,@lEnd)

IF li != 80
    roda(cbcont,cbtxt,"M")
EndIF

dbSelectArea("SFH")
DbClearFilter()
dbSetOrder(1)

If aReturn[5] = 1
   Set Printer TO 
   Commit
   Ourspool(wnrel)                             
Endif
MS_FLUSH()

Return Nil
