#INCLUDE "PROTHEUS.CH"

user function PESOVOL(cPedido) 

  //local cPedido := cValToChar(StrZero(000341,6))
  local aPRet  := {0,0}
  local aVlret  := {0,0}
  local Stret  := 0

  Local aArea   := GetArea()
    dbSelectArea("SC5")
    dbSetOrder(1) 
    dbSeek(xFilial('SC5')+cPedido)
    IF FOUND() // Avalia o retorno da pesquisa realizada
      aPRet  := PesoTotal(cPedido)
      aVlret := QtdVol(cPedido)
      Stret  := xstex(cPedido)
          RECLOCK("SC5", .F.)

          IF(Stret==0)//AX=AG.IMPRESSAO;AL=IMPRESSO;EX=EM_EXPEDICAO;AF=AG_FATURAMENTO;AT=AT_LOGISTICA
            SC5->C5_XSTEX := "AT"
          ELSE
            SC5->C5_XSTEX := "EX"
          END
            SC5->C5_PESOL :=aPRet[2] //peso liquido
            SC5->C5_PBRUTO:=aPRet[1] + aVlret[2] //somando peso dos produtos com as embalagens
            SC5->C5_VOLUME1:=aVlret[1] // quantidade de volumes
            SC5->C5_ESPECI1:="Caixa"
            SC5->C5_ESPECI4:=cValToChar(aVlret[3])
          MSUNLOCK()     // Destrava o registro
        
    ENDIF
    RestArea(aArea)

return  

static function PesoTotal(cPedido)

Local cQuery     := ""
local aPRet  := {0,0}

cQuery      := " select " 
cQuery      += " SUM(SC6.C6_QTDENT * SB1.B1_PESBRU) as PESOBRUTO_TOT, " 
cQuery      += " SUM(SC6.C6_QTDENT * SB1.B1_PESO) as PESOLIQ_TOT "
cQuery      += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery      += " INNER JOIN "+RetSqlName("SB1")+" SB1 on SC6.C6_PRODUTO = SB1.B1_COD "
cQuery      += " where C6_FILIAL=  '"+xFilial("SC6")+"'  and C6_NUM = '"+cPedido+"' "
cQuery      += " AND SC6.D_E_L_E_T_ = ' ' "

    cQuery := ChangeQuery(cQuery)
    cAliasQry := GetNextAlias()
    DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasQry,.F.,.T.)
    If (cAliasQry)->(!Eof())
        aPRet[1] := (cAliasQry)->PESOBRUTO_TOT
        aPRet[2] := (cAliasQry)->PESOLIQ_TOT
    EndIf
	(cAliasQry)->(dbCloseArea())
return aPRet

//-------------------------------------------------------

static function QtdVol(cPedido)
Local cQuery     := ""
local aVlret  := {0,0,0}

cQuery      := " Select "
cQuery      += " count(1) as VOLUMES, SUM(CB3.CB3_PESO) as PESO , SUM(DCU.DCU_XCUBAG) as CUBAGEM "
cQuery      += " FROM "+RetSqlName("DCU")+" DCU "
cQuery      += " INNER JOIN "+RetSqlName("CB3")+" CB3 on DCU.DCU_XCODEM = CB3.CB3_CODEMB "
cQuery      += " WHERE DCU.DCU_PEDIDO ='"+cPedido+"' "
cQuery      += " AND DCU.D_E_L_E_T_ = ' ' "

    cQuery := ChangeQuery(cQuery)
    cAliasQry := GetNextAlias()
         


    DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasQry,.F.,.T.)
    If (cAliasQry)->(!Eof())
        aVlret[1] := (cAliasQry)->VOLUMES
        aVlret[2] := (cAliasQry)->PESO
        aVlret[3] := (cAliasQry)->CUBAGEM
    EndIf
	(cAliasQry)->(dbCloseArea())
return aVlret

static function xstex(cPedido)
Local cQuery     := ""
local Stret  := 0

cQuery      := " Select "
cQuery      += " SUM(C6.C6_QTDVEN) - SUM(DCT.DCT_QTEMBA) SALDO "
cQuery      += " from "+RetSqlName("SC6")+" C6 "
cQuery      += " INNER JOIN "+RetSqlName("DCT")+" DCT "
cQuery      += " ON C6_FILIAL = DCT_FILIAL AND C6_NUM = DCT_PEDIDO and C6.C6_PRODUTO = DCT_CODPRO "
cQuery      += " where C6.C6_NUM = '"+cPedido+"' "
cQuery      += " AND DCT.D_E_L_E_T_ = ' ' AND C6.D_E_L_E_T_ = ' ' "

    cQuery := ChangeQuery(cQuery)
    cAliasQry := GetNextAlias()
    DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasQry,.F.,.T.)
    If (cAliasQry)->(!Eof())
        Stret  := (cAliasQry)->SALDO
    EndIf
	(cAliasQry)->(dbCloseArea())
return Stret


