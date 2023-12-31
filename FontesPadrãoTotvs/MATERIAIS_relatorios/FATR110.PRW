#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FATR110.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATR110   �Autor  �Eduardo Gomes Junior� Data �  13/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relatorio de pre-escopo                                    ���
�������������������������������������������������������������������������͹��
���Uso       � CRMA290 - WORKAREA / FATA530 - SIMULADOR DE HORAS          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function FATR110()

Local aArea			:= GetArea()
Local aEscopoPrj	:= {}
Local nLeE			:= 1
Local aPrepHeade	:= {}
Local aPrepAcols	:= {}
Local cQtdCalc
Local aExcel		:= {}
Local lContinua	:= .F.

Private wnrel		:= "FATR110"
Private cTitulo		:= STR0001	//"Relat�rio de pr�-escopo"
Private cTamanho  	:= "G" // P = 80, M = 136, G = 220
Private cNomeProg	:= "FATR110"
Private Cabec1		:= ""
Private Cabec2		:= ""
Private Cabec3		:= ""
Private aReturn		:= { STR0002, 1, STR0003, 2, 1, 1, "", 1 }	//"Zebrado"###"Administracao"

Private cNrOrcame
Private cSimulacao
Private cVersao
Private nTipRel
Private nHorasSN

If	!IsInCallStack("A600SERVICOS")
	
	If	Pergunte( "FATR110A" , .T. )

		lContinua := .T.
	
		cNrOrcame 		:= MV_PAR01
		cSimulacao 	:= MV_PAR02
		cVersao		:= MV_PAR03
		nTipRel		:= MV_PAR04
		nHorasSN		:= MV_PAR05
	Endif 
	
Else
	
	If	Pergunte( "FATR110B" , .T. )
		lContinua := .T.

		cNrOrcame 		:= M->AF1_CODORC
		cSimulacao 	:= M->AF1_ORCAME
		cVersao		:= M->AF1_VERSAO
		nTipRel		:= MV_PAR01
		nHorasSN		:= MV_PAR02
			
	Endif 
	 
Endif 

If	lContinua
	dbSelectArea("ADZ")
	dbSetOrder(1)
	If	!dbSeek(xFilial("ADZ")+cNrOrcame)
	    MsgAlert(STR0005,STR0004)	//"Proposta informada n�o encontrada!"###"Aten��o"
    Else
    
    	If	!Empty(cSimulacao)
    
		    MsgRun(STR0006,cTitulo,{||aEscopoPrj := Ft530Ordem(cSimulacao,cVersao) })	//Esta funcao preenche o array com o escopo da simulacao realizando ordenacao dos itesn   //"Aguarde analisando projeto informado..."
    
    		IF	nTipRel == 1
    	
				//�����������Ŀ
				//� Relatorio �
				//�������������
				If	Len(aEscopoPrj) > 1
					R110ImpEscPrj(cTamanho, cTitulo,aEscopoPrj,cNrOrcame,cSimulacao,cVersao)
				Else
				    MsgAlert(STR0007,STR0004)	//"Nao existes itens no projeto","Aten��o"
				Endif 		
				
	    	Else 
    	
				//�������Ŀ
				//� Excel �
				//���������
				aPrepHeade := {STR0008,STR0009,If(nHorasSN==1,STR0010,"")}	//"EDT/TAREFA"###"Descricao"###"Quantidade"
				
				For nLeE=1 To Len(aEscopoPrj)
				
					If	aEscopoPrj[nLeE,6] <> "001"
				
						If	nHorasSN == 1 
							cQtdCalc := R110CalcQtd( aEscopoPrj[nLeE,4], aEscopoPrj[nLeE,10], aEscopoPrj )
						Endif 
				
						Aadd(aPrepAcols,{aEscopoPrj[nLeE,4],aEscopoPrj[nLeE,7],If(nHorasSN==1,cQtdCalc:=StrTran(cQtdCalc,".",",") ,"") })
						
					Endif 
										
				Next 
				
				AAdD(aExcel , {"ARRAY",STR0011+cNrOrcame+STR0012+cSimulacao+STR0013+cVersao, aPrepHeade, aPrepAcols} )	//"Proposta Comercial: "###" Simula��o: "###" - Vers�o: "

				If 	Len(aExcel) > 0

					DlgToExcel(aExcel)
	
					While ApMsgNoYes(STR0014)	//"Deseja exportar novamente para excel?"
						DlgToExcel(aExcel)
					EndDo
				Else
					ApMsgStop(STR0015)	//"N�o h� dados!"
				EndIf
		
	    	Endif
	    	
		Else
		
			MsgAlert(STR0016,STR0004) 	//"Proposta informado n�o possui projeto criado"###"Aten��o"
    
        Endif 
        
	Endif 

Endif 

RestArea(aArea)

Return

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Programa  �R110ImpEscPr j�Autor  �Eduardo Gomes Junior� Data �  13/04/15   ���
�����������������������������������������������������������������������������͹��
���Desc.     � Relatorio de pre-escopo                                        ���
�����������������������������������������������������������������������������͹��
���Uso       � CRMA290 - WORKAREA / FATA530 - SIMULADOR DE HORAS              ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
Static Function R110ImpEscPrj(cTamanho, cTitulo, aEscopoPrj, cProposta, cNumPMS, cPMSVersao)

Local cDesc1  := STR0017	//"Este relat�rio imprime o escopo e as funcionalidades conforme estrutura da EDT."
Local cDesc2  := ""
Local cDesc3  := ""

wnrel := SetPrint( "AF1", wnrel,, @cTitulo, cDesc1, cDesc2, cDesc3, .F., , .T., cTamanho )

If nLastKey == 27
   Return( Nil )
Endif

SetDefault( aReturn, "AF1" )

nTipo := Iif( aReturn[4] == 1, 15, 18 )

If nLastKey == 27
   Return( Nil )
EndIf

RptStatus( { || R110IniImpres( wnrel, cTamanho, @cTitulo, aEscopoPrj, cProposta, cNumPMS, cPMSVersao ) } , STR0018 , STR0019 , .T. )	//"Aguarde..."###"Processando registros..."

Return( Nil )

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �R110IniImpres�Autor  �Eduardo Gomes Junior� Data �  13/04/15   ���
����������������������������������������������������������������������������͹��
���Desc.     � Relatorio de pre-escopo                                       ���
����������������������������������������������������������������������������͹��
���Uso       � CRMA290 - WORKAREA / FATA530 - SIMULADOR DE HORAS             ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function R110IniImpres( wnrel, cTamanho, cTitulo, aEscopoPrj, cProposta, cNumPMS, cPMSVersao )

Local nLePrj		:= 1
Local cQtdCalc

Private Li			:= 80
Private cNomeProg	:= 'CRPMSR10'
Private M_PAG		:= 1

For nLePrj:=1 To Len(aEscopoPrj)

	If Li > 55
		Cabec( cTitulo, STR0011+cProposta+STR0012+cNumPMS+STR0013+cPMSVersao  , "", cNomeProg, cTamanho, nTipo )	//"Proposta Comercial: "###" Simula��o: "###" - Vers�o: "
		Li ++
		@ Li, 001 PSay Cabec1
		Li ++
	Endif
	
	cQtdCalc := R110CalcQtd( aEscopoPrj[nLePrj,4], aEscopoPrj[nLePrj,10], aEscopoPrj )
	
	If	aEscopoPrj[nLePrj,6] <> "001"
		@ Li, If( Len( AllTrim( aEscopoPrj[nLePrj,4] ) ) > 0, Len( AllTrim( aEscopoPrj[nLePrj,4] ) ) + 5, 01 ) PSay aEscopoPrj[nLePrj,7] + Space(15 - If( Len( AllTrim( aEscopoPrj[nLePrj,4] ) ) > 0, Len( AllTrim( aEscopoPrj[nLePrj,4] ) ) + 5, 01 )) + If( Len( AllTrim( aEscopoPrj[nLePrj,4] ) ) > 0, If( nHorasSN == 1, Space( 5 ) + cQtdCalc + ' horas', '' ), '' )
		Li ++
	Endif 		

Next nLePrj

@ Li, 000 PSay __PrtThinLine()
Li ++

If Li <> 80
   Roda(,,cTamanho)
Endif

If aReturn[5] == 1
   Set Printer TO
   dbCommitAll()
   Ourspool( wnrel )
EndIf

Ms_Flush()

Return( Nil )

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �R110CalcQtd �Autor  �Eduardo Gomes Junior� Data �  27/08/13   ���
���������������������������������������������������������������������������͹��
���Desc.     � Relatorio de pre-escopo                                      ���
���������������������������������������������������������������������������͹��
���Uso       � CRMA290 - WORKAREA / FATA530 - SIMULADOR DE HORAS            ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Function R110CalcQtd(cEDTPos, nQtdPos, aEscopoPrj)

Local aArea 	:= GetArea()
Local nLe		:= 1
Local nLeProx	:= 1
Local nQuant	:= nQtdPos

If	Len( AllTrim(cEDTPos) ) = 2

	nQuant	:= 0	
	nLeProx += 1	

	For nLe:=nLeProx To Len(aEscopoPrj)

		If	Len( AllTrim(aEscopoPrj[nLe,4] ) ) > 2 

			If 	Len(AllTrim( aEscopoPrj[nLe,4] ) ) = 5 .AND. AllTrim( aEscopoPrj[nLe,5] ) == Alltrim( cEDTPos )
				nQuant += aEscopoPrj[nLe,10]
			Endif
			
		Endif 			
	
	Next nLe

EndIf

RestArea(aArea)

Return cValToChar( nQuant )

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �R110VldProp�Autor  �Eduardo Gomes Junior� Data �  13/04/15   ���
��������������������������������������������������������������������������͹��
���Desc.     � Valida proposta informada nos parametros do relatorio	     ���
��������������������������������������������������������������������������͹��
���Uso       � CRMA290 - WORKAREA / FATA530 - SIMULADOR DE HORAS           ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Function R110VldProp()


If	!IsInCallStack("A600SERVICOS")
	
		cNrOrcame 		:= MV_PAR01
	
Else
	
		cNrOrcame 		:= M->AF1_CODORC
	 
Endif 

dbSelectArea("ADZ")
dbSetOrder(1)
If	!dbSeek(xFilial("ADZ")+cNrOrcame)
    MsgAlert(STR0005,STR0004)	//"Proposta informada n�o encontrada!"###"Aten��o"
Else
	If	EMPTY(ADZ->ADZ_PMS)
		MsgAlert(STR0020,STR0004)	//"Proposta comercial informada n�o possui servi�o (simulador de horas) vinculada!"###"Aten��o"
	Else 
		cSimulacao	 := ADZ->ADZ_PMS
		cVersao	 := ADZ->ADZ_PMSVER
	Endif 
Endif

