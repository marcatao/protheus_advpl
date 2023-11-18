#INCLUDE "PROTHEUS.CH"

user function PESOVOL 

  local cPedido := cValToChar(StrZero(000341,6))
  local aPRet  := {0,0}
  local aVlret  := {0,0}


  Local aArea   := GetArea()
    dbSelectArea("SC5")
    dbSetOrder(1) 
    dbSeek(xFilial('SC5')+cPedido)
    IF FOUND() // Avalia o retorno da pesquisa realizada
      aPRet := PesoTotal(cPedido)
      aVlret := QtdVol(cPedido)

          RECLOCK("SC5", .F.)
            SC5->C5_PESOL :=aPRet[2] //peso liquido
            SC5->C5_PBRUTO:=aPRet[1] + aVlret[2] //somando peso dos produtos com as embalagens
            SC5->C5_VOLUME1:=aVlret[1] // quantidade de volumes
            SC5->C5_ESPECI1:="Caixa"
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
local aVlret  := {0,0}

cQuery      := " Select 
cQuery      += " count(1) as VOLUMES, SUM(CB3.CB3_PESO) as PESO
cQuery      += " FROM "+RetSqlName("DCU")+" DCU
cQuery      += " INNER JOIN "+RetSqlName("CB3")+" CB3 on DCU.DCU_XCODEM = CB3.CB3_CODEMB
cQuery      += " WHERE DCU.DCU_PEDIDO ='"+cPedido+"' "
cQuery      += " AND DCU.D_E_L_E_T_ = ' ' "

    cQuery := ChangeQuery(cQuery)
    cAliasQry := GetNextAlias()
    DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasQry,.F.,.T.)
    If (cAliasQry)->(!Eof())
        aVlret[1] := (cAliasQry)->VOLUMES
        aVlret[2] := (cAliasQry)->PESO
    EndIf
	(cAliasQry)->(dbCloseArea())


return aVlret

