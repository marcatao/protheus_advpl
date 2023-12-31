#INCLUDE "PROTHEUS.CH"
#INCLUDE "MATR091.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR091  � Autor �Nereu Humberto Junior  � Data � 28.06.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da rela��o de Compras                              ���
���          � Programa baseado no MATR090.                               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR091(void)                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � PLANO DE MELHORIA CONTINUA        �Programa: MATR091.PRW   ���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data              BOPS          ���
�������������������������������������������������������������������������Ĵ��
���      01  �                          �                                 ���
���      02  � Nereu Humberto Junior    � 02/04/07        00000119708     ���
���      03  �                          �                                 ���
���      04  �                          �                                 ���
���      05  � Nereu Humberto Junior    � 02/04/07        00000119708     ���
���      06  �                          �                                 ���
���      07  �                          �                                 ���
���      08  �                          �                                 ���
���      09  �                          �                                 ���
���      10  �                          �                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Function MATR091()
	
	Local oReport := Nil
	
	//�����������������������Ŀ
	//�Interface de impressao �
	//�������������������������
	oReport := ReportDef()
	oReport:PrintDialog()

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Nereu Humberto Junior  � Data �28.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport	:= Nil 
Local oSection1	:= Nil
Local cAliasSA2	:= GetNextAlias()
Local cTamVlr	:= TamSX3('D1_TOTAL')[1]
Local cTamCod	:= TamSX3('D1_FORNECE')[1]+5

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
oReport:= TReport():New("MATR091",STR0003,"MTR091", {|oReport| ReportPrint(oReport,cAliasSA2)},STR0001+" "+STR0002) //"Relacao de compras (fornecedor) "##"Este relat�rio ir� imprimir a rela��o de itens "##"referentes as compras e devolucoes. " 
oReport:SetTotalInLine(.F.)
oReport:SetLandscape(.T.)

Pergunte("MTR091",.F.)

oSection1 := TRSection():New(oReport,STR0021,{"SA2","SF1","SF2","SD1","SD2","SB1"}) //"Relacao de compras (fornecedor) "
oSection1 :SetTotalInLine(.F.)
oSection1 :SetHeaderPage()

TRCell():New(oSection1,"cDoc","   ",/*Titulo*/,/*Picture*/,TAMSX3('D1_DOC')[1]+5,/*lPixel*/,/*{|| code-block de impressao }*/)
//oSection1:Cell("cDoc"):GetFieldInfo("D1_DOC")
TRCell():New(oSection1,"cProduto","   ",/*Titulo*/,/*Picture*/,TAMSX3('D1_COD')[1]+15,/*lPixel*/,/*{|| code-block de impressao }*/)
//oSection1:Cell("cProduto"):GetFieldInfo("D1_COD")
TRCell():New(oSection1,"cDescri","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("cDescri"):GetFieldInfo("B1_DESC")
TRCell():New(oSection1,"nQuant","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("nQuant"):GetFieldInfo("D1_QUANT")
TRCell():New(oSection1,"cUm","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("cUm"):GetFieldInfo("B1_UM")
oSection1:Cell("cUm"):SetTitle(STR0024) //"UM"

TRCell():New(oSection1,"nPrUnit","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("nPrUnit"):GetFieldInfo("D1_VUNIT")
TRCell():New(oSection1,"nImposto","   ",STR0015,PesqPict("SD1","D1_TOTAL"),cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/) //"Impostos"
TRCell():New(oSection1,"nValor","   ",STR0016,PesqPict("SD1","D1_TOTAL"),cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/) //"Valor"
TRCell():New(oSection1,"cCliFor","   ",STR0017,PesqPict("SD1","D1_FORNECE"),cTamCod,/*lPixel*/,/*{|| code-block de impressao }*/) //"Codigo"
TRCell():New(oSection1,"cRazSoc","   ",/*Titulo*/,/*Picture*/,/*Tamanho/*,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("cRazSoc"):GetFieldInfo("A2_NOME")
oSection1:Cell("cRazSoc"):SetSize(If(cPaisLoc == "MEX",20,28))
oSection1:Cell("cRazSoc"):SetLineBreak() 
TRCell():New(oSection1,"cTp","   ",STR0018+CRLF+STR0027,"@!",1,/*lPixel*/,/*{|| code-block de impressao }*/) //TP  NF
TRCell():New(oSection1,"cTe","   ",STR0019,"@!",3,/*lPixel*/,/*{|| code-block de impressao }*/) //TE
TRCell():New(oSection1,"cTipo","   ",STR0020,"@!",2,/*lPixel*/,/*{|| code-block de impressao }*/) //Tp
TRCell():New(oSection1,"cGrupo","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("cGrupo"):GetFieldInfo("D1_GRUPO")
oSection1:Cell("cGrupo"):SetTitle(STR0025) //"Grp"

TRCell():New(oSection1,"cDtDigit","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("cDtDigit"):GetFieldInfo("D1_DTDIGIT")  
oSection1:Cell("cDtDigit"):SetTitle(STR0026) //"Fech.Dig."

TRCell():New(oSection1,"nCusto","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("nCusto"):GetFieldInfo("D1_CUSTO")
	
Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Nereu Humberto Junior  � Data �21.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasSA2)

Local oSection1	:= oReport:Section(1) 
Local nTotFat	:= 0 //Total por fatura
Local nTotCli	:= 0 //Total por cliente
Local nTotEnt	:= 0 //Total por movimento
Local nTotSai	:= 0 //Total por movimento
Local lQuebra 	:= .T.//Separacao de ENTRADAS / SAIDAS
Local lImpLin	:= .F.

Private cProdDe		:= MV_PAR01
Private cProdAte	:= MV_PAR02
Private dDataDe		:= MV_PAR03
Private dDataAte	:= MV_PAR04
Private cForneDe	:= MV_PAR05 
Private cForneAte	:= MV_PAR06
Private nMoeda		:= MV_PAR07
Private lDifMoeda	:= MV_PAR08 == 1
Private nDecs		:= Msdecimais(nMoeda) //casas decimais utilizadas na moeda da impressao
Private dEmissao	:= dDataBase
Private cPictValor	:= PesqPict("SD2","D2_TOTAL")

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SA2")
dbSetOrder(1) //A2_FILIAL+A2_COD+A2_LOJA

//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �	
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//�Query do relat�rio da secao 1                                           �
//��������������������������������������������������������������������������
oReport:Section(1):BeginQuery()	

BeginSql Alias cAliasSA2

	SELECT A2_FILIAL, A2_COD, A2_LOJA, A2_NOME
	
	FROM %table:SA2% SA2
	
	WHERE A2_FILIAL = %xFilial:SA2% AND 
		  A2_COD >= %Exp:cForneDe% AND 
		  A2_COD <= %Exp:cForneAte% AND 	 	  
		  SA2.%NotDel% 
		  
	ORDER BY %Order:SA2% 
		
EndSql 
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
//�Metodo TrPosition()                                                     �
//�                                                                        �
//�Posiciona em um registro de uma outra tabela. O posicionamento ser�     �
//�realizado antes da impressao de cada linha do relat�rio.                �
//�                                                                        �
//�                                                                        �
//�ExpO1 : Objeto Report da Secao                                          �
//�ExpC2 : Alias da Tabela                                                 �
//�ExpX3 : Ordem ou NickName de pesquisa                                   �
//�ExpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexe-�
//�        cutada.                                                         �
//�                                                                        �				
//��������������������������������������������������������������������������

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
oReport:SetMeter(SA2->(LastRec()))

oSection1:Init()
dbSelectArea(cAliasSA2)
While !oReport:Cancel() .And. (cAliasSA2)->(!Eof()) 

	If oReport:Cancel()
		Exit
	EndIf
	
	dbSelectArea("SF1")
	dbSetOrder(2) //F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC
	MsSeek(xFilial("SF1")+(cAliasSA2)->A2_COD+(cAliasSA2)->A2_LOJA)
	nTotCli := 0
	lQuebra	:= .T.
    
	Do While ! Eof() .And. F1_FORNECE == (cAliasSA2)->A2_COD  .And. F1_LOJA == (cAliasSA2)->A2_LOJA
		If F1_DTDIGIT >= dDataDe .And. F1_DTDIGIT <= dDataAte .And. Alltrim(F1_ESPECIE)=="NF" .And.;
			(lDifMoeda .Or. (!lDifMoeda .And. nMoeda == F1_MOEDA))
			dEmissao:= F1_DTDIGIT
			nTotFat	:= ImpDetCel("SF1",lQuebra,oReport,oSection1)
			If  nTotFat > 0
				oReport:PrintText(STR0009+TransForm(nTotFat,cPictValor)) //"Total da fatura ->"
				lQuebra := .F.
				nTotCli += nTotFat
				nTotEnt	+= nTotFat
			EndIf				
		Endif		
		SF1->(dbskip())
	EndDo	
	If nTotCli > 0
		oReport:PrintText(STR0010+TransForm(nTotCli,cPictValor)) //"Total de entradas->"
		lImpLin	:= .T.
	EndIf		

	dbSelectArea("SF2")
	dbSetOrder(2) //F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE+F2_TIPO+F2_ESPECIE
	dbSeek(xFilial("SF2")+(cAliasSA2)->A2_COD)
	lQuebra :=	.T.	
	nTotCli	:=	0

	Do While ! Eof() .And. F2_CLIENTE == (cAliasSA2)->A2_COD  .And. F2_LOJA == (cAliasSA2)->A2_LOJA
		If F2_EMISSAO >= dDataDe .And. F2_EMISSAO <= dDataAte .And. Trim(F2_ESPECIE) == "NCP" .And.;
			(lDifMoeda .Or. (!lDifMoeda .And. nMoeda == F2_MOEDA))
		
			If !Empty(F2_DTDIGIT)
				dEmissao:= F2_DTDIGIT
			Else
				dEmissao:= F2_EMISSAO
			EndIf
			
			nTotFat	:=	ImpDetCel("SF2",lQuebra,oReport,oSection1)
			lQuebra	:= .F.
			If nTotFat > 0
				oReport:PrintText(STR0009+TransForm(nTotFat,cPictValor)) //"Total da fatura ->"
				nTotCli += nTotFat
				nTotSai	+= nTotFat
			EndIf				
		Endif		

		SF2->(dbskip())
	EndDo	

	If nTotCli > 0
		oReport:PrintText(STR0011+TransForm(nTotCli,cPictValor)) //"Total de saidas ->"
		lImpLin	:= .T.
	EndIf		
	
	oReport:IncMeter()

	dbSelectArea(cAliasSA2)
	(cAliasSA2)->(dbSkip())	

	If lImpLin	
		 oReport:SkipLine()
		 oReport:ThinLine()
		 oReport:SkipLine()
	EndIf		
	lImpLin	:= .F.	
EndDo
oReport:PrintText(STR0010+TransForm(nTotEnt,cPictValor)+Space(50)+STR0011+TransForm(nTotSai,cPictValor)+Space(50)+STR0012+TransForm(nTotEnt-nTotSai,cPictValor)) //"Total de entradas->" - "Total salidas ->" - "DIFERENCIA  -> "
oReport:ThinLine()
oSection1:Finish()

Return NIL

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ImpDetCel � Autor � Nereu Humberto Junior � Data � 28.06.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime Total da Nota Fiscal                               ���
���          � Arquivo de origem da nota.                                 ���
���parametro � cTab = Arquivo de processamento                            ���
���          � lQuebra = Imprime a descricao da quebra?                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Somatoria dos itens                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR091                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function ImpDetCel(cTab,lQuebra,oReport,oSection1)

Local cTabSD	:= IIf(cTab == "SF2","SD2","SD1")
Local cPrefSF	:= Right(cTab,2)
Local cPrefSD	:= Right(cTabSD,2)
Local nImpTot	:= 0
Local nTaxa		:= 0
Local nMoedaFat	:= 0
Local nTotItens	:= 0
Local nVlrItem	:= 0
Local nVlrTot	:= 0
Local dDtDig	:= dDataBase
Local aImpostos	:= {}
Local nY		:= 0
Local lFirst	:= .T.

If cTab == "SF1"
	dDtDig		:= SF1->F1_DTDIGIT
	nTaxa   	:= SF1->F1_TXMOEDA
	nMoedaFat	:= SF1->F1_MOEDA
Else
	dDtDig		:= SF2->F2_EMISSAO
	nTaxa   	:= SF2->F2_TXMOEDA	
	nMoedaFat	:= SF2->F2_MOEDA
EndIf  

dbSelectArea(cTabSD)
If cTabSD == "SD2"
	dbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
Else
	dbSetOrder(1) //D2_FILIAL+D2_COD+D2_LOCAL+D2_NUMSEQ
EndIf
dbSeek(xFilial()+&(cTab+"->"+cPrefSF+"_DOC")+&(cTab+"->"+cPrefSF+"_SERIE")+IIF(cTabSD == "SD2",&(cTab+"->"+cPrefSF+"_CLIENTE"),&(cTab+"->"+cPrefSF+"_FORNECE")))
	
While !Eof() .And. &(cPrefSD+"_FILIAL")+&(cPrefSD+"_DOC")+&(cPrefSD+"_SERIE")+IIF(cTabSD == "SD2",&(cPrefSD+"_CLIENTE"),&(cPrefSD+"_FORNECE"))==;
	xFilial()+&(cTab+"->"+cPrefSF+"_DOC")+&(cTab+"->"+cPrefSF+"_SERIE")+IIF(cTabSD == "SD2",&(cTab+"->"+cPrefSF+"_CLIENTE"),&(cTab+"->"+cPrefSF+"_FORNECE")) 	
		
	If &(cPrefSD+"_COD") < cProdDe .Or. &(cPrefSD+"_COD") > cProdAte 
		dbSkip()
		Loop
	EndIf

	nImpTot	:=	0
	aImpostos := TesImpInf(&(cTabSD+"->"+cPrefSD+"_TES"))
	If lFirst
		If cTab == "SF1" .And. lQuebra
			oReport:SkipLine()
			oReport:PrintText(STR0013) //"<-ENTRADAS->"
			oReport:SkipLine()
		ElseIf cTab == "SF2" .And. lQuebra
			oReport:SkipLine()
			oReport:PrintText(STR0014) //"<-S A I D A S->"
			oReport:SkipLine()
		EndIf		
		lFirst := .F.
	Endif	

	For nY:=1 to Len(aImpostos)
		cCampImp:= cTabSD+"->"+(aImpostos[nY][2])
		nImpos	:= &cCampImp
		nImpTot	+= xMoeda(nImpos,nMoedaFat,nMoeda,dDtDig,nDecs+1,nTaxa)
	Next
	
	SB1->(dbSeek(xFilial("SB1")+&(cTabSD+"->"+cPrefSD+"_COD")))
	
	oSection1:Cell("cDoc"):SetValue(&(cPrefSD+"_DOC"))
	oSection1:Cell("cProduto"):SetValue(&(cPrefSD+"_COD"))
	oSection1:Cell("cDescri"):SetValue(SB1->B1_DESC)
	oSection1:Cell("nQuant"):SetValue(&(cPrefSD+"_QUANT"))
	oSection1:Cell("cUm"):SetValue(SB1->B1_UM)
	If cTab == "SF1"
		nVlrItem	:= xMoeda(D1_VUNIT,nMoedaFat,nMoeda,dDtDig,nDecs+1,nTaxa)
	Else
		nVlrItem	:= xMoeda(D2_PRCVEN,nMoedaFat,nMoeda,dDtDig,nDecs+1,nTaxa)
	EndIf			
	oSection1:Cell("nPrUnit"):SetValue(nVlrItem)
	oSection1:Cell("nImposto"):SetValue(nImpTot)
	
	nVlrTot := xMoeda( &(cPrefSD+"_TOTAL"),nMoedaFat,nMoeda,dDtDig,nDecs+1,nTaxa)
	oSection1:Cell("nValor"):SetValue(nVlrTot)
	nTotItens +=  nVlrTot
	If cTab == "SF1"
		SA2->(dbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA))
		oSection1:Cell("cCliFor"):SetValue(SD1->D1_FORNECE)
	Else
		SA2->(dbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA))
		oSection1:Cell("cCliFor"):SetValue(SD2->D2_CLIENTE)
	EndIf	
	oSection1:Cell("cRazSoc"):SetValue(SA2->A2_NOME)
	oSection1:Cell("cTp"):SetValue(&(cPrefSD+"_TIPO"))
	oSection1:Cell("cTe"):SetValue(&(cPrefSD+"_TES"))
	oSection1:Cell("cTipo"):SetValue(&(cPrefSD+"_TP"))
	oSection1:Cell("cGrupo"):SetValue(&(cPrefSD+"_GRUPO"))
	oSection1:Cell("cDtDigit"):SetValue(dEmissao)
	If cTab <> "SF1"	
		oSection1:Cell("nCusto"):SetValue(&("D2_CUSTO"+Alltrim(Str(nMoeda))))
	Else
		If nMoeda == 1
			oSection1:Cell("nCusto"):SetValue(SD1->D1_CUSTO)
		Else
			oSection1:Cell("nCusto"):SetValue(&("D1_CUSTO"+Alltrim(Str(nMoeda))))
		EndIf
	EndIf		
	oSection1:PrintLine()
	dbSkip()
EndDo

Return nTotItens
