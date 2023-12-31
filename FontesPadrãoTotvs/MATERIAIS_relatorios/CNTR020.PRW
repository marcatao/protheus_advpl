#INCLUDE "CNTR020.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE DEF_ADITI "1" //Aditivo
#DEFINE DEF_REAJU "2" //Reajuste
#DEFINE DEF_REALI "3" //Realinhamento
#DEFINE DEF_READQ "4" //Readequacao
#DEFINE DEF_PARAL "5" //Paralisacao
#DEFINE DEF_REINI "6" //Reinicio
#DEFINE DEF_CLAUS "7" //Alteracao de Clausula
#DEFINE DEF_RENOV "C" //Alteracao de Clausula

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � CNTR020  � Autor � Marcelo Custodio      � Data � 25.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de revisoes dos contratos                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Function CNTR020()

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Contrato:                                    �
//� mv_par02     // Revisao de                                   �
//� mv_par03     // Vigencia de:                                 �
//� mv_par04     // Vigencia ate:                                �
//� mv_par05     // Fornecedor de:                               �
//� mv_par06     // Tipo de Contrato ?                           �
//| mv_par07	 // Cliente ?                                    �
//| mv_par08     // Imprimir valores - Moeda do ctr/Outra moeda  �
//| mv_par09     // Moeda: 										 �
//| mv_par10     // Data de Referencia:							 �
//����������������������������������������������������������������
Pergunte("CNR021",.F.)

oReport := ReportDef()
oReport:PrintDialog()

Return Nil

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � ReportDef� Autor � Marcelo Custodio      � Data � 25.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina padrao de configuracao das sections do relatorio    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR020                                                    ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function ReportDef()
Local oReport
Local oSectCab// Sessao Cabecalho
Local oSectPla// Sessao Planilhas
Local oSectItm// Sessao Itens de Planilhas
Local oSectCro// Sessao Cronograma
Local oSectCtb// Sessao Cronograma Contabil

Local nCNBTamPrd:= TamSX3("CNB_PRODUT")[1]

oReport := TReport():New("CNTR021",OemToAnsi(STR0001),"CNR021",{|oReport| CR020IMP(oReport)},OemToAnsi(STR0011))

//����������������������������������������������������Ŀ
//� Cabecalho do contrato                              �
//������������������������������������������������������
oSectCab := TRSection():New(oReport,OemToAnsi(STR0010),{"CN9","SE4","CN1"})
TRCell():New(oSectCab,"CN9_NUMERO","CN9",,,TamSx3("CN9_NUMERO")[1])
TRCell():New(oSectCab,"CN9_REVISA","CN9",,,TamSx3("CN9_REVISA")[1])
TRCell():New(oSectCab,"CN0_DESCRI","CN0",OemToAnsi(STR0019),,iIf(TamSx3("CN0_DESCRI")[1]>15,15,TamSx3("CN0_DESCRI")[1]))
TRCell():New(oSectCab,"CN9_SITUAC","CN9",,,TamSx3("CN9_SITUAC"	)[1],,{|| QA_CBox("CN9_SITUAC",AllTrim(QRYCN9->CN9_SITUAC))})
TRCell():New(oSectCab,"CN9_DTFIM","CN9",,,TamSx3("CN9_DTFIM")[1])
TRCell():New(oSectCab,"CN1_DESCRI","CN1","Tipo",,iIf(TamSx3("CN1_DESCRI")[1]>10,10,TamSx3("CN1_DESCRI")[1]))
TRCell():New(oSectCab,"CN9_VLATU","CN9",,,TamSx3("CN9_VLATU")[1],,{|| QRYCN9->(C020xMoeda(.T.,CN9_NUMERO,CN9_REVISA,"CN9_VLATU"))})
TRCell():New(oSectCab,"CN9_SALDO","CN9",,,TamSx3("CN9_SALDO")[1],,{|| QRYCN9->(C020xMoeda(.T.,CN9_NUMERO,CN9_REVISA,"CN9_SALDO"))})

oSectCab:Cell("CN0_DESCRI"):SetLineBreak()
oSectCab:Cell("CN1_DESCRI"):SetLineBreak()

//����������������������������������������������������Ŀ
//� Cabecalho das Planilhas                            �
//������������������������������������������������������
oSectPla := TRSection():New(oSectCab,OemToAnsi(STR0012),{"CNA","CNL"})
TRCell():New(oSectPla,"CNA_NUMERO","CNA")
TRCell():New(oSectPla,"CNL_DESCRI","CNL","Tipo")
TRCell():New(oSectPla,"CNA_FORNEC","CNA")
TRCell():New(oSectPla,"CNA_LJFORN","CNA")
TRCell():New(oSectPla,"CNA_CLIENT","CNA")
TRCell():New(oSectPla,"CNA_LOJACL","CNA")
TRCell():New(oSectPla,"CNA_VLTOT","CNA",,,,,{|| QRYCNA->(C020xMoeda(.T.,CNA_CONTRA,CNA_REVISA,"CNA_VLTOT"))})
TRCell():New(oSectPla,"CNA_SALDO","CNA",,,,,{|| QRYCNA->(C020xMoeda(.T.,CNA_CONTRA,CNA_REVISA,"CNA_SALDO"))})

//����������������������������������������������������Ŀ
//� Itens das planilhas                                �
//������������������������������������������������������
oSectItm := TRSection():New(oSectPla,OemToAnsi(STR0013),{"CNB"})
TRCell():New(oSectItm,"CNB_ITEM","CNB")
TRCell():New(oSectItm,"CNB_PRODUT","CNB",,,nCNBTamPrd)
TRCell():New(oSectItm,"CNB_QUANT","CNB")
TRCell():New(oSectItm,"CNB_VLUNIT","CNB",,,,,{|| QRYCNB->(C020xMoeda(.T.,CNB_CONTRA,CNB_REVISA,"CNB_VLUNIT"))})
TRCell():New(oSectItm,"CNB_VLTOT","CNB",,,,,{|| QRYCNB->(C020xMoeda(.T.,CNB_CONTRA,CNB_REVISA,"CNB_VLTOT"))})
TRCell():New(oSectItm,"CNB_DESC","CNB")
TRCell():New(oSectItm,"CNB_VLDESC","CNB",,,,,{|| QRYCNB->(C020xMoeda(.T.,CNB_CONTRA,CNB_REVISA,"CNB_VLDESC"))})
TRCell():New(oSectItm,"CNB_QTDMED","CNB")
TRCell():New(oSectItm,"CNB_SLDMED","CNB")

oSectItm:Cell("CNB_PRODUT"):SetLineBreak()

//����������������������������������������������������Ŀ
//� Cronogramas                                        �
//������������������������������������������������������
oSectCro := TRSection():New(oSectPla,OemToAnsi(STR0014),{"CNF"})
TRCell():New(oSectCro,"CNF_NUMERO","CNF")
TRCell():New(oSectCro,"CNF_PARCEL","CNF")
TRCell():New(oSectCro,"CNF_COMPET","CNF")
TRCell():New(oSectCro,"CNF_VLPREV","CNF",,,,,{|| QRYCNF->(C020xMoeda(.T.,CNF_CONTRA,CNF_REVISA,"CNF_VLPREV"))})
TRCell():New(oSectCro,"CNF_VLREAL","CNF",,,,,{|| QRYCNF->(C020xMoeda(.T.,CNF_CONTRA,CNF_REVISA,"CNF_VLREAL"))})
TRCell():New(oSectCro,"CNF_SALDO","CNF",,,,,{|| QRYCNF->(C020xMoeda(.T.,CNF_CONTRA,CNF_REVISA,"CNF_SALDO"))})
TRCell():New(oSectCro,"CNF_DTVENC","CNF")
TRCell():New(oSectCro,"CNF_PRUMED","CNF")
TRCell():New(oSectCro,"CNF_DTREAL","CNF")

//����������������������������������������������������Ŀ
//� Cronograma Contabil                                �
//������������������������������������������������������
oSectCtb := TRSection():New(oSectPla,OemToAnsi(STR0020),{"CNW"})
TRCell():New(oSectCtb,"CNW_NUMERO","CNW")
TRCell():New(oSectCtb,"CNW_PARCEL","CNW")
TRCell():New(oSectCtb,"CNW_DTPREV","CNW")
TRCell():New(oSectCtb,"CNW_VLPREV","CNW",,,,,{|| QRYCNW->(C020xMoeda(.T.,CNW_CONTRA,CNW_REVISA,"CNW_VLPREV"))})
TRCell():New(oSectCtb,"CNW_HIST","CNW")
TRCell():New(oSectCtb,"CNW_CC","CNW")
TRCell():New(oSectCtb,"CNW_DTLANC","CNW")
TRCell():New(oSectCtb,"CNW_ITEMCT","CNW")
TRCell():New(oSectCtb,"CNW_CLVL","CNW")

Return oReport

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � CR020Imp � Autor � Marcelo Custodio      � Data � 25.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Executa impressao do relatorio                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR020                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Objeto do relatorio                               ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function CR020Imp(oReport)
Local oSectCab := oReport:Section(1)//Cabecalho do contrato
Local oSectPla := oReport:Section(1):Section(1)//Cabecalho da planilha
Local oSectItm := oReport:Section(1):Section(1):Section(1)//Itens de Planilhas
Local oSectCro := oReport:Section(1):Section(1):Section(2)//Cronogramas
Local oSectCtb := oReport:Section(1):Section(1):Section(3)//Cronogramas Contabeis
Local nTotLinha
Local cTpRev//Tipo da revisao
Local cEsRev//Especie da revisao
Local lPlanil//Exibe planilha
Local lCronog//Exibe Cronograma
Local lCroCtb//Exibe Cronograma Contabil
Local nX
Local cCronAt
Local lFstCNA  := .T.
Local lMedeve  := .F.
Local lCtb     := .F.

If mv_par08 == 2
	oReport:SetTitle(oReport:Title() +STR0024 +AllTrim(GetMv("MV_SIMB" +Ltrim(Str(mv_par09)))) +")")
EndIf

//����������������������������������������������������Ŀ
//� Configura perguntas do tipo Range                  �
//������������������������������������������������������
MakeSqlExpr(PadR("CNR021",10))

//����������������������������������������������������Ŀ
//� Configura filtro do cabecalho                      �
//������������������������������������������������������
CR020Cab(oSectCab)
//������������������������������������������������������������Ŀ
//� Filtra planilhas e itens                                   �
//��������������������������������������������������������������
CR020Pla(oSectPla)
CR020Itm(oSectItm)
//������������������������������������������������������������Ŀ
//� Filtra cronogramas do contrato                             �
//��������������������������������������������������������������
CR020Cro(oSectCro)

//������������������������������������������������������������Ŀ
//� Filtra cronogramas contabeis do contrato                   �
//��������������������������������������������������������������
CR020Ctb(oSectCtb)

oSectCab:Init()
While !QRYCN9->(Eof())
	If oReport:Cancel()
		Exit
	EndIf

	lCtb    := .F.//Contrato com cronograma contabil

	//����������������������������������������������������Ŀ
	//� Imprime cabecalho do contrato                      �
	//������������������������������������������������������
	oSectCab:PrintLine()
	oReport:SkipLine()
	oReport:SkipLine()

	//����������������������������������������������������Ŀ
	//� Armazena tipo e especie de revisao                 �
	//������������������������������������������������������
	cTpRev := CN0->CN0_TIPO
	cEsRev := CN0->CN0_ESPEC

	//����������������������������������������������������Ŀ
	//� Verifica se imprime planilha/cabecalho             �
	//� Planilha imprime quando:                           �
	//� 1 - Aditivo de quantidade                          �
	//� 2 - Aditivo de quantidade/prazo                    �
	//� 3 - Reajuste                                       �
	//� 4 - Realinhamento                                  �
	//� 5 - Readequacao                                    �
	//� Planilha imprime quando:                           �
	//� 1 - Aditivo de quantidade                          �
	//� 2 - Aditivo de prazo                               �
	//� 3 - Aditivo de quantidade/prazo                    �
	//� 4 - Reajuste                                       �
	//� 5 - Realinhamento                                  �
	//� 6 - Reinicio                                       �
	//������������������������������������������������������

	lPlanil := ((cTpRev == DEF_ADITI .And. cEsRev $ "14") .OR. (cTpRev == DEF_REAJU) .OR. (cTpRev == DEF_REALI) .OR. (cTpRev == DEF_READQ) .OR. (cTpRev == DEF_RENOV) )
	lCroCtb := lCtb .And. ((cTpRev == DEF_ADITI .And. cEsRev $ "134") .OR. (cTpRev == DEF_REAJU) .OR. (cTpRev == DEF_REALI) .OR. (cTpRev == DEF_REINI) .OR. (cTpRev == DEF_RENOV) )
	lFstCNA := .T.

	//������������������������������������������������������������Ŀ
	//� Imprime Texto de Justificativa da revisao   			   �
	//��������������������������������������������������������������
	nTotLinha := MlCount(MSMM(QRYCN9->CN9_CODJUS))
	oReport:SkipLine()
	oReport:SkipLine()
	CR010Box(oReport,STR0017)
	oReport:SkipLine()
	For nX := 1 To nTotLinha
		oReport:PrintText(MemoLine(MSMM(QRYCN9->CN9_CODJUS),,nX))
		oReport:SkipLine()
	Next nX
   If nTotLinha == 0
		oReport:PrintText(OemToAnsi(STR0020))//"EM BRANCO"
   EndIf
   oReport:SkipLine()

	//������������������������������������������������������������Ŀ
	//� Verifica se a revisao e do tipo "Alteracao de Clausula"    �
	//��������������������������������������������������������������
	If cTpRev == DEF_CLAUS
		//������������������������������������������������������������Ŀ
		//� Imprime Texto de Alteracao de clausula      			      �
		//��������������������������������������������������������������
		nTotLinha := MlCount(MSMM(QRYCN9->CN9_CODCLA))
		oReport:SkipLine()
		oReport:SkipLine()
		CR010Box(oReport,STR0018)
		For nX := 1 To nTotLinha
			oReport:PrintText(MemoLine(MSMM(QRYCN9->CN9_CODCLA),,nX))
			oReport:SkipLine()
		Next nX
	   If nTotLinha == 0
			oReport:PrintText(OemToAnsi(STR0020))
	   EndIf
	   oReport:SkipLine()
	EndIf

	//������������������������������������������������������������Ŀ
	//� Os filtros das secoes filhas sao criados dentro do looop   �
	//� pois e necessario conhecer o tipo de revisao antes de      �
	//� filtrar os itens filhos                                    �
	//��������������������������������������������������������������

	If lPlanil

		oSectPla:Init()
		oSectPla:ExecSQL()
		//������������������������������������������������������������Ŀ
		//� Percorre planilhas                                         �
		//��������������������������������������������������������������
		While !QRYCNA->(Eof())
			lMedeve := Cn300RetSt("MEDEVE",0,QRYCNA->CNA_NUMERO)
			lCronog := !lMedeve .And. ((cTpRev == DEF_ADITI .And. cEsRev $ "134") .OR. (cTpRev == DEF_REAJU) .OR. (cTpRev == DEF_REALI) .OR. (cTpRev == DEF_REINI) .OR. (cTpRev == DEF_RENOV) )

			//������������������������������������������������������������Ŀ
			//� Imprime cabecalho da planilha                              �
			//��������������������������������������������������������������
			If !lFstCNA
				oSectPla:PrintHeader()
			EndIf
			lFstCNA:=.F.
			If !Empty(QRYCNA->CNA_CLIENT)
				oSectPla:Cell("CNA_FORNEC"):Disable()
				oSectPla:Cell("CNA_LJFORN"):Disable()
				oSectPla:Cell("CNA_CLIENT"):Enable()
				oSectPla:Cell("CNA_LOJACL"):Enable()
			Else
				oSectPla:Cell("CNA_CLIENT"):Disable()
				oSectPla:Cell("CNA_LOJACL"):Disable()
				oSectPla:Cell("CNA_FORNEC"):Enable()
				oSectPla:Cell("CNA_LJFORN"):Enable()
			EndIf
			oSectPla:PrintLine()
			//������������������������������������������������������������Ŀ
			//� Imprime itens de planilha                                  �
			//��������������������������������������������������������������
			oSectItm:Print()
			//������������������������������������������������������������Ŀ
			//� Verifica se imprime cronograma                             �
			//��������������������������������������������������������������
			If lCronog
				oReport:SkipLine()
				//������������������������������������������������������������Ŀ
				//� Imprime cronograma                                         �
				//��������������������������������������������������������������
	 			oSectCro:Print()
			EndIf
			//������������������������������������������������������������Ŀ
			//� Verifica se imprime cronograma contabil                    �
			//��������������������������������������������������������������
			If lCroCtb
				oReport:SkipLine()
				//������������������������������������������������������������Ŀ
				//� Imprime cronograma                                         �
				//��������������������������������������������������������������
	 			oSectCtb:Print()
			EndIf

			QRYCNA->(dbSkip())
			oReport:SkipLine()
			oReport:SkipLine()
		EndDo
		//������������������������������������������������������������Ŀ
		//� Finaliza secao das planilhas                               �
		//��������������������������������������������������������������
		oSectPla:Finish()
	ElseIf lCronog//Imprime apenas cronogramas
		oSectCro:Init()
		oSectCro:ExecSQL()

		//������������������������������������������������������������Ŀ
		//� Mantem controle do cronograma atual                        �
		//��������������������������������������������������������������
		cCronAt := QRYCNF->CNF_NUMERO

		While !QRYCNF->(Eof())
			//������������������������������������������������������������Ŀ
			//� Verifica se mudou cronograma, em caso positivo imprime     �
			//� cabecalho                                                  �
			//��������������������������������������������������������������
			If cCronAt != QRYCNF->CNF_NUMERO
//				CR010Box(oReport,OemToAnsi(STR0015)+QRYCN9->CN9_NUMERO+If(!Empty(QRYCN9->CN9_REVISA),"/"+QRYCN9->CN9_REVISA,""))
				oSectCro:PrintHeader()
				cCronAt := QRYCNF->CNF_NUMERO
			EndIf
			//������������������������������������������������������������Ŀ
			//� Imprime cronograma                                         �
			//��������������������������������������������������������������
			oSectCro:PrintLine()
			QRYCNF->(dbSkip())
		EndDo
		//������������������������������������������������������������Ŀ
		//� Finaliza sessao dos cronogramas                            �
		//��������������������������������������������������������������
		oSectCro:Finish()
	EndIf

	QRYCN9->(dbSkip())
	//������������������������������������������������������������Ŀ
	//� Forca quebra de pagina em caso de novo contrato            �
	//��������������������������������������������������������������
 	If !QRYCN9->(Eof())
		oReport:EndPage()
	EndIf
EndDo
//������������������������������������������������������������Ŀ
//� Finaliza sessao do cabecalho                               �
//��������������������������������������������������������������
oSectCab:Finish()
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � CR020Cab � Autor � Marcelo Custodio      � Data � 25.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Filtra contratos de acordo com os parametros               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR020                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Section do cabecalho de contrato                  ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Function CR020Cab(oSectCab)
Local cPart   := "%%"

//����������������������������������������������������Ŀ
//� Gera query de filtro dos contratos                 �
//������������������������������������������������������
oSectCab:BeginQuery()

BeginSql alias "QRYCN9"
	SELECT CN9_NUMERO, CN9_REVISA, CN9_DTINIC, CN9_SITUAC, CN9_DTFIM, CN9_DTPROP,CN9_DTASSI, CN9_DTENCE, CN9_CONDPG,
		CN9_TPCTO, CN9_DTULST, CN9_VIGE, CN9_INDICE,CN9_FLGCAU, CN9_MINCAU, CN9_FLGREJ, CN9_REVATU, CN9_VLINI,
		CN9_VLATU, CN9_SALDO,CN9_CODOBJ, CN9_CODCLA, CN9_CODJUS, CN9_UNVIGE, CN0_TIPO, CN0_DESCRI, CN0_ESPEC, CN9_TIPREV
	FROM %table:CN9% CN9
	JOIN %table:CN0% CN0 ON
		CN0.%NotDel% AND
		CN0.CN0_FILIAL = %xFilial:CN0% AND
		CN0.CN0_CODIGO = CN9.CN9_TIPREV
	LEFT JOIN %table:CNC% CNC ON
		CNC.%NotDel% AND
		CNC.CNC_FILIAL = %xFilial:CNC% AND
		CNC.CNC_NUMERO = CN9.CN9_NUMERO AND
		CNC.CNC_REVISA = CN9.CN9_REVISA
	WHERE CN9_FILIAL = %xFilial:CN9% AND
	(CN9_DTINIC >= %exp:dtos(MV_PAR03)% or
	CN9_DTFIM <= %exp:dtos(MV_PAR04)% )AND
	CN9.%notDel%
	ORDER BY CN9_NUMERO, CN9_REVISA
EndSql

//����������������������������������������������������Ŀ
//� Informa parametros de range                        �
//������������������������������������������������������
If Empty(MV_PAR05)
	oSectCab:EndQuery({MV_PAR01,MV_PAR02,MV_PAR07,MV_PAR06})
Else
	oSectCab:EndQuery({MV_PAR01,MV_PAR02,MV_PAR05,MV_PAR06})
EndIf

//����������������������������������������������������Ŀ
//� Configura posicionamento das tabelas filhas        �
//������������������������������������������������������
TRPosition():New(oSectCab,"SE4",1,"xFilial() + QRYCN9->CN9_CONDPG")//Cond. Pagto
TRPosition():New(oSectCab,"CN1",1,"xFilial() + QRYCN9->CN9_TPCTO")//Tipo de Contrato
TRPosition():New(oSectCab,"CN0",1,"xFilial() + QRYCN9->CN9_TIPREV")//Tipo de Contrato
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � CR020Pla � Autor � Marcelo Custodio      � Data � 25.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Filtra planilhas do contrato atual                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR020                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Section do cabecalho de planilha                  ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Function CR020Pla(oSectPla)
//����������������������������������������������������Ŀ
//� Gera query de filtro das planilhas                 �
//������������������������������������������������������
BEGIN REPORT QUERY oSectPla

BeginSql alias "QRYCNA"
	SELECT CNA_NUMERO,CNA_FORNEC,CNA_LJFORN,CNA_CRONOG,CNA_DTINI,CNA_VLTOT,CNA_SALDO,CNA_TIPPLA,CNA_DTFIM,CNA_FLREAJ, CNA_CONTRA, CNA_REVISA, CNA_CLIENT, CNA_LOJACL
	FROM %table:CNA% CNA WHERE
	CNA_FILIAL = %xfilial:CNA% AND
	CNA_CONTRA = %report_param:QRYCN9->CN9_NUMERO% AND
	CNA_REVISA = %report_param:QRYCN9->CN9_REVISA% AND
	CNA.%notDel%
	ORDER BY CNA_CONTRA,CNA_REVISA,CNA_NUMERO
EndSql

END REPORT QUERY oSectPla

TRPosition():New(oSectPla,"CNL",1,"xFilial() + QRYCNA->CNA_TIPPLA")//Tipos de Tabelas
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � CR020Itm � Autor � Marcelo Custodio      � Data � 25.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Filtra itens da planilha atual                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR020                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Section do itens da planilha                      ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Function CR020Itm(oSectItm)
//����������������������������������������������������Ŀ
//� Gera query de filtro dos itens das planilhas       �
//������������������������������������������������������
BEGIN REPORT QUERY oSectItm
BeginSql alias "QRYCNB"
	SELECT CNB_ITEM, CNB_PRODUT, CNB_QUANT, CNB_VLUNIT, CNB_VLTOT, CNB_VLTOT, CNB_DESC, CNB_VLDESC, CNB_QTDMED, CNB_SLDMED, CNB_CONTRA, CNB_REVISA, CNB_NUMERO
	FROM %table:CNB% CNB WHERE
	CNB_FILIAL = %xfilial:CNB% AND
	CNB_CONTRA = %report_param:QRYCNA->CNA_CONTRA% AND
	CNB_REVISA = %report_param:QRYCNA->CNA_REVISA% AND
	CNB_NUMERO = %report_param:QRYCNA->CNA_NUMERO% AND
	CNB.%notDel%
	ORDER BY CNB_CONTRA,CNB_REVISA,CNB_NUMERO,CNB_ITEM
EndSql
END REPORT QUERY oSectItm
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � CR020Cro � Autor � Marcelo Custodio      � Data � 25.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Filtra cronogramas do contrato ou da planilha              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR020                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Section do cronograma                             ���
���          � lExp02 - Filtra por planilha ou contrato                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Function CR020Cro(oSectCro,lPlanil)
Local cPart
//����������������������������������������������������Ŀ
//� Inclui filtro por planilha, quando houver impressao�
//� de planilhas e cronogramas                         �
//������������������������������������������������������
If lPlanil
	cPart := "%AND (CNF_NUMERO = '"+ QRYCNA->CNA_CRONOG +"')%"
else
	cPart := "%%"
EndIf

//����������������������������������������������������Ŀ
//� Gera query dos cronogramas                         �
//������������������������������������������������������
BEGIN REPORT QUERY oSectCro
BeginSQL alias "QRYCNF"
	SELECT CNF.*
	FROM %table:CNF% CNF WHERE
	CNF_FILIAL = %xFilial:CNF% AND
	CNF_CONTRA = %report_param:QRYCN9->CN9_NUMERO% AND
	CNF_REVISA = %report_param:QRYCN9->CN9_REVISA% AND
	CNF.%notDel% %report_param:cPart%
	ORDER BY CNF_CONTRA,CNF_REVISA,CNF_NUMERO,CNF_PARCEL
EndSql
END REPORT QUERY oSectCro
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � CR020Ctb � Autor � Marcelo Custodio      � Data � 28.02.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Filtra cronogramas contabeis do contrato ou da planilha    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNTR020                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oExp01 - Section do cronograma                             ���
���          � lExp02 - Filtra por planilha ou contrato                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Function CR020Ctb(oSectCtb,lPlanil)
Local cPart
//����������������������������������������������������Ŀ
//� Inclui filtro por planilha, quando houver impressao�
//� de planilhas e cronogramas                         �
//������������������������������������������������������
If lPlanil
	cPart := "%AND (CNW_NUMERO = '"+ QRYCNA->CNA_CRONCT +"')%"
else
	cPart := "%%"
EndIf

//����������������������������������������������������Ŀ
//� Gera query dos cronogramas con                     �
//������������������������������������������������������
BEGIN REPORT QUERY oSectCtb
BeginSQL alias "QRYCNW"
	SELECT CNW.*
	FROM %table:CNW% CNW WHERE
	CNW_FILIAL = %xFilial:CNW% AND
	CNW_CONTRA = %report_param:QRYCN9->CN9_NUMERO% AND
	CNW_REVISA = %report_param:QRYCN9->CN9_REVISA% AND
	CNW.%notDel% %report_param:cPart%
	ORDER BY CNW_CONTRA,CNW_REVISA,CNW_NUMERO,CNW_PARCEL
EndSql
END REPORT QUERY oSectCtb

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �C020xMoeda�Autor  �Microsiga           � Data �  11/06/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Realiza a conversao entre moedas de um determinado valor.  ���
�������������������������������������������������������������������������͹��
���Parametros� lTReport: indica se a impressao e em TReport.			  ���
���			 � cContra: numero do contrato que esta sendo impresso.		  ���
���			 � cRev: revisao do contrato que esta sendo impresso.		  ���
���			 � cCampo: nome do campo a ser convertido.					  ���
�������������������������������������������������������������������������͹��
���Retorno	 � nRet: valor apos conversao								  ���
�������������������������������������������������������������������������͹��
���Uso       � CNTR020													  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function C020xMoeda(lTReport,cContra,cRev,cCampo)
Local dDataRef  := If(lTReport,mv_par10,mv_par14)
Local nMoedaOri	:= Posicione("CN9",1,xFilial("CN9")+cContra+cRev,"CN9_MOEDA")
Local nMoedaDes := nMoedaOri
Local nRet 		:= &(cCampo)

If Empty(dDataRef)
	dDataRef := dDataBase
EndIf

If lTReport
	If mv_par08 == 2
		nMoedaDes := mv_par09
	EndIf
ElseIf mv_par12 == 2
	nMoedaDes := mv_par13
EndIf

nRet := Round(xMoeda(nRet,nMoedaOri,nMoedaDes,dDataRef,6),TamSX3(cCampo)[2])

Return nRet

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CNR020ClFr� Autor � Aline Sebrian         � Data � 12.04.11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valida os parametro do Cliente e Fornecedor no relatorio.   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �CNR020ClFr()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �CNR020ClFr()                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function CNR020ClFr(cCnr,cTipo)
Local aSaveArea	:= GetArea()

If cCnr=="CNR020"
	If cTipo=="1"
		If !Empty(mv_par07) .Or. (!Empty(mv_par08) .And. UPPER(mv_par08) != REPLICATE("Z",TamSx3("CNC_CODIGO")[1]))
			mv_par10	:= Space(TamSx3("A1_COD")[1])
			mv_par11	:= REPLICATE("Z",TamSx3("A1_COD")[1])
		EndIf
	Else
		If !Empty(mv_par10) .Or. (!Empty(mv_par11) .And. UPPER(mv_par11) != REPLICATE("Z",TamSx3("A1_COD")[1]))
			mv_par07	:= Space(TamSx3("CNC_CODIGO")[1])
			mv_par08	:= REPLICATE("Z",TamSx3("CNC_CODIGO")[1])
		EndIf
	EndIf
Else
	If cTipo=="1"
		If !Empty(MV_PAR05)
			MV_PAR07	:= Space(TamSx3("CNC_CLIENT")[1])
		EndIf
	Else
		If !Empty(MV_PAR07)
			MV_PAR05	:= Space(TamSx3("CNC_CODIGO")[1])
		EndIf
	EndIf
EndIf

RestArea(aSaveArea)
Return
