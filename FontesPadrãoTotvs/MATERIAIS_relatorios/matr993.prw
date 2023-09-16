#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "MATR993.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR993  � Autor � Rodrigo M. Pontes     � Data �18/12/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Certificado de reten��o do imposto de ICA			      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR993(ExpA1)                                             ���
�������������������������������������������������������������������������Ĵ��
���Parametro � ExpA1[n][1]  - Numero do Certificado						  ���
���          � ExpA1[n][2]  - Data de Emiss�o                             ���
���          � ExpA1[n][3]  - Codigo do Fornecedor                        ���
���          � ExpA1[n][4]  - Loja                                        ���
���          � ExpA1[n][5]  - Tipo						                  ���
���          � ExpA1[n][6]  - Numero da Fatura                            ���
���          � ExpA1[n][7]  - Serie da Fatura                             ���
���          � ExpA1[n][8]  - Base de Calculo da Reten��o                 ���
���          � ExpA1[n][9]  - Aliquota para o Calculo                     ���
���          � ExpA1[n][10] - Filial que esta gerando o certificado       ���
���          � ExpA1[n][11] - Valor do imposto de reten��o                ���
���          � ExpA1[n][12] - Valor da Reten��o                           ���
���          � ExpA1[n][13] - Codigo fiscal da opera��o                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Gera Certificado de Reten��o ICA                           ���
�������������������������������������������������������������������������Ĵ��
���Programado� Data   � BOPS �  Motivo da Alteracao                       ���
�������������������������������������������������������������������������Ĵ��
���Alf. Medra�15/06/16�TUMAXX� En la funci�n FImpRetICA() se asigna el    ���
���          �        �      � n�mero de Certificado en el encabezado del ���
���          �        �      �  informe. Colombia                         ���
���Alf. Medra�20/10/16�TWGPRD�En Func FImpRetICA se agrega validacion si  ���
���          �        �      �A2_PFISICA es vacio toma A2_CGC NIT Retenido���
���          �        �      �Se quita transform a M0_CGC para Colombia   ���
���Alf. Medra�08/11/16�TWIPKT�MERGE 12.1.07 vs Main  COL                  ���
���Alf. Medra�13/08/18�DMINA �En fun FImpRetICA se agrega la columna de   ���
���          �        � -3776�Municipio y se agupan los valores por Tarifa���
���          �        �      �y Municipio                                 ���
���Veronica F�12/06/19�DMINA �En fun FImpRetICA se modifican las          ���
���          �        � -6839�coordenada para que se muestren los         ���
���          �        �      �totales y lineas del reporte                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function MATR993(alDados)

	Local olReport
	Local clNomProg		:= FunName()
	Local clTitulo 		:= STR0001 //Reten��o de ICA
	Local clDesc   		:= STR0002 //Relatorio de certificado de reten��o de ICA

	If FindFunction("TRepInUse") .And. TRepInUse()
		olReport:=TReport():New(clNomProg,clTitulo,,{|olReport| FImpRetICA(olReport,alDados)},clDesc)
		olReport:oPage:nPaperSize	:= 9 	// Impress�o em papel A4
		olReport:lHeaderVisible  	:= .F. 	// N�o imprime cabe�alho do protheus
		olReport:lFooterVisible  	:= .F.	// N�o imprime rodap� do protheus
		olReport:lParamPage			:= .F.	// N�o imprime pagina de parametros
		olReport:PrintDialog()
	Endif

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FImpRetICA� Autor � Rodrigo M. Pontes     � Data �18/12/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impress�o do certificado de reten��o do imposto de ICA     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FImpRetICA(ExpO1,ExpA1)                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametro � ExpO1        - Objeto TReport para a impress�o			  ���
���          | ExpA1[n][1]  - Numero do Certificado						  ���
���          � ExpA1[n][2]  - Data de Emiss�o                             ���
���          � ExpA1[n][3]  - Codigo do Fornecedor                        ���
���          � ExpA1[n][4]  - Loja                                        ���
���          � ExpA1[n][5]  - Tipo						                  ���
���          � ExpA1[n][6]  - Numero da Fatura                            ���
���          � ExpA1[n][7]  - Serie da Fatura                             ���
���          � ExpA1[n][8]  - Base de Calculo da Reten��o                 ���
���          � ExpA1[n][9]  - Aliquota para o Calculo                     ���
���          � ExpA1[n][10] - Filial que esta gerando o certificado       ���
���          � ExpA1[n][11] - Valor do imposto de reten��o                ���
���          � ExpA1[n][12] - Valor da Reten��o                           ���
���          � ExpA1[n][13] - Codigo fiscal da opera��o                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Gera Certificado de Reten��o ICA                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

Static Function FImpRetICA(olReport,alDados)

	Local nlLinha	:= 0 //Contador de linhas do memoline
	Local i			:= 0
	Local nlBaseTot	:= 0 //Valor base do imposto total
	Local nlImpTot	:= 0 //Valor do imposto total
	Local nlBaseRet	:= 0 //Valor base do imposto por aliquota
	Local nlImpRet	:= 0 //Valor do imposto por aliquota
	Local nlAliq	:= 0 //Aliquota
	Local k			:= 0
	Local nTopLin	:= 0
	Local clForn	:= "" //Codigo do fornecedor
	Local clLoja	:= "" //Loja
	Local cData		:= ""
	Local cCodMun	:= ""
	Local cCdMnTs	:= ""
	Local cMunic	:= ""
	Local oFont		:= TFont():New("Courier New",09,12,.T.,.F.,5,.T.,5,.F.,.F.)
	Local oFont1	:= TFont():New("Courier New",09,13,.T.,.T.,5,.T.,5,.F.,.F.)
    Local oFont10 	:= TFont():New("Courier New",,-10,,)
	Local aAliq		:= {} //Array das aliquotas por fornecedor
	Local clNomPer	:= ""
	Local cNitCC	:= ""
	Local cPicNit	:= ""
	Local cPicNitAg	:= GetSx3Cache( "A2_CGC" , "X3_PICTURE" )
	Local nConcep   := 0
	Local cValConcep:= ""
	
	nConcep  	:=Iif(cPaisLoc$"COL",MV_PAR14,1)
	ASORT(alDados,,,{|x,y| x[18] < y[18]})  // COD MUN
	
	For i:=1 to Len(alDados)

		If Len(aAliq) > 0
			If aScan(aAliq,{|x| x[4] == alDados[i][3]}) > 0
				Loop
			Endif
		Endif

		olReport:SayBitmap(olReport:Row()+50,olReport:Col()+1050,FLgEmp(),330,170)

	   	olReport:Box(olReport:Row()+0250,olReport:Col()+0350,olReport:Row()+0250,olReport:Col()+2125)
	   	olReport:SkipLine(12)
	   If cPaisLoc == 'COL'
	  	 	olReport:Say(0290,1790, STR0021 + alDados[i][1],oFont,10,,) //"CERTIFICADO No.:"
		EndIf
	   	olReport:Say(olReport:Row(),olReport:Col()+0700,STR0003	,oFont,,,) //CERTIFICADO DE RETENCION DE ICA
	   	olReport:SkipLine(4)
	   	olReport:Say(olReport:Row(),olReport:Col()+0990,STR0004 + AllTrim(Str(Year(mv_par02)))	,oFont,,,) //ANO GRAVABLE:
	   	olReport:SkipLine(2)
	   	olReport:Say(olReport:Row(),olReport:Col()+0850,STR0005 +Upper(SubStr(MesExtenso(Month(mv_par02)),1,3))+" "+AllTrim(Str(Day(mv_par02)))+"/"+AllTrim(Str(Year(mv_par02))),oFont,,,) // DE:
	   	olReport:Say(olReport:Row(),olReport:Col()+1280,STR0006 +Upper(SubStr(MesExtenso(Month(mv_par03)),1,3))+" "+AllTrim(Str(Day(mv_par03)))+"/"+AllTrim(Str(Year(mv_par03))),oFont,,,) // A:
	   	olReport:SkipLine(4)

	   	olReport:Say(olReport:Row(),olReport:Col()+0700,STR0007 + AllTrim(Upper(SM0->M0_NOMECOM))	,oFont,,,) //RETENEDOR:
	   	olReport:SkipLine(2)
	   	olReport:Say(olReport:Row(),olReport:Col()+0700,STR0008 + IF(cPaisLoc == 'COL',SM0->M0_CGC, AllTrim(Transform(SM0->M0_CGC,cPicNitAg))) 	,oFont,,,) //NIT      :
	   	olReport:SkipLine(2)
	   	olReport:Say(olReport:Row(),olReport:Col()+0700,STR0009 + AllTrim(Upper(SM0->M0_ENDENT)) 	,oFont,,,) //DIRECCION:
	   	olReport:SkipLine(4)

	   	DbSelectArea("SA2")
	   	SA2->(DbSetOrder(1))
	   	SA2->(DbGoTop())
	   	If DbSeek(xFilial("SA2")+Padr(alDados[i,3],TamSx3("A2_COD")[1]," ")+PadR(alDados[i,4],TamSX3("A2_LOJA")[1]," "))
			If SA2->A2_PESSOA == "F"
	    		If AllTrim(SA2->A2_NOMEMAT + SA2->A2_NOMEPAT) <> ""
	    			clNomPer := RTRIM(SA2->A2_NOMEPRI) + RTRIM(" "+SA2->A2_NOMEPES) + RTRIM(" "+SA2->A2_NOMEMAT) + RTRIM(" "+SA2->A2_NOMEPAT)
	    		Else
	    			clNomPer := Alltrim(SA2->A2_NOME)
	    		EndIf
	   			cNitCC 	:= SA2->A2_PFISICA
	    		cPicNit	:= GetSx3Cache( "A2_PFISICA" , "X3_PICTURE" )
			Else
	   			clNomPer:= RTRIM(SA2->A2_NOME)
	   			cNitCC 	:= SA2->A2_CGC
	    		cPicNit	:= GetSx3Cache( "A2_CGC" , "X3_PICTURE" )
	    	EndIf

	    If cPaisLoc == 'COL'
	    	If !Empty(SA2->A2_PFISICA)
	    		cNitCC 	:= SA2->A2_PFISICA
	    	Else	
	    		cNitCC 	:= SA2->A2_CGC
	    	EndIf
	    EndIf
			olReport:Say(olReport:Row(),olReport:Col()+0700,STR0010 + clNomPer ,oFont,,,) //RETUVO A :			
			olReport:SkipLine(2)
			olReport:Say(olReport:Row(),olReport:Col()+0700,STR0008 + AllTrim(Transform(cNitCC,cPicNit)),oFont,,,) //NIT      :
			olReport:SkipLine(2)
		 	olReport:Say(olReport:Row(),olReport:Col()+0700,STR0009 + AllTrim(Upper(SA2->A2_END)) + ' ' + AllTrim(Upper(SA2->A2_BAIRRO)) + ' ' + AllTrim(Upper(SA2->A2_MUN))	,oFont,,,) //DIRECCION:
		Endif
		
		

		olReport:SkipLine(8)

		aAliq	  	:= {}
		nlImpRet 	:= 0
		nlBaseRet 	:= 0
		nlBaseTot	:= 0
		nlImpTot	:= 0

		clForn := alDados[i][3]
		clLoja := alDados[i][4]
		nlAliq := alDados[i][9]
		cCodMun:= alDados[i][18]

		For k:=i to Len(alDados)
			cMunic := alDados[k][19]
			If clForn == alDados[k][3] .And. clLoja == alDados[k][4] 
				If nlAliq == alDados[k][9] .and. cCodMun == alDados[k][18] 
					cCdMnTs := alDados[k][19]
					nlBaseRet += alDados[k][8]
					nlImpRet  += alDados[k][12]
					If k >= Len(alDados)
						If nlBaseRet > 0 .And. nlImpRet > 0
							aAdd(aAliq,{nlBaseRet,nlImpRet,nlAliq,clForn,cCdMnTs})
						Endif
					Endif
				Else
					aAdd(aAliq,{nlBaseRet,nlImpRet,nlAliq,clForn,cCdMnTs})
					nlAliq 		:= alDados[k][9]
					nlBaseRet 	:= alDados[k][8]
					nlImpRet  	:= alDados[k][12]
					cCdMnTs 	:= alDados[k][19]
					If k >= Len(alDados)
						If nlBaseRet > 0 .And. nlImpRet > 0
							aAdd(aAliq,{nlBaseRet,nlImpRet,nlAliq,clForn,cCdMnTs})
						Endif
					Endif
				Endif
			Else
				aAdd(aAliq,{nlBaseRet,nlImpRet,nlAliq,clForn,cCdMnTs})
				Exit
			Endif
		Next k

		For k:=1 to Len(aAliq)
			nlBaseTot += aAliq[k,1]
			nlImpTot  += aAliq[k,2]
		Next k

		olReport:Box(olReport:Row()-0050,olReport:Col()+0170,olReport:Row()+0100,olReport:Col()+2350)
		olReport:Box(olReport:Row()-0050,olReport:Col()+0590,olReport:Row()+0100,olReport:Col()+0590)
		olReport:Box(olReport:Row()-0050,olReport:Col()+1000,olReport:Row()+0100,olReport:Col()+1000)
		olReport:Box(olReport:Row()-0050,olReport:Col()+1400,olReport:Row()+0100,olReport:Col()+1400)
		olReport:Box(olReport:Row()-0050,olReport:Col()+1910,olReport:Row()+0100,olReport:Col()+2350)
		olReport:Box(olReport:Row()+0050,olReport:Col()+0170,olReport:Row()+0050,olReport:Col()+2350)

		olReport:Say(olReport:Row(),olReport:Col()+260,STR0011,oFont1,,,) //CONCEPTO
		olReport:Say(olReport:Row(),olReport:Col()+0685,STR0022,oFont1,,,) //MUNICIPIO
		olReport:Say(olReport:Row(),olReport:Col()+1140,STR0012,oFont1,,,) //TARIFA
		olReport:Say(olReport:Row(),olReport:Col()+1460,STR0013,oFont1,,,) //BASE RETENCION
		olReport:Say(olReport:Row(),olReport:Col()+1950,STR0014,oFont1,,,) //VALOR RETENIDO	
		
		If nConcep == 2
			cValConcep := STR0023 //COMPRAS
		Elseif nConcep == 3
			cValConcep := STR0024 //SERVICIOS GENERALES
		Elseif nConcep == 4
		    cValConcep := STR0025 //OTROS
		Else
			cValConcep := STR0001 //RETENCION DEL ICA
		EndIF
		
		For k:=1 to Len(aAliq)
			olReport:Say(olReport:Row()+55,olReport:Col()+0185,cValConcep												,oFont10,,,) //RETENCION DE ICA
			olReport:Say(olReport:Row()+55,olReport:Col()+0685,AllTrim(aAliq[k,5])								,oFont10,,,) // MUNICIPIO
			olReport:Say(olReport:Row()+55,olReport:Col()+1140,AllTrim(Str(aAliq[k,3])) + STR0015		 			,oFont10,,,)// X MIL
			olReport:Say(olReport:Row()+55,olReport:Col()+1370,Transform(aAliq[k,1],"@E 999,999,999,999,999.99")	,oFont10,,,)
			olReport:Say(olReport:Row()+55,olReport:Col()+1820,Transform(aAliq[k,2],"@E 999,999,999,999,999.99")	,oFont10,,,)
			olReport:SkipLine(2)

			olReport:Box(olReport:Row()-20,olReport:Col()+0170,olReport:Row()+45,olReport:Col()+0170)
			If k > 1
				olReport:Box(olReport:Row()-20,olReport:Col()+0590,olReport:Row()+45,olReport:Col()+0590)
			Else
				olReport:Box(olReport:Row()-20,olReport:Col()+0590,olReport:Row()+40,olReport:Col()+0590)
			Endif
			olReport:Box(olReport:Row()-20,olReport:Col()+1000,olReport:Row()+45,olReport:Col()+1000)
			olReport:Box(olReport:Row()-20,olReport:Col()+1400,olReport:Row()+45,olReport:Col()+1400)
			olReport:Box(olReport:Row()-20,olReport:Col()+1910,olReport:Row()+45,olReport:Col()+1910)
			olReport:Box(olReport:Row()-20,olReport:Col()+2350,olReport:Row()+45,olReport:Col()+2350)
			If k > 1		
				olReport:Box(olReport:Row()+45,olReport:Col()+0170,olReport:Row()+45,olReport:Col()+2350)
			Endif
			
		Next k

	   	olReport:SkipLine(2)
		
		
		IIf( k -1 > 1, nTopLin := 15,  nTopLin := 20)
		
		olReport:Box(olReport:Row()-nTopLin,olReport:Col()+0170,olReport:Row()+50,olReport:Col()+1400)
		olReport:Box(olReport:Row()-nTopLin,olReport:Col()+1400,olReport:Row()+50,olReport:Col()+1910)
		olReport:Box(olReport:Row()-nTopLin,olReport:Col()+1910,olReport:Row()+50,olReport:Col()+2350)
		
		olReport:Say(olReport:Row(),olReport:Col()+0570,STR0016										 	,oFont1,,,) //TOTAL
		olReport:Say(olReport:Row(),olReport:Col()+1370,Transform(nlBaseTot,"@E 999,999,999,999,999.99")	,oFont10,,,)
		olReport:Say(olReport:Row(),olReport:Col()+1820,Transform(nlImpTot,"@E 999,999,999,999,999.99")	,oFont10,,,)
		

		olReport:SkipLine(12)
		olReport:Say(olReport:Row(),olReport:Col()+0350,AllTrim(Extenso(nlImpTot,.F.,1))			,oFont,,,)

		olReport:SkipLine(12)
		olReport:Say(olReport:Row(),olReport:Col()+0350,STR0017 + AllTrim(Upper(SM0->M0_CIDENT))	,oFont,,,) //CIUDAD DONDE SE CONSIGNO LA RETENCION :
		olReport:SkipLine(9)

		olReport:Say(olReport:Row()   ,olReport:Col()+0350,MemoLine(STR0019,75,1,2,.T.),oFont10,,,)
		olReport:Say(olReport:Row()+60,olReport:Col()+0350,MemoLine(STR0019,75,2,2,.T.),oFont10,,,)

		olReport:SkipLine(10)

		DbSelectArea("SFB")
		SFB->(DbSetOrder(1))
		If DbSeek(xFilial("SFB")+"RC0")

			nlLinha := MLCOUNT(SFB->FB_CERTIF,80,3,.T.)

			If nlLinha == 0
				nlLinha := 1
			Elseif nlLinha > 3
				nlLinha := 3
			Endif

			For k:=1 to nlLinha
				olReport:Say(olReport:Row(),olReport:Col()+0325,MEMOLINE(SFB->FB_CERTIF,80,k,3,.T.),oFont,,,)
				olReport:SkipLine(2)
			Next k

		Endif

		cData := SubStr(GravaData(dDataBase,.F.,8),1,4)+"/"+SubStr(GravaData(dDataBase,.F.,8),5,2)+"/"+SubStr(GravaData(dDataBase,.F.,8),7,2)

		olReport:SkipLine(2)
		olReport:Say(olReport:Row(),olReport:Col()+0350,AllTrim(Upper(SM0->M0_CIDENT)),oFont,,,)
		olReport:Say(olReport:Row(),olReport:Col()+1050, STR0020 + " " + AllTrim(cData),oFont,,,)

		olReport:SkipLine(6)
		olReport:Box(olReport:Row(),olReport:Col()+0350,olReport:Row(),olReport:Col()+2125)

	    olReport:EndPage()
	Next i

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FLgEmp   � Autor � Rodrigo M. Pontes     � Data �18/12/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Traz o logotipo da empresa								  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FLgEmp()				                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Gera Certificado de Reten��o ICA                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

Function FLgEmp()

	Local cLogo			:= ""
	Local cStartPath	:= GetSrvProfString("Startpath","")

	cLogo := cStartPath + "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" 	// Empresa+Filial
	If !File(cLogo)
		cLogo := cStartPath + "LGRL"+SM0->M0_CODIGO+".BMP" 				// Empresa
	Endif

Return cLogo
