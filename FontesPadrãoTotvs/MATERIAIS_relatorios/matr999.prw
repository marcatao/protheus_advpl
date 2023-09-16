#include "PROTHEUS.CH"
#include "MATR999.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���FUNCAO    � MATR999  � Autor � Liber de Esteban      � Data � 30/06/2006 ���
�������������������������������������������������������������������������Ĵ��
���DESCRICAO � Relatorio de analise de vendas por periodo                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFIS - EUA                                                ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador �Data    � BOPS     � Motivo da Alteracao                  ���
�������������������������������������������������������������������������Ĵ��
���Jonathan Glz�06/07/15�PCREQ-4256�Se elimina la funcion AjSX1999() la   ���
���            �        �          �hace modificacion a SX1 por motivo de ���
���            �        �          �adecuacion a fuentes a nuevas estruc- ���
���            �        �          �turas SX para Version 12.             ���
���M.Camargo   �09.11.15�PCREQ-4262�Merge sistemico v12.1.8		           ���
���Jonathan Glz�19/12/16�SERINN001-�Se cambio la forma de usar las tablas ���
���            �        �       688�temporales por motivo-limpieza CTREE  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
FUNCTION MATR999()

Local oReport


If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	MATR999R3()
EndIf

Return

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���FUNCAO    �ReportDef � Autor � Liber de Esteban      � Data � 10/05/2006 ���
���������������������������������������������������������������������������Ĵ��
���DESCRICAO � Definicao do componente                                      ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                     ���
���������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function ReportDef()

Local oReport
Local oVendas
Local oCompras

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

oReport := TReport():New("MATR999",STR0031,"MTR999",{|oReport| ReportPrint(oReport)},STR0032) //"Analise de Imposto"###"Analise de Imposto de Compras/Vendas"

Pergunte("MTR999",.F.)

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
//��������������������������������������������������������������������������

//�������������������Ŀ
//�Secao de Vendas    �
//���������������������
oVendas:=TRSection():New(oReport,STR0045,{"TMP2"},{STR0033}/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Vendas"###"Cod. Cliente/Fornecedor"
oVendas:SetEdit(.F.)
//��������������������������������������������������������������������Ŀ
//�As celulas da secao vendas serao definidas na rotina de impressao,  �
//�pois dependem de parametros passados pelo usuario                   �
//����������������������������������������������������������������������

//�������������������Ŀ
//�Secao de Compras   �
//���������������������
oCompras := TRSection():New(oReport,STR0034,{"TMP"},{STR0033}/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Compras"###"Cod. Cliente/Fornecedor"

TRCell():New(oCompras,"CODCLI" ,"TMP",STR0046,/*cPicture*/,06,/*lPixel*/,/*{|| code-block de impressao }*/) //"Fornecedor"
TRCell():New(oCompras,"NFISCAL","TMP",STR0035,/*cPicture*/,12,/*lPixel*/,/*{|| code-block de impressao }*/) //"Nota Fiscal"
TRCell():New(oCompras,"SERIE"  ,"TMP",STR0047,/*cPicture*/,03,/*lPixel*/,/*{|| code-block de impressao }*/) //"Serie"
TRCell():New(oCompras,"EMISSAO","TMP",STR0036,/*cPicture*/,08,/*lPixel*/,/*{|| code-block de impressao }*/) //"Dt. Emissao"
TRCell():New(oCompras,"VALDES" ,"TMP",STR0048,"@E 999,999,999.99",14,/*lPixel*/,/*{|| code-block de impressao }*/) //"Imp. Venda"
TRCell():New(oCompras,"BASIMP" ,"TMP",STR0049,"@E 999,999,999.99",14,/*lPixel*/,/*{|| code-block de impressao }*/) //"Valor Base"
TRCell():New(oCompras,"VAMERC" ,"TMP",STR0050,"@E 999,999,999.99",14,/*lPixel*/,/*{|| code-block de impressao }*/) //"Valor Total"

//Totalizador por quebra de fornecedor
oBreak := TRBreak():New(oCompras,oCompras:Cell(1),STR0037,.F.) //"Total do Fornecedor"
TRFunction():New(oCompras:Cell("VALDES"),NIL,"SUM",oBreak,,/*cPicture*/,/*uFormula*/,.T.,.F.,.F.)
TRFunction():New(oCompras:Cell("BASIMP"),NIL,"SUM",oBreak,,/*cPicture*/,/*uFormula*/,.T.,.F.,.F.)
TRFunction():New(oCompras:Cell("VAMERC"),NIL,"SUM",oBreak,,/*cPicture*/,/*uFormula*/,.T.,.F.,.F.)

Return(oReport)

/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint� Autor �Liber de Esteban       � Data �10/05/2006���
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
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function ReportPrint(oReport)

Local oVendas	:= oReport:Section(1)
Local oCompras	:= oReport:Section(2)

Local nCont     := 0
Local nLin		:= 0
Local aCposTMP2 := {}
Local cOper, nMes, cVar,  cCampo

Private cImposto, cEstado, cCodCampo, nTotdate, dDataRef, dinicial, dfinal, nTipo
Private nTotMes	:= 0

Private aIndex1 := {}
Private aIndex2 := {}
Private oTmpTMP
Private oTmpTMP2

cImposto    := AllTrim(mv_par01)
cEstado     := AllTrim(mv_par02)
dInicial    := mv_par03
dFinal      := mv_par04
nTipo       := mv_par06
nTotdate	:= 0

Private dDataR   := CTOD("01/" + StrZero(Month(dInicial),2) + Str(Year(dInicial)),"DD/MM/YYYY")

dbSelectArea("SFB")
dbSetOrder(1)
If dbSeek(xFilial("SFB")+cImposto)
	cCodCampo := SFB->FB_CPOLVRO
Endif

If nTipo == 1
	cOper    := STR0034 //"Compras"
	DevPurch()
Else
	cOper    := STR0045 //"Vendas"
	DevSales()
EndIf

oReport:SetTitle(STR0031 + STR0038 + cOper) //"Analise de Imposto"###" de "
oCompras:SetTotalInLine(.F.)

If nTipo == 1
	
	//���������������������������Ŀ
	//�Impirme secao de Compras   �
	//�����������������������������
	oCompras:Print()

Else
	
	dbSelectArea("TMP")
	If (TMP->(RECCOUNT()) > 0)	
	
		//Monta celulas de acordo com o periodo informado pelo usuario
		//Cria arquivo de trabalho(TMP2) para impressao
		TRCell():New(oVendas,"TIPO","TMP2"," ",/*cPicture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
		AADD(aCposTMP2,{"TIPO","C",10,0})
		While dDataR < dFinal
			nMes := Month(dDataR)
			nCont++
			cVar := "MES" + Alltrim(Str(nCont,2))
			TRCell():New(oVendas,cVar,"TMP2",MesExtenso(nMes),"@E 999,999.99",10,/*lPixel*/,/*{|| code-block de impressao }*/)
			AADD(aCposTMP2,{cVar,"N",14,2})
			dDataR := dDataR+40  // sempre caira no proximo mes
			dDataR := CTOD("01/" + StrZero(Month(dDataR),2) + Str(Year(dDataR)),"DD/MM/YYYY")
		End
		
		TRCell():New(oVendas,"TOTMES","TMP2",STR0051,"@E 999,999.99",10,/*lPixel*/,/*{|| code-block de impressao }*/) //"Ate a Data"
		
		AADD(aCposTMP2,{"TOTMES","N",14,2})
		
		aIndex2 := {"TIPO"}//JGR
		oTmpTMP2 := FWTemporaryTable():New("TMP2") //JGR
		oTmpTMP2:SetFields( aCposTMP2 )
		oTmpTMP2:AddIndex("I01", aIndex2)
		oTmpTMP2:Create()
	
		//Grava Vendas no TMP2
		RecLock("TMP2",.T.)
		TMP2->TIPO := STR0039 //"1 - VENDAS"
		
		cCodigo := AllTrim(TMP->NUM)
		cDescr  := AllTrim(TMP->DESCR)
		cALiq   := AllTrim(Str(TMP->ALIQ))
		
		nCont := 0
		TMP->(dbGotop())
		While !TMP->(EOF())
			
			nCont++
			cCampo    := "TMP2->MES" + Alltrim(Str(nCont,2))
			&cCampo   := TMP->VLRTOT
			nTotdate  += TMP->VLRTOT
			
			TMP->(DbSkip())
		end
		TMP2->TOTMES := nTotdate
		MsUnlock()
		
		TMP->(dbGotop())
		
		//Grava Impostos no TMP2
		RecLock("TMP2",.T.)
		TMP2->TIPO := STR0040 //"2 - TAXAS"
		
		nCont     := 0
		nTotdate := 0
		While !TMP->(EOF())
			
			nCont++
			cCampo    := "TMP2->MES" + Alltrim(Str(nCont,2))
			&cCampo   := TMP->VLRIMP
			nTotdate  += TMP->VLRIMP
			
			TMP->(DbSkip())
		End
		TMP2->TOTMES := nTotdate
		MsUnlock()
		
		//���������������������������Ŀ
		//�Impirme secao de Vendas    �
		//�����������������������������
		oVendas:Init()
		oReport:PrintText(STR0041 + STR(nCont,2) + STR0052 ,,10) //"Periodo: "###" meses"
		oReport:SkipLine()
		
		nLin := oReport:Row()
		oReport:PrintText(STR0053 + cEstado,nLin,10) //"Estado: "
		oReport:PrintText(STR0042 + cCodigo,nLin,300) //"Codigo: "
		oReport:PrintText(STR0043 + cDescr,nLin,600) //"Descri��o: "
		oReport:PrintText(STR0044 + cAliq,nLin,1300) //"Taxa: "
		oReport:SkipLine()
		oReport:SkipLine()
		
		oVendas:Print()
		
		TMP2->(DbCloseArea())//JGR
		If oTmpTMP2 <> Nil   //JGR
			oTmpTMP2:Delete()
			oTmpTMP2 := Nil
		Endif
	
	EndIf
			
EndIf
	
TMP->(DbCloseArea())//JGR
If oTmpTMP <> Nil   //JGR
	oTmpTMP:Delete()
	oTmpTMP := Nil
Endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MATR999   �Autor  �Ronny Ctvrtnik      � Data �  02/02/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio de analise de vendas por periodo                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5 - Estados Unidos                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Matr999R3()
Private cImposto, cEstado, dInicial, dFinal, lPagEst, nTipo, Limite, cCodCampo, cArqTmp
Private aMeses	:= {}
Private nTotMes	:= 0

tamanho     := "G"
Limite		:= 168
cDesc1 		:= STR0002
cDesc2 		:= ""
cDesc3 		:= ""
aReturn 	:= {STR0003, 1,STR0004, 1, 2, 1,"",1 }
nomeprog	:= "MATR999"
cPerg       := "MTR999"
nLastKey	:= 0
lContinua	:= .T.
wnrel    	:= "MATR999"
cString		:= "SF3"
m_pag       := 1
/*
+------------------------------------------------------------+
| Variaveis utilizadas para parametros                       |
| mv_par01           // Imposto (SFB)						 |
| mv_par02           // Estado, Tabela (12) SX5              |
| mv_par03           // Data Inicial                         |
| mv_par04           // Data Final                           |
| mv_par05           // Quebra Pag. por Estado               |
| mv_par06           // Compra ou Venda                      |
+------------------------------------------------------------+
*/
While .t.
	If ! Pergunte(cPerg,.T.)               // Pergunta no SX1
		Return
	Endif
	if Int(Round((mv_par04 - mv_par03) / 30, 0)) <= 12
		Exit
	else
		Alert(STR0005)
	endif
end
//���������������������������������������������������������������������Ŀ
//� Monta la interfase estandar con el usuario...                       �
//�����������������������������������������������������������������������
ctitulo 	:= iif(mv_par06 = 1,STR0017,STR0001)
wnrel := SetPrint(cString,wnrel,cPerg,@ctitulo,cDesc1,cDesc2,cDesc3,.T.,,,Tamanho)
If ! nLastKey == 27
	SetDefault(aReturn,cString)
	If ! nLastKey == 27
		cImposto    := AllTrim(mv_par01)
		cEstado     := AllTrim(mv_par02)
		dInicial    := mv_par03
		dFinal      := mv_par04
		lPagEst     := iif(mv_par05 = 1,.t.,.f.)
		nTipo       := mv_par06
		
		dbSelectArea("SFB")
		dbSetOrder(1)
		If dbSeek(xFilial("SFB")+cImposto)
			cCodCampo := SFB->FB_CPOLVRO
		Endif
		
		if nTipo = 1 // Purchase
			tamanho     := "M"
			Limite		:= 131
			DevPurch()
			RptStatus({||PrintPurch()})
		else // Sales
			tamanho     := "G"
			Limite		:= 168
			DevSales()
			RptStatus({||PrintSales()})
		endif
	Endif
Endif

TMP->(DbCloseArea())
FErase(cArqTmp+GetDBExtension())
FErase(cArqTmp+IndexExt())

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � DevSales     �Autor � Ronny Ctvrtnik       �Data� 02/02/01 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Seleciona dados para emissao do rtelatorio                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������
*/
Static Function DevSales()
Local aCampos, lRet, cEstcli
Local aTamAliq	:= Tamsx3('FB_ALIQ')

SF3->(dbSetOrder(1)) // prepara indice a ser usado (F3_FILIAL+DTOS(F3_ENTRADA))

lRet := .F.

dbSelectArea("SFF")
dbSetOrder(1)

aCampos:={ {"ZONFIS"      ,"C",02,0},;
{"NUM"         ,"C",06,0},;
{"DESCR"       ,"C",30,0},;
{"ALIQ"        ,"N",aTamAliq[1],aTamAliq[2]},;
{"MES"         ,"C",02,0},;
{"DATAENT"     ,"D",08,0},;
{"VLRTOT"      ,"N",17,2},;
{"VLRIMP"      ,"N",17,2} }

aIndex1 := {"ZONFIS","NUM","DATAENT"}//JGR
oTmpTMP := FWTemporaryTable():New("TMP") //JGR
oTmpTMP:SetFields( aCampos )
oTmpTMP:AddIndex("I01", aIndex1)
oTmpTMP:Create()

SF3->( dbSeek( xFilial("SF3")+Dtos(dInicial), .t. ))
While !SF3->(Eof()) .And. SF3->F3_ENTRADA <= dFinal
	If SF3->F3_TIPOMOV = "V" .And. &("SF3->F3_VALIMP" + cCodCampo) > 0
		If Empty(SF3->F3_DTCANC)
			If LocCliEFor(nTipo,SF3->F3_CLIEFOR)  // posiciona no cliente
				cEstCli := SA1->A1_EST
				If (Empty(cEstado) .Or. cEstCli = cEstado)
					dDataRef := CTOD("01/" + StrZero(Month(SF3->F3_ENTRADA),2) + Str(Year(SF3->F3_ENTRADA)),"DD/MM/YYYY")
					If !TMP->( dbSeek( cEstCli+SA1->A1_CODZON+Dtos(dDataRef) ))
						// se nao existe para esta zona fiscal, cria todas as referencias para o periodo
						CriaRefs( cEstCli, SA1->A1_CODZON)
						TMP->( dbSeek( cEstCli+SA1->A1_CODZON+Dtos(dDataRef))) // deixa posicionado no atual
					EndIf
					TMP->VLRTOT   := TMP->VLRTOT + &("SF3->F3_BASIMP" + cCodCampo) // Total do mes
					TMP->VLRIMP   := TMP->VLRIMP + &("SF3->F3_VALIMP" + cCodCampo) // Total de Impostos do Mes
				EndIf
				
			EndIf
		Endif
	EndIf
	SF3->( dbSkip())
EndDo

Return()

/*
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LocCliEFor�Autor  �Ronny Ctvrtnik      � Data �  06/02/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Localiza chave em cadastro de clientes.                    ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������
*/
Static Function LocCliEFor(ntipo,cChave)
Local lRet
lRet := .f.
If nTipo = 1  // purchase (SA2)
	dbSelectArea("SA2")
	dbSetOrder(1)
	lRet := SA2->(DbSeek(xFilial("SA2")+cChave))
Else 		  // sales (SA1)
	dbSelectArea("SA1")
	dbSetOrder(1)
	lRet := SA1->(DbSeek(xFilial("SA1")+cChave))
EndIf
Return(lRet)


/*
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LocCliEFor�Autor  �Ronny Ctvrtnik      � Data �  06/02/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Localiza chave em cadastro de clientes.                    ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������
*/
Static Function CriaRefs(cEst,cNum)
Local dDataR := CTOD("01/" + StrZero(Month(dInicial),2) + Str(Year(dInicial)),"DD/MM/YYYY")
aMeses  :={}
While dDataR < dFinal
	nTotMes ++
	AADD(aMeses, Month(dDataR))
	TMP->(dbAppend())
	TMP->ZONFIS   := cEst    // Estado
	TMP->NUM      := cNum    // Zona Fiscal
	TMP->DATAENT  := dDataR  // Data Ent.
	TMP->MES      := StrZero( Month(dDataR),2) // Mes
	SFF->( dbSeek( xFilial("SFF")+SA1->A1_CODZON+"0"+cCodCampo) )
	TMP->DESCR    := SFF->FF_CONCEPT // Descricao
	TMP->ALIQ     := SFF->FF_ALIQ // Aliquota
	TMP->VLRTOT   := 0
	TMP->VLRIMP   := 0
	dDataR := dDataR+40  // sempre caira no proximo mes
	dDataR := CTOD("01/" + StrZero(Month(dDataR),2) + Str(Year(dDataR)),"DD/MM/YYYY")
EndDo

Return


/*
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrintSales�Autor  �Ronny Ctvrtnik      � Data �  02/02/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetua a impressao do relatorio                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������
*/
Static Function PrintSales()

Local aValTot[14], aValImp[14], aValVlrTot[13], aValImpTot[13], SumarizaTot[13], SumarizaImp[13]
Local i := 0

Private nLin := 0

Afill( aValTot, 0)
Afill( aValImp, 0)
Afill( aValVlrTot, 0)
Afill( aValImpTot, 0)
Afill( SumarizaTot, 0)
Afill( SumarizaImp, 0)
SetRegua(TMP->(RECCOUNT()))
TMP->(dbGotop())
M999Cabec(cTitulo)
while ! TMP->(EOF()) .And. ! lAbortPrint
	cZonAnt := TMP->ZONFIS
	lTemReg := .f.
	while TMP->ZONFIS = cZonAnt // Varre Estados
		IncRegua()
		
		if nLin >= 80
			M999Rodape()
			M999Cabec(cTitulo)
		endif
		@ nLin,001 PSAY STR0007 + AllTrim(TMP->ZONFIS)
		@ nLin,015 PSAY STR0008 + AllTrim(TMP->NUM)
		@ nLin,030 PSAY STR0009 + SubStr(AllTrim(TMP->DESCR),1,34)
		@ nLin,065 PSAY STR0010 + AllTrim(Str(TMP->ALIQ))
		cNumAnt := TMP->NUM
		nLin++
		nInd := 1
		while TMP->ZONFIS = cZonAnt .and. TMP->NUM = cNumAnt // Varre meses
			@ nLin,(nInd*12) PSAY TMP->VLRTOT Picture PesqPict("SF3","F3_BASIMP1",7)
			aValImp[nInd] += TMP->VLRIMP
			aValImpTot[nInd] += TMP->VLRIMP
			aValVlrTot[nInd] += TMP->VLRTOT
			nInd++
			aValTot[13] += TMP->VLRTOT
			aValImpTot[13] += TMP->VLRIMP
			aValVlrTot[13] += TMP->VLRTOT
			TMP->(DbSkip())
		end
		@ nLin,((Len(aMeses) + 1) * 12) PSAY aValTot[13] Picture PesqPict("SF3","F3_BASIMP1",7)
		aValTot[13] := 0
		nLin++
		i := 0
		For i = 1 to len(aMeses)
			@ nLin,(i*12) PSAY aValImp[i] Picture PesqPict("SF3","F3_BASIMP1",7)
			aValImp[13] += aValImp[i]
		Next
		@ nLin,((Len(aMeses) + 1) * 12) PSAY aValImp[13] Picture PesqPict("SF3","F3_BASIMP1",7)
		Afill( aValImp, 0)
	end
	
	nLin+=2
	@ (nLin++), 01 PSAY STR0011 + cZonAnt
	@ nlin,001 PSAY Replicate("-",Limite)
	nLin++
	//
	// Totaliza Valores
	//
	@ nLin,001 PSAY STR0012
	i := 0
	for i := 1 to len(aMeses)
		@ nLin,(i*12) PSAY aValVlrTot[i] Picture PesqPict("SF3","F3_BASIMP1",7)
		SumarizaTot[i] += aValVlrTot[i]
	next
	@ nLin,((Len(aMeses) + 1) * 12) PSAY aValVlrTot[13] Picture PesqPict("SF3","F3_BASIMP1",7)
	SumarizaTot[13] += aValVlrTot[13]
	Afill( aValVlrTot, 0)
	nLin++
	//
	// Totaliza Taxas
	//
	@ nLin,001 PSAY STR0013
	i := 0
	for i := 1 to len(aMeses)
		@ nLin,(i*12) PSAY aValImpTot[i] Picture PesqPict("SF3","F3_BASIMP1",7)
		SumarizaImp[i] += aValImpTot[i]
	next
	@ nLin,((Len(aMeses) + 1) * 12) PSAY aValImpTot[13] Picture PesqPict("SF3","F3_BASIMP1",7)
	SumarizaImp[13] += aValImpTot[13]
	Afill( aValImpTot, 0)
	
	if lPagEst
		m999Rodape()
		M999Cabec(cTitulo)
	Else
		nLin+=3
	endif
EndDo

If Empty( cEstado)  // todos os estados, entao sumariza
	nLin++
	@ (nLin++), 01 PSAY STR0014
	@ nlin,001 PSAY Replicate("-",Limite)
	nLin++
	//
	// Totaliza Todos os Valores
	//
	@ nLin,001 PSAY STR0012
	i := 0
	for i := 1 to len(aMeses)
		@ nLin,(i*12) PSAY SumarizaTot[i] Picture PesqPict("SF3","F3_BASIMP1",7)
	next
	@ nLin,((Len(aMeses) + 1) * 12) PSAY SumarizaTot[13] Picture PesqPict("SF3","F3_BASIMP1",7)
	Afill( SumarizaTot, 0)
	nLin++
	//
	// Totaliza Todas as Taxas
	//
	@ nLin,001 PSAY STR0013
	i := 0
	For i := 1 To Len(aMeses)
		@ nLin,(i*12) PSAY SumarizaImp[i] Picture PesqPict("SF3","F3_BASIMP1",7)
	Next
	@ nLin,((Len(aMeses) + 1) * 12) PSAY SumarizaImp[13] Picture PesqPict("SF3","F3_BASIMP1",7)
	Afill( SumarizaImp, 0)
	
	nLin++
EndIf
M999Rodape()
SetPrc(0,0)
Return Nil

/*
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �m999Cabec �Autor  �Ronny Ctvrtnik      � Data �  05/02/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera o cabecalho do relatorio                              ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������
*/
Static Function M999Cabec(cTitulo)
Local i := 0
if nTipo = 1
	nLin := cabec(cTitulo+ " - " + dToc(dInicial) + " - " + dToc(dFinal),;
	" ",;
	" ",;
	nomeprog,;
	tamanho,;
	18)
else
	nLin := cabec((cTitulo + " - " + dToc(dInicial) + " - " + dToc(dFinal)),;
	STR0002 + AllTrim(Str(nTotMes)) + STR0015,;
	" ",;
	nomeprog,;
	tamanho,;
	18)
	nLin++
	@ nLin,001 PSAY Replicate("-",Limite)
	nLin++
	i := 0
	for i := 1 to len(aMeses)
		@ nLin,(i*12) PSAY MesExtenso(aMeses[i])
	next
	@ nLin,(i*12) PSAY STR0016
	nLin++
	@ nLin,001 PSAY Replicate("-",Limite)
	nLin++
endif
Return Nil

/*
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �m999Rodape�Autor  �Ronny Ctvrtnik      � Data �  05/02/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetua a impressao do relatorio                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������
*/
Static Function M999Rodape()
Roda(1," ",tamanho)
nlin :=0
Return Nil

/*
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � DevPurch     �Autor � Ronny Ctvrtnik       �Data� 08/02/01 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Seleciona dados para emissao do rtelatorio compras         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������
*/
Static Function DevPurch()
Local aCampos, lRet, cZonFis
Private aMeses := {}

lRet := .F.

dbSelectArea("SFF")
dbSetOrder(3)
dbSeek(xFilial("SFF")+cImposto)
cZonFis := GetMV("MV_ZONFIS")
while ! SFF->(Eof())
	if SFF->FF_IMPOSTO = cImposto .and.;
		SFF->FF_ZONFIS = cEstado .and.;
		Alltrim(SFF->FF_NUM) = Alltrim(cZonFis)
		exit
	endif
	SFF->(DbSkip())
enddo
aCampos:={ {"CODCLI"      ,"C", 06,0},;
{"NOME"        ,"C", 20,0},;
{"NFISCAL"     ,"C", 12,0},;
{"SERIE"       ,"C", 03,0},;
{"EMISSAO"     ,"D", 08,0},;
{"VALDES"      ,"N", 17,2},;
{"BASIMP"      ,"N", 17,2},;
{"VAMERC"      ,"N", 17,2} }

aIndex1 := {"CODCLI","NOME","NFISCAL"}//JGR
oTmpTMP := FWTemporaryTable():New("TMP") //JGR
oTmpTMP:SetFields( aCampos )
oTmpTMP:AddIndex("I01", aIndex1)
oTmpTMP:Create()

SF3->( dbSeek( xFilial("SF3")+Dtos(dInicial), .t. ))
While !SF3->(Eof()) .And. SF3->F3_ENTRADA <= dFinal
	If 	SF3->F3_TIPOMOV = "C" .and.;
		&("SF3->F3_VALIMP" + cCodCampo) = 0 .and. SF3->F3_VALCONT <> 0
		TMP->(dbAppend())
		TMP->CODCLI		:= SF3->F3_CLIEFOR //Codigo clientes
		LocCliEFor(nTipo,SF3->F3_CLIEFOR)
		TMP->NOME		:= SA2->A2_NOME //Nome Cliente
		TMP->NFISCAL	:= SF3->F3_NFISCAL // Nota
		TMP->SERIE		:= SF3->&(SerieNfId("SF3",3,"F3_SERIE")) // Serie
		TMP->EMISSAO	:= SF3->F3_EMISSAO // Emissao
		TMP->VALDES		:= ((SF3->F3_VALCONT * SFF->FF_ALIQ) / 100)
		TMP->BASIMP		:= SF3->F3_VALCONT // Total da nota
		TMP->VAMERC		:= SF3->F3_VALCONT // Valor das mercadorias
	endif
	SF3->(DbSkip())
enddo

Return()

/*
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrintPurch�Autor  �Ronny Ctvrtnik      � Data �  08/02/01  ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetua a impressao do relatorio compra                     ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������
*/
Static Function PrintPurch()

Private nLin := 0

SetRegua(TMP->(RECCOUNT()))
TMP->(dbGotop())
M999Cabec(cTitulo)
nLin++
@ nLin,001 PSAY Replicate("-",Limite)
nLin++
//VOICE                 SERIE     DATE                SALE TAX            BASE VALUE     TOTAL OF GOOD
//                                            9.999.999.999,99     99.999.999.999,99 99.999.999.999,99
@ nLIn,001 PSAY STR0020 // INVOICE
@ nLin,025 PSAY STR0021 // SERIE
@ nLin,035 PSAY STR0022 // DATE
@ nLin,055 PSAY STR0023 // SALE TAX
@ nLin,075 PSAY STR0024 // BASE VALUE
@ nLin,090 PSAY STR0025 // TOTAL OF GOOD
nLin++
@ nLin,001 PSAY STR0027 // NUMBER
@ nLin,035 PSAY STR0028 // ISSUE
nLin++
@ nLin,001 PSAY Replicate("-",Limite)
nLin++
nGerTotValDes := 0
nGerTotBasImp := 0
nGerTotVaMerc := 0
while ! TMP->(EOF())
	cCodCli := TMP->CODCLI
	nTotValDes := 0
	nTotBasImp := 0
	nTotVaMerc := 0
	nLin++
	//@ nlin,001 PSAY STR0018 + " " + STR0026 // CODE SUPPLIER
	//@ nLin,030 PSAY STR0019 // COMP. NAME
	//nLin++
	@ nLin,001 PSAY STR0026 + " : " + AllTrim(TMP->CODCLI)
	@ nLin,020 PSAY AllTrim(TMP->NOME)
	nLin++
	@ nLin,001 PSAY Replicate("-",Limite)
	nLin++
	while TMP->CODCLI = cCodCli // Varre Clientes
		IncRegua()
		if nLin >= 80
			M999Rodape()
			M999Cabec(cTitulo)
			nLin++
			@ nLin,001 PSAY Replicate("-",Limite)
			nLin++
			//@ nLin,001 PSAY STR0017 // Sales Tax Analisys - Inflow
			@ nLIn,001 PSAY STR0020 // INVOICE
			@ nLin,025 PSAY STR0021 // SERIE
			@ nLin,035 PSAY STR0022 // DATE
			@ nLin,055 PSAY STR0023 // SALE TAX
			@ nLin,075 PSAY STR0024 // BASE VALUE
			@ nLin,091 PSAY STR0025 // TOTAL OF GOOD
			nLin++
			@ nLin,001 PSAY STR0027 // NUMBER
			@ nLin,035 PSAY STR0028 // ISSUE
			nLin++
			@ nLin,001 PSAY Replicate("-",Limite)
			nLin++
			//@ nlin,001 PSAY STR0018 // CODE
			//@ nLin,020 PSAY STR0019 // COMP. NAME
			//nLin++
			@ nLin,001 PSAY STR0026 + " : " + AllTrim(TMP->CODCLI)
			@ nLin,020 PSAY AllTrim(TMP->NOME)
			nLin++
			@ nLin,001 PSAY Replicate("-",Limite)
			nLin++
		endif
		@ nLin,001 PSAY TMP->NFISCAL
		@ nLin,025 PSAY TMP->SERIE
		@ nLin,035 PSAY TMP->EMISSAO
		@ nLin,047 PSAY TMP->VALDES Picture PesqPict("SF3","F3_BASIMP1",16)
		@ nLin,068 PSAY TMP->BASIMP Picture PesqPict("SF3","F3_BASIMP1",17)
		@ nLin,086 PSAY TMP->VAMERC Picture PesqPict("SF3","F3_BASIMP1",17)
		nTotValDes += TMP->VALDES
		nTotBasImp += TMP->BASIMP
		nTotVaMerc += TMP->VAMERC
		nLin++
		TMP->(DbSkip())
	enddo
	nLin++
	@ nLin,035 PSAY STR0029 // "TOTAL"
	@ nLin,047 PSAY nTotValDes Picture PesqPict("SF3","F3_BASIMP1",16)
	@ nLin,068 PSAY nTotBasImp Picture PesqPict("SF3","F3_BASIMP1",17)
	@ nLin,086 PSAY nTotVaMerc Picture PesqPict("SF3","F3_BASIMP1",17)
	nLin++
	@ nLin, 01 PSAY Replicate("-",Limite)
	nLin++
	nGerTotValDes += nTotValDes
	nGerTotBasImp += nTotBasImp
	nGerTotVaMerc += nTotVaMerc
enddo
nLin++
@ nLin,035 PSAY STR0030 //"GENER. TOTAL"
@ nLin,047 PSAY nGerTotValDes Picture PesqPict("SF3","F3_BASIMP1",16)
@ nLin,068 PSAY nGerTotBasImp Picture PesqPict("SF3","F3_BASIMP1",17)
@ nLin,086 PSAY nGerTotVaMerc Picture PesqPict("SF3","F3_BASIMP1",17)
nLin++
@ nLin, 01 PSAY Replicate("-",Limite)
nLin++
M999Rodape()
SetPrc(0,0)

Return Nil
