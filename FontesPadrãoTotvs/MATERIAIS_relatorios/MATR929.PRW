#INCLUDE "MATR929.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MATR929   � Autor �Gustavo G. Rueda       � Data �23/09/2004���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relacao de Retencao de IRRF                                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �MATR929()       			                   	              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum   				     	               		          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �NIL            				     	               		  ���
�������������������������������������������������������������������������Ĵ��
���Uso       �SIGAFIS                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Function MATR929 ()
Local	wnrel		:=	"MATR929"	
Local	cDesc1		:=	STR0001									//"Relacao de Valores a Recolher IRRF - Motoristas Agregados."
Local	cDesc2		:=	STR0002									//"Emite a Relacao de Recolhimento de IRRF - Motoristas Agregados."
Local	cDesc3		:=	""
Local	Tamanho		:=	"G" 
Local	cAliasDty	:=	"DTY" 	
Local	Titulo		:=	STR0001									//"Relacao de Valores a Recolher IRRF - Motoristas Agregados."
Local	lEnd		:=	.F.										//'Controle de cancelamento do relatorio'
Local	lRet		:=	.T.
Local	cPerg		:=	"MTR929"
Local 	lVerpesssen := Iif(FindFunction("Verpesssen"),Verpesssen(),.T.)
Private	aReturn		:=	{STR0003, 1,STR0004 , 1, 2, 1, '', 1 }	//"Zebrado"###"Administracao"
Private	nLastKey	:=	0  										//' Controla o cancelamento da SetPrint e SetDefault'

If !(IntTms()) //-- Verifica se o par�metro MV_INTTMS est� configurado para integra��o do TMS.
	FormBatch (OemToAnsi (STR0047), {;
		OemToAnsi (STR0048), OemToAnsi (STR0049), OemToAnsi (STR0050), OemToAnsi ("")},;
		{{ 1, .T., {|o| o:oWnd:End ()}}})
	Return (lRet)
EndIf

If lVerpesssen
	//��������������������������������������������������������������Ŀ
	//� Carrega as perguntas selecionadas                            �
	//����������������������������������������������������������������
	//��������������������������������������������������������������Ŀ
	//� mv_par01 - Periodo De    ?                                   �
	//� mv_par02 - Periodo Ate   ?                                   �
	//� mv_par03 - Tipo Apuracao ? = 1-Decendial,2-Quinzenal,3-Mensal�
	//� mv_par04 - Imprime Apuracoes ? = 1-Sim,2-Nao.(Cols.Acumulado)�
	//����������������������������������������������������������������
	Pergunte (cPerg, .T.)
	//��������������������������������������������������������������Ŀ
	//� Envia controle para a funcao SETPRINT                        �
	//����������������������������������������������������������������
	wnrel:=SetPrint (cAliasDty, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho)

	If (nLastKey==27)
		Set Filter to
		Return (lRet)
	Endif

	SetDefault (aReturn, cAliasDty)

	If (nLastKey==27)
		Set Filter to
		Return (lRet)
	Endif

	RptStatus({|lEnd| R929Imp (@lEnd, wnRel, cAliasDty, Titulo, Tamanho)}, Titulo)
EndIf
Return (lRet)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R929Imp   � Autor �Gustavo G. Rueda       � Data �23/09/2004���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime a Relacao de Retencao de IRRF                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpL1 - Variavel de controle para cancelamento do relatorio ���
���          �ExpC1 - Nome do Arquivo (TMSR430)                           ���
���          �ExpC2 - Alias utilizado na Filtragem (DTY)                  ���
���          �ExpC3 - Titulo do Relatorio                                 ���
���          �ExpN1 - Tamanho do Relatorio (G)                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �NIL                                                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       �TMSR430                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function R929Imp (lEnd, wnRel, cAliasDty, Titulo, Tamanho)
	Local		cChave		:=	""	
	Local		Cabec1 		:= 	""
	Local		Cabec2 		:= 	""
	Local		cCabec1 	:= 	""
	Local		cCabec2 	:= 	""
	Local		aLay		:=	R929Lay (@Cabec1, @Cabec2)	
	Local 		nTipo		:= 	Iif (aReturn[4]==1, 15, 18)	//Inicializa os codigos de caracter Comprimido/Normal da impressora	
	Local		lRet		:=	.T.
	Local		nTotFrete	:=	0
	Local		nTotIRRF	:=	0
	Local		aBaseReg	:=	{}
	Local		aCabecRel	:=	{}
	Local		aRet		:=	{}
	Local		nAcumulado	:=	0
	Local		cDescTpApur	:=	Iif (MV_PAR03==1, "Decendial", Iif (MV_PAR03==2, "Quinzenal", "Mensal"))+" - "+StrZero (Day (MV_PAR01), 2)+"/"+StrZero (Month (MV_PAR01), 2)+"/"+StrZero (Year (MV_PAR01), 4)+" a "+StrZero (Day (MV_PAR02), 2)+"/"+StrZero (Month (MV_PAR02), 2)+"/"+StrZero (Year (MV_PAR02), 4)
	Local		lImprimiu	:=	.F.
	Local		nTotDirf40	:=	0
	Local		nTot1Dec	:=	0
	Local		nTot2Dec	:=	0
	Local		nTot3Dec	:=	0
	Local		nTotDesc	:=	0
	Local		nTotTrib	:=	0
	Private 	m_pag  		:= 	1
	Private 	li   		:= 	99
	//
	If (MV_PAR03)==1 .And. (MV_PAR04==1)
		aCabecRel	:=	{aLay[15], aLay[16], aLay[17], aLay[18], aLay[19], aLay[20], aLay[21]}
	ElseIf (MV_PAR03)==2 .And. (MV_PAR04==1)
		aCabecRel	:=	{aLay[5], aLay[6], aLay[7], aLay[8], aLay[12], aLay[13], aLay[14]}
	Else
		aCabecRel	:=	{aLay[1], aLay[2], aLay[3], aLay[4], aLay[9], aLay[10], aLay[11]}
	EndIf
	//
	aRet	:=	AlimentTrb (cAliasDty)
	//
	If (lEnd)
		li++
		@ PROW ()+1, 001 PSAY STR0036	//"CANCELADO PELO OPERADOR"
		Return (lRet)
	EndIf
	//
	DbSelectArea ("TRB")
	TRB->(DbGoTop ())
	//
	Do While !TRB->(Eof ())
		If Empty(TRB->TRB_IRRF)
			TRB->(DbSkip ())
			Loop
		Endif
		lImprimiu	:=	.T.
		//
		If !(Left (cChave, 6)==TRB->TRB_ANO+TRB->TRB_MES)
			If (li<>99)
				FmtLin (, aCabecRel[3],,, li++)
				ImpTot (@li, nTotFrete, nTotDirf40, nTot1Dec, nTot2Dec, nTot3Dec, nTotDesc, nTotTrib, nTotIRRF, aCabecRel, 6)
			EndIf
			//
			nTotFrete	:=	0
			nTotIRRF	:=	0
			nTotDirf40	:=	0
			nTot1Dec	:=	0
			nTot2Dec	:=	0
			nTot3Dec	:=	0
			nTotDesc	:=	0
			nTotTrib	:=	0
			cCabec1		:=	Cabec1+cDescTpApur+Space (60)+MesExtenso (Val (TRB->TRB_MES))+"/"+TRB->TRB_ANO
			cCabec2		:=	Cabec2+AllTrim (SM0->M0_NOMECOM)
			//
			Cabec (Titulo, cCabec1, cCabec2, wnRel, Tamanho, nTipo)
			FmtLin (, aCabecRel[1],,, li++)
			FmtLin (, aCabecRel[2],,, li++)
			FmtLin (, aCabecRel[3],,, li++)
		EndIf
		cChave	:=	TRB->TRB_ANO+TRB->TRB_MES+TRB->TRB_FORN+TRB->TRB_LOJA
		//
		Do While !TRB->(Eof ()) .And. (cChave==TRB->TRB_ANO+TRB->TRB_MES+TRB->TRB_FORN+TRB->TRB_LOJA)
			//
			If (MV_PAR03)==1 .And. (MV_PAR04==1)
				aBaseReg	:=	{TRB_MOTOR, TRB->TRB_CPF, Transform (TRB->TRB_FRETE, "@E 99,99,999.99"), Transform (TRB->TRB_FRETE*(40/100), "@E 99,99,999.99"), Transform (TRB->TRB_ACUM1, "@E 9,999,999,999.99"), Transform (TRB->TRB_ACUM2, "@E 9,999,999,999.99"), Transform (TRB->TRB_ACUM3, "@E 9,999,999,999.99"), Transform (TRB->TRB_DESC, "@E 99,99,999.99"), Transform (TRB->TRB_TRIB, "@E 99,99,999.99"), Transform (TRB->TRB_IRRF, "@E 99,99,999.99")}
			ElseIf (MV_PAR03)==2 .And. (MV_PAR04==1)
				aBaseReg	:=	{TRB_MOTOR, TRB->TRB_CPF, Transform (TRB->TRB_FRETE, "@E 99,99,999.99"), Transform (TRB->TRB_FRETE*(40/100), "@E 99,99,999.99"), Transform (TRB->TRB_ACUM1, "@E 9,999,999,999.99"), Transform (TRB->TRB_ACUM2, "@E 9,999,999,999.99"), Transform (TRB->TRB_DESC, "@E 99,99,999.99"), Transform (TRB->TRB_TRIB, "@E 99,99,999.99"), Transform (TRB->TRB_IRRF, "@E 99,99,999.99")}
			Else
				If (MV_PAR03==1)
					If (TRB->TRB_ACUM3>0)			// (*) Para nao pegar zerado quando for selecionado decendial com uma data intermediaria. Ex: 11/04/04 a 20/04/04, DECENDIAL, exibe apuracoes como NAO
						nAcumulado	:=	TRB->TRB_ACUM3
					ElseIf (TRB->TRB_ACUM2>0)	// (*)
						nAcumulado	:=	TRB->TRB_ACUM2
					Else
						nAcumulado	:=	TRB->TRB_ACUM1
					EndIf
				ElseIf (MV_PAR03==2)
					If (TRB->TRB_ACUM2>0)		// (*)
						nAcumulado	:=	TRB->TRB_ACUM2
					Else
						nAcumulado	:=	TRB->TRB_ACUM1
					EndIf
				Else
					nAcumulado	:=	TRB->TRB_ACUM1
				EndIf
				aBaseReg	:=	{TRB->TRB_MOTOR, TRB->TRB_CPF, Transform (TRB->TRB_FRETE, "@E 99,99,999.99"), Transform (TRB->TRB_FRETE*(40/100), "@E 99,99,999.99"), Transform (nAcumulado, "@E 9,999,999,999.99"), Transform (TRB->TRB_DESC, "@E 99,99,999.99"), Transform (TRB->TRB_TRIB, "@E 99,99,999.99"), Transform (TRB->TRB_IRRF, "@E 99,99,999.99")}
			EndIf
			//
			nTotFrete	+=	TRB->TRB_FRETE
			nTotDirf40	+=	TRB->TRB_FRETE*(40/100)
			nTot1Dec	+=	TRB->TRB_ACUM1
			nTot2Dec	+=	TRB->TRB_ACUM2
			nTot3Dec	+=	TRB->TRB_ACUM3
			nTotDesc	+=	TRB->TRB_DESC
			nTotTrib	+=	TRB->TRB_TRIB
			nTotIRRF	+=	TRB->TRB_IRRF
			//
	   		//-- Imprime o Cabecalho
			If (li>58)
				cCabec1	:=	Cabec1+cDescTpApur+Space (60)+MesExtenso (Val (TRB->TRB_MES))+"/"+TRB->TRB_ANO
				cCabec2	:=	Cabec2+AllTrim (SM0->M0_NOMECOM)
				//
				FmtLin (, aCabecRel[1],,, li++)
				Cabec (Titulo, Cabec1, Cabec2, wnRel, Tamanho, nTipo)
				FmtLin (, aCabecRel[1],,, li++)
				FmtLin (, aCabecRel[2],,, li++)
				FmtLin (, aCabecRel[3],,, li++)
			EndIf
			//
			FmtLin (aBaseReg, aCabecRel[4],,, li++)
			//
			TRB->(DbSkip ())
		EndDo
	EndDo
	//
	If (lImprimiu)
	 	//-- Imprime o Cabecalho 	
		If (li>58)
			If (li<>99)
				FmtLin (, aCabecRel[1],,, li++)
			EndIf
			//
			cCabec1	:=	Cabec1+cDescTpApur+Space (60)+MesExtenso (Val (TRB->TRB_MES))+"/"+TRB->TRB_ANO
			cCabec2	:=	Cabec2+AllTrim (SM0->M0_NOMECOM)
			//
			Cabec (Titulo, Cabec1, Cabec2, wnRel, Tamanho, nTipo)
			FmtLin (, aCabecRel[1],,, li++)
			FmtLin (, aCabecRel[2],,, li++)
			FmtLin (, aCabecRel[3],,, li++)
		Else
			FmtLin (, aCabecRel[3],,, li++)
		EndIf
		//
		ImpTot (@li, nTotFrete, nTotDirf40, nTot1Dec, nTot2Dec, nTot3Dec, nTotDesc, nTotTrib, nTotIRRF, aCabecRel, 6)
	EndIf
	//���������������������������������������������������������������������Ŀ
	//� Se impressao em disco, chama o gerenciador de impressao...          �
	//�����������������������������������������������������������������������
	If (aReturn[5]==1)
		DbCommitAll ()
		OurSpool (wnrel)
	Endif
	MS_FLUSH()
	//
	DbSelectArea (aRet[2])
	(aRet[2])->(DbCloseArea ())
	Ferase (aRet[1]+GetDBExtension ())
	Ferase (aRet[1]+OrdBagExt ())
Return (lRet)

Static Function ImpTot (li, nTotFrete, nTotDirf40, nTot1Dec, nTot2Dec, nTot3Dec, nTotDesc, nTotTrib, nTotIRRF, aCabecRel, nInd)
	Local	lRet		:=	.T.
	Local	aBaseReg	:=	{}
	//
	If (MV_PAR03)==1 .And. (MV_PAR04==1)
		aBaseReg	:=	{"R$",;
			Transform (nTotFrete, "@E 9,999,999.99"),;
			Transform (nTotDirf40, "@E 9,999,999.99"),;
			Transform (nTot1Dec, "@E 9,999,999,999.99"),;
			Transform (nTot2Dec, "@E 9,999,999,999.99"),;
			Transform (nTot3Dec, "@E 9,999,999,999.99"),;
			Transform (nTotDesc, "@E 9,999,999.99"),;
			Transform (nTotTrib, "@E 9,999,999.99"),;
			Transform (nTotIRRF, "@E 9,999,999.99")}
			
	ElseIf (MV_PAR03)==2 .And. (MV_PAR04==1)
		aBaseReg	:=	{"R$",;
			Transform (nTotFrete, "@E 9,999,999.99"),;
			Transform (nTotDirf40, "@E 9,999,999.99"),;
			Transform (nTot1Dec, "@E 9,999,999,999.99"),;
			Transform (nTot2Dec, "@E 9,999,999,999.99"),;
			Transform (nTotDesc, "@E 9,999,999.99"),;
			Transform (nTotTrib, "@E 9,999,999.99"),;
			Transform (nTotIRRF, "@E 9,999,999.99")}
	Else
		aBaseReg	:=	{"R$",;
			Transform (nTotFrete, "@E 9,999,999.99"),;
			Transform (nTotDirf40, "@E 9,999,999.99"),;
			Transform (nTot1Dec, "@E 9,999,999,999.99"),;
			Transform (nTotDesc, "@E 9,999,999.99"),;
			Transform (nTotTrib, "@E 9,999,999.99"),;
			Transform (nTotIRRF, "@E 9,999,999.99")}
	EndIf
	//
	FmtLin (aBaseReg, aCabecRel[6],,, li++)
	FmtLin (, aCabecRel[7],,, li++)
Return (lRet)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AlimentTrb � Autor �Gustavo G. Ruedaao  � Data � 23/09/2004 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Funcao de processamento da tabela DTY e criacao do TRB.     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC - Alias corrente da tabela DTY.                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA - Array contendo o nome fisico e logico do TRB criado. ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATR929                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function AlimentTrb (cAliasDty)
	Local 		cQuery		:=	""
	Local		cArqDty		:=	""
	Local		aRet		:=	{}
	Local		cQDataIni	:=	StrZero (Year (MV_PAR01), 4)+StrZero (Month (MV_PAR01), 2)+"01"		//Utilizada na Query e IndRegua
	Local		cQDataFim	:=	DToS (MV_PAR02)		//Utilizada na Query e IndRegua
	Local		cArq		:=	""
	Local		aStru		:=	{}
	Local		aTamF2_FOR	:=	TamSX3 ("DTY_CODFOR")
	Local		cAno		:=	""
	Local		cMes		:=	""
	Local		cCodForn	:=	""
	Local		cLojForn	:=	""
	Local		nA2_NumDep	:=	SA2->(FieldPos ("A2_NUMDEP"))
	//
	aAdd (aStru, {"TRB_ANO",		"C",	004,			0})
	aAdd (aStru, {"TRB_MES",		"C",	002,			0})
	aAdd (aStru, {"TRB_FORN",		"C",	aTamF2_FOR[1],	0})
	aAdd (aStru, {"TRB_LOJA",		"C",	002,			0})
	//
	aAdd (aStru, {"TRB_MOTOR",		"C",	040,			0})
	aAdd (aStru, {"TRB_CPF",		"C",	011,			0})
	aAdd (aStru, {"TRB_FRETE",		"N",	012,			2})
	aAdd (aStru, {"TRB_ACUM1",		"N",	016,			2})
	aAdd (aStru, {"TRB_ACUM2",		"N",	016,			2})
	aAdd (aStru, {"TRB_ACUM3",		"N",	016,			2})
	aAdd (aStru, {"TRB_DESC",		"N",	012,			2})
	aAdd (aStru, {"TRB_TRIB",		"N",	012,			2})
	aAdd (aStru, {"TRB_IRRF",		"N",	012,			2})
	//
	cArq	:=	CriaTrab (aStru)
	DbUseArea (.T.,__LocalDriver, cArq,"TRB")
	IndRegua ("TRB", cArq,"TRB_ANO+TRB_MES+TRB_FORN+TRB_LOJA")
	//
	aRet	:=	{cArq, "TRB"}
	//
	DbSelectArea (cAliasDty)
		DTY->(DbSetOrder (3))
    //    
	#IFDEF TOP
		If (TcSrvType ()<>"AS/400")
			cAliasDty	:=	"R929Imp"
			//
			cQuery	:=	"SELECT "
				cQuery	+=	"DTY.DTY_CODFOR, DTY.DTY_LOJFOR, SUBSTRING (DTY.DTY_DATCTC, 1, 6) ANOMES, MIN (SA2.A2_NOME) A2_NOME, MIN (SA2.A2_CGC) A2_CGC, MIN (SA2.A2_NUMDEP) A2_NUMDEP, SUM (DTY.DTY_IRRF) DTY_IRRF, SUM (DTY.DTY_INSS) DTY_INSS, SUM (DTY.DTY_VALFRE) DTY_VALFRE, '0D' CHAVE "
			cQuery	+=	"FROM "
				cQuery	+=	RetSqlName("DTY")+" DTY, "+RetSqlName("SA2")+" SA2 "
			cQuery	+=	"WHERE "
				cQuery	+=	"DTY_FILIAL='"+xFilial ("DTY")+"' AND DTY.DTY_DATCTC BETWEEN '"+DToS (MV_PAR01)+"' AND '"+DToS (MV_PAR02)+"' AND DTY.D_E_L_E_T_=' ' AND SA2.A2_COD =DTY.DTY_CODFOR AND SA2.A2_LOJA=DTY.DTY_LOJFOR AND SA2.A2_FILIAL='"+xFilial ("SA2")+"' AND SA2.D_E_L_E_T_=' ' "
			cQuery	+=	"GROUP BY "
				cQuery	+=	"DTY_CODFOR, DTY_LOJFOR, SUBSTRING (DTY.DTY_DATCTC, 1, 6) "
			//
			cQuery	+=	"UNION "
			cQuery	+=	"SELECT "
				cQuery	+=	"DTY.DTY_CODFOR, DTY.DTY_LOJFOR, SUBSTRING (DTY.DTY_DATCTC, 1, 6) ANOMES, MIN (SA2.A2_NOME) A2_NOME, MIN (SA2.A2_CGC) A2_CGC, MIN (SA2.A2_NUMDEP) A2_NUMDEP, SUM (DTY.DTY_IRRF) DTY_IRRF, SUM (DTY.DTY_INSS) DTY_INSS, SUM (DTY.DTY_VALFRE) DTY_VALFRE, '1D' CHAVE "
			cQuery	+=	"FROM "
				cQuery	+=	RetSqlName("DTY")+" DTY, "+RetSqlName("SA2")+" SA2 "
			cQuery	+=	"WHERE "
				cQuery	+=	"DTY_FILIAL='"+xFilial ("DTY")+"' AND DTY.DTY_DATCTC BETWEEN '"+cQDataIni+"' AND '"+cQDataFim+"' AND DTY.D_E_L_E_T_ = ' ' AND SA2.A2_COD =DTY.DTY_CODFOR AND SA2.A2_LOJA=DTY.DTY_LOJFOR AND SA2.A2_FILIAL='"+xFilial ("SA2")+"' AND SA2.D_E_L_E_T_=' ' "
				//
				//Decendial
				If (MV_PAR03==1)
					cQuery	+=	" AND SUBSTRING (DTY.DTY_DATCTC, 7, 8)>='01' AND SUBSTRING (DTY.DTY_DATCTC, 7, 8)<='10' "
				ElseIf (MV_PAR03==2)	//Quinzenal
					cQuery	+=	" AND SUBSTRING (DTY.DTY_DATCTC, 7, 8)>='01' AND SUBSTRING (DTY.DTY_DATCTC, 7, 8)<='15' "
				EndIf
				cQuery	+=	"GROUP BY "
				cQuery	+=	"DTY_CODFOR, DTY_LOJFOR, SUBSTRING (DTY.DTY_DATCTC, 1, 6) "
				// 
				//Decendial ou Quinzenal
			If (MV_PAR03==1 .Or. MV_PAR03==2)
				cQuery	+=	"UNION "
				cQuery	+=	"SELECT "
					cQuery	+=	"DTY.DTY_CODFOR, DTY.DTY_LOJFOR, SUBSTRING (DTY.DTY_DATCTC, 1, 6) ANOMES, MIN (SA2.A2_NOME) A2_NOME, MIN (SA2.A2_CGC) A2_CGC, MIN (SA2.A2_NUMDEP) A2_NUMDEP, SUM (DTY.DTY_IRRF) DTY_IRRF, SUM (DTY.DTY_INSS) DTY_INSS, SUM (DTY.DTY_VALFRE) DTY_VALFRE, '2D' CHAVE "
				cQuery	+=	"FROM "
					cQuery	+=	RetSqlName("DTY")+" DTY, "+RetSqlName("SA2")+" SA2 "
				cQuery	+=	"WHERE "
					cQuery	+=	"DTY_FILIAL='"+xFilial ("DTY")+"' AND DTY.DTY_DATCTC BETWEEN '"+cQDataIni+"' AND '"+cQDataFim+"' AND DTY.D_E_L_E_T_ = ' ' AND SA2.A2_COD =DTY.DTY_CODFOR AND SA2.A2_LOJA=DTY.DTY_LOJFOR AND SA2.A2_FILIAL='"+xFilial ("SA2")+"' AND SA2.D_E_L_E_T_=' ' "
					//
					//Decendial
					If (MV_PAR03==1)
						cQuery	+=	" AND SUBSTRING (DTY.DTY_DATCTC, 7, 8)>='11' AND SUBSTRING (DTY.DTY_DATCTC, 7, 8)<='20' "
					ElseIf (MV_PAR03==2)	//Quinzenal
						cQuery	+=	" AND SUBSTRING (DTY.DTY_DATCTC, 7, 8)>='16' AND SUBSTRING (DTY.DTY_DATCTC, 7, 8)<='31' "
					EndIf
				cQuery	+=	"GROUP BY "
					cQuery	+=	"DTY_CODFOR, DTY_LOJFOR, SUBSTRING (DTY.DTY_DATCTC, 1, 6) "
			EndIf
			//
			//Decendial
			If (MV_PAR03==1)
				cQuery	+=	"UNION "
				cQuery	+=	"SELECT "
					cQuery	+=	"DTY.DTY_CODFOR, DTY.DTY_LOJFOR, SUBSTRING (DTY.DTY_DATCTC, 1, 6) ANOMES, MIN (SA2.A2_NOME) A2_NOME, MIN (SA2.A2_CGC) A2_CGC, MIN (SA2.A2_NUMDEP) A2_NUMDEP, SUM (DTY.DTY_IRRF) DTY_IRRF, SUM (DTY.DTY_INSS) DTY_INSS, SUM (DTY.DTY_VALFRE) DTY_VALFRE, '3D' CHAVE "
				cQuery	+=	"FROM "
					cQuery	+=	RetSqlName("DTY")+" DTY, "+RetSqlName("SA2")+" SA2 "
				cQuery	+=	"WHERE "
					cQuery	+=	"DTY_FILIAL='"+xFilial ("DTY")+"' AND DTY.DTY_DATCTC BETWEEN '"+cQDataIni+"' AND '"+cQDataFim+"' AND DTY.D_E_L_E_T_ = ' ' AND SA2.A2_COD =DTY.DTY_CODFOR AND SA2.A2_LOJA=DTY.DTY_LOJFOR AND SA2.A2_FILIAL='"+xFilial ("SA2")+"' AND SA2.D_E_L_E_T_=' ' AND SUBSTRING (DTY.DTY_DATCTC, 7, 8)>='21' AND SUBSTRING (DTY.DTY_DATCTC, 7, 8)<='31' "
				cQuery	+=	"GROUP BY "
					cQuery	+=	"DTY_CODFOR, DTY_LOJFOR, SUBSTRING (DTY.DTY_DATCTC, 1, 6) "
			EndIf
				//
			cQuery	+=	"ORDER BY "
				cQuery	+=	"DTY_CODFOR, DTY_LOJFOR, ANOMES, CHAVE "	
		    //
			cQuery := ChangeQuery(cQuery)
			//
			dbUseArea (.T., "TOPCONN", TcGenQry (,,cQuery), cAliasDty, .T., .T.)
		Else
	#ENDIF	 
			cArqDty := CriaTrab (Nil, .F.)
			//
			cQuery	:=	"DTY_FILIAL=='"+xFilial ("DTY")+"' .And. DTOS (DTY_DATCTC)>='"+cQDataIni+"' .And. DTOS (DTY_DATCTC)<='"+cQDataFim+"'"
			//
			IndRegua (cAliasDty, cArqDty, IndexKey (),, cQuery, STR0032) //"Selecionando Documentos ..."
	#IFDEF TOP
		Endif
	#ENDIF
	//
	DbSelectArea (cAliasDty)
		SetRegua(RecCount ())		// Total de Elementos da regua
		(cAliasDty)->(DbGoTop ())
	//
	While !(cAliasDty)->(Eof())
		//
		IncRegua()
		//
		#IFDEF TOP
			cNome		:=	Left ((cAliasDty)->A2_NOME, 40)
			cCgc		:=	Left ((cAliasDty)->A2_CGC, 11)
			nNumDep		:=	Iif (nA2_NumDep==0, 0, (cAliasDty)->A2_NUMDEP)
		#ELSE
			DbSelectArea ("SA2")
				SA2->(dbsetOrder(1))
			If !(SA2->(MsSeek (xFilial ('SA2')+(cAliasDty)->DTY_CODFOR+(cAliasDty)->DTY_LOJFOR)))
				(cAliasDty)->(DbSkip ())
				Loop
			EndIF
			//
			cNome		:=	Left (SA2->A2_NOME, 40)
			cCgc		:=	Left (SA2->A2_CGC, 11)
			nNumDep		:=	Iif (nA2_NumDep==0, 0, SA2->A2_NUMDEP)
		#ENDIF
		
		If !((cAliasDty)->DTY_CODFOR+(cAliasDty)->DTY_LOJFOR>=MV_PAR05+MV_PAR06 .And. (cAliasDty)->DTY_CODFOR+(cAliasDty)->DTY_LOJFOR<=MV_PAR07+MV_PAR08)
			(cAliasDty)->(DbSkip ())
			Loop
		EndIF
		//
		#IFDEF TOP
			cAno		:=	SubStr ((cAliasDty)->ANOMES, 1, 4)
			cMes		:=	SubStr ((cAliasDty)->ANOMES, 5, 2)
		#ELSE
			cAno		:=	StrZero (Year ((cAliasDty)->DTY_DATCTC), 4)
			cMes		:=	StrZero (Month ((cAliasDty)->DTY_DATCTC), 2)
		#ENDIF
		//
		cCodForn	:=	(cAliasDty)->DTY_CODFOR
		cLojForn	:=	(cAliasDty)->DTY_LOJFOR
		aAcumulado	:=	{0, 0, 0}
		nFrete		:=	0
		nDesconto	:=	0
		nIrrf		:=	0
		//
		#IFDEF TOP
			Do While !(cAliasDty)->(Eof ()) .And. (cAno+cMes+cCodForn+cLojForn==SubStr ((cAliasDty)->ANOMES, 1, 4)+SubStr ((cAliasDty)->ANOMES, 5, 2)+(cAliasDty)->DTY_CODFOR+(cAliasDty)->DTY_LOJFOR)
		#ELSE
			Do While !(cAliasDty)->(Eof ()) .And. (cAno+cMes+cCodForn+cLojForn==StrZero (Year ((cAliasDty)->DTY_DATCTC), 4)+StrZero (Month ((cAliasDty)->DTY_DATCTC), 2)+(cAliasDty)->DTY_CODFOR+(cAliasDty)->DTY_LOJFOR)
		#ENDIF		
			//
			If (MV_PAR03==1)	//Decendial
				#IFDEF TOP
					If ("1D"$(cAliasDty)->CHAVE)
				#ELSE
					If (Day ((cAliasDty)->DTY_DATCTC)>=1 .And. Day ((cAliasDty)->DTY_DATCTC)<=10)
				#ENDIF
						aAcumulado[1]	+=	(cAliasDty)->DTY_VALFRE
				#IFDEF TOP
					ElseIf ("2D"$(cAliasDty)->CHAVE)
				#ELSE
					ElseIf (Day ((cAliasDty)->DTY_DATCTC)>=11 .And. Day ((cAliasDty)->DTY_DATCTC)<=20)
				#ENDIF
						aAcumulado[2]	+=	(cAliasDty)->DTY_VALFRE
				#IFDEF TOP
					ElseIf ("3D"$(cAliasDty)->CHAVE)
				#ELSE					
					ElseIf (Day ((cAliasDty)->DTY_DATCTC)>=21 .And. Day ((cAliasDty)->DTY_DATCTC)<=31)
				#ENDIF				
						aAcumulado[3]	+=	(cAliasDty)->DTY_VALFRE
					EndIf
			ElseIf (MV_PAR03==2)	//Quinzenal
				#IFDEF TOP
					If ("1D"$(cAliasDty)->CHAVE)
				#ELSE
					If (Day ((cAliasDty)->DTY_DATCTC)>=1 .And. Day ((cAliasDty)->DTY_DATCTC)<=15)
				#ENDIF
				 		aAcumulado[1]	+=	(cAliasDty)->DTY_VALFRE
				#IFDEF TOP
					ElseIf ("2D"$(cAliasDty)->CHAVE)
				#ELSE 
					ElseIf (Day ((cAliasDty)->DTY_DATCTC)>=16 .And. Day ((cAliasDty)->DTY_DATCTC)<=31)
				#ENDIF
						aAcumulado[2]	+=	(cAliasDty)->DTY_VALFRE
					EndIf
			Else	//Mensal
				#IFDEF TOP
					If ("0D"$(cAliasDty)->CHAVE)
						aAcumulado[1]	+=	(cAliasDty)->DTY_VALFRE
					EndIf
				#ELSE
					aAcumulado[1]	+=	(cAliasDty)->DTY_VALFRE
				#ENDIF
			EndIF
			//
			//Valores do registro Totalizador (0D) com a quebra por: cAno+cMes+cCodForn+cLojForn
			#IFDEF TOP
				If ("0D"$(cAliasDty)->CHAVE)
			#ELSE
				If (DTOS ((cAliasDty)->DTY_DATCTC)>=DTOS (MV_PAR01) .And. DTOS ((cAliasDty)->DTY_DATCTC)<=DTOS (MV_PAR02))
			#ENDIF
					nFrete		+=	(cAliasDty)->DTY_VALFRE
					nDesconto	+=	(cAliasDty)->DTY_INSS
					nIrrf		+=	(cAliasDty)->DTY_IRRF
	       		EndIf
	       	//
			(cAliasDty)->(DbSkip ())
	   	EndDo
		//
		If !(TRB->(DbSeek (cAno+cMes+cCodForn+cLojForn)))
			RecLock ("TRB", .T.)
				TRB->TRB_ANO		:=	cAno
				TRB->TRB_MES		:=	cMes
				TRB->TRB_FORN		:=	cCodForn
				TRB->TRB_LOJA		:=	cLojForn
				TRB->TRB_MOTOR		:=	cNome
				TRB->TRB_CPF		:=	cCgc
				TRB->TRB_DESC		:=	(nNumDep*GetNewPar ("MV_TMSVDEP", 0))
		Else
			RecLock ("TRB", .F.)			
		EndIF
	   	//
			TRB->TRB_FRETE	+=	nFrete
			TRB->TRB_DESC	+=	nDesconto
			//
			If (aAcumulado[1]>0)
				TRB->TRB_ACUM1	+=	aAcumulado[1]
				TRB->TRB_TRIB  	+=	(aAcumulado[1]*(40/100))-TRB->TRB_DESC
			EndIf
			//
			If (aAcumulado[2]>0) .Or.;
				(MV_PAR04==1 .And. cAno+cMes+"11"<=DToS (MV_PAR02)) .Or.;
				(MV_PAR04==2 .And. cAno+cMes+"16"<=DToS (MV_PAR02))
				//				
				TRB->TRB_ACUM2	+=	aAcumulado[2]
				TRB->TRB_TRIB	:=	((aAcumulado[1]+aAcumulado[2])*(40/100))-TRB->TRB_DESC
			EndIf
			//
			If (aAcumulado[3]>0) .Or.;
				(MV_PAR04==1 .And. cAno+cMes+"21"<=DToS (MV_PAR02))
				//
				TRB->TRB_ACUM3	+=	aAcumulado[3]
				TRB->TRB_TRIB	:=	((aAcumulado[1]+aAcumulado[2]+aAcumulado[3])*(40/100))-TRB->TRB_DESC
			EndIf
			//
			TRB->TRB_IRRF	+=	nIrrf
	   	MsUnLock ()
	EndDo
   	//
	(cAliasDty)->(DbCloseArea ())	
Return (aRet)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R929Lay   � Autor �Gustavo G. Rueda       � Data �23/09/2004���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Monta o Layout para o relatorio.                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1 - Cabecalho 1                                         ���
���          �ExpC2 - Cabecalho 2                                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA - Array contendo a estrutura do layout.                ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATR929                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function R929Lay (Cabec1, Cabec2)
	Local	aLay	:=	{}
							//"         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22"
							//"1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
	aAdd (aLay, STR0019)	//"+------------------------------------------+-------------+--------------+--------------+------------------+--------------+--------------+--------------+"
	aAdd (aLay, STR0020)	//"| Motorista                                |    C.P.F.   |        Frete |  DIRF - 40%  |        Acumulado |    Descontos |   Tributavel |   Imp. Renda |"
	aAdd (aLay, STR0021)	//"+------------------------------------------+-------------+--------------+--------------+------------------+--------------+--------------+--------------+"
	aAdd (aLay, STR0022)	//"| ######################################## | ########### | ############ | ############ | ################ | ############ | ############ | ############ |"
	aAdd (aLay, STR0023)	//"+------------------------------------------+-------------+--------------+--------------+------------------+------------------+--------------+--------------+--------------+"
	aAdd (aLay, STR0024)	//"| Motorista                                |    C.P.F.   |        Frete |  DIRF - 40%  | Acum. 1.Quinzena | Acum. 2.Quinzena |    Descontos |   Tributavel |   Imp. Renda |"
	aAdd (aLay, STR0025)	//"+------------------------------------------+-------------+--------------+--------------+------------------+------------------+--------------+--------------+--------------+"
	aAdd (aLay, STR0026)	//"| ######################################## | ########### | ############ | ############ | ################ | ################ | ############ | ############ | ############ |"
	aAdd (aLay, STR0027)	//"+--------------------------------------------------------+--------------+--------------+------------------+--------------+--------------+--------------+"
	aAdd (aLay, STR0028)	//"| Totais (##):                                           | ############ | ############ | ################ | ############ | ############ | ############ |"
	aAdd (aLay, STR0029)	//"+--------------------------------------------------------+--------------+---------------------------------------------------------------+--------------+"
	aAdd (aLay, STR0037)	//"+--------------------------------------------------------+--------------+--------------+------------------+------------------+--------------+--------------+--------------+"
	aAdd (aLay, STR0038)	//"| Totais (##):                                           | ############ | ############ | ################ | ################ | ############ | ############ | ############ |"
	aAdd (aLay, STR0039)	//"+--------------------------------------------------------+--------------+----------------------------------------------------------------------------------+--------------+"	
	aAdd (aLay, STR0040)	//"+------------------------------------------+-------------+--------------+--------------+------------------+------------------+------------------+--------------+--------------+--------------+"
	aAdd (aLay, STR0041)	//"| Motorista                                |    C.P.F.   |        Frete |  DIRF - 40%  | Acum. 1.Decendio | Acum. 2.Decendio | Acum. 3.Decendio |    Descontos |   Tributavel |   Imp. Renda |"
	aAdd (aLay, STR0042)	//"+------------------------------------------+-------------+--------------+--------------+------------------+------------------+------------------+--------------+--------------+--------------+"
	aAdd (aLay, STR0043)	//"| ######################################## | ########### | ############ | ############ | ################ | ################ | ################ | ############ | ############ | ############ |"
	aAdd (aLay, STR0044)	//"+--------------------------------------------------------+--------------+--------------+------------------+------------------+------------------+--------------+--------------+--------------+"
	aAdd (aLay, STR0045)	//"| Totais (##):                                           | ############ | ############ | ################ | ################ | ################ | ############ | ############ | ############ |"
	aAdd (aLay, STR0046)	//"+--------------------------------------------------------+--------------+-----------------------------------------------------------------------------------------------------+--------------+"
	//
	Cabec1	:=	STR0030		//"Tipo Apuracao: ######### - ########## a ##########                                                                                                                                                                          "
	Cabec2	:=	STR0031		//"Empresa Pagto: ########################################                                                                                                                                                                     "
Return (aLay)
