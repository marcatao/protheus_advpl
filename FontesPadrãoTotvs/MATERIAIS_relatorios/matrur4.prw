#INCLUDE "MATRUR4.ch"
#INCLUDE "Protheus.ch"

//��������������������������������������Ŀ
//� Defines das posicoes do array aItens �
//����������������������������������������
#DEFINE _DATA		1
#DEFINE _DOCTO		2
#DEFINE _CLIENTE	3
#DEFINE _VALOR 		4
#DEFINE _IMEBAB  	5
#DEFINE _IMEBA2  	6
#DEFINE _IMEBA4  	7
#DEFINE _DESCGAST  8
#DEFINE _RETENC		9
#DEFINE _VALLIQ 	10
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MATRUR4   � Autor �Sergio S. Fuzinaka     � Data � 22.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Livros Fiscais de Compras Hacienda - IMEBA		          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Uruguai                                                     ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MATRUR4()

Local oReport

If TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	MatrUr4R3()
EndIf

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef  � Autor �Sergio S. Fuzinaka     � Data �10.05.2006���
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
Local oEmpresa
Local oLinha
Local cReport	:= "MATRUR4"
Local cPerg		:= "MTRUR4"
Local cTitulo	:= OemToAnsi(STR0023)
Local cDesc		:= OemToAnsi(STR0024)

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
oReport:=TReport():New(cReport,cTitulo,cPerg,{|oReport| ReportPrint(oReport)},cDesc)
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

//�����������������������������Ŀ
//�Secao 1 - Cabecalho          �
//�������������������������������
oEmpresa:=TRSection():New(oReport,OemToAnsi(STR0037),{"SM0"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oEmpresa:SetTotalInLine(.F.)
TRCell():New(oEmpresa,"M0_NOMECOM","SM0",OemToAnsi(STR0037),/*Picture*/,40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oEmpresa,"M0_ENDENT","SM0",OemToAnsi(STR0038),/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oEmpresa,"M0_CGC","SM0",OemToAnsi(STR0039),/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/)

//�����������������������������Ŀ
//�Secao 2 - Detalhe            �
//�������������������������������
oLinha:=TRSection():New(oReport,OemToAnsi(STR0040),{"SF3","SA2"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oLinha:SetTotalInLine(.F.)
TRCell():New(oLinha,"F3_ENTRADA","SF3",OemToAnsi(STR0027),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"F3_NFISCAL","SF3",OemToAnsi(STR0028),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"A2_NOME","",OemToAnsi(STR0029),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"VALOR","",OemToAnsi(STR0030),PesqPict("SF3","F3_VALCONT"),TamSx3("F3_VALCONT")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"IMEBAB","",OemToAnsi(STR0031),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"IMEBA2","",OemToAnsi(STR0032),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"IMEBA4","",OemToAnsi(STR0033),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"DESCGAST","",OemToAnsi(STR0034),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"RETENC","",OemToAnsi(STR0035),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"VALLIQ","",OemToAnsi(STR0036),PesqPict("SF3","F3_VALCONT"),TamSx3("F3_VALCONT")[1],/*lPixel*/,/*{|| code-block de impressao }*/)

//�����������������������������Ŀ
//�Totais                       �
//�������������������������������
TRFunction():New(oLinha:Cell("VALOR"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("IMEBAB"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("IMEBA2"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("IMEBA4"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("DESCGAST"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("RETENC"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("VALLIQ"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)

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

Local cCabec	:= OemToAnsi(STR0023)+OemToAnsi(STR0025)+DtoC(mv_par01)+OemToAnsi(STR0026)+DtoC(mv_par02)
Local aImpostos	:= {}
Local cAliasSF3	:= "SF3"
Local cChave	:= ""
Local cClieFor	:= ""
Local nDescG	:= 0
Local nI		:= 0
Local nZ		:= 0
Local cNomeCom	:= ""
Local cEndEnt	:= ""
Local cCGC		:= ""
Local dEntrada	:= CtoD("")
Local cNFiscal	:= ""
Local cNome		:= ""
Local nValor	:= 0
Local nIMEBAB	:= 0
Local nIMEBA2	:= 0
Local nIMEBA4	:= 0
Local nDescGast	:= 0
Local nRetenc	:= 0
Local nValLiq	:= 0
Local aItens	:= {}
				
//�������������������������������������������������������Ŀ
//�Altera o titulo para impressao                         �
//���������������������������������������������������������
oReport:SetTitle(cCabec)

//�������������������������������������������������������Ŀ
//�Monta aImpostos com as informacoes de cada imposto     �
//���������������������������������������������������������
dbSelectArea("SFB")
dbSetOrder(1)
dbGoTop()

AADD(aImpostos,{"BA1",""})                
AADD(aImpostos,{"BA2",""})                
AADD(aImpostos,{"BA3",""})
AADD(aImpostos,{"TCF",""})
While !SFB->(Eof()) 
	If aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]}) > 0
		aImpostos[aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]})][2] := SFB->FB_CPOLVRO
	EndIf	
	dbSkip()
Enddo                 
aSort(aImpostos,,,{|x,y| x[2] < y[2]})

//������������������������������������������������������������������������Ŀ
//�Filtragem do relatorio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SF3")
dbSetOrder(1)

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)

	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(2):BeginQuery()	
	
	cAliasSF3 := GetNextAlias()
		
	BeginSql Alias cAliasSF3
		SELECT SF3.*
		FROM %table:SF3% SF3
		WHERE F3_FILIAL = %xFilial:SF3%	AND 
			F3_ENTRADA	>=	%Exp:mv_par01%	AND 
			F3_ENTRADA	<=	%Exp:mv_par02%	AND 
			F3_TIPOMOV	=	'C'				AND 
			SF3.%NotDel% 
		ORDER BY %Order:SF3%
	EndSql 

	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//��������������������������������������������������������������������������
	oReport:Section(2):EndQuery(/*Array com os parametros do tipo Range*/)
		
#ELSE

	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeAdvplExpr(oReport:uParam)

	cCondicao := "F3_FILIAL == '"+xFilial("SF3")+"' .And. "
	cCondicao += "F3_TIPOMOV == 'C' .And. "
	cCondicao += "Dtos(F3_ENTRADA) >= '"+Dtos(mv_par01)+"' .And. "
	cCondicao += "Dtos(F3_ENTRADA) <= '"+Dtos(mv_par02)+"'"

	oReport:Section(2):SetFilter(cCondicao,IndexKey())
	
#ENDIF		

oReport:Section(1):Cell("M0_NOMECOM"):SetBlock({|| cNomeCom})
oReport:Section(1):Cell("M0_ENDENT"):SetBlock({|| cEndEnt})
oReport:Section(1):Cell("M0_CGC"):SetBlock({|| cCGC})

oReport:Section(2):Cell("F3_ENTRADA"):SetBlock({|| dEntrada})
oReport:Section(2):Cell("F3_NFISCAL"):SetBlock({|| cNFiscal})
oReport:Section(2):Cell("A2_NOME"):SetBlock({|| cNome})
oReport:Section(2):Cell("VALOR"):SetBlock({|| nValor})
oReport:Section(2):Cell("IMEBAB"):SetBlock({|| nIMEBAB})
oReport:Section(2):Cell("IMEBA2"):SetBlock({|| nIMEBA2})
oReport:Section(2):Cell("IMEBA4"):SetBlock({|| nIMEBA4})
oReport:Section(2):Cell("DESCGAST"):SetBlock({|| nDescGast})
oReport:Section(2):Cell("RETENC"):SetBlock({|| nRetenc})
oReport:Section(2):Cell("VALLIQ"):SetBlock({|| nValLiq})

//�������������������������������������������������������������Ŀ
//�Inclui as posicoes dos campos de impostos no array aImpostos �
//���������������������������������������������������������������
For nZ:=1 To Len(aImpostos)
	AAdd(aImpostos[nZ],FieldPos("F3_BASIMP"+aImpostos[nZ][2]))
	AAdd(aImpostos[nZ],FieldPos("F3_VALIMP"+aImpostos[nZ][2]))
Next	          

//������������������������������������������������������������������������Ŀ
//�Metodo TrPosition()                                                     �
//�                                                                        �
//�Posiciona em um registro de uma outra tabela. O posicionamento ser�     �
//�realizado antes da impressao de cada linha do relat�rio.                �
//�                                                                        �
//�ExpO1 : Objeto Report da Secao                                          �
//�ExpC2 : Alias da Tabela                                                 �
//�ExpX3 : Ordem ou NickName de pesquisa                                   �
//�ExpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexe-�
//�        cutada.                                                         �
//��������������������������������������������������������������������������

//�������������������������������������������������������Ŀ
//�Posicionamento das tabelas                             �
//���������������������������������������������������������
SA1->(dbSelectArea("SA1"))
SA1->(dbSetOrder(1))

SA2->(dbSelectArea("SA2"))
SA2->(dbSetOrder(1))

SF1->(dbSelectArea("SF1"))
SF1->(dbSetOrder(1))

SF2->(dbSelectArea("SF2"))
SF2->(dbSetOrder(1))
			
//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relatorio                               �
//��������������������������������������������������������������������������
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

If mv_par03 <> 1
	oReport:Section(2):Cell("RETENC"):Disable()
Endif

While !oReport:Cancel() .And. !(cAliasSF3)->(Eof())

	aItens := {}
	oReport:IncMeter()

    If FieldGet(aImpostos[1][3]) > 0 .Or. FieldGet(aImpostos[2][3]) > 0 .Or. FieldGet(aImpostos[3][3]) > 0

		cChave := (cAliasSF3)->F3_FILIAL+DTOS((cAliasSF3)->F3_ENTRADA)+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+;
					(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_CFO+(cAliasSF3)->F3_ESPECIE+(cAliasSF3)->F3_TIPOMOV

		dEntrada	:= (cAliasSF3)->F3_ENTRADA                                                   
		cNFiscal	:= (cAliasSF3)->F3_NFISCAL
		cClieFor	:= (cAliasSF3)->F3_CLIEFOR 
		cLoja		:= (cAliasSF3)->F3_LOJA
		
		If Len(cClieFor) > 0               
			If (cAliasSF3)->F3_TIPO <> "B"
				If SA2->(dbSeek(xFilial("SA2")+cClieFor+cLoja))
					cNome := SA2->A2_NOME
				Else 
					cNome := SubStr(cClieFor,1,30)
				EndIf
			Else                
				If SA1->(dbSeek(xFilial("SA1")+cClieFor))
					cNome := SA1->A1_NOME
				Else 
					cNome := SubStr(cClieFor,1,30)
				EndIf
			EndIf	
		EndIf

		If (cAliasSF3)->F3_TIPO <> "D"
			If SF1->(dbSeek(xFilial("SF1")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))	
				nDescG := xMoeda(SF1->F1_DESCONT+SF1->F1_DESPESA,SF1->F1_MOEDA,1,,,SF1->F1_TXMOEDA)
			Else 
				nDescG := 0
			EndIf	
		Else                    
			If SF2->(dbSeek(xFilial("SF2")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))	
				nDescG := xMoeda(SF2->F2_DESCONT+SF2->F2_DESPESA,SF2->F2_MOEDA,1,,,SF2->F2_TXMOEDA)
			Else 
				nDescG := 0
			EndIf	
		EndIf	

		AAdd(aItens,{dEntrada,cNFiscal,cNome,(cAliasSF3)->F3_VALCONT,0,0,0,nDescG,0,0,(cAliasSF3)->F3_TIPO})
		
		For nI:=1 To Len(aImpostos)
			Do Case
				Case  aImpostos[nI][1] $ "BA1".And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IMEBAB] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "BA2".And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IMEBA2] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "BA3"  .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IMEBA4] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "TCF".And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_RETENC] := FieldGet(aImpostos[nI][4])	
			EndCase							
		Next  
		
		(cAliasSF3)->(dbSkip())
		
		While (cAliasSF3)->F3_FILIAL+DTOS((cAliasSF3)->F3_ENTRADA)+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_CFO+;
			  (cAliasSF3)->F3_ESPECIE+(cAliasSF3)->F3_TIPOMOV == cChave 
			  
			aItens[Len(aItens)][_VALOR] += (cAliasSF3)->F3_VALCONT

			For nI:=1 To Len(aImpostos)
				Do Case
					Case  aImpostos[nI][1] $ "BA1" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IMEBAB] += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "BA2" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IMEBA2] += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "BA3" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IMEBA4] += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "TCF" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_RETENC] += FieldGet(aImpostos[nI][4])		
				EndCase							
			Next  
			
			(cAliasSF3)->(dbSkip())        
		Enddo	
		
		aItens[Len(aItens)][_VALLIQ] += aItens[Len(aItens)][_VALOR] - (aItens[Len(aItens)][_IMEBAB] +;
										aItens[Len(aItens)][_IMEBA2] + aItens[Len(aItens)][_IMEBA4] +;
										aItens[Len(aItens)][_DESCGAST])
	
		dEntrada	:= aItens[1][_DATA]
		cNFiscal	:= aItens[1][_DOCTO]
		cNome		:= aItens[1][_CLIENTE]

		If aItens[1][Len(aItens[1])] <> "D"		
			nValor		:= aItens[1][_VALOR]
			nIMEBAB		:= aItens[1][_IMEBAB]
			nIMEBA2		:= aItens[1][_IMEBA2]
			nIMEBA4		:= aItens[1][_IMEBA4]
			nDescGast	:= aItens[1][_DESCGAST]
			nRetenc		:= aItens[1][_RETENC]
			nValLiq		:= aItens[1][_VALLIQ]
		Else                                                                           
			nValor		:= (aItens[1][_VALOR] * -1)
			nIMEBAB		:= (aItens[1][_IMEBAB] * -1)
			nIMEBA2		:= (aItens[1][_IMEBA2] * -1)
			nIMEBA4		:= (aItens[1][_IMEBA4] * -1)
			nDescGast	:= (aItens[1][_DESCGAST] * -1)
			nRetenc		:= (aItens[1][_RETENC] * -1)
			nValLiq		:= (aItens[1][_VALLIQ] * -1)
		EndIf	
		oReport:Section(2):PrintLine() 	
				
	Else
	
		(cAliasSF3)->(dbSkip())
		
	EndIf		
	
Enddo
oReport:Section(2):Finish()	

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MATRUR4R3 � Autor � Paulo Eduardo      � Data �  12/11/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para impressao de livros fiscais de Compras Hacienda���
���          � para o Uruguai.                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Localizacoes                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MATRUR4R3()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1       := STR0001 //"Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := STR0002 //"de Livros Fiscais de Compras para o Uruguai"
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := STR0003 //"Livro Fiscal de Compras"
Local nLin         := 80
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "MATRUR4" 
Private nTipo      := 18
Private aReturn    := { STR0004, 1, STR0005, 2, 2, 1, "", 1} //"Zebrado"###"Administracao"
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "MATRUR4" 
Private cPerg      := "MTRUR4"
Private cString    := ""
Private cAliasSF3
Private aItens, aImpostos
Private nTotal    := 0, nTotBA1 := 0, nTotBA2 := 0
Private nTotBA3 := 0, nTotDesc := 0, nTotRet := 0, nTotLiq := 0


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
cString := "SF3"

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho,,.T.)

Pergunte(cPerg,.F.)

//�������������������������������������������������������Ŀ
//�Monta aImpostos com as informacoes de cada imposto     �
//���������������������������������������������������������
DbSelectArea("SFB")
DbSetOrder(1)
DbGoTop()

aImpostos := {}
AAdd(aImpostos,{"BA1",""})                
AAdd(aImpostos,{"BA2",""})                
AAdd(aImpostos,{"BA3",""})
AAdd(aImpostos,{"TCF",""})
While !SFB->(EOF()) 
	If aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]}) > 0
		aImpostos[aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]})][2] := SFB->FB_CPOLVRO
	EndIf	
	DbSkip()
EndDo                 
aSort(aImpostos,,,{|x,y| x[2] < y[2]})

//���������������������������������������������������������������������Ŀ
//� Monta os cabecalhos do relatorio                                    �
//�����������������������������������������������������������������������                        
titulo := STR0006 +space(1)+ DTOC(mv_par01) +space(1)+ STR0007 +space(1)+ DTOC(mv_par02) //"Livro de Compras de"###"a"
                                  
Cabec1 := Padr(STR0008,10," ") +space(5)+ Padr(STR0009,12," ") +space(5)+ Padr(STR0010,30," ") +space(5)+ PadL(STR0011,17," ") +space(5)+; //"Data"###"Documento"###"Cliente"###"Valor Fazenda"
		PadL("IMEBA "+ STR0022,17," ") +space(5)+ PadL("IMEBA 2/100",17," ") +space(5)+ PadL("IMEBA 4/100",17," ") +space(5)
If mv_par03 == 1		
	Cabec1+= PadL(STR0020,17," ") +space(5)+ PadL(STR0021,17," ") +space(5)+ PadL(STR0013,17," ") //"Desc./Gastos"###"Retencao"###"Fazenda Liquido"
Else
	Cabec1+= PadL(STR0020,17," ") +space(5)+ PadL(STR0013,17," ") //"Desc./Gastos"###"Fazenda Liquido"
EndIf	
	
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)		

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| MUr4Imprime(Cabec1,Cabec2,Titulo,nLin) },Titulo)								

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Fun��o    �MUR4IMPRIME� Autor � AP6 IDE            � Data �  31/10/03   ���
��������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS  ���
���          � monta a janela com a regua de processamento.                ���
��������������������������������������������������������������������������͹��
���Uso       � Programa principal                                          ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

Static Function MUr4Imprime(Cabec1,Cabec2,Titulo,nLin)

Local nY := 1
Local cbcont:=0,cbtxt:=space(10)
Local cCond, cArqTrab, cOrdem, cChave
Local cFornLivro, cFornecedor
Local dDataEntr
Local nValor 	   :=0
Local nOrdSF3      := 1, nZ:= 1, nI:=1
Local cCGCDesc := Rtrim(RetTitle("A2_CGC"))
Local aCabec := {STR0014 +space(1)+ SM0->M0_NOMECOM +Padc("",130)+padL(STR0015+space(1)+STRZERO(m_pag,3,0),81),; //"Empresa:"###"Pagina:"
		STR0016 +space(1)+ Alltrim(SM0->M0_ENDENT)+" - "+ AllTrim(SM0->M0_CIDENT)+" - "+ AllTrim(SM0->M0_ESTENT)+; //"Endereco:"
		Padc(Titulo,130) + PadL(STR0008+": "+DTOC(dDataBase),111),; //"Data"
		cCGCDesc + ": " + Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC"))}

#IFDEF TOP  
Local cQuery:=""

//����������������������������������������������������Ŀ
//�Monta query para selecao dos itens a serem mostrados�
//������������������������������������������������������
	cAliasSF3:="F3TMP"
	If Select(cAliasSF3)<>0
   		DbSelectArea(cAliasSF3)
   		DbCloseArea()
	Endif            
	
	cQuery := "SELECT * FROM "+RetSqlName("SF3")+" "+cAliasSF3+" "
    cQuery += "WHERE F3_FILIAL='"+ xFilial("SF3")+"'"+" AND F3_TIPOMOV = 'C' AND "
    cQuery += "F3_ENTRADA >= '"+Dtos(mv_par01)+"'"+" AND F3_ENTRADA <= '"+Dtos(mv_par02)+"'"
	cQuery +=" AND D_E_L_E_T_<>'*' ORDER BY " 
	cQuery +="F3_ENTRADA,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_CFO"
	cQuery :=ChangeQuery(cQuery)
	MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasSF3,.F.,.T.)},STR0017) //"Selecionando registros..."
	TCSetField(cAliasSF3,"F3_ENTRADA","D",8,0)
#ELSE
	
//������������������������������������Ŀ
//�Monta IndRegua para selecao do itens�
//��������������������������������������
	cAliasSF3:="SF3"
	DbSelectArea(cAliasSF3)
	DbGoTop()         

	nOrdSF3 := IndexOrd()

	cCond := cAliasSF3+"->F3_FILIAL == '"+ xFilial(cAliasSF3) + "' "
	cCond += ".and. "+cAliasSF3+"->F3_TIPOMOV =='C' .and."
	cCond += "Dtos("+cAliasSF3+"->F3_ENTRADA) >= '"+ Dtos(mv_par01) +"' .and. "
	cCond += "Dtos("+cAliasSF3+"->F3_ENTRADA) <= '"+ Dtos(mv_par02) +"'"
	cArqTrab := CriaTrab(Nil,.F.)
	cOrdem:=SF3->(IndexKey())
	IndRegua(cAliasSF3,cArqTrab,cOrdem,,cCond,STR0017) //"Selecionando registros..."
#ENDIF    

//�������������������������������������������������������������Ŀ
//�Inclui as posicoes dos campos de impostos no array aImpostos �
//���������������������������������������������������������������
For nZ:=1 To Len(aImpostos)
	AAdd(aImpostos[nZ],FieldPos("F3_BASIMP"+aImpostos[nZ][2]))
	AAdd(aImpostos[nZ],FieldPos("F3_VALIMP"+aImpostos[nZ][2]))
Next	          

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
SetRegua(RecCount())

//������������������������������������Ŀ
//�Monta array de com os itens do SF3  �
//��������������������������������������

aItens := {}
While !(cAliasSF3)->(EOF())  
    If FieldGet(aImpostos[1][3]) > 0 .or. FieldGet(aImpostos[2][3]) > 0 .or. FieldGet(aImpostos[3][3]) > 0
		cChave := (cAliasSf3)->F3_FILIAL+DTOS((cAliasSF3)->F3_ENTRADA)+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+;
					(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_CFO+(cAliasSF3)->F3_ESPECIE+(cAliasSF3)->F3_TIPOMOV
		dDataEntr  := (cAliasSF3)->F3_ENTRADA                                                   
		cDocumento := (cAliasSF3)->F3_NFISCAL
		cFornLivro := (cAliasSF3)->F3_CLIEFOR
		If Len(cFornLivro) > 0               
			If (cAliasSf3)->F3_TIPO <> "B"
				SA2->(DbGoTop())
				If SA2->(MsSeek(xFilial()+cFornLivro))
					cFornecedor := TransForm(SubStr(SA2->A2_NOME,1,30),PesqPict("SA2","A2_NOME"))
				Else 
					cFornecedor := SubStr(cFornLivro,1,30)
				EndIf
			Else                
				SA1->(DbGoTop())
				If SA1->(MsSeek(xFilial()+cFornLivro))
					cFornecedor := TransForm(SubStr(SA1->A1_NOME,1,30),PesqPict("SA1","A1_NOME"))
				Else 
					cFornecedor := SubStr(cFornLivro,1,30)
				EndIf
			EndIf	
		EndIf
		If (cAliasSf3)->F3_TIPO <> "D"
			SF1->(DbSetOrder(1))
			If SF1->(MsSeek(xFilial()+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))	
				nDescGast:= xMoeda(SF1->F1_DESCONT+SF1->F1_DESPESA,SF1->F1_MOEDA,1,,,SF1->F1_TXMOEDA)
			Else 
				nDescGast:= 0
			EndIf	
		Else                    
			SF2->(DbSetOrder(1))
			If SF2->(MsSeek(xFilial()+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))	
				nDescGast:= xMoeda(SF2->F2_DESCONT+SF2->F2_DESPESA,SF2->F2_MOEDA,1,,,SF2->F2_TXMOEDA)
			Else 
				nDescGast:= 0
			EndIf	
		EndIf	
		nValor   := (cAliasSF3)->F3_VALCONT
		AAdd(aItens,{dDataEntr,cDocumento,cFornecedor,nValor,0,0,0,nDescGast,0,0,(cAliasSF3)->F3_TIPO})
		
		For nI:=1 To Len(aImpostos)
			Do Case
				Case  aImpostos[nI][1] $ "BA1".And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IMEBAB] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "BA2".And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IMEBA2] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "BA3"  .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IMEBA4] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "TCF".And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_RETENC] := FieldGet(aImpostos[nI][4])	
			EndCase							
		Next  
		
		(cAliasSF3)->(DbSkip())
		
		While (cAliasSF3)->F3_FILIAL+DTOS((cAliasSF3)->F3_ENTRADA)+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_CFO+;
			  (cAliasSF3)->F3_ESPECIE+(cAliasSF3)->F3_TIPOMOV == cChave 
			aItens[Len(aItens)][_VALOR] += (cAliasSF3)->F3_VALCONT
			For nI:=1 To Len(aImpostos)
				Do Case
					Case  aImpostos[nI][1] $ "BA1" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IMEBAB] += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "BA2" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IMEBA2] += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "BA3" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IMEBA4] += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "TCF" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_RETENC] += FieldGet(aImpostos[nI][4])		
				EndCase							
			Next  
			
			(cAliasSF3)->(DbSkip())        
		EndDo	
		aItens[Len(aItens)][_VALLIQ] += aItens[Len(aItens)][_VALOR] - (aItens[Len(aItens)][_IMEBAB] +;
										aItens[Len(aItens)][_IMEBA2] + aItens[Len(aItens)][_IMEBA4] +;
										aItens[Len(aItens)][_DESCGAST])
		
		//���������������������������������������������������������������������Ŀ
		//� Faz a somatoria dos totais a serem apresentados no relatorio        �
		//�����������������������������������������������������������������������
		If aItens[1][Len(aItens[1])] <> "D"
			nTotal    += aItens[1][_VALOR]
			nTotBA1   += aItens[1][_IMEBAB]
			nTotBA2   += aItens[1][_IMEBA2]
			nTotBA3   += aItens[1][_IMEBA4]
			nTotDesc  += aItens[1][_DESCGAST]
			nTotRet   += aItens[1][_RETENC]
			nTotLiq   += aItens[1][_VALLIQ]
		Else                               
			nTotal    -= aItens[1][_VALOR]
			nTotBA1   -= aItens[1][_IMEBAB]
			nTotBA2   -= aItens[1][_IMEBA2]
			nTotBA3   -= aItens[1][_IMEBA4]
			nTotDesc  -= aItens[1][_DESCGAST]
			nTotRet   -= aItens[1][_RETENC]
			nTotLiq   -= aItens[1][_VALLIQ]
		EndIf	
		
		//���������������������������������������������������������������������Ŀ
		//� Verifica o cancelamento pelo usuario...                             �
		//�����������������������������������������������������������������������
		
		If lAbortPrint
			@nLin,00 PSAY STR0018 //"*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//���������������������������������������������������������������������Ŀ
		//� Impressao do cabecalho do relatorio. . .                            �
		//�����������������������������������������������������������������������
		
		If nLin > 58 // Salto de P�gina. Neste caso o formulario tem 58 linhas...
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,aCabec)
			nLin ++
		Endif
		
		@nLin,00   PSAY Padr(aItens[nY][_DATA],10)
		@nLin,15   PSAY aItens[nY][_DOCTO]
		@nLin,32   PSAY aItens[nY][_CLIENTE]
		If aItens[1][Len(aItens[1])] <> "D"		
			@nLin,67   PSAY Transform(aItens[nY][_VALOR],PesqPict("SF3","F3_VALCONT"))
			@nLin,88   PSAY Transform(aItens[nY][_IMEBAB],PesqPict("SF3","F3_VALIMP1"))
			@nLin,110  PSAY Transform(aItens[nY][_IMEBA2],PesqPict("SF3","F3_VALIMP1"))
			@nLin,132  PSAY Transform(aItens[nY][_IMEBA4],PesqPict("SF3","F3_VALIMP1"))
			@nLin,154  PSAY Transform(aItens[nY][_DESCGAST],PesqPict("SF3","F3_VALIMP1"))
			If mv_par03 == 1
				@nLin,176  PSAY Transform(aItens[nY][_RETENC],PesqPict("SF3","F3_VALIMP1"))
				@nLin,199  PSAY Transform(aItens[nY][_VALLIQ],PesqPict("SF3","F3_VALCONT"))
			Else
				@nLin,177  PSAY Transform(aItens[nY][_VALLIQ],PesqPict("SF3","F3_VALCONT"))
			EndIf	
		Else                                                                           
			@nLin,67   PSAY Transform(aItens[nY][_VALOR]*-1,PesqPict("SF3","F3_VALCONT"))
			@nLin,88   PSAY Transform(aItens[nY][_IMEBAB]*-1,PesqPict("SF3","F3_VALIMP1"))
			@nLin,110  PSAY Transform(aItens[nY][_IMEBA2]*-1,PesqPict("SF3","F3_VALIMP1"))
			@nLin,132  PSAY Transform(aItens[nY][_IMEBA4]*-1,PesqPict("SF3","F3_VALIMP1"))
			@nLin,154  PSAY Transform(aItens[nY][_DESCGAST]*-1,PesqPict("SF3","F3_VALIMP1"))
			If mv_par03 == 1
				@nLin,176  PSAY Transform(aItens[nY][_RETENC]*-1,PesqPict("SF3","F3_VALIMP1"))
				@nLin,199  PSAY Transform(aItens[nY][_VALLIQ]*-1,PesqPict("SF3","F3_VALCONT"))
			Else
				@nLin,177  PSAY Transform(aItens[nY][_VALLIQ]*-1,PesqPict("SF3","F3_VALCONT"))
			EndIf	
		EndIf	
		
		nLin := nLin + 1 // Avanca a linha de impressao
		aItens := {}
	Else
		(cAliasSF3)->(DbSkip())
	EndIf		
EndDo	

If nTotal <> 0
	//���������������������������������������������������������������������Ŀ
	//� Monta linha de totais do relatorio.                                 �
	//�����������������������������������������������������������������������                                    
	nLin := nLin + 2
	                 
	@nLin,00   PSAY STR0019                                        //"TOTAIS GERAIS"
	@nLin,67   PSAY Transform(nTotal,PesqPict("SF3","F3_VALCONT"))
	@nLin,88   PSAY Transform(nTotBA1,PesqPict("SF3","F3_VALIMP1"))
	@nLin,110  PSAY Transform(nTotBA2,PesqPict("SF3","F3_VALIMP1"))
	@nLin,132  PSAY Transform(nTotBA3,PesqPict("SF3","F3_VALIMP1"))
	@nLin,154  PSAY Transform(nTotDesc,PesqPict("SF3","F3_VALIMP1"))
	If mv_par03 == 1
		@nLin,176  PSAY Transform(nTotRet,PesqPict("SF3","F3_VALIMP1"))
		@nLin,199  PSAY Transform(nTotLiq,PesqPict("SF3","F3_VALCONT"))
	Else	                                                            
		@nLin,177  PSAY Transform(nTotLiq,PesqPict("SF3","F3_VALCONT"))
	EndIf	
		
	//���������������������������������������������������������������������Ŀ
	//� Monta rodape da pagina                                              �
	//�����������������������������������������������������������������������
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
	
//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������
	
SET DEVICE TO SCREEN
	
//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������
	
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
	
MS_FLUSH()
Fim := .F.
	
Return

