#INCLUDE "PROTHEUS.CH"

User Function MA410COR()

Local aCores := {}
//AX=AG.IMPRESSAO;AL=IMPRESSO;EX=EM_EXPEDICAO;AF=AG_FATURAMENTO
    aAdd(aCores,{"(C5_XSTEX == 'AX' .And. Empty(C5_NOTA)) .OR. (Empty(C5_XSTEX) .And. Empty(C5_NOTA))",  "BR_VERDE",    "Aguardando Expedicao"})  
    aAdd(aCores,{"C5_XSTEX == 'AL'  .And. Empty(C5_NOTA)",                                               "BR_AMARELO",  "Pedido Impresso Pela expedição"}) 
    aAdd(aCores,{"C5_XSTEX == 'EX'  .And. Empty(C5_NOTA)",                                               "BR_MARROM",   "Em expedição"})
    aAdd(aCores,{"C5_XSTEX == 'AT'  .And. Empty(C5_NOTA)",                                               "BR_AZUL",     "Aguardando Logistica"}) 
    aAdd(aCores,{"C5_XSTEX == 'AF'  .And. Empty(C5_NOTA)",                                               "BR_PINK",     "Aguardando Faturamento"})
    aAdd(aCores,{"!Empty(C5_NOTA)"                       ,                                               "BR_VERMELHO", "Faturado"})  
return( aCores )
 
User Function MA410LEG()
Local aLegNew := ParamIXB
    AADD( aLegNew, {"BR_VERDE","Aguardando Expedicao"} )
    AADD( aLegNew, {"BR_AMARELO","Pedido Impresso Pela expedição"} )
    AADD( aLegNew, {"BR_MARROM","Em expedição"} )
    AADD( aLegNew, {"BR_AZUL","Aguardando Logistica"} ) 
    AADD( aLegNew, {"BR_PINK","Aguardando Faturamento"} )
    AADD( aLegNew, {"BR_VERMELHO","Faturado"} )
Return( aLegNew )

User Function MA440COR()
Local aCores := {}
//AX=AG.IMPRESSAO;AL=IMPRESSO;EX=EM_EXPEDICAO;AF=AG_FATURAMENTO
    aAdd(aCores,{"(C5_XSTEX == 'AX' .And. Empty(C5_NOTA)) .OR. (Empty(C5_XSTEX) .And. Empty(C5_NOTA))",  "BR_VERDE",    "Aguardando Expedicao"})  
    aAdd(aCores,{"C5_XSTEX == 'AL'  .And. Empty(C5_NOTA)",                                               "BR_AMARELO",  "Pedido Impresso Pela expedição"}) 
    aAdd(aCores,{"C5_XSTEX == 'EX'  .And. Empty(C5_NOTA)",                                               "BR_MARROM",   "Em expedição"})
    aAdd(aCores,{"C5_XSTEX == 'AT'  .And. Empty(C5_NOTA)",                                               "BR_AZUL",     "Aguardando Logistica"}) 
    aAdd(aCores,{"C5_XSTEX == 'AF'  .And. Empty(C5_NOTA)",                                               "BR_PINK",     "Aguardando Faturamento"})
    aAdd(aCores,{"!Empty(C5_NOTA)"                       ,                                               "BR_VERMELHO", "Faturado"})  
return( aCores )
 
User Function MA440LEG()
Local aLegNew := ParamIXB
    AADD( aLegNew, {"BR_VERDE","Aguardando Expedicao"} )
    AADD( aLegNew, {"BR_AMARELO","Pedido Impresso Pela expedição"} )
    AADD( aLegNew, {"BR_MARROM","Em expedição"} ) 
    AADD( aLegNew, {"BR_AZUL","Aguardando Logistica"} )
    AADD( aLegNew, {"BR_PINK","Aguardando Faturamento"} )
    AADD( aLegNew, {"BR_VERMELHO","Faturado"} )
Return( aLegNew )
