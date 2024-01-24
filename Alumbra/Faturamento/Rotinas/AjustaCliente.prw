#INCLUDE "PROTHEUS.CH"

User Function AtvCli() 
    Local aArea    := GetArea()
    

     conout( 'TESTE  Textooooooo Textooooooo Textooooooo  Textooooooo Textooooooo Textooooooo  Textooooooo Textooooooo Textooooooo  Textooooooo Textooooooo Textooooooo  Textooooooo Textooooooo Textooooooo  Textooooooo Textooooooo Textooooooo  Textooooooo Textooooooo Textooooooo  Textooooooo Textooooooo Textooooooo  Textooooooo Textooooooo Textooooooo ' ) // Resultado: "C:\Windows\system32;C:\Windows;..."
      conout( 'Ola mundo'  ) // Resultado: "C:\Windows\system32;C:\Windows;..."
       conout( GetEnv('PATH') ) // Resultado: "C:\Windows\system32;C:\Windows;..."
        conout( GetEnv('PATH') ) // Resultado: "C:\Windows\system32;C:\Windows;..."


    Default cTexto := " Textooooooo Textooooooo Textooooooo Textooooooo Textooooooo Textooooooo Textooooooo Textooooooo Textooooooov"
    FWLogMsg(;
        "INFO",;    //cSeverity      - Informe a severidade da mensagem de log. As opções possíveis são: INFO, WARN, ERROR, FATAL, DEBUG
        ,;          //cTransactionId - Informe o Id de identificação da transação para operações correlatas. Informe "LAST" para o sistema assumir o mesmo id anterior
        "ZCONOUT",; //cGroup         - Informe o Id do agrupador de mensagem de Log
        ,;          //cCategory      - Informe o Id da categoria da mensagem
        ,;          //cStep          - Informe o Id do passo da mensagem
        ,;          //cMsgId         - Informe o Id do código da mensagem
        cTexto,;    //cMessage       - Informe a mensagem de log. Limitada à 10K
        ,;          //nMensure       - Informe a uma unidade de medida da mensagem
        ,;          //nElapseTime    - Informe o tempo decorrido da transação
        ;           //aMessage       - Informe a mensagem de log em formato de Array - Ex: { {"Chave" ,"Valor"} }
    ) 
     
    RestArea(aArea)
Return
 


static function AtvClix(cA1Cod,cA1Loja)

   Local aTables := {"SA1"}
    Local aArea   := GetArea()
    RpcSetType( 3 )
    //seta o ambiente com a empresa 99 filial 01 com os direitos do usuário administrador, módulo CTB
    lRet := RpcSetEnv( "01","01", "Administrador",, "FAT",, aTables, , , ,  )
   

    dbSelectArea("SA1")
    dbSetOrder(1) // A1_FILIAL + A1_COD + A1_LOJA
    dbSeek(xFilial('SA1')+cA1Cod+cA1Loja)
   
    IF FOUND() // Avalia o retorno da pesquisa realizada
        IF(SA1->A1_MSBLQL = '1') 
          RECLOCK("SA1", .F.)
            SA1->A1_MSBLQL := '2'
          MSUNLOCK()     // Destrava o registro
        ENDIF
    ENDIF
    RestArea(aArea)
 RpcClearEnv() 
return
