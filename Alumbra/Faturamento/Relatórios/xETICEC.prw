#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'TOPCONN.ch'

//----------------------------------------------------------------------------------------------------------------------
/* {Protheus.doc} ETIQUETA PEDIDOS C&C
RELATORIO - ETIQUETA PEDIDOS C&C
@author    BRUNO NASCIMENTO GONï¿½ALVES
@since     25/09/2023
@version   12/superior
*/
//----------------------------------------------------------------------------------------------------------------------

USER FUNCTION xETICEC()

    LOCAL aPergs := {}
    LOCAL aResps := {}

    AADD(aPergs, {1, "NUMERO DA NOTA FISCAL", SPACE(TAMSX3("F2_DOC")[1]),,,"SF2",,100, .F.})

        IF PARAMBOX(aPergs, "Parametros do relatorio", @aResps,,,,,,,, .T., .T.)
            IMPETIQ(aResps)
        ENDIF    

RETURN

STATIC FUNCTION IMPETIQ(aResps)

	LOCAL cQuery	:= ""
    LOCAL cQuery1	:= ""
	LOCAL nNf       := aResps[1]
	LOCAL cPorta    := "LPT1"
    LOCAL cModelo   := "ZEBRA"
	LOCAL cEtiqueta := ""
    LOCAL nI        := ""
    LOCAL nV        := 0

	cQuery := " SELECT D.[A1_NOME], B.[C9_NFISCAL], A.[DCV_CODVOL], C.[B1_DESC], C.[B1_CODBAR], A.[DCV_QUANT], A.[DCV_PEDIDO] " + CRLF
    cQuery += " FROM " + RETSQLNAME("DCV") + " A " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SC9") + " B " + CRLF
    cQuery += " ON A.[DCV_FILIAL] = B.[C9_FILIAL] " + CRLF
    cQuery += " AND A.[DCV_PEDIDO] = B.[C9_PEDIDO] " + CRLF
    cQuery += " AND A.[DCV_ITEM] = B.[C9_ITEM] " + CRLF
    cQuery += " AND A.[DCV_SEQUEN] = B.[C9_SEQUEN] " + CRLF
    cQuery += " AND  B.[D_E_L_E_T_] = ' ' " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SB1") + " C " + CRLF
    cQuery += " ON A.[DCV_CODPRO] = C.[B1_COD] " + CRLF
    cQuery += " LEFT JOIN " + RETSQLNAME("SA1") + " D " + CRLF
    cQuery += " ON B.[C9_CLIENTE] = D.[A1_COD] " + CRLF
    cQuery += " WHERE A.[D_E_L_E_T_] = ' ' AND B.[C9_NFISCAL] = '"+ nNf +"'" + CRLF
    cQuery += " ORDER BY A.[DCV_CODVOL] "

    cQuery := CHANGEQUERY(cQuery)
    cAlias := GETNEXTALIAS()
    DBUSEAREA(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.F.,.T.)

    cQuery1 := " SELECT COUNT(*) AS TOTAL " + CRLF
    cQuery1 += " FROM " + CRLF
    cQuery1 += " (SELECT A.[DCV_CODVOL] FROM " + RETSQLNAME("DCV") + " A " + CRLF
    cQuery1 += " WHERE A.[D_E_L_E_T_] = ' ' AND A.[DCV_PEDIDO] = '"+ (cAlias)->DCV_PEDIDO +"'" + CRLF
    cQuery1 += " GROUP BY A.[DCV_CODVOL]) AS B" 
    cAlias1 := MPSYSOPENQUERY(cQuery1)

    WHILE (cAlias)->(!Eof())
        IF(nI <> ALLTRIM((cAlias)->DCV_CODVOL))
            nI := ALLTRIM((cAlias)->DCV_CODVOL)
            nV += 1
        ENDIF

        MSCBPRINTER(cModelo,cPorta,,10,.F.,,,,,,.F.,)
        MSCBCHKSTATUS(.F.)
        MSCBBEGIN(1,6)
        cEtiqueta := "^XA " + CRLF
        cEtiqueta += "^FX NUMERO DA NOTA " + CRLF
        cEtiqueta += "^CF0,80 " + CRLF
        cEtiqueta += "^FO20,40^FDNF: "+ ALLTRIM((cAlias)->C9_NFISCAL) +"^FS " + CRLF
        cEtiqueta += "^FX CLIENTE, FORNECEDOR E PRODUTO " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO10,220^FD CLIENTE: "+ ALLTRIM((cAlias)->A1_NOME) +"^FS " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO10,250^FD FORNECEDOR: ALUMBRA PRODUTOS ELETRICOS^FS " + CRLF
        cEtiqueta += "^CFA,30 " + CRLF
        cEtiqueta += "^FO10,280^FD PRODUTO: "+ ALLTRIM((cAlias)->B1_DESC) +"^FS " + CRLF
        cEtiqueta += "^FX QUANTIDADE DE PEÇAS " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO10,370^FD QTDE: "+ STRZERO((cAlias)->DCV_QUANT, 4) +"^FS " + CRLF
        cEtiqueta += "^FX VOLUME " + CRLF
        cEtiqueta += "^CF0,60 " + CRLF
        cEtiqueta += "^FO400,350^FD VOLUME:^FS " + CRLF
        cEtiqueta += "^FO450,400^FD"+ STRZERO(nV,3) +" / "+ STRZERO((cAlias1)->TOTAL,3)+"^FS " + CRLF
        cEtiqueta += "^FX CODIGO DE BARRA. " + CRLF
        cEtiqueta += "^BY3,1,80 " + CRLF
        cEtiqueta += "^FO250,450^BC^FD"+ ALLTRIM((cAlias)->B1_CODBAR) +"^FS " + CRLF
        cEtiqueta += "^XZ "
        MSCBWRITE(cEtiqueta)
        MSCBEND()
        MSCBCLOSEPRINTER()

        (cAlias)->(DBSKIP())
    ENDDO

    (cAlias)->(DBCLOSEAREA())

RETURN

    

