#Include "MATR098.CH"
#Include "FIVEWIN.CH"
                                                   
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MATR098  � Autor � Liber De Esteban      � Data � 23/05/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Relacao de Agentes Fiscais x Impostos (SFZ)                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �MATR098()                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador �Data    � BOPS     � Motivo da Alteracao                  ���
�������������������������������������������������������������������������Ĵ��
���Jonathan Glz�06/07/15�PCREQ-4256�Se elimina la funcion AjustaSX1() que ���
���            �        �          �hace modificacion a SX1 por motivo de ���
���            �        �          �adecuacion a fuentes a nuevas estruc- ���
���            �        �          �turas SX para Version 12.             ���
���M.Camargo   �09.11.15�PCREQ-4262�Merge sistemico v12.1.8		           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
FUNCTION MATR098()

Local oReport
                                

If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport := ReportDef()
	oReport:PrintDialog()  
Else
	MATR098R3()
EndIf

Return     


/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���FUNCAO    �ReportDef � Autor � Liber de Esteban      � Data � 23/05/2006 ���
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

oReport := TReport():New("MATR098",OemToAnsi(STR0008),"MTR098P9R1",; //"Relacao de Agentes Fiscais x Impostos"
{|oReport| ReportPrint(oReport)},STR0009) //"Imprimir� os dados dos Agentes Fiscais x Impostos de acordo com a configura�� do usu�rio."

oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)       
Pergunte("MTR098P9R1",.F.)

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
oSection := TRSection():New(oReport,STR0008,{"SFZ"},,.T.,.T.) //"Relacao de Agentes Fiscais x Impostos"
oSection:SetTotalInLine(.F.)

TRFunction():New(oSection:Cell(2),NIL,"COUNT",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.,.F.)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint� Autor �Liber de Esteban       � Data �23/05/2006���
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

Local cAliasSFZ := "SFZ"
Local cTipMov, cImp
Local cEspecie  := mv_par02
Local cTipo     := mv_par03   

cImp  := mv_par04


If mv_par01 == 1
	cTipMov := "E"
Else
	cTipMov := "S"
Endif

cCond := "%"

If Empty(cTipMov) 
	cCond += 'FZ_TIPMOV >= '+"'"+cTipMov+"'"
Else
	cCond += 'FZ_TIPMOV = '+"'"+cTipMov+"'"
EndIf
If Empty(cEspecie)
	cCond += ' AND FZ_ESPECIE >= '+"'"+cEspecie+"'"
Else
	cCond += ' AND FZ_ESPECIE ='+"'"+cEspecie+"'"
EndIf
If Empty(cTipo)
	cCond += ' AND FZ_TIPO >= '+"'"+cTipo+"'"
Else
	cCond += ' AND FZ_TIPO = '+"'"+cTipo+"'"
EndIf
cCond += "%"


dbSelectArea(cAliasSFZ)
dbSetOrder(1)

#IFDEF TOP

	cAliasSFZ := GetNextAlias()

	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)
	
	oReport:Section(1):BeginQuery()	
	BeginSql alias cAliasSFZ
		SELECT * FROM %table:SFZ% SFZ
		WHERE FZ_FILIAL = %xFilial:SFZ% AND 
		%Exp:cCond% AND SFZ.%notDel%
		ORDER BY %Order:SFZ%
	EndSql
	oReport:Section(1):EndQuery({MV_PAR04})
	
#ELSE
	//����������������������������������������������������������������������������������������������������Ŀ
	//�Utilizar a funcao MakeAdvlExpr, somente quando for utilizar o range de parametros para ambiente CDX �
	//������������������������������������������������������������������������������������������������������
	MakeAdvplExpr("MTR098P9R1") 

	dbSelectArea(cAliasSFZ)
	dbSetOrder(1)
                                                                                            
	cCondicao:= 'FZ_FILIAL =='+"'"+xFilial()+"'"+' .And. ' 
	
	If !Empty(cTipMov) 
		cCondicao += 'FZ_TIPMOV =='+"'"+cTipMov+"'"+' .And. '
	EndIf
	If !Empty(cEspecie)
		cCondicao += 'FZ_ESPECIE =='+"'"+cEspecie+"'"+' .And. '
	EndIf
	If !Empty(cTipo)
		cCondicao += 'FZ_TIPO=='+"'"+cTipo+"'"+' .And.'
	EndIf	
	
	cCondicao += +mv_par04

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
���Funcao    �MATR098R3 � Autor � Sergio S. Fuzinaka    � Data � 16.11.01 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Relacao de Agentes Fiscais x Impostos - SFZ (Release 3)     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �MATR098R3()                                                 ���
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
Function MATR098R3()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local wnrel
Local CbCont,Cabec1,Cabec2,Cabec3,nPos
Local tamanho:= "M"
Local limite := 132
Local Titulo := OemToAnsi(STR0001)	// "Relacao de Agentes Fiscais x Impostos"
Local cDesc1 := OemToAnsi(STR0002)	// "Imprimira os dados dos Agentes Fiscais x Impostos de acordo com a"
Local cDesc2 := OemToAnsi(STR0003)	// "configuracao do usuario."
Local cDesc3 := OemToAnsi(STR0004)	// ""

Private aReturn  := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
Private aLinha   := {}
Private nomeprog := "MATR098"
Private nLastKey := 0
Private cPerg    := "MTR098"
Private aParDef  := {}
Private cTipMov  := ""
Private cEspecie := ""   
Private cTipo    := ""
Private cImpDe   := ""
Private cImpAte  := ""

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
Cabec1   := Upper(OemToAnsi(STR0001))		//"Relacao de Agentes Fiscais x Impostos"
Cabec2   := Replicate("-",limite)
Cabec3   := ""
cString  := "SFZ"
li       := 80
m_pag    := 1
aOrd     := {OemToAnsi(STR0007)}		// Por Tipo Movimento
wnrel    := "MATR098"                   // Nome default do relatorio em disco 

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01      	 // Tipo de Movimento (E)ntrada ou (S)aida   �                        �
//� mv_par02         // Tipo do Documento Fiscal                 �
//� mv_par03         // Agente Fiscal                            �
//� mv_par04         // Imposto De                               �
//� mv_par05         // Imposto Ate                              �
//����������������������������������������������������������������
Pergunte(cPerg,.F.)               // Pergunta no SX1

nrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,,Tamanho)
If nLastKey = 27 
   DbClearFilter()
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
   DbClearFilter()
   Return
Endif

If mv_par01=1
	cTipMov  := "E"
Else
	cTipMov  := "S"	
Endif	

cEspecie := mv_par02  
cTipo    := mv_par03
cImpDe   := mv_par04
cImpAte  := mv_par05     

//��������������������������������������������������������������Ŀ
//� Monta Array para identificacao dos campos dos arquivos       �
//����������������������������������������������������������������
RptStatus({|lEnd| R098Imp(@lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)},Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � R098IMP  � Autor � Sergio S. Fuzinaka    � Data � 16.11.01 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Chamada do Relatorio                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATR098()                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function R098Imp(lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)
Local cFilter := " "

cFilter:= 'FZ_FILIAL =='+"'"+xFilial()+"'"+' .And. ' 
If !Empty(cTipMov) 
	cFilter += 'FZ_TIPMOV =='+"'"+cTipMov+"'"+' .And. '
EndIf
If !Empty(cEspecie)
	cFilter += 'FZ_ESPECIE =='+"'"+cEspecie+"'"+' .And. '
EndIf
If !Empty(cTipo)
	cFilter += 'FZ_TIPO=='+"'"+cTipo+"'"+' .And.'
EndIf	
cFilter += 'FZ_IMPOSTO >='+"'"+cImpDe+"'"+' .And. FZ_IMPOSTO <='+"'"+cImpAte+"'" 

If Len(aReturn) > 8
    Mont_dic(cString)
else
    Mont_Array(cString)
endif

dbSelectArea("SFZ")
dbSetOrder(aReturn[8])
Set Filter to &cFilter

ImpCadast(Cabec1,Cabec2,Cabec3,NomeProg,Tamanho,Limite,cString,@lEnd)

IF li != 80
    roda(cbcont,cbtxt,"M")
EndIF

dbSelectArea("SFZ")
DbClearFilter()
dbSetOrder(1)

If aReturn[5] = 1
   Set Printer TO 
   Commit
   Ourspool(wnrel)                             
Endif
MS_FLUSH()

Return nil
