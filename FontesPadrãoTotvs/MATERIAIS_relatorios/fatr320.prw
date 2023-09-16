#INCLUDE "rwmake.ch" 
#INCLUDE "FATR320.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FINR320  � Autor � Marco Bianchi         � Data � 09/08/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � WorkArea - Release 4.                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Function FATR320(aParam)

Local oReport


oReport := ReportDef(aParam)
oReport:PrintDialog()


Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Marco Bianchi         � Data � 09/08/06 ���
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
Static Function ReportDef(aParam)

Local oReport		:= Nil
Local cAliasSA3	:= ""
Local cAliasAD7	:= ""
Local cAliasAD8	:= ""


cAliasAD7 := GetNextAlias()
cAliasSA3 := GetNextAlias()
cAliasAD8 := GetNextAlias()



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
oReport := TReport():New("FATR320",STR0019,"FTR320P9R1", {|oReport| ReportPrint(oReport,cAliasSA3,cAliasAD7,aParam,cAliasAD8)},STR0020 + " " + STR0021)	// "Workarea"###"Este programa tem como objetivo imprimir relatorio "###"de acordo com os parametros informados pelo usuario."
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)

Pergunte("FTR320P9R1",.F.)

//������������������������������������������������������������������������Ŀ
//�Verifica as Perguntas Seleciondas                                       �
//��������������������������������������������������������������������������
If ( aParam == Nil )
	Pergunte(oReport:uParam,.F.)
EndIf

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
//������������������������������������������������������������������������Ŀ
//�Vendedor - Setion(1)                                                    �
//��������������������������������������������������������������������������
oVendedor := TRSection():New(oReport,STR0019,{"SA3"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Area de trabalho"
oVendedor:SetTotalInLine(.F.)
TRCell():New(oVendedor,"A3_COD"		,"SA3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oVendedor,"A3_NOME"	,"SA3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

//������������������������������������������������������������������������Ŀ
//�Agenda - Setion(1):Section(1)                                           �
//��������������������������������������������������������������������������
oAgenda := TRSection():New(oVendedor,STR0019,{"AD7","SUS","SU5"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Area de Trabalho"
oAgenda:SetTotalInLine(.F.)
TRCell():New(oAgenda,"AD7_TOPICO"	,"AD7",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgenda,"AD7_DATA"		,"AD7",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgenda,"AD7_HORA1"	,"AD7",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgenda,"AD7_HORA2"	,"AD7",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgenda,"CMEMO"		,"AD7",STR0022		,/*Picture*/,40			,/*lPixel*/,{|| MSMM((cAliasAD7)->AD7_CODMEM) })	// "Comentario"
TRCell():New(oAgenda,"AD7_NROPOR"	,"AD7",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgenda,"AD7_CODCLI"	,"AD7",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgenda,"AD7_LOJA"		,"AD7",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgenda,"A1_NOME"		,"SA1",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgenda,"AD7_PROSPE"	,"AD7",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgenda,"AD7_LOJPRO"	,"AD7",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgenda,"US_NOME"		,"SUS",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgenda,"U5_CONTAT"	,"SU5",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

//������������������������������������������������������������������������Ŀ
//�Faz a quebra de linha para impressao de campos MEMO                     �
//��������������������������������������������������������������������������
oReport:Section(1):Section(1):Cell("CMEMO"):SetLineBreak()

//������������������������������������������������������������������������Ŀ
//�Tarefas - Section(2)                                                    �
//��������������������������������������������������������������������������
oTarefa := TRSection():New(oReport,STR0025,{"AD8","SA1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Workarea"
oTarefa:SetTotalInLine(.F.)
TRCell():New(oTarefa,"AD8_TOPICO"	,"AD8",/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTarefa,"AD8_DTINI"	,"AD8",/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTarefa,"AD8_DTFIM"	,"AD8",/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTarefa,"AD8_STATUS"	,"AD8",/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTarefa,"AD8_PRIOR"	,"AD8",/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTarefa,"AD8_PERC"		,"AD8",/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTarefa,"CMEMO"		,"AD8",STR0022		,/*Picture*/,40		   		,/*lPixel*/,{|| MSMM((cAliasAD8)->AD8_CODMEM) })		// "Comentario"
TRCell():New(oTarefa,"AD8_CODCLI"	,"AD8",/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTarefa,"AD8_LOJCLI"	,"AD8",/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTarefa,"A1_NOME"		,"SA1",/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)

//������������������������������������������������������������������������Ŀ
//�Faz a quebra de linha para impressao de campos MEMO                     �
//��������������������������������������������������������������������������
oReport:Section(2):Cell("CMEMO"):SetLineBreak()

//������������������������������������������������������������������������Ŀ
//�Busca descricao de campos do tipo ComboBox                              �
//��������������������������������������������������������������������������
oReport:Section(2):Cell("AD8_STATUS"):SetCBox("1="+STR0008+";2="+STR0009+";3="+STR0010+";4="+STR0011+";5="+STR0012)
oReport:Section(2):Cell("AD8_PRIOR"):SetCBox("1="+STR0013+";2="+STR0014+";3="+STR0015)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Marco Bianchi         � Data � 09/08/06 ���
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
���04/04/2007�Norbert Waage  �Bops 122912 - Correcao da sintaxe das con-  ���
���          �               �dicoes em SQL e CodeBase.                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasSA3,cAliasAD7,aParam,cAliasAD8)

Local lQuery    := .F.
Local cRepr     := ""
Local dDataIni  := CTOD("  /  /  ")
Local dDataFim  := CTOD("  /  /  ")
Local dDtTaskIni:= CTOD("  /  /  ")
Local dDtTaskFim:= CTOD("  /  /  ")
Local nListTar  := 0
Local nSaltaPag := 0
Local nLoop 	:= 0
Local lAgend	:= .F.
Local cTxtAgend := Upper(Posicione("SX2",1,"AD7","X2NOME()"))
Local cTxtTaref := Upper(Posicione("SX2",1,"AD8","X2NOME()"))
Local cOrder    := ""	


//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//�Carrega variaveis para filtro                                           �
//��������������������������������������������������������������������������
If ( aParam <> Nil )
	For nLoop := 1 To Len( aParam )
		lImpParam:= .F.
		cTipo	:= aParam[ nLoop, 1 ]
		Do Case
		Case cTipo == "REPRID_FROM"
			cRepr  := aParam[nLoop,2]
		Case cTipo == "REPRID_TO"
			cRepr := aParam[nLoop,2]
		Case cTipo == "DATE_TO"
			dDataIni  := aParam[nLoop,2]
			dDtTaskIni:= aParam[nLoop,2]
		Case cTipo == "DATE_FROM"
			dDataFim  := aParam[nLoop,2]
			dDtTaskFim:= aParam[nLoop,2]				
		Case cTipo == "LIST_TASK"
			nListTar := aParam[nLoop,2]
		Case cTipo == "TASK_FROM"
			nTaskFrom:= aParam[nLoop,2]
		Case cTipo == "EJECT_PAGE"
			nSaltaPag := aParam[nLoop,2]
		EndCase
	Next nLoop

	Do Case
	Case nTaskFrom == 1
		dDtTaskIni := FirstDay(dDataIni)
		dDtTaskFim := LastDay(dDataIni)
	Case nTaskFrom == 2
		aSemana := LimSemana( dDataIni )
		dDtTaskIni := aSemana[1]
		dDtTaskFim := aSemana[2]
	EndCase
	
Else
	cRepr     := MV_PAR01    // Representante(s)
	dDataIni  := MV_PAR02    // Data De
	dDataFim  := MV_PAR03    // Data Ate
	dDtTaskIni:= MV_PAR02    // Data De
	dDtTaskFim:= MV_PAR03    // Data Ate
	nListTar  := MV_PAR04    // Listar Tarefas (Pendentes, Concluidas, Todas)
	nSaltaPag := MV_PAR05    // Salta Pagina por Representante
EndIf

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������


//������������������������������������������������������������������������Ŀ
//�Query do relat�rio da secao 1                                           �
//��������������������������������������������������������������������������
lQuery := .T.
If Empty(cRepr)
	cRepr := "% %"
Else
	cRepr := "%" + cRepr + "AND %"
EndIf
cOrder := "%" + SA3->(IndexKey()) + "%"
oReport:Section(1):BeginQuery()	
BeginSql Alias cAliasSA3
SELECT *
FROM %Table:SA3% SA3
WHERE A3_FILIAL = %xFilial:SA3% AND 
	%Exp:cRepr%
	SA3.%NotDel%
ORDER BY %Exp:SqlOrder(cOrder)%
EndSql 
oReport:Section(1):EndQuery({MV_PAR01})

dbSelectArea(cAliasSA3)
dbGoTop()
	
//������������������������������������������������������������������������Ŀ
//�Define regra de saida do loop quando mutilizado metodo Print            �
//�Altera texto dos totalizadores de acordo com ordem selecionada          �
//��������������������������������������������������������������������������
If lQuery
	oReport:Section(1):Section(1):SetParentFilter({|x| (cAliasAD7)->AD7_FILIAL+(cAliasAD7)->AD7_VEND == x}, {||xFilial("AD7")+(cAliasSA3)->A3_COD} )
EndIf	

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
TRPosition():New(oReport:Section(1):Section(1),"SA1",1,{|| xFilial("SA1")+(cAliasAD7)->AD7_CODCLI+(cAliasAD7)->AD7_LOJA })
TRPosition():New(oReport:Section(2),"SA1",1,{|| xFilial("SA1")+(cAliasAD8)->AD8_CODCLI+(cAliasAD8)->AD8_LOJCLI })

TRPosition():New(oReport:Section(1):Section(1),"SU5",1,{|| xFilial("SU5")+(cAliasAD7)->AD7_CONTAT })
TRPosition():New(oReport:Section(1):Section(1),"SUS",1,{|| xFilial("SUS")+(cAliasAD7)->AD7_PROSPE+(cAliasAD7)->AD7_LOJPRO })

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
oReport:SetMeter((cAliasSA3)->(LastRec()))
While !oReport:Cancel() .And. !(cAliasSA3)->(Eof())
	
	cVendedor := (cAliasSA3)->A3_COD
	cCodUsr   := (cAliasSA3)->A3_CODUSR

	AD7->(dbSetOrder(1))
	cOrder := "%" + AD7->(IndexKey()) + "%"
	oReport:Section(1):Section(1):BeginQuery()	
	BeginSql Alias cAliasAD7
	SELECT *
	FROM %Table:SA3% SA3,%Table:AD7% AD7
	WHERE A3_FILIAL = %xFilial:SA3% AND 
		SA3.%NotDel% AND 
		AD7_FILIAL = %xFilial:AD7% AND 
		AD7_DATA >= %Exp:DTOS(dDataIni)% AND AD7_DATA <= %Exp:DTOS(dDataFim)% AND 
		AD7_VEND = A3_COD AND 
		AD7.%NotDel%
	ORDER BY %Exp:SqlOrder(cOrder)%
	EndSql 
	oReport:Section(1):Section(1):EndQuery({MV_PAR01})
	
	dbSelectArea(cAliasAD7)
	dbGoTop()

	If !lQuery
		dbSelectArea(cAliasAD7)
		dbSetOrder(1)
		dbSeek(xFilial(cAliasAD7)+(cAliasSA3)->A3_COD  )
	EndIf	

	//������������������������������������������������������������������������Ŀ
	//�Impressao das Agendas do Representante                                  �
	//��������������������������������������������������������������������������
	oReport:Section(1):Init()
	oReport:Section(1):Section(1):Init()

	lAgend := .F.
	dbSelectArea(cAliasAD7)
	While !oReport:Cancel() .And. !(cAliasAD7)->(Eof())
		If (cAliasAD7)->AD7_VEND == cVendedor
			If !lAgend
				oReport:Section(1):PrintLine()
				lAgend := .T.
				oReport:PrintText(" ")
				oReport:PrintText(cTxtAgend)
				oReport:PrintText(Replicate("-",Len(AllTrim(cTxtAgend))))
			EndIf
			oReport:section(1):Section(1):PrintLine()
		EndIf
		(cAliasAD7)->(dbSkip())
	EndDo
	oReport:Section(1):Section(1):Finish()
	If lAgend
		oReport:Section(1):Finish()
	EndIf

	//������������������������������������������������������������������������Ŀ
	//�Filtro das Tarefas do Representante                                     �
	//��������������������������������������������������������������������������
	dbSelectArea("AD8")		// Tarefas (CRM)
	dbSetOrder(2)			// Codigo do Usuario, Data inicial
	
	cOrder := "%" + AD8->(IndexKey()) + "%"
	cWhere := "%"
	Do Case
	Case nListTar == 1
		cWhere += "AD8_STATUS<>'5' AND AD8_STATUS<>'3' AND "
	Case nListTar == 2
		cWhere += "( AD8_STATUS='5' OR AD8_STATUS='3' ) AND "
	EndCase
	cWhere += "%"

	oReport:Section(2):BeginQuery()	
	BeginSql Alias cAliasAD8
	SELECT *	
	FROM %Table:AD8% AD8
	WHERE 
		AD8_FILIAL = %xFilial:AD8% AND
		AD8_CODUSR = %Exp:cCodUsr%     AND 
		AD8_DTINI >= %Exp:DToS( dDtTaskIni )% AND 
		AD8_DTINI <= %Exp:DToS( dDtTaskFim )% AND 
		%Exp:cWhere%
		AD8.%Notdel%
	ORDER BY %Exp:SqlOrder(cOrder)%
	EndSql 
	oReport:Section(2):EndQuery(/*Array com os parametros do tipo Range*/)
	
	
	
	//������������������������������������������������������������������������Ŀ
	//�Impressao das Tarefas do representante                                  �
	//��������������������������������������������������������������������������
	If !(cAliasAD8)->(Eof())
		If !lAgend
			oReport:Section(1):PrintLine()
			oReport:Section(1):Finish()
		EndIf
		oReport:PrintText(" ")
		oReport:PrintText(cTxtTaref)
		oReport:PrintText(Replicate("-",Len(AllTrim(cTxtTaref))))
		oReport:Section(2):Print()
	EndIf
	
    If nSaltaPag == 1
    	oReport:Section(1):SetPageBreak()
    EndIf
	
	dbSelectArea(cAliasSA3)
	If !lQuery
		dbSkip()
	Else
		(cAliasSA3)->(dbSkip())
	EndIf	
	oReport:IncMeter()
EndDo

Return