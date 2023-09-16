#INCLUDE "MATR967.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MATR967   �Autor  �Mary C. Hergert     � Data �  07/06/2006 ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio dos valores de credito de IPTU nas notas fiscais  ���
���          �eletronicas de entrada de ISS de Sao Paulo - SP             ���
�������������������������������������������������������������������������͹��
���Uso       �Sigafis                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function MATR967()

Local cTitulo	:= ""
Local cErro		:= ""
Local cSolucao	:= ""
Local cCampos	:= ""

Local oReport               
Local lVerpesssen := Iif(FindFunction("Verpesssen"),Verpesssen(),.T.)             

PRIVATE cPerg := "MTR967"

If lVerpesssen
	If TRepInUse()
		//������������������������������������������������������������������������Ŀ
		//�Interface de impressao                                                  �
		//��������������������������������������������������������������������������
		oReport := ReportDef()
		oReport:PrintDialog()
	Else     
		MATR967R3()
	EndIf
EndIf 

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Mary C. Hergert        � Data �06/07/2006���
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
Static Function ReportDef()

Local aOrdem := {STR0018,STR0019} // "Fornecedor","Nota Fiscal Eletr�nica"
Local oReport
Local oCredito                             
Local aFilterGC
Local cFunction:= "MethIsMemberOf"

oReport := TReport():New("MATR967",STR0001,CPERG, {|oReport| ReportPrint(oReport)},STR0002+STR0003) 	// "Rela��o de Cr�ditos - Nota Fiscal Eletr�nica"
																														// "Este programa ir� imprimir uma rela��o com todos os documentos de entrada "
If !&cFunction.(oReport,"GetGClist")
	oReport:GetGClist(.F.)
Endif

oReport:SetTotalInLine(.F.)
oReport:SetLandscape()   
oReport:SetUseGC(.F.) // Remove bot�o da gest�o de empresas pois conflita com a pergunta "Seleciona Filiais" 

Pergunte(CPERG,.F.)			
// AQUI, COLOCA O FOR PARA SABER DE QUAIS FILIAIS IMPRIMIR.

oCredito := TRSection():New(oReport,STR0004,{"SF1"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/) //"Cr�dito - NF-e"
oCredito:SetTotalInLine(.F.)                                                                        
TRCell():New(oCredito,"F1_FILIAL"	,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oCredito,"F1_NFELETR"	,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oCredito,SerieNfId("SF1",3,"F1_SERIE")	,"SF1",SerieNfId("SF1",7,"F1_SERIE"),/*Picture*/,SerieNfId("SF1",6,"F1_SERIE"),/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oCredito,"F1_DTDIGIT"	,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oCredito,"F1_FORNECE"	,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oCredito,"F1_LOJA"		,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oCredito,"A2_NOME"		,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| Left(SA2->A2_NOME,40) })  
TRCell():New(oCredito,"F1_NUMRPS"  	,"SF1",STR0020 /*RPS*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
 TRCell():New(oCredito,"F1_CODNFE"	,"SF1",STR0022 /*C�d. Verif.*/,"@R !!!!-!!!!",/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oCredito,"F1_EMINFE"	,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oCredito,"F1_CREDNFE"	,"SF1",STR0021 /*Val. Cr�dito*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  

oCredito:Cell("F1_FILIAL"):Disable()

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Mary C. Hergert        � Data �07/06/2006���
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
Static Function ReportPrint(oReport)

Local cAliasSF1 := "SF1"

Local nX        := 0             
Local nOrdem    := oReport:Section(1):GetOrder() 

Local oCredito	:= oReport:Section(1)
Local oBreak
Local oBreakFil

Local cNomeFil	 :=""
Local nForFilial := 0
Local aFilsCalc  := {} 
Local lFiliais   := Iif( MV_PAR05==1 , .T. , .F. ) 
Local lFilAgl    := Iif( MV_PAR06==1 , .T. , .F. )
Local cSelect    := ""

#IFDEF TOP
	Local cNumRPS	:= ",F1_NUMRPS"
#ENDIF

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
SM0->( DbSeek( cEmpAnt + cFilAnt ) ) 
If nOrdem == 1
	oBreak := TRBreak():New(oCredito,oCredito:Cell("F1_FORNECE"),STR0005,.F.)  // "Total do fornecedor"
	oBreakFil := TRBreak():New(oCredito,oCredito:Cell("F1_FILIAL"),"Total Filial",.F.)  // "Total do fornecedor"
	If lFiliais	.And. !lFilAgl
		TRFunction():New(oCredito:Cell("F1_CREDNFE"),/* cID */,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,.F.,.F.)
		TRFunction():New(oCredito:Cell("F1_CREDNFE"),/* cID */,"SUM",oBreakFil,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,.F.,.F.)
	ElseIf !lFiliais
		TRFunction():New(oCredito:Cell("F1_CREDNFE"),/* cID */,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,.T.,.F.)
	Else
		TRFunction():New(oCredito:Cell("F1_CREDNFE"),/* cID */,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,.T.,.F.)
	EndIf
Else
	TRFunction():New(oCredito:Cell("F1_CREDNFE"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.,.T.,.F.)
Endif        

//������������������������������������������Ŀ
//�Seleciona Filiais?                        �
//��������������������������������������������			
If lFiliais 
	If MV_PAR06==2               
		aFilsCalc  := MatFilCalc(lFiliais)
	else
		aFilsCalc := MatFilCalc(lFiliais,,,lFilAgl,,Iif(MV_PAR06 == 1,2,0)) //Parametro Exp6 Valida apenas CNPJ+IE iguais
	Endif 
Else
	aFilsCalc:={{.T.,cFilAnt}}
EndIf

If lFiliais

	For nForFilial := 1 To Len(aFilsCalc)
	
		If aFilsCalc[ nForFilial, 1 ]
		
		   
		   cFilAnt := aFilsCalc[ nForFilial, 2 ]
            //��������������������������������������������������������������Ŀ
			//� Posiciona na pr�xima filial selecionada                      �
			//����������������������������������������������������������������
            SM0->( DbSetOrder(1) )
			SM0->( DbSeek( cEmpAnt + cFilAnt ) )   
			 
			//������������������������������������������������������������������������Ŀ
			//�Transforma parametros Range em expressao SQL                            �
			//��������������������������������������������������������������������������
			MakeSqlExpr(oReport:uParam)
			//������������������������������������������������������������������������Ŀ
			//�Filtragem do relat�rio                                                  �
			//��������������������������������������������������������������������������
			#IFDEF TOP
				//������������������������������������������������������������������������Ŀ
				//�Query do relat�rio da secao 1                                           �
				//��������������������������������������������������������������������������
				lQuery := .T.
				
				cSelect:= "%"
				cSelect+= "F1_DOC, F1_SERIE," + Iif(SerieNfId("SF1",3,"F1_SERIE")<>"F1_SERIE","F1_SDOC,","")
				cSelect+= "F1_DTDIGIT, F1_FORNECE, F1_LOJA, F1_NFELETR, F1_CODNFE, F1_EMINFE, F1_CREDNFE"+cNumRPS
				cSelect+= "%"
				
				oCredito:BeginQuery()	
				         
				cAliasSF1 := GetNextAlias()
						
				If nOrdem == 1
					BeginSql Alias cAliasSF1
					SELECT %Exp:cSelect% 
						
					FROM %table:SF1% SF1
						
					WHERE F1_FILIAL = %xFilial:SF1% AND 
						F1_DTDIGIT >= %Exp:mv_par01% AND 
						F1_DTDIGIT <= %Exp:mv_par02% AND 
						F1_FORNECE >= %Exp:mv_par03% AND 
						F1_FORNECE <= %Exp:mv_par04% AND
						F1_CREDNFE > 0 AND
						SF1.%NotDel% 
					ORDER BY F1_FORNECE, F1_LOJA, F1_NFELETR
					EndSql
				Else
					BeginSql Alias cAliasSF1
					SELECT %Exp:cSelect%  
						
					FROM %table:SF1% SF1
						
					WHERE F1_FILIAL = %xFilial:SF1% AND 
						F1_DTDIGIT >= %Exp:mv_par01% AND 
						F1_DTDIGIT <= %Exp:mv_par02% AND 
						F1_FORNECE >= %Exp:mv_par03% AND 
						F1_FORNECE <= %Exp:mv_par04% AND
						F1_CREDNFE > 0 AND
						SF1.%NotDel% 
					ORDER BY F1_NFELETR, F1_FORNECE, F1_LOJA
					EndSql
				Endif 
			
				oCredito:EndQuery(/*Array com os parametros do tipo Range*/)
				oCredito:SetParentQuery()			                  
			#ELSE                           
			
				MakeAdvplExpr(oReport:uParam)
				dbSelectArea("SF1")
			
				cCondicao := 'F1_FILIAL == "' + xFilial("SF1") + '" .And. ' 
				cCondicao += 'Dtos(F1_DTDIGIT) >= "' + Dtos(mv_par01) + '" .And. Dtos(F1_DTDIGIT) <= "' + Dtos(mv_par02) + '" .And. '
				cCondicao += 'F1_FORNECE >= "' + mv_par03 + '" .And. F1_FORNECE <= "' + mv_par04 + '" .And. '
				cCondicao += 'F1_CREDNFE > 0'
				
				If nOrdem == 1
					oCredito:SetFilter(cCondicao,"F1_FORNECE+F1_LOJA+F1_NFELETR")
				Else
					oCredito:SetFilter(cCondicao,"F1_NFELETR+F1_FORNECE+F1_LOJA")
				Endif	
				
			#ENDIF		
			
		 	TRPosition():New(oCredito,"SA2",1,{|| xFilial("SA2") + (cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA})
			
			oCredito:Cell("F1_NFELETR"):SetBlock({||(cAliasSF1)->F1_NFELETR})
			oCredito:Cell(SerieNfId("SF1",3,"F1_SERIE")):SetBlock({||(cAliasSF1)->&(SerieNfId("SF1",3,"F1_SERIE"))})
			oCredito:Cell("F1_DTDIGIT"):SetBlock({||(cAliasSF1)->F1_DTDIGIT})
			oCredito:Cell("F1_FORNECE"):SetBlock({||(cAliasSF1)->F1_FORNECE})
			oCredito:Cell("F1_LOJA"):SetBlock({||(cAliasSF1)->F1_LOJA})
			oCredito:Cell("F1_NUMRPS"):SetBlock({||(cAliasSF1)->F1_NUMRPS}) 
			oCredito:Cell("F1_CODNFE"):SetBlock({||(cAliasSF1)->F1_CODNFE})
			oCredito:Cell("F1_EMINFE"):SetBlock({||(cAliasSF1)->F1_EMINFE})
			oCredito:Cell("F1_CREDNFE"):SetBlock({||(cAliasSF1)->F1_CREDNFE})
			
			//������������������������������������������������������������������������Ŀ
			//�Inicio da impressao do fluxo do relat�rio                               �
			//��������������������������������������������������������������������������
		  
			(cAliasSF1)->(dbGoTop())
			dbSelectArea(cAliasSF1)
			
			If !Empty((cAliasSF1)->F1_NFELETR)
			oReport:EndPage() //Reinicia Paginas
			EndIf
			
			oReport:SetMeter((cAliasSF1)->(LastRec()))
		
			While !oReport:Cancel() .And. !(cAliasSF1)->(Eof())
				
				If oReport:Cancel()
					Exit
				EndIf
				
				If !Empty((cAliasSF1)->F1_NFELETR)	                            
				oCredito:Init()
				EndIf
		    
		    	While !oReport:Cancel() .And. !(cAliasSF1)->(Eof()) 
					oCredito:PrintLine()
					oReport:IncMeter()
					(cAliasSF1)->(DbSkip())
				Enddo                                         
				oReport:IncMeter()
			
			Enddo
            
			oCredito:Finish()
								
		EndIf
	
	Next nForFilial

Else

	oReport:EndPage() //Reinicia Paginas
			
    //��������������������������������������������������������������Ŀ
	//� Posiciona na pr�xima filial selecionada                      �
	//����������������������������������������������������������������
    SM0->( DbSetOrder(1) )
	SM0->( DbSeek( cEmpAnt + cFilAnt ) )   
	
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)
	//������������������������������������������������������������������������Ŀ
	//�Filtragem do relat�rio                                                  �
	//��������������������������������������������������������������������������
	#IFDEF TOP
		
		cSelect:= "%"
		cSelect+= "F1_DOC, F1_SERIE," + Iif(SerieNfId("SF1",3,"F1_SERIE")<>"F1_SERIE","F1_SDOC,","")
		cSelect+= "F1_DTDIGIT, F1_FORNECE, F1_LOJA, F1_NFELETR, F1_CODNFE, F1_EMINFE, F1_CREDNFE"+cNumRPS
		cSelect+= "%"
				
		//������������������������������������������������������������������������Ŀ
		//�Query do relat�rio da secao 1                                           �
		//��������������������������������������������������������������������������
		lQuery := .T.
		oCredito:BeginQuery()	
		         
		cAliasSF1 := GetNextAlias()
				
		If nOrdem == 1
			BeginSql Alias cAliasSF1
			SELECT %Exp:cSelect%
				
			FROM %table:SF1% SF1
				
			WHERE F1_FILIAL = %xFilial:SF1% AND 
				F1_DTDIGIT >= %Exp:mv_par01% AND 
				F1_DTDIGIT <= %Exp:mv_par02% AND 
				F1_FORNECE >= %Exp:mv_par03% AND 
				F1_FORNECE <= %Exp:mv_par04% AND
				F1_CREDNFE > 0 AND
				SF1.%NotDel% 
			ORDER BY F1_FORNECE, F1_LOJA, F1_NFELETR
			EndSql
		Else
			BeginSql Alias cAliasSF1
			SELECT %Exp:cSelect%
				
			FROM %table:SF1% SF1
				
			WHERE F1_FILIAL = %xFilial:SF1% AND 
				F1_DTDIGIT >= %Exp:mv_par01% AND 
				F1_DTDIGIT <= %Exp:mv_par02% AND 
				F1_FORNECE >= %Exp:mv_par03% AND 
				F1_FORNECE <= %Exp:mv_par04% AND
				F1_CREDNFE > 0 AND
				SF1.%NotDel% 
			ORDER BY F1_NFELETR, F1_FORNECE, F1_LOJA
			EndSql
		Endif 
	
		oCredito:EndQuery(/*Array com os parametros do tipo Range*/)
		oCredito:SetParentQuery()			                  
	#ELSE                           
			
		MakeAdvplExpr(oReport:uParam)
		dbSelectArea("SF1")
	
		cCondicao := 'F1_FILIAL == "' + xFilial("SF1") + '" .And. ' 
		cCondicao += 'Dtos(F1_DTDIGIT) >= "' + Dtos(mv_par01) + '" .And. Dtos(F1_DTDIGIT) <= "' + Dtos(mv_par02) + '" .And. '
		cCondicao += 'F1_FORNECE >= "' + mv_par03 + '" .And. F1_FORNECE <= "' + mv_par04 + '" .And. '
		cCondicao += 'F1_CREDNFE > 0'
		
		If nOrdem == 1
			oCredito:SetFilter(cCondicao,"F1_FORNECE+F1_LOJA+F1_NFELETR")
		Else
			oCredito:SetFilter(cCondicao,"F1_NFELETR+F1_FORNECE+F1_LOJA")
		Endif	
				
	#ENDIF		
			
 	TRPosition():New(oCredito,"SA2",1,{|| xFilial("SA2") + (cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA})
	
	oCredito:Cell("F1_NFELETR"):SetBlock({||(cAliasSF1)->F1_NFELETR})
	oCredito:Cell(SerieNfId("SF1",3,"F1_SERIE")):SetBlock({||(cAliasSF1)->&(SerieNfId("SF1",3,"F1_SERIE"))})
	oCredito:Cell("F1_DTDIGIT"):SetBlock({||(cAliasSF1)->F1_DTDIGIT})
	oCredito:Cell("F1_FORNECE"):SetBlock({||(cAliasSF1)->F1_FORNECE})
	oCredito:Cell("F1_LOJA"):SetBlock({||(cAliasSF1)->F1_LOJA})
	oCredito:Cell("F1_NUMRPS"):SetBlock({||(cAliasSF1)->F1_NUMRPS}) 
	oCredito:Cell("F1_CODNFE"):SetBlock({||(cAliasSF1)->F1_CODNFE})
	oCredito:Cell("F1_EMINFE"):SetBlock({||(cAliasSF1)->F1_EMINFE})
	oCredito:Cell("F1_CREDNFE"):SetBlock({||(cAliasSF1)->F1_CREDNFE})
	
	//������������������������������������������������������������������������Ŀ
	//�Inicio da impressao do fluxo do relat�rio                               �
	//��������������������������������������������������������������������������
  
	(cAliasSF1)->(dbGoTop())
	dbSelectArea(cAliasSF1)
	oReport:SetMeter((cAliasSF1)->(LastRec()))

	While !oReport:Cancel() .And. !(cAliasSF1)->(Eof())
		
		If oReport:Cancel()
			Exit
		EndIf
			                            
		oCredito:Init()
    
    	While !oReport:Cancel() .And. !(cAliasSF1)->(Eof()) 
	
			oCredito:PrintLine()
			oReport:IncMeter()
			(cAliasSF1)->(DbSkip())
		Enddo                                         
		oReport:IncMeter()
	Enddo

	oCredito:Finish()

EndIf	
                                                              

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MATR967R3 �Autor  �Mary C. Hergert     � Data �  07/06/2006 ���
�������������������������������������������������������������������������͹��
���Desc.     �Imprime o relatorio com as configuracoes do release 3       ���
�������������������������������������������������������������������������͹��
���Uso       �Sigafis                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Matr967R3()

Local Titulo    := OemToAnsi(STR0023)  //"Rela��o de Cr�ditos - Nota Fiscal Eletr�nica"
Local cDesc1    := OemToAnsi(STR0024) 	//"Este relat�rio ira imprimir as movimentacoes de entrada que "
Local cDesc2    := OemToAnsi(STR0025)  //"geraram cr�dito atrav�s da Nota Fiscal Eletr�nica"
Local cDesc3    := ""
Local lDic      := .F. 					// Habilita/Desabilita Dicionario
Local lComp     := .F. 					// Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro   := .F. 					// Habilita/Desabilita o Filtro
Local wnrel     := "MATR967"  			// Nome do Arquivo utilizado no Spool
Local nomeprog  := "MATR967"  			// nome do programa
Local cString	:= "SF1"
Local nPagina	:= 1

Private Tamanho := "M"					// P/M/G
Private Limite  := 132 					// 80/132/220
Private aReturn := {STR0026,1,STR0027,1,2,1,"",1}	//"Zebrado"###"Administracao"
Private aOrdem	:= {STR0032,STR0033} // "Fornecedor","Nota Fiscal Eletr�nica"

Private lEnd    := .F.					// Controle de cancelamento do relatorio
Private m_pag   := 1  					// Contador de Paginas
Private nLastKey:= 0  					// Controla o cancelamento da SetPrint e SetDefault

//������������������������������������������������������������������������Ŀ
//�Envia para a SetPrint                                                   �
//��������������������������������������������������������������������������
cPerg   := "MTR967"				// Pergunta do Relatorio
Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro,.F.)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| Mtr967Imp(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

//��������������������������������������������������������������Ŀ
//� Restaura Ambiente                                            �
//����������������������������������������������������������������
dbSelectArea(cString)
dbClearFilter()
Set Device To Screen
Set Printer To

If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return(.T.)
                                
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �Mtr967Imp   �Autor  �Mary C. Hergert     � Data � 03/07/2006  ���
���������������������������������������������������������������������������͹��
���Desc.     �Impressao do detalhe do relatorio de conferencia no Release 3 ���
���������������������������������������������������������������������������͹��
���Uso       �Matr967                                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/                                                                                                    
Static Function Mtr967Imp(lEnd,wnRel,cString,nomeprog,Titulo)

Local cCabec1	:= STR0028  //"NF-Eletr.  S�rie   Fornecedor Loja  Raz�o Social                               N�mero RPS     C�d. Verif.  Valor Cr�dito"
Local cCabec2	:= ""
Local cAliasSF1	:= "SF1"
Local cNome		:= ""
Local cCliente	:= ""

Local lQuery	:= .F.

Local nLin		:= 60  
Local nOrdem	:= aReturn[8]                                                                             
Local nTotForn	:= 0
Local nTotGer	:= 0

#IFNDEF TOP
	Local cArqInd	:= ""
	Local cChave	:= ""
	Local cCondicao	:= ""
#ELSE
	Local cNumRPS	:= ",F1_NUMRPS"
#ENDIF                               

// Variaveis utilizadas no processamento por Filiais
Local aFilsCalc  := MatFilCalc(mv_par05 == 1)
Local cFilBack   := cFilAnt
Local nForFilial := 0
//Local lProc	     := .T.                                

Local nTotFil    := 0
//Local nTotalg    := 0
Local cSelect    := ""


if Empty(aFilsCalc)
	aadd(aFilsCalc,{.T.,cFilAnt,""})
Endif

If !Empty(aFilsCalc)

	For nForFilial := 1 To Len(aFilsCalc)  
	
		If aFilsCalc[ nForFilial, 1 ]
		
			cFilAnt := aFilsCalc[ nForFilial, 2 ]
            
			SM0->( DbSetOrder(1) )
			SM0->( DbSeek( cEmpAnt + cFilAnt ) )	            
			
    	    if nForFilial <> 1
	    		nLin := Cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,18)
	    	endif

			//�����������������������������Ŀ
			//�Selecionando as movimentacoes�
			//�������������������������������
			#IFDEF TOP
			
				lQuery := .T.
				
				cSelect:= "%"
				cSelect+= "F1_DOC, F1_SERIE," + IIF(SerieNfId("SF1",3,"F1_SERIE")<>"F1_SERIE","F1_SDOC,","") 
				cSelect+= " F1_DTDIGIT, F1_FORNECE, F1_LOJA, F1_NFELETR, F1_CODNFE, F1_EMINFE, F1_CREDNFE, F1_TIPO" + cNumRPS
				cSelect+= "%"  
				       
				cAliasSF1 := GetNextAlias()
						
				If nOrdem == 1
					BeginSql Alias cAliasSF1
					SELECT %Exp:cSelect%
						
					FROM %table:SF1% SF1
						
					WHERE F1_FILIAL = %Exp:cFilAnt% AND 
						F1_DTDIGIT >= %Exp:mv_par01% AND 
						F1_DTDIGIT <= %Exp:mv_par02% AND 
						F1_FORNECE >= %Exp:mv_par03% AND 
						F1_FORNECE <= %Exp:mv_par04% AND
						F1_CREDNFE > 0 AND
						SF1.%NotDel% 
					ORDER BY F1_FORNECE, F1_LOJA, F1_NFELETR
					EndSql
				Else
					BeginSql Alias cAliasSF1
					SELECT %Exp:cSelect%
						
					FROM %table:SF1% SF1
						
					WHERE F1_FILIAL = %Exp:cFilAnt% AND 
						F1_DTDIGIT >= %Exp:mv_par01% AND 
						F1_DTDIGIT <= %Exp:mv_par02% AND 
						F1_FORNECE >= %Exp:mv_par03% AND 
						F1_FORNECE <= %Exp:mv_par04% AND
						F1_CREDNFE > 0  AND
						SF1.%NotDel% 
					ORDER BY F1_NFELETR, F1_FORNECE, F1_LOJA
					EndSql
				Endif 
		
			#ELSE                           
			
				cArqInd	:=	CriaTrab(NIL,.F.)
				If nOrdem == 1
					cChave := "F1_FORNECE+F1_LOJA+F1_NFELETR"
				Else
					cChave := "F1_NFELETR+F1_FORNECE+F1_LOJA"
				Endif	
			
				dbSelectArea("SF1")
				cCondicao := 'F1_FILIAL == "' + cFilAnt + '" .And. ' 
				cCondicao += 'Dtos(F1_DTDIGIT) >= "' + Dtos(mv_par01) + '" .And. Dtos(F1_DTDIGIT) <= "' + Dtos(mv_par02) + '" .And. '
				cCondicao += 'F1_FORNECE >= "' + mv_par03 + '" .And. F1_FORNECE <= "' + mv_par04 + '" .And. '
				cCondicao += 'F1_CREDNFE > 0'
				
				IndRegua(cAliasSF1,cArqInd,cChave,,cCondicao,STR0029) //"Selecionando Registros..."
				
			#ENDIF		

			(cAliasSF1)->(dbGoTop())
			dbSelectArea(cAliasSF1)
			SetRegua(LastRec()) 
			            
			nTotFil := 0                
			
			While !lEnd .And. !(cAliasSF1)->(Eof())
			
				If nLin > 55
					nLin := Cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,18)
				Endif             
				
				nLin++ 
	
				//��������������������������������������������������������������������Ŀ
				//�Caso a ordem escolhida seja por fornecedor, totaliza por fornecedor.�
				//����������������������������������������������������������������������
				If nOrdem == 1
					If cCliente <> (cAliasSF1)->F1_FORNECE + (cAliasSF1)->F1_LOJA
						If !Empty(cCliente)
							nLin++
							@nLin,000 Psay Repli("-",Limite)
							nLin++
							@nLin,000 PSay STR0030 // Total do Fornecedor
							@nLin,107 PSay nTotForn Picture PesqPict("SF1","F1_CREDNFE")
							nLin++
							nLin++
							nTotForn := 0
						Endif
					cCliente := (cAliasSF1)->F1_FORNECE + (cAliasSF1)->F1_LOJA 
				Endif
				nTotForn 	+= (cAliasSF1)->F1_CREDNFE
			Endif
	
			nTotGer	+= (cAliasSF1)->F1_CREDNFE
			nTotFil += (cAliasSF1)->F1_CREDNFE
			SA2->(dbSetOrder(1))
			SA1->(dbSetOrder(1))
		    cNome := ""
			If (cAliasSF1)->F1_TIPO $ "DB"
				If SA1->(dbSeek(xFilial("SA1")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA))
					cNome := Left(SA1->A1_NOME,40)
				Endif
			Else
				If SA2->(dbSeek(xFilial("SA2")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA))
					cNome := Left(SA2->A2_NOME,40)
				Endif
			Endif
			
			//0         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160  
			//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
			//NF-Eletr.  S�rie   Fornecedor Loja  Raz�o Social                               N�mero RPS     C�d. Verif.       Valor Cr�dito
			//99999999   99999   99999999   999   9999999999999999999999999999999999999999   999999999999   9999999999   999,999,999,999.99
				@nLin, 000 PSay (cAliasSF1)->F1_NFELETR
				@nLin, 011 PSay (cAliasSF1)->&(SerieNfId("SF1",3,"F1_SERIE"))
				@nLin, 019 PSay (cAliasSF1)->F1_FORNECE
				@nLin, 030 PSay (cAliasSF1)->F1_LOJA
				@nLin, 036 PSay cNome                 
				@nLin, 079 PSay (cAliasSF1)->F1_NUMRPS
				@nLin, 094 PSay (cAliasSF1)->F1_CODNFE Picture "@R !!!!-!!!!"
				@nLin, 107 PSay (cAliasSF1)->F1_CREDNFE Picture PesqPict("SF1","F1_CREDNFE")
			                                                            
				(cAliasSF1)->(dbSkip())
			
			Enddo             
			If nLin > 55
				nLin := Cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,18)
			Endif             
			
			nLin++ 
		
			// Total do ultimo fornecedor
			If nOrdem == 1
				if nTotForn <> 0
					nLin++
					@nLin,000 Psay Repli("-",Limite)
					nLin++
					@nLin,000 PSay STR0030 // Total do Fornecedor
					@nLin,107 PSay nTotForn Picture PesqPict("SF1","F1_CREDNFE")
					nLin++ 
					cCliente := '' 
					nTotForn := 0
				Endif
			Endif	
			// Total Filial  
			
			if nTotFil <> 0
				nLin++
				@nLin,000 Psay Repli("-",Limite)
				nLin++
				@nLin,000 PSay "Total da Filial " + Alltrim(SM0->M0_FILIAL)
				@nLin,107 PSay nTotFil Picture PesqPict("SF1","F1_CREDNFE") 
				nLin++
				nLin++                                         
			endif
    	Endif                              
	Next nForFilial    
Endif              

//������������������������������Ŀ
//�Imprime os totais do relatorio�
//��������������������������������
If nTotGer > 0
	// Total geral
	nLin++
	nLin++
	@nLin,000 Psay Repli("-",Limite)
	nLin++
	@nLin,000 PSay STR0031 // Total Geral
	@nLin,107 PSay nTotGer Picture PesqPict("SF1","F1_CREDNFE")
Endif

cFilAnt := cFilBack
DBSELECTAREA("SM0")
DBSETORDER(1)
DBSEEK(cEmpAnt + CFILANT)	            

If lQuery
	dbSelectArea(cAliasSF1)
	dbCloseArea()
Else	     
	dbSelectArea(cAliasSF1)
	Ferase(cArqInd+OrdBagExt())
	RetIndex("SF1")
Endif

Return(.T.)
