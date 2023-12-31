#INCLUDE "MATR952.CH"
#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MATR952  � Autor � Nereu Humberto Junior � Data � 19.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio de Contratos de Parceria.                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
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
Function MATR952( cAlias, nReg )
Local oReport
PRIVATE lAuto := (nReg!=Nil) 

//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������
oReport := ReportDef(nReg)
oReport:PrintDialog()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Nereu Humberto Junior  � Data �17.05.2006���
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
Static Function ReportDef(nReg)

Local oReport 
Local oSection1
Local oSection2 
Local oSection3 
Local oSection4
Local oSection5
Local oCell         
Local aOrdem := {}
Local cAliasSC3 := GetNextAlias()

If Type("lAuto") == "U"
	lAuto := (nReg!=Nil)
Endif

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
oReport:= TReport():New("MATR952",STR0001,If(lAuto,Nil,"MTR952"), {|oReport| ReportPrint(oReport,cAliasSC3,nReg)},STR0002+" "+STR0003) //"Contratos em Aberto"##"Emite uma relacao com as informacoes referentes"##"aos Contratos de Parceria."
oReport:SetLandscape()    
oReport:SetTotalInLine(.F.)
Pergunte("MTR952",.F.)
Aadd( aOrdem, STR0007 ) // "Por Numero"
Aadd( aOrdem, STR0008 ) // "Por Fornecedor"
Aadd( aOrdem, STR0009 ) // "Por Produto"

oSection1 := TRSection():New(oReport,STR0001,{"SC3","SE4"},aOrdem) //"Contratos em Aberto"
oSection1 :SetHeaderSection()
oSection1 :SetTotalInLine(.F.)
oSection1 :SetTotalText(STR0028)
oSection1:SetNoFilter({"SE4"})

TRCell():New(oSection1,"C3_NUM","SC3",STR0031,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C3_EMISSAO","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C3_COND","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"E4_DESCRI","SE4",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C3_FILENT","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C3_MOEDA","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"cDescMoed","   ",STR0029,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| AllTrim(SuperGetMv("MV_MOEDA"+AllTrim(Str(Max((cAliasSC3)->C3_MOEDA,1),2)))) }) //Descricao

oSection2 := TRSection():New(oSection1,STR0032,{"SA2","SC3"}) 
oSection2 :SetTotalInLine(.F.)
oSection2 :SetTotalText(STR0028)

TRCell():New(oSection2,"A2_COD","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"A2_LOJA","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"A2_NOME","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C3_CONTATO","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"cTpFRETE","   ",STR0024,/*Picture*/,24,/*lPixel*/,{|| RetTipoFrete((cAliasSC3)->C3_TPFRETE) }) 

oSection3 := TRSection():New(oSection2,STR0033,{"SC3","SB1","SA2"}) 
oSection3 :SetHeaderPage()

TRCell():New(oSection3,"C3_ITEM","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"C3_PRODUTO","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B1_DESC","SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"C3_QUANT","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"C3_PRECO","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"C3_TOTAL","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"C3_DATPRI","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"C3_DATPRF","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"C3_LOCAL","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"C3_QUANT","SC3",STR0030,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasSC3)->C3_QUANT - (cAliasSC3)->C3_QUJE }) //Saldo
TRCell():New(oSection3,"C3_RESIDUO","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| IIF((cAliasSC3)->C3_RESIDUO=="S",STR0026,STR0027) })
TRCell():New(oSection3,"C3_OBS","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"C3_NUM","SC3",STR0017,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"C3_EMISSAO","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"C3_FILENT","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTpFRETE","   ",STR0024,/*Picture*/,24,/*lPixel*/,{|| RetTipoFrete((cAliasSC3)->C3_TPFRETE) }) 

oSection4 := TRSection():New(oReport,STR0034,{"SC3","SB1"}) 
oSection4 :SetTotalInLine(.F.)
oSection4 :SetTotalText(STR0028)

TRCell():New(oSection4,"C3_PRODUTO","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"B1_DESC","SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection5 := TRSection():New(oSection4,STR0035,{"SC3","SA2"}) 
oSection5 :SetHeaderPage()

TRCell():New(oSection5,"C3_ITEM","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection5,"C3_QUANT","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection5,"C3_PRECO","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection5,"C3_TOTAL","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection5,"C3_DATPRI","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection5,"C3_DATPRF","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection5,"C3_LOCAL","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection5,"C3_QUANT","SC3",STR0030,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasSC3)->C3_QUANT - (cAliasSC3)->C3_QUJE },,,,,,.F.) //Saldo
TRCell():New(oSection5,"C3_RESIDUO","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| IIF((cAliasSC3)->C3_RESIDUO=="S",STR0026,STR0027) },,,,,,.F.)
TRCell():New(oSection5,"C3_OBS","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.T.)
TRCell():New(oSection5,"C3_NUM","SC3",STR0017,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection5,"C3_EMISSAO","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection5,"C3_COND","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.T.)
TRCell():New(oSection5,"C3_MOEDA","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection5,"C3_FILENT","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection5,"cTpFRETE","   ",STR0024,/*Picture*/,24,/*lPixel*/,{|| RetTipoFrete((cAliasSC3)->C3_TPFRETE) },,,,,,.F.) 
TRCell():New(oSection5,"A2_COD","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection5,"A2_LOJA","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection5,"A2_NOME","SA2",/*Titulo*/,/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.T.)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Nereu Humberto Junior  � Data �16.05.2006���
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
Static Function ReportPrint(oReport,cAliasSC3,nReg)

Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(1):Section(1)  
Local oSection3 := oReport:Section(1):Section(1):Section(1)  
Local oSection4 := oReport:Section(2)
Local oSection5 := oReport:Section(2):Section(1)
Local cForn		:= ""
Local lFirst    := .F.
Local nOrdem    := oReport:Section(1):GetOrder() 
Local oBreak
Local cQuery := ""

If Type("lAuto") == "U"
	lAuto := (nReg!=Nil)
Endif

If nOrdem == 1
	oBreak := TRBreak():New(oSection3,oSection3:Cell("C3_NUM"),STR0028,.F.)
	TRFunction():New(oSection3:Cell("C3_TOTAL"),NIL,"SUM",oBreak,Nil,/*cPicture*/,/*uFormula*/,.F.,.F.,,oSection1) //"Total dos Itens: "
	oReport:SetTitle( oReport:Title()+" - "+STR0007) // "Por Numero"
	oSection5:Disable()
ElseIf nOrdem == 2
	TRFunction():New(oSection3:Cell("C3_TOTAL"),NIL,"SUM",/*oBreak*/,STR0028,/*cPicture*/,/*uFormula*/,.T.,.F.,,oSection2) //"Total dos Itens: "
	oReport:SetTitle( oReport:Title()+" - "+STR0008) // "Por Fornecedor"
	oSection5:Disable()
ElseIf nOrdem == 3
	TRFunction():New(oSection5:Cell("C3_TOTAL"),NIL,"SUM",/*oBreak*/,STR0028,/*cPicture*/,/*uFormula*/,.T.,.F.,,oSection4) //"Total dos Itens: "
	oReport:SetTitle( oReport:Title()+" - "+STR0009) // "Por Produto"
	oSection3:Disable()
Endif

dbSelectArea("SC3")
dbSetOrder(nOrdem)
If lAuto
	dbGoto(nReg)
	mv_par01 := SC3->C3_EMISSAO
	mv_par02 := SC3->C3_EMISSAO
	mv_par03 := SC3->C3_NUM      
	mv_par04 := SC3->C3_NUM      
	mv_par05 := SC3->C3_FORNECE  
	mv_par06 := SC3->C3_FORNECE  
	mv_par07 := SC3->C3_LOJA     
	mv_par08 := SC3->C3_LOJA     
	mv_par09 := Space(15)
	mv_par10 := Repli("Z",15)
	mv_par11 := Space(02)
	mv_par12 := Repli("Z",2)
	mv_par13 := 1
Endif	

If mv_par13 == 1
	oReport:SetTitle( oReport:Title()+STR0013) //" - Todos"
ElseIf mv_par13 == 2
	oReport:SetTitle( oReport:Title()+STR0014) //" - Pendentes"
ElseIf mv_par13 == 3
	oReport:SetTitle( oReport:Title()+STR0015) //" - Parciais"
Else
	oReport:SetTitle( oReport:Title()+STR0016) //" - Atendidos"
Endif

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������

//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �	
//��������������������������������������������������������������������������
If !lAuto
	MakeSqlExpr(oReport:uParam)
Endif	
//������������������������������������������������������������������������Ŀ
//�Query do relat�rio da secao 1                                           �
//��������������������������������������������������������������������������
If nOrdem <> 3
	oReport:Section(1):BeginQuery()	
Else
	oReport:Section(2):BeginQuery()	
Endif	

cQuery :="%"
If mv_par13 == 2 
	cQuery += "AND C3_QUJE = 0 "	
ElseIf mv_par13 == 3
	cQuery += "AND (C3_QUJE > 0 AND C3_QUANT > C3_QUJE) "	
ElseIf mv_par13 == 4
	cQuery += "AND C3_QUJE = C3_QUANT "	
Endif
cQuery +="%"	

BeginSql Alias cAliasSC3

SELECT SC3.*

FROM %table:SC3% SC3

WHERE C3_FILIAL = %xFilial:SC3% AND 
  		  C3_EMISSAO  >= %Exp:Dtos(mv_par01)% AND 
	  C3_EMISSAO  <= %Exp:Dtos(mv_par02)% AND 
	  C3_NUM >= %Exp:mv_par03% AND 
	  C3_NUM <= %Exp:mv_par04% AND 	 	  
 	  C3_FORNECE >= %Exp:mv_par05% AND 
	  C3_FORNECE <= %Exp:mv_par06% AND 
	  C3_LOJA >= %Exp:mv_par07% AND 
	  C3_LOJA <= %Exp:mv_par08% AND 	 	  	
	  C3_PRODUTO >= %Exp:mv_par09% AND 
	  C3_PRODUTO <= %Exp:mv_par10% AND 
  		  C3_LOCAL >= %Exp:mv_par11% AND 
	  C3_LOCAL <= %Exp:mv_par12% AND 
	  SC3.%NotDel% 
	  %Exp:cQuery%
	  
ORDER BY %Order:SC3% 
		
EndSql 
//������������������������������������������������������������������������Ŀ
//�Metodo EndQuery ( Classe TRSection )                                    �
//�                                                                        �
//�Prepara o relat�rio para executar o Embedded SQL.                       �
//�                                                                        �
//�ExpA1 : Array com os parametros do tipo Range                           �
//�                                                                        �
//��������������������������������������������������������������������������
If nOrdem <> 3
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
Else
	oReport:Section(2):EndQuery(/*Array com os parametros do tipo Range*/)
Endif	


If nOrdem == 3
	oSection1:SetParentQuery()
Else
	oSection2:SetParentQuery()
EndIf
oSection3:SetParentQuery()
oSection4:SetParentQuery()
oSection5:SetParentQuery()

If nOrdem == 3 .Or. nOrdem == 1
	oSection1:SetParentRecno(.T.)
Else 
	oSection2:SetParentRecno(.T.)
EndIf

Do Case
	Case nOrdem == 1
		oSection2:SetParentFilter( { |cParam| (cAliasSC3)->C3_NUM == cParam },{ || (cAliasSC3)->C3_NUM })
		oSection3:SetParentFilter( { |cParam| (cAliasSC3)->C3_NUM == cParam },{ || (cAliasSC3)->C3_NUM })			
		//oSection3:SetParentRecno(.T.)

	Case nOrdem == 2
		oSection2:SetParentFilter( { |cParam| (cAliasSC3)->C3_FORNECE+(cAliasSC3)->C3_LOJA == cParam },{ || (cAliasSC3)->C3_FORNECE+(cAliasSC3)->C3_LOJA })
		oSection3:SetParentFilter( { |cParam| (cAliasSC3)->C3_FORNECE+(cAliasSC3)->C3_LOJA == cParam },{ || (cAliasSC3)->C3_FORNECE+(cAliasSC3)->C3_LOJA })

	Case nOrdem == 3
		oSection5:SetParentFilter( { |cParam| (cAliasSC3)->C3_PRODUTO == cParam },{ || (cAliasSC3)->C3_PRODUTO })
EndCase
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
TRPosition():New(oSection1,"SE4",1,{|| xFilial("SE4") + (cAliasSC3)->C3_COND})
TRPosition():New(oSection2,"SA2",1,{|| xFilial("SA2") + (cAliasSC3)->C3_FORNECE+(cAliasSC3)->C3_LOJA})
TRPosition():New(oSection3,"SB1",1,{|| xFilial("SB1") + (cAliasSC3)->C3_PRODUTO}	)

TRPosition():New(oSection4,"SB1",1,{|| xFilial("SB1") + (cAliasSC3)->C3_PRODUTO})
TRPosition():New(oSection5,"SA2",1,{|| xFilial("SA2") + (cAliasSC3)->C3_FORNECE+(cAliasSC3)->C3_LOJA})

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
oReport:SetMeter(SC3->(LastRec()))

Do Case
		Case nOrdem == 1
			oSection3:Cell("C3_NUM"):Disable()
			oSection3:Cell("C3_EMISSAO"):Disable()
			oSection3:Cell("C3_FILENT"):Disable()
			oSection3:Cell("cTpFRETE"):Disable()

			oSection1:Print()
		Case nOrdem == 2

			oSection3:Cell("C3_NUM"):Enable()
			oSection3:Cell("C3_EMISSAO"):Enable()
			oSection3:Cell("C3_FILENT"):Enable()
			oSection3:Cell("cTpFRETE"):Enable()

			oSection2:Cell("C3_CONTATO"):Disable()
			oSection2:Cell("cTpFRETE"):Disable()
			
			oSection2:Print()
	
		Case nOrdem == 3

			oSection4:Print()
EndCase			

Return NIL