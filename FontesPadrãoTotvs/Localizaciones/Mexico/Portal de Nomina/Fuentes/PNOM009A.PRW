#INCLUDE "PROTHEUS.CH"
#INCLUDE "PNOM009A.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PNOM009A  �Autor  �GSANTACRUZ          � Data �  08/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �FILTRO PARA LOS PRESTAMOS Y VACACIONES                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PNOM009                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


STATIC _cRegraRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao	 �PNM9MonExp� Autor � GSANTACRUZ       	    � Data � 08/03/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Monta ventana  de Filtro y retorna la expresion montada	  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � Generico 												  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cExpr := PNM9MonExp(cAlias,oWnd)                           ���
���			 � cExpr --> Expressao valida como retorno					  ���
���			 � cAlias--> Alias do Arquivo   Pesquisado, DEFAULT o Alias() ���
���			 � oWnd	--> Janela Pai do Filtro, DEFAULT oMainWindow		  ���
��������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
*/
USER Function PNM9MonExp(cAlias,aMuestra,oWnd,cFilter,cCodProd)

Local cDesc
Local oDlg
Local oBtn
Local oBtnE
Local oBTNou
Local oBTNa
Local oBtnExp
Local oBtnEdt
Local oBtnOp
Local aStrOp
Local cOper
Local oExpr
Local cExpr
Local oCampoDes
Local oCampoOri
Local bBlock
Local oTxtFil
Local oOper
Local oMatch
Local oConf
Local nCont
Local nMatch    := 0
Local lOk       := .t.
Local lConfirma := .f.
Local cTxtFil   := ""
Local cExpFil   := ""
Local cCampoOri := ""
Local cCampoDes := ""
Local aCampo    := {}
Local aCpo      := {}
Local ni:=0

Default cFilter := ""
Default cAlias  := Alias()
Default oWnd    := GetWndDefault()

_cRegraRet := ""

CursorWait()

cTxtFil := Alltrim(&(ReadVar()))

dbSelectArea("SX3")
dbSetorder(2)

for ni:=1 to len(aMuestra)
		if sx3->(dbSeek(aMuestra[ni]))
				AADD(aCampo,{ TRIM(x3titulo()),	 x3_campo, x3_tamanho,x3_tipo,x3_picture})
        endif				
		aadd(aCpo, TRIM(x3titulo()))
next

//Asort(aCpo)
//Asort(aCampo) 
dbSelectArea(cAlias)
cExprfil := Iif(Empty(cFilter),dbFilter(),cFilter)
If !Empty(cExprFil)
	_cRegraRet := cExprFil
	cTxtFil := MontDescr(cAlias,cExprfil)
EndIf

cDesc  := OemToAnsi(STR0001) //"Expresi�n del Filtro"
cCampoOri := aCpo[1] // Apresenta a primeira caracteristica no combo.

DEFINE MSDIALOG oDlg FROM 20,10 TO 200,361 TITLE cDesc PIXEL

Public nLastKey := 0


DEFINE SBUTTON oConf FROM 76, 116 TYPE 1 DISABLE OF oDlg ACTION (If(lOk,lOk := ValidFilter(@cExpFil),nil),If(lOk,lConfirma:=.T.,nil), If(lOk,oDlg:End(),nil))
DEFINE SBUTTON FROM 76, 144 TYPE 2 ENABLE OF oDlg ACTION (nLastKey := 27,oDlg:End())
aStrOp := { OemToAnsi(STR0002),OemToAnsi(STR0003),OemToAnsi(STR0004),OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007)} //"Igual a","Diferente de","Menor que","Menor o igual a","Mayor que","Mayor o igual a"

@ 14,004 COMBOBOX oCampo VAR cCampoOri ITEMS aCpo SIZE 46, 32 OF oDlg PIXEL ON CHANGE BuildGet(oExpr,@cExpr,aCampo,oCampo,oDlg,,oOper:nAt)

cExpr := CalcField(oCampo:nAt,aCampo)
cOper := aStrOp[1]

@ 14,054 COMBOBOX oOper VAR cOper ITEMS aStrOp SIZE 42, 32 OF oDlg PIXEL ON CHANGE BuildGet(oExpr,@cExpr,aCampo,oCampo,oDlg,,oOper:nAt)

@ 14,100 GET oExpr VAR cExpr SIZE 73, 9 OF oDlg PIXEL PICTURE AllTrim(aCampo[oCampo:nAt,5]) FONT oDlg:oFont

@ 06,004 SAY OemToAnsi(STR0008) SIZE  39,7 OF oDlg PIXEL //"Caracteristicas:"
@ 06,054 SAY OemToAnsi(STR0009)      SIZE  39,7 OF oDlg PIXEL //"Operadores:"
@ 06,100 SAY OemToAnsi(STR0010)  		SIZE 53,7 OF oDlg PIXEL //"Expresion:"
@ 46,005 SAY OemToAnsi(STR0011)     		SIZE 53,7 OF oDlg PIXEL //"Regla:"

@ 31,004 BUTTON oBtnA PROMPT OemToAnsi(STR0012)       SIZE 33,12 OF oDlg PIXEL ACTION (oConf:SetEnable(.t.),cTxtFil := BuildTxt(cTxtFil,Trim(cCampoOri),cOper,cExpr,.t.,@cExpFil,aCampo,oCampo:nAt,oOper:nAt),cExpr := CalcField(oCampo:nAt,aCampo),BuildGet(oExpr,@cExpr,aCampo,oCampo,oDlg,,oOper:nAt),oTxtFil:Refresh(),oBtnE:Enable(),oBtnOp:Disable(),oBtnOu:Enable(),oBtne:Refresh(),oBtnOu:Refresh(),oBtna:Disable(),oBtna:Refresh())  // "&Agrega"

oBtnA:oFont := oDlg:oFont

@ 31,039 BUTTON oBtn 	 PROMPT OemToAnsi(STR0013) SIZE 33,12 OF oDlg PIXEL ACTION (oConf:SetEnable(.t.),cTxtFil := "",cExpFil := "",nMatch := 0,oTxtFil:Refresh(),oBtnA:Enable(),oBtnA:Refresh(),oBtnE:Disable(),oBtnOU:Disable(),oMatch:Disable(),oBtnOp:Enable(),oConf:Refresh()) ; oBtn:oFont := oDlg:oFont   // "&Limpia filtro"
//@ 31,074 BUTTON oBtnEdt  PROMPT "Editar"       SIZE 33,12 OF oDlg PIXEL ACTION ( If(oTxtFil:lReadOnly,oTxtFil:lReadOnly := .f.,oTxtFil:lReadOnly := .t.),oTxtFil:Refresh(),oConf:SetEnable(.t.)) //"Editar"

@ 53,005 GET oTxtFil VAR cTxtFil						   SIZE 167, 20 OF oDlg PIXEL MEMO COLOR CLR_BLACK READONLY

oTxtFil:bRClicked := {||AlwaysTrue()}

@ 25,150 BUTTON oBtnOp PROMPT "("  SIZE 10,12 OF oDlg PIXEL ACTION (If(nMatch==0,oMatch:Enable(),nil),nMatch++,cTxtFil+= " ( ",cExpFil+="(",oTxtFil:Refresh()) ; oBtnOp:oFont := oDlg:oFont
@ 25,163 BUTTON oMatch PROMPT ")"  SIZE 10,12 OF oDlg PIXEL ACTION (nMatch--,cTxtFil+= " ) ",cExpFil+=")",If(nMatch==0,oMatch:Disable(),nil),oTxtFil:Refresh()) ; oMatch:oFont := oDlg:oFont
@ 38,150 BUTTON oBtne  PROMPT OemToAnsi(STR0014)  SIZE 10,12 OF oDlg PIXEL ACTION (cTxtFil+=" and ",cExpFil += " and ",oTxtFil:Refresh(),oBtne:Disable(),oBtnou:Disable(),oBtnA:Enable(),oBtne:Refresh(),oBtnou:Refresh(),oBtnA:Enable(),oBtnA:Refresh(),oBtnOp:Enable()) ; oBtne:oFont := oDlg:oFont  // "y"
@ 38,163 BUTTON oBtnOu PROMPT OemToAnsi(STR0015) SIZE 10,12 OF oDlg PIXEL ACTION (cTxtFil+=" or ",cExpFil += " or ",oTxtFil:Refresh(),oBtne:Disable(),oBtnou:Disable(),oBtnA:Enable(),oBtne:Refresh(),oBtnou:Refresh(),oBtnA:Enable(),oBtna:Refresh(),oBtnOp:Enable()) ; oBtnou:oFont := oDlg:oFont // "o"

oMatch:Disable()
oBtnE:Disable()
oBtnOu:Disable()

If !Empty(cTxtFil) // Quando ja esta com o filtro preenchido assumir foi adicionado uma nova condicao
	oConf:SetEnable(.t.)
	oBtnE:Enable()
	oBtnOp:Disable()
	oBtnOu:Enable()
	oBtne:Refresh()
	oBtnOu:Refresh()
	oBtna:Enable()
	oBtna:Refresh()
endif
ACTIVATE MSDIALOG oDlg CENTERED

If lConfirma

	If cExpFil <> Nil
		_cRegraRet := cExpFil
	   //	cCampo	 := Padr(cTxtFil,30) 	
	Endif

Else
	nLastKey := 27
Endif

Return _cRegraRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BuildGet  �Autor  �Marcelo Iuspa       � Data �  18/09/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta expressao a ser usada nas regras e condicoes          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATPNM9                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BuildGet(oExpr,cExpr,aCampo,oCampo,oDlg,lFirst,nOpr)

Local cPicture := AllTrim(aCampo[oCampo:nAt,5])
Local aOper    := { "=","<>","<","<=",">",">=","$","!x"}

cExpr := CalcField(oCampo:nAt,aCampo)
DEFAULT lFirst := .t.

If Empty(cPicture)
	If aCampo[oCampo:nAT,4] == "N"
		cPicture := "@E "+Replicate("9",aCampo[oCampo:nAT,3])
		If aCampo[oCampo:nAT,8] > 0
			//cPicture := Subs(cPicture,1,Len(cPicture)-(aCampo[oCampo:nAt,8]+1))
			cPicture := Subs(cPicture,1,Len(cPicture))			
			cPicture += "."+Replicate("9",aCampo[oCampo:nAT,3])
		EndIf
	ElseIf aCampo[oCampo:nAT,4] == "C"
		cPicture := "@K"
	EndIf

EndIf

If aCampo[oCampo:nAt,4] == "D"
	cPicture := "@D"
EndIf

If nOpr != Nil
	If aOper[nOpr] $ "$|!x.."
		cExpr := Space(60)
		cPicture := "@S23"
	EndIf
EndIf
oExpr:oGet:Picture := cPicture
oExpr:oGet:Pos := 0

SetFocus(oExpr:hWnd)
oExpr:oGet:Assign()
oExpr:Refresh()
// Executando a segunda vez para for�ar a Picture do GET.
If lFirst
	BuildGet(oExpr,cExpr,aCampo,oCampo,oDlg,.f.,nOpr)
EndIf
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcField �Autor  �Marcelo Iuspa       � Data �  18/09/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o campo informado vazio                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATPNM9                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CalcField(nAt,aCampo)
Local cRet

If aCampo[nAt,4] == "C"
	cRet := Space(aCampo[nAt,3])
ElseIf aCampo[nAt,4] == "N"
	cRet := 0
ElseIf aCampo[nAt,4] == "D"
	cRet := CTOD("  /  /  ")
EndIf
Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BuildTxt  �Autor  �Marcelo Iuspa       � Data �  18/09/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta a expressao de condicao                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATPNM9                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BuildTxt(cTxtFil,cCampo,cOper,xExpr,lAnd,cExpFil,aCampo,nCpo,nOper)

Local cChar := CHR(39)
Local cType := ValType(xExpr)
Local aOper := { "=","<>","<","<=",">",">="}
//Local aOper := { "==","<>","<","<=",">",">=","$","!x"}
Local cTxtFilNew := cCampo+" "+cOper+" "+If(cType=="C",cChar,"")+cValToChar(xExpr)+If(cType=="C",cChar,"")
Local cExpFilNew := ""

              
			If (aOper[nOper]=="=")
				cExpFilNew += " " + aCampo[nCpo,2] +" "+aOper[nOper]+" "       
				IF CTYPE=="D"                                       
					cExpFilNew += "'" + DTOS(ctod(AllTrim(cValToChar(xExpr))))+"' "
				ELSE
					cExpFilNew += "'"+AllTrim(cValToChar(xExpr))+"'"
				ENDIF	                
				VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
			Else

				IF CTYPE=="D"                                                       

					cExpFilNew += " "+aCampo[nCpo,2] +" " +aOper[nOper]+ " "
					cExpFilNew += "'"+ DTOS(ctod(AllTrim(cValToChar(xExpr))))+"' "
				ELSE
					cExpFilNew += " "+aCampo[nCpo,2] + " " +aOper[nOper]+ " "
					cExpFilNew += "'"+AllTrim(cValToChar(xExpr))+"'"
				ENDIF	
				VldLenFilter( @cExpFil, @cTxtFil, cExpFilNew, cTxtFilNew )
			EndIf



Return cTxtFil



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldLenFilter�Autor  �Marcelo Iuspa     � Data �  18/09/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida o tamanho da expressao de condicao                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATPNM9                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VldLenFilter( cExpFil, cTxtFil, cExpr, cTxtExpr )
Local cExpSave := If( cExpFil==Nil, '', cExpFil )
Local cTxtSave := If( cTxtFil==Nil, '', cTxtFil )

If cExpFil  != Nil
	cExpFil += cExpr
	If cTxtExpr != Nil
		cTxtFil += cTxtExpr //cExpr
	EndIf
	If Len(cExpFil) > 600
		msgAlert(OemToAnsi(STR0016))//"La expresi�n es muy larga"
		cExpFil := cExpSave
		cTxtFil := cTxtSave
	EndIf
EndIf
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidFilter �Autor  �Marcelo Iuspa     � Data �  18/09/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao que valida o Filtro pelo botao OK.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATPNM9                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidFilter(cExpr)
Local lRet  := .t.
Local aArea := GetArea()                

cExpr:=(alltrim(cExpr))
if substr(cExpr,len(cExpr)-2,2)=='or' 
	cExpr:=	substr(cExpr,1,RAT("or", substr(cExpr,1,len(cExpr)-1))-1)
else
	if  substr(cExpr,len(cExpr)-3,3)== 'and'
		cExpr:=	substr(cExpr,1,RAT("and", substr(cExpr,1,len(cExpr)-1))-1)
	endif
endif

RestArea(aArea)
Return lRet
