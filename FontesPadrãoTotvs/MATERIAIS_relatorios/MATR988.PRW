#INCLUDE "MATR988.ch"
#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �Matr988   � Autor � Luciana Pires         � Data �12/03/2008���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Relatorio para totalizar os creditos dos movimentos de saida���
���			 �de produtos incentivados pelo PRODEPE - Decreto 31.250      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function Matr988()
//��������������������������������������������������������������Ŀ
//� Definicao das variaveis                                      |
//����������������������������������������������������������������
Local oReport
Local cPerg    		:= "MTR988"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte(cPerg,.F.)

//�������������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                          �
//� mv_par01             // Data Inicial                                          �
//� mv_par02             // Data Final                                            �
//� mv_par03             // Valor do saldo devedor do periodo anterior            �
//� mv_par04             // Nome do arquivo do periodo anterior                   �
//���������������������������������������������������������������������������������

If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport	:= ReportDef()
	oReport:PrintDialog()
Else
	Matr988R3()
EndIf
	
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Luciana Pires          � Data �11/03/2008���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport
Local oCabec
Local oSaidi

//�����������������������Ŀ
//�Componente de impressao�
//�������������������������
oReport := TReport():New("MATR988","Resumo de Cr�ditos de Movimentos de Produtos Incentivados - PRODEPE","MTR988",{|oReport| ReportPrint(oReport)},STR0002+" "+STR0003) // "Este relat�rio ira imprimir os cr�ditos dos movimentos de saida de produtos incentivados pelo PRODEPE."
Pergunte("MTR988",.F.)

//��������������������������������
//�Secao 1 - Cabecalho Padrao    �
//��������������������������������
oCabec	:= TRSection():New(oReport,"Dados da Empresa/Filial",{"SM0"},{"Emiss�o"},/*Campos do SX3*/,/*Campos do SIX*/)
oCabec:SetTotalInLine(.F.)
TRCell():New(oCabec,"M0_NOMECOM"	,"SM0"	,"EMPRESA"	,/*Picture*/,40	,/*lPixel*/,{|| SM0->M0_NOMECOM })
TRCell():New(oCabec,"M0_CGC"		,"SM0"	,"C.N.P.J"	,"@R 99.999.999/9999-99" ,30 ,/*lPixel*/,{|| SM0->M0_CGC })
TRCell():New(oCabec,"M0_INSC"		,"SM0"	,"I.E"		,/*Picture*/,25	,/*lPixel*/,{|| SM0->M0_INSC })
TRCell():New(oCabec,"M0_ENDENT"		,"SM0"	,"ENDERECO"	,/*Picture*/,40	,/*lPixel*/,{|| SM0->M0_ENDENT })
TRCell():New(oCabec,"M0_CIDENT"		,"SM0"	,"CIDADE"	,/*Picture*/,25	,/*lPixel*/,{|| SM0->M0_CIDENT })
TRCell():New(oCabec,"M0_ESTENT"		,"SM0"	,"ESTADO"	,/*Picture*/,02,/*lPixel*/,{||  SM0->M0_ESTENT })
     
//���������������������������������������������������������������
//�Secao 2 - Movimentos de Saida com Produtos Incentivados  	�
//���������������������������������������������������������������
oSaidi := TRSection():New(oReport,"MOVIMENTOS DE SAIDA COM PRODUTOS INCENTIVADOS",{},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSaidi:SetTotalInLine(.F.)
TRCell():New(oSaidi,"NCM"			,,"NCM"									,"@!"				,12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSaidi,"TOTAL"			,,"VALOR TOTAL SA�DAS INTERESTADUAIS"	,"@E 999,999,999.99",14,/*lPixel*/,/*{|| code-block de impressao }*/)

oSaidi:Cell("TOTAL"):SetHeaderAlign("RIGHT")

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Luciana Pires          � Data �11/03/2008���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)
Local oSaidi	:= oReport:Section(2)
//��������������������������������������������������������������Ŀ
//� Definicao de Variaveis                                       �
//����������������������������������������������������������������
Local cChave	:= ""

Local lHouveMov	:= .F.

Local aRetCred	:= {}
Local aFaixa	:= {}
Local aLinha	:= {}

Local nLinha    := 0
Local nX		:= 0 
Local nY		:= 1  
Local nVCred	:= 0

Local dDataIni	:= MV_PAR01
Local dDataFin	:= MV_PAR02
Local nValDevA	:= MV_PAR03
Local cArqAnt	:= Alltrim(MV_PAR04)

//����������������������������������������Ŀ
//� Creditos de ICMS - Prodepe             �
//������������������������������������������
aRetCred := RetCred2(dDataIni, dDataFin, nValDevA, cArqAnt) 
dbSelectArea("SFT")

//��������������������������������������������������������������Ŀ
//� Imprime o cabecalho                                          �
//����������������������������������������������������������������
oReport:SetMeter(1)
oReport:Section(1):Init()
oReport:Section(1):PrintLine() 		
	
If Len(aRetCred) > 1

	lHouveMov := .T.
	//�����������������������������������������������������������
	//�Secao 2 - Movimentos de Saida com Produtos Incentivados  �
	//�����������������������������������������������������������
	oReport:SetMeter(Len(aLinha))
	oReport:Section(2):Init()
	oReport:SkipLine()
	oReport:ThinLine()
	oReport:SkipLine()   
	nLin := oReport:Row()
	oReport:PrintText("                            MOVIMENTOS DE SAIDA COM PRODUTOS INCENTIVADOS - POR NCM - DECRETO 31.250 - PE",nLin,oReport:Section(2):Cell("TOTAL"):ColPos())
	oReport:SkipLine(2)
	oReport:ThinLine()
	oReport:SkipLine()   
	
	//��������������������������������������������������������������Ŀ
	//� Ordenacao Por NCM                                            |
	//����������������������������������������������������������������
	aSort(aRetCred,,, {|x,y| x[1] < y[1]}) 

	//������������������������������������������������Ŀ
	//�Altero codeblocks para imp dos campos do array  �
	//��������������������������������������������������

	oReport:Section(2):Cell("NCM"):SetBlock({|| aRetCred[nX][01]})
	oReport:Section(2):Cell("TOTAL"):SetBlock({|| aRetCred[nX][03]})

	//������������������������������������������������Ŀ
	//�Imprimo as linhas do relatorio                  �
	//��������������������������������������������������
	For nX := 1 to Len(aRetCred)
		If aRetCred[nX][01] <> "TOTAL"
			oReport:Section(2):PrintLine() 	
		Else
			oReport:SkipLine(2) 	
			oReport:ThinLine()
			oReport:Section(2):PrintLine() 			

			//��������������������������������������������������������������Ŀ
			//� Verifico saldo devedor do periodo anterior para impressao    |
			//����������������������������������������������������������������
			If nValDevA == 0
				nValDevA := LoadAnt(cArqAnt, "011") //Saldo Devedor
			Endif
	
			nVCred	:= Iif(aRetCred[nX][02],aRetCred[nX][04],0)
			oReport:SkipLine()
			nLin := oReport:Row()
			oReport:PrintText("TOTAL SALDO DEVEDOR DO PER�ODO ANTERIOR: "+ TransForm(nValDevA,"@e 999,999,999,999,999.99"))
			oReport:SkipLine()
			nLin := oReport:Row()
			oReport:PrintText("TOTAL BENEF�CIO CR�DITO PRESUMIDO:       "+ TransForm(nVCred,"@e 999,999,999,999,999.99"))
		Endif
	Next

Endif

//��������������������������������������������������������������Ŀ
//� Sem Movimento no Periodo                                     �
//����������������������������������������������������������������
If !lHouveMov
	oReport:Section(2):PrintLine()
	oReport:SkipLine(2)
	oReport:PrintText("*** NAO HOUVE MOVIMENTO ***")
Endif

oReport:Section(2):Finish() 

Return Nil

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �Matr988R3 �Autor  �Luciana Pires       � Data � 04/03/2008   ���
��������������������������������������������������������������������������͹��
���Desc.     � Relatorio para totalizar os creditos dos movimentos de saida���
���          � de produtos incentivados pelo PRODEPE                       ���
��������������������������������������������������������������������������͹��
���Uso       � Sigafis                                                     ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Function Matr988R3

//��������������������������������������������������������������Ŀ
//� Definicao das variaveis                                      |
//����������������������������������������������������������������

Private titulo		:=	STR0001 //"Resumo de Cr�ditos de Movimentos de Produtos Incentivados - PRODEPE - Decreto 31.250"
Private cDesc1		:=	STR0002 //"Este relat�rio ira imprimir os cr�ditos dos movimentos de saida de"
Private cDesc2		:=	STR0003 //"produtos incentivados pelo PRODEPE - Decreto 31.250 - PE."
Private cDesc3		:=	""  
Private aReturn  	:=	{STR0004,1,STR0005,2,2,1,"",1} //"Zebrado"###"Administracao"
Private nomeprog 	:=	"MATR988"
Private cPerg    	:=	"MTR988"
Private cString		:= "SFT"
Private nLastKey 	:=	0
Private Limite   	:=	132
Private Tamanho  	:=	"M"      
Private lEnd   		:= 	.F.		// Controle de cancelamento do relatorio
Private m_pag  		:= 	1  		// Contador de Paginas
                                                          
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
Titulo   :=	STR0001 //"Resumo de Cr�ditos de Movimentos de Produtos Incentivados - PRODEPE - Decreto 31.250"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel	:=	"MATR988"   
wnrel	:=	SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho)

nPagina	:=	1

If nLastKey == 27
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	dbClearFilter()
	Return                                                        
Endif
	
RptStatus({|lEnd| ImpRel(@lEnd,wnRel,Tamanho, nPagina)},titulo)

//��������������������������������������������������������������Ŀ
//� Restaura Ambiente                                            �
//����������������������������������������������������������������
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	Ourspool(wnrel)
Endif

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ImpRel   �Autor  �Luciana Pires       � Data � 04/03/2008  ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime o Relatorio                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Matr988                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                    

Static Function ImpRel(lEnd,wnRel,Tamanho,nPagina)       

//��������������������������������������������������������������Ŀ
//� Definicao de Variaveis                                       �
//����������������������������������������������������������������
Local cChave	:= ""

Local lHouveMov	:= .F.

Local aLay      := Array(19)
Local aRetCred	:= {}

Local nLinha    := 0
Local nX		:= 0   
Local nVCred	:= 0	

Local dDataIni	:= MV_PAR01
Local dDataFin	:= MV_PAR02
Local nValDevA	:= MV_PAR03
Local cArqAnt	:= Alltrim(MV_PAR04)

//����������������������������������������Ŀ
//� Creditos de ICMS - Prodepe             �
//������������������������������������������
aRetCred := RetCred2(dDataIni, dDataFin, nValDevA, cArqAnt) 
dbSelectArea("SFT")

//����������������������������������������Ŀ
//� Layout                                 �
//������������������������������������������
R988LayOut(@aLay)           

//��������������������������������������������������������������Ŀ
//� Imprime Cabecalho                                            �
//����������������������������������������������������������������
nLinha 	:= Mtr988Cabec(nPagina,dDataIni,dDataFin)	
nPagina += 1

If Len(aRetCred)>1

	//��������������������������������������������������������������Ŀ
	//� Ordenacao Por NCM                                            |
	//����������������������������������������������������������������
	aSort(aRetCred,,, {|x,y| x[1] < y[1]}) 

	For nX := 1 to Len(aRetCred)
		If aRetCred[nX][01] <> "TOTAL"
			//������������������������������������������������Ŀ
			//�Imprimo as linhas do relatorio                  �
			//��������������������������������������������������
			If nLinha >= 65
				FmtLin(,aLay[01],,,@nLinha)		
				nLinha 	:= Mtr988Cabec(nPagina,dDataIni,dDataFin)	
				nPagina += 1
			Endif
		
			FmtLin({	aRetCred[nX][01],;
						TransForm(aRetCred[nX][03],"@e 999,999,999,999,999.99")},aLay[13],,,@nLinha)
			lHouveMov := .T.
			nVCred	:= 0
		Endif
	Next
Endif	

//��������������������������������������������������������������Ŀ
//� Sem Movimento no Periodo                                     �
//����������������������������������������������������������������
If !lHouveMov
	FmtLin(,aLay[15],,,@nLinha)
Endif

//��������������������������������������������������������������Ŀ
//� Totalizacao dos Movimentos                                   �
//����������������������������������������������������������������
If nLinha >= 63
	nLinha 	:= Mtr988Cabec(nPagina,dDataIni,dDataFin)	
	nPagina += 1
ElseIf nLinha >= 65
	FmtLin(,aLay[01],,,@nLinha)		
	nLinha 	:= Mtr988Cabec(nPagina,dDataIni,dDataFin)	
	nPagina += 1
Endif           
           
If nLinha > 0 .And. lHouveMov
	nX := Ascan(aRetCred,{|x|x[1]=="TOTAL"})
	If nX > 0
		nVCred	:= Iif(aRetCred[nX][02],aRetCred[nX][04],0)
		FmtLin(,aLay[14],,,@nLinha)
		FmtLin({TransForm(aRetCred[nX][03],"@e 999,999,999,999,999.99")},aLay[16],,,@nLinha)			    
		FmtLin(,aLay[07],,,@nLinha)
		//��������������������������������������������������������������Ŀ
		//� Verifico saldo devedor do periodo anterior para impressao    |
		//����������������������������������������������������������������
		If nValDevA == 0
			nValDevA := LoadAnt(cArqAnt, "011") //Saldo Devedor
		Endif
		FmtLin({TransForm(nValDevA,"@e 999,999,999,999,999.99")},aLay[17],,,@nLinha)   
		FmtLin(,aLay[07],,,@nLinha)
		FmtLin({TransForm(nVCred,"@e 999,999,999,999,999.99")},aLay[18],,,@nLinha)			    
	Endif
Endif

//����������������������������������Ŀ
//�Completa o preenchimento da pagina�
//������������������������������������
If nLinha <= 65
	While nLinha <= 64
		FmtLin({,,,,,,,,,,,},aLay[04],,,@nLinha)
	EndDo
	FmtLin({},aLay[01],,,@nLinha)
Endif
                                
Return( .T. ) 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |R988LayOut� Autor �Luciana Pires       � Data � 07/03/2008  ���
�������������������������������������������������������������������������͹��
���Desc.     �Layout de Impressao                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �MATR988                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function R988LayOut(aLay)

						//   0	     1         2         3         4         5         6         7         8         9         10        11        12        13
						//   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

	aLay[01] := STR0006 // 	"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[02] := STR0007 // 	"|                                RESUMO DE CREDITOS DE MOVIMENTOS DE PRODUTOS INCENTIVADOS - PRODEPE                               |"
	aLay[03] := STR0008 //	"|                                                                                                                 PAGINA: ######   |"
	aLay[04] := STR0009 //	"|                                                                                                                                  |"
	aLay[05] := STR0010 //	"| EMPRESA:  ######################################     C.N.P.J.: ##################                I.E.:   #####################   |"
	aLay[06] := STR0011 //	"| ENDERECO: ######################################     CIDADE:   #############################     ESTADO: ##                      |"
	aLay[07] := STR0009 //	"|                                                                                                                                  |"
	aLay[08] := STR0006 //	"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[09] := STR0012 //	"|                          MOVIMENTOS DE SAIDA COM PRODUTOS INCENTIVADOS - POR NCM - DECRETO 31.250 - PE                           |"
    aLay[10] := STR0006 //	"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[11] := STR0013 //	"| NCM                                                                                            VALOR TOTAL SA�DAS INTERESTADUAIS |"	
	aLay[12] := STR0014 //	"|----------------------------------------------------------------------------------------------------------------------------------|"
	aLay[13] := STR0015 //	"| ##########                                                                                                ###################### |"
	aLay[14] := STR0014 //	"|----------------------------------------------------------------------------------------------------------------------------------|"
	aLay[15] := STR0016 //	"|                                                   *** NAO HOUVE MOVIMENTO ***                                                    |"
	aLay[16] := STR0017 //	"|                                                                TOTAL GERAL DAS SA�DAS INTERESTADUAIS      ###################### |"
	aLay[17] := STR0018 //	"|                                                                TOTAL SALDO DEVEDOR DO PER�ODO ANTERIOR    ###################### |"
	aLay[18] := STR0020 //	"|                                                                TOTAL BENEF�CIO CR�DITO PRESUMIDO          ###################### |"
	aLay[19] := STR0019 //	"|                                             EMISSAO: DE  ##########  ATE  ##########                                             |"	

Return .T.

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �Mtr988Cabec� Autor �Luciana Pires       � Data � 07/03/2008  ���
��������������������������������������������������������������������������͹��
���Desc.     �Cabecalho do relatorio                                       ���
���          �                                                             ���
��������������������������������������������������������������������������͹��
���Uso       �Matr988                                                      ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Static Function Mtr988Cabec(nPagina,dDataIni,dDataFin)
Local nLinha	:= 0
Local aLay		:= Array(19)

R988LayOut(@aLay)
	
@nLinha,000 PSAY AvalImp(Limite)
	
FmtLin({},aLay[01],,,@nLinha)
FmtLin({},aLay[02],,,@nLinha)
FmtLin({StrZero(nPagina,6)},aLay[03],,,@nLinha)     
FmtLin({dDataIni,dDataFin},aLay[19],,,@nLinha)                         
FmtLin({},aLay[04],,,@nLinha)                              
FmtLin({SM0->M0_NOMECOM,Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),SM0->M0_INSC},aLay[05],,,@nLinha)
FmtLin({SM0->M0_ENDENT,SM0->M0_CIDENT,SM0->M0_ESTENT},aLay[06],,,@nLinha)
FmtLin({},aLay[07],,,@nLinha)           
FmtLin({},aLay[08],,,@nLinha)           
FmtLin({},aLay[09],,,@nLinha)           
FmtLin({},aLay[10],,,@nLinha)           
FmtLin({},aLay[11],,,@nLinha)           
FmtLin({},aLay[12],,,@nLinha)           		

Return(nLinha)
