#INCLUDE "matrur3.ch"
#INCLUDE "Protheus.ch"

//��������������������������������������Ŀ
//� Defines das posicoes do array aItens �
//����������������������������������������
#DEFINE _DATA		1
#DEFINE _DOCTO		2
#DEFINE _CLIENTE	3
#DEFINE _VALOR		4
#DEFINE _IVAMAIOR	5
#DEFINE _IVAMENOR	6
#DEFINE _COFIS		7
#DEFINE _VALLIQ 	8
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MATRUR3   � Autor �Sergio S. Fuzinaka     � Data � 18.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Livros Fiscais de Compras Normales                          ���
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
Function MatrUr3()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	MatrUr3R3()
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
Local cReport	:= "MATRUR3"
Local cPerg		:= "MTRUR3"
Local cTitulo	:= OemToAnsi(STR0020)
Local cDesc		:= OemToAnsi(STR0021)

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
oEmpresa:=TRSection():New(oReport,OemToAnsi(STR0022),{"SM0"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oEmpresa,"M0_NOMECOM","SM0",OemToAnsi(STR0022),/*Picture*/,40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oEmpresa,"M0_ENDENT","SM0",OemToAnsi(STR0023),/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oEmpresa,"M0_CGC","SM0",OemToAnsi(STR0024),/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/)

oLinha:=TRSection():New(oReport,OemToAnsi(STR0035),{"SF3","SA2"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oLinha,"F3_ENTRADA","SF3",OemToAnsi(STR0027),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"F3_NFISCAL","SF3",OemToAnsi(STR0028),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"A2_NOME","SA2",OemToAnsi(STR0029),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"VLR","",OemToAnsi(STR0030),PesqPict("SF3","F3_VALCONT"),TamSx3("F3_VALCONT")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"IVA23","",OemToAnsi(STR0031),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"IVA14","",OemToAnsi(STR0032),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"COFIS","",OemToAnsi(STR0033),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha,"VLRLIQ","",OemToAnsi(STR0034),PesqPict("SF3","F3_VALCONT"),TamSx3("F3_VALCONT")[1],/*lPixel*/,/*{|| code-block de impressao }*/)

TRFunction():New(oLinha:Cell("VLR"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("IVA23"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("IVA14"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("COFIS"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oLinha:Cell("VLRLIQ"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)

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

Local cCondicao := ""
Local cAliasSF3	:= "SF3"
Local cCabec	:= OemToAnsi(STR0020)+OemToAnsi(STR0025)+DtoC(mv_par01)+OemToAnsi(STR0026)+DtoC(mv_par02)
Local aItens	:= {}
Local aImpostos	:= {}
Local aImpAux	:= {}
Local cChave	:= ""
Local cClieFor	:= ""
Local cLoja		:= ""
Local nValCont	:= 0
Local nI		:= 0
Local nZ		:= 0
Local cNomeCom	:= ""
Local cEndEnt	:= ""
Local cCGC		:= ""
Local dEntrada	:= CtoD("")
Local cNFiscal	:= ""
Local cNome		:= ""
Local nVlr		:= 0
Local nIVA23	:= 0
Local nIVA14	:= 0
Local nCOFIS	:= 0
Local nVlrLiq	:= 0

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

AAdd(aImpostos,{"IVA|IV3",""})                
AAdd(aImpostos,{"IV2|IV4",""})                
AAdd(aImpostos,{"COF",""})
While !SFB->(EOF()) 
	If aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]}) > 0
		aImpostos[aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]})][2] := SFB->FB_CPOLVRO
	EndIf	
	dbSkip()
Enddo                 
aSort(aImpostos,,,{|x,y| x[2] < y[2]})

//����������������������������������Ŀ
//�Monta array auxiliar de impostos  �
//������������������������������������
AAdd(aImpAux,{"BA1",""})                
AAdd(aImpAux,{"BA2",""})                
AAdd(aImpAux,{"BA3",""})              
SFB->(dbGoTop()) 
While !SFB->(EOF()) 
	If aScan(aImpAux,{|x| SFB->FB_CODIGO $ x[1]}) > 0
		aImpAux[aScan(aImpAux,{|x| SFB->FB_CODIGO $ x[1]})][2] := SFB->FB_CPOLVRO
	EndIf	
	dbSkip()
Enddo                 
aSort(aImpAux,,,{|x,y| x[2] < y[2]}) 

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
	//�                                                                        �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(2):EndQuery(/*Array com os parametros do tipo Range*/)
		
	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������

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
oReport:Section(2):Cell("VLR"):SetBlock({|| nVlr})
oReport:Section(2):Cell("IVA23"):SetBlock({|| nIVA23})
oReport:Section(2):Cell("IVA14"):SetBlock({|| nIVA14})
oReport:Section(2):Cell("COFIS"):SetBlock({|| nCOFIS})
oReport:Section(2):Cell("VLRLIQ"):SetBlock({|| nVlrLiq})

//�������������������������������������������������������������Ŀ
//�Inclui as posicoes dos campos de impostos no array aImpostos �
//���������������������������������������������������������������
For nZ:=1 To Len(aImpostos)
	AAdd(aImpostos[nZ],FieldPos("F3_BASIMP"+aImpostos[nZ][2]))
	AAdd(aImpostos[nZ],FieldPos("F3_VALIMP"+aImpostos[nZ][2]))
	AAdd(aImpAux[nZ],FieldPos("F3_BASIMP"+aImpAux[nZ][2]))
	AAdd(aImpAux[nZ],FieldPos("F3_VALIMP"+aImpAux[nZ][2]))
Next	          

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
//������������������������������������������������������������������������Ŀ
//�Imprime a secao da carga                                                �
//��������������������������������������������������������������������������
While !oReport:Cancel() .And. !(cAliasSF3)->(Eof())

	aItens := {}
	oReport:IncMeter()

	If !(FieldGet(aImpAux[1][3]) > 0 .Or. FieldGet(aImpAux[2][3]) > 0 .Or. FieldGet(aImpAux[3][3]) > 0)

		cChave	:=	(cAliasSf3)->F3_FILIAL+DTOS((cAliasSF3)->F3_ENTRADA)+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+;
					(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_CFO+(cAliasSF3)->F3_ESPECIE+(cAliasSF3)->F3_TIPOMOV

		dEntrada	:= (cAliasSF3)->F3_ENTRADA                                                   
		cNFiscal	:= (cAliasSF3)->F3_NFISCAL
		cClieFor	:= (cAliasSF3)->F3_CLIEFOR
		cLoja		:= (cAliasSF3)->F3_LOJA
		nValCont	:= (cAliasSF3)->F3_VALCONT

		If Len(cClieFor) > 0
			If (cAliasSF3)->F3_TIPO $ "B"
				SA1->(dbGoTop())
				SA1->(dbSetOrder(1))				
				If SA1->(dbSeek(xFilial("SA1")+cClieFor+cLoja))
					cNome := TransForm(SA1->A1_NOME,PesqPict("SA1","A1_NOME"))
				Else 
					cNome := SubStr(cClieFor,1,40)
				EndIf
			Else
				SA2->(dbGoTop())
				SA2->(dbSetOrder(1))				
				If SA2->(dbSeek(xFilial("SA2")+cClieFor+cLoja))
					cNome := TransForm(SA2->A2_NOME,PesqPict("SA2","A2_NOME"))
				Else 
					cNome := SubStr(cClieFor,1,40)
				EndIf
			EndIf	
		EndIf
	
		AAdd(aItens,{dEntrada,cNFiscal,cNome,nValCont,0,0,0,0,(cAliasSF3)->F3_TIPO})
		
		For nI:=1 To Len(aImpostos)
			Do Case
				Case  aImpostos[nI][1] $ "IV2|IV4" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IVAMAIOR] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "IVA|IV3" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IVAMENOR] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "COF" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_COFIS]    := FieldGet(aImpostos[nI][4])
			EndCase							
		Next  
		
		(cAliasSF3)->(dbSkip())
		
		While (cAliasSF3)->F3_FILIAL+DTOS((cAliasSF3)->F3_ENTRADA)+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_CFO+;
			  (cAliasSF3)->F3_ESPECIE+(cAliasSF3)->F3_TIPOMOV == cChave 
			  
			aItens[Len(aItens)][_VALOR] += FieldGet(FieldPos("F3_VALCONT"))
			
			For nI:=1 To Len(aImpostos)
				Do Case
					Case  aImpostos[nI][1] $ "IV2|IV4" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IVAMAIOR]  += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "IVA|IV3" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IVAMENOR]  += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "COF" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_COFIS]  += FieldGet(aImpostos[nI][4])
				EndCase							
			Next  
			
			(cAliasSF3)->(dbSkip())  
		Enddo	

		aItens[Len(aItens)][_VALLIQ] += aItens[Len(aItens)][_VALOR] - (aItens[Len(aItens)][_IVAMAIOR] +;
										aItens[Len(aItens)][_IVAMENOR] + aItens[Len(aItens)][_COFIS])
		
		//���������������������������������������������������������������������Ŀ
		//� Faz a somatoria dos totais a serem apresentados no relatorio        �
		//�����������������������������������������������������������������������
		If aItens[1][Len(aItens[1])] <> "D"
			nVlr	:= aItens[1][_VALOR]
			nIVA23	:= aItens[1][_IVAMAIOR]
			nIVA14	:= aItens[1][_IVAMENOR]
			nCOFIS	:= aItens[1][_COFIS]
			nVlrLiq	:= aItens[1][_VALLIQ]
		Else                               
			nVlr	:= (aItens[1][_VALOR] * -1)
			nIVA23	:= (aItens[1][_IVAMAIOR] * -1)
			nIVA14	:= (aItens[1][_IVAMENOR] * -1)
			nCOFIS	:= (aItens[1][_COFIS] * -1)
			nVlrLiq	:= (aItens[1][_VALLIQ] * -1)
		EndIf	   
	
		oReport:Section(2):PrintLine() 	
	Else
		dbSelectArea((cAliasSF3))
		dbSkip()
	Endif
Enddo
oReport:Section(2):Finish()	

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MATRUR3R3 � Autor � Paulo Eduardo      � Data �  07/11/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para impressao de livros fiscais de Compras Normales���
���          � para o Uruguai.                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Localizacoes                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MatrUR3R3()

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
Private nomeprog   := "MATRUR3" 
Private nTipo      := 18
Private aReturn    := { STR0004, 1, STR0005, 2, 2, 1, "", 1} //"Zebrado"###"Administracao"
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "MATRUR3" 
Private cPerg      := "MTRUR3"
Private cString    := ""
Private cAliasSF3
Private aItens, aImpostos, aImpAux
Private nTotal    := 0, nTotIVA23 := 0
Private nTotIVA14 := 0, nTotCOFIS := 0, nTotNeto := 0


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
AAdd(aImpostos,{"IVA|IV3",""})                
AAdd(aImpostos,{"IV2|IV4",""})                
AAdd(aImpostos,{"COF",""})
While !SFB->(EOF()) 
	If aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]}) > 0
		aImpostos[aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]})][2] := SFB->FB_CPOLVRO
	EndIf	
	DbSkip()
EndDo                 
aSort(aImpostos,,,{|x,y| x[2] < y[2]})

//����������������������������������Ŀ
//�Monta array auxiliar de impostos  �
//������������������������������������
aImpAux := {}                                 
AAdd(aImpAux,{"BA1",""})                
AAdd(aImpAux,{"BA2",""})                
AAdd(aImpAux,{"BA3",""})              
SFB->(DbGoTop()) 
While !SFB->(EOF()) 
	If aScan(aImpAux,{|x| SFB->FB_CODIGO $ x[1]}) > 0
		aImpAux[aScan(aImpAux,{|x| SFB->FB_CODIGO $ x[1]})][2] := SFB->FB_CPOLVRO
	EndIf	
	DbSkip()
EndDo                 
aSort(aImpAux,,,{|x,y| x[2] < y[2]}) 
//���������������������������������������������������������������������Ŀ
//� Monta os cabecalhos do relatorio                                    �
//�����������������������������������������������������������������������                        
titulo := STR0006 +space(1)+ DTOC(mv_par01) +space(1)+ STR0007 +space(1)+ DTOC(mv_par02) //"Livro de Compras de"###"a"
                                  
Cabec1 := Padr(STR0008,10," ") +space(5)+ Padr(STR0009,12," ") +space(5)+ Padr(STR0010,40," ") +space(10)+ PadL(STR0011,17," ") +space(10)+; //"Data"###"Documento"###"Cliente"###"Valor"
		PadL("IVA 23%",17," ") +space(10)+ PadL("IVA 14%",17," ") +space(10)+ PadL("COFIS",17," ") +space(10)+ PadL(STR0013,17," ") //"Valor Liquido"
	
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

RptStatus({|| MUr3Imprime(Cabec1,Cabec2,Titulo,nLin) },Titulo)								

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Fun��o    �MUR3IMPRIME� Autor � AP6 IDE            � Data �  31/10/03   ���
��������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS  ���
���          � monta a janela com a regua de processamento.                ���
��������������������������������������������������������������������������͹��
���Uso       � Programa principal                                          ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

Static Function MUr3Imprime(Cabec1,Cabec2,Titulo,nLin)

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
	AAdd(aImpAux[nZ],FieldPos("F3_BASIMP"+aImpAux[nZ][2]))
	AAdd(aImpAux[nZ],FieldPos("F3_VALIMP"+aImpAux[nZ][2]))
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
	If !(FieldGet(aImpAux[1][3]) > 0 .Or. FieldGet(aImpAux[2][3]) > 0 .Or. FieldGet(aImpAux[3][3]) > 0)
		cChave := (cAliasSf3)->F3_FILIAL+DTOS((cAliasSF3)->F3_ENTRADA)+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+;
					(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_CFO+(cAliasSF3)->F3_ESPECIE+(cAliasSF3)->F3_TIPOMOV
		dDataEntr := (cAliasSF3)->F3_ENTRADA                                                   
		cDocumento:= (cAliasSF3)->F3_NFISCAL
		cFornLivro := (cAliasSF3)->F3_CLIEFOR
		If Len(cFornLivro) > 0
			If (cAliasSf3)->F3_TIPO <> "B"
				SA2->(DbGoTop())
				If SA2->(MsSeek(xFilial()+cFornLivro))
					cFornecedor := TransForm(SA2->A2_NOME,PesqPict("SA2","A2_NOME"))
				Else 
					cFornecedor := SubStr(cFornLivro,1,40)
				EndIf
			Else                
				SA1->(DbGoTop())
				If SA1->(MsSeek(xFilial()+cFornLivro))
					cFornecedor := TransForm(SA1->A1_NOME,PesqPict("SA1","A1_NOME"))
				Else 
					cFornecedor := SubStr(cFornLivro,1,40)
				EndIf
			EndIf	
		EndIf	
		nValor  := (cAliasSF3)->F3_VALCONT
		AAdd(aItens,{dDataEntr,cDocumento,cFornecedor,nValor,0,0,0,0,(cAliasSF3)->F3_TIPO})
		
		For nI:=1 To Len(aImpostos)
			Do Case
				Case  aImpostos[nI][1] $ "IV2|IV4" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IVAMAIOR] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "IVA|IV3" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_IVAMENOR] := FieldGet(aImpostos[nI][4])
				Case  aImpostos[nI][1] $ "COF" .And. aImpostos[nI][4] > 0
					aItens[Len(aItens)][_COFIS]    := FieldGet(aImpostos[nI][4])
			EndCase							
		Next  
		
		(cAliasSF3)->(DbSkip())
		
		While (cAliasSF3)->F3_FILIAL+DTOS((cAliasSF3)->F3_ENTRADA)+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_CFO+;
			  (cAliasSF3)->F3_ESPECIE+(cAliasSF3)->F3_TIPOMOV == cChave 
			aItens[Len(aItens)][_VALOR] += FieldGet(FieldPos("F3_VALCONT"))
			For nI:=1 To Len(aImpostos)
				Do Case
					Case  aImpostos[nI][1] $ "IV2|IV4" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IVAMAIOR]  += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "IVA|IV3" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_IVAMENOR]  += FieldGet(aImpostos[nI][4])
					Case  aImpostos[nI][1] $ "COF" .And. aImpostos[nI][4] > 0
						aItens[Len(aItens)][_COFIS]  += FieldGet(aImpostos[nI][4])
				EndCase							
			Next  
			
			(cAliasSF3)->(DbSkip())        
		EndDo	
		aItens[Len(aItens)][_VALLIQ] += aItens[Len(aItens)][_VALOR] - (aItens[Len(aItens)][_IVAMAIOR] +;
										aItens[Len(aItens)][_IVAMENOR] + aItens[Len(aItens)][_COFIS])
		
		//���������������������������������������������������������������������Ŀ
		//� Faz a somatoria dos totais a serem apresentados no relatorio        �
		//�����������������������������������������������������������������������
		If aItens[1][Len(aItens[1])] <> "D"
			nTotal    += aItens[1][_VALOR]
			nTotIVA23 += aItens[1][_IVAMAIOR]
			nTotIVA14 += aItens[1][_IVAMENOR]
			nTotCOFIS += aItens[1][_COFIS]
			nTotNeto  += aItens[1][_VALLIQ]
		Else                               
			nTotal    -= aItens[1][_VALOR]
			nTotIVA23 -= aItens[1][_IVAMAIOR]
			nTotIVA14 -= aItens[1][_IVAMENOR]
			nTotCOFIS -= aItens[1][_COFIS]
			nTotNeto  -= aItens[1][_VALLIQ]
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
			@nLin,82   PSAY Transform(aItens[nY][_VALOR],PesqPict("SF3","F3_VALCONT"))
			@nLin,108  PSAY Transform(aItens[nY][_IVAMAIOR],PesqPict("SF3","F3_VALIMP1"))
			@nLin,135  PSAY Transform(aItens[nY][_IVAMENOR],PesqPict("SF3","F3_VALIMP1"))
			@nLin,162  PSAY Transform(aItens[nY][_COFIS],PesqPict("SF3","F3_VALIMP1"))
			@nLin,190  PSAY Transform(aItens[nY][_VALLIQ],PesqPict("SF3","F3_VALCONT"))
		Else	                                                                        
			@nLin,82   PSAY Transform(aItens[nY][_VALOR]*-1,PesqPict("SF3","F3_VALCONT"))
			@nLin,108  PSAY Transform(aItens[nY][_IVAMAIOR]*-1,PesqPict("SF3","F3_VALIMP1"))
			@nLin,135  PSAY Transform(aItens[nY][_IVAMENOR]*-1,PesqPict("SF3","F3_VALIMP1"))
			@nLin,162  PSAY Transform(aItens[nY][_COFIS]*-1,PesqPict("SF3","F3_VALIMP1"))
			@nLin,190  PSAY Transform(aItens[nY][_VALLIQ]*-1,PesqPict("SF3","F3_VALCONT"))
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
	@nLin,82   PSAY Transform(nTotal,PesqPict("SF3","F3_VALCONT"))
	@nLin,108  PSAY Transform(nTotIVA23,PesqPict("SF3","F3_VALIMP1"))
	@nLin,135  PSAY Transform(nTotIVA14,PesqPict("SF3","F3_VALIMP1"))
	@nLin,162  PSAY Transform(nTotCOFIS,PesqPict("SF3","F3_VALIMP1"))
	@nLin,190  PSAY Transform(nTotNeto,PesqPict("SF3","F3_VALCONT"))
		
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

