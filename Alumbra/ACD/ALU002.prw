//Bibliotecas
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} ALU002
Fun��o gen�rica de cadastro para Modelo 1 em MVC
@author Thiago Marcato
@since 16/09/2023
@version 1.0
    @return Nil, Fun��o n�o tem retorno
    @example
    u_ALU002()
    @obs N�o se pode executar fun��o MVC dentro do f�rmulas
/*/
User Function ALU002(cTab, aLeg, cOpc)      

    //Cria o objeto de apresenta��o do browse
    Local oBrowse

    //Guarda a �rea atual
    Local aArea     := GetArea()

    //Guarda fun��o de chamada anterior
    Local cFunBkp   := FunName()

    //Declara a vari�vel para o t�tulo
    Local cTitulo   := "Separa��o por Demanda"

    //Declara a vari�vel para o FOR
    Local nLeg

    //Declara a vari�vel cTabela como private para manter seu valor durante toda execu��o da rotina
    Private cTabela := "ZZ8"


    //Declara o vetor aLegenda como private para manter seu valor durante toda execu��o da rotina
    Private aLegenda:= {}

    //Declara a vari�vel cTabela como private para manter seu valor durante toda execu��o da rotina
    Private cOpcoes := ""

    //Define a vari�vel cTab com um valor Default
    Default cTab    := "ZZ8"


    //Define o vetor aLeg com um valor Default
    Default aLeg    := {}

    //Define o vetor aLeg com um valor Default
    Default cOpc    := ""

    //Atribui valor a vari�vel cTabela
    cTabela := cTab

    //Atribui valor ao vetor aLegenda
    aLegenda:= aLeg

    //Atribui valor a vari�vel cOpcoes
    cOpcoes := cOpc

    //Seta a fun��o atual
    SetFunName("ALU002")

    //Cria a tabela utilizada no processo
     
    ChkFile(cTabela)


    //For�a posicionamento na tabela no arquivo SX2
    //PosSx2(cTabela)

    //Define o t�tulo da tabela baseado no arquivo SX2
    cTitulo:= Capital(FwSX2Util():GetX2Name(cTabela, .T.))

    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse:= FWMBrowse():New()

    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias(cTabela)

    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)

    //Legendas
    If Len(aLeg) > 0
        For nLeg:= 1 To Len(aLeg)
            //Vetor aLeg: aAdd(aLeg{Regra_Legenda,Cor_Legenda,Texto_Legenda})
            oBrowse:AddLegend( aLeg[nLeg,1], aLeg[nLeg,2], aLeg[nLeg,3] )
            //Adicionando as Legendas
        Next nLeg
    else
        oBrowse:AddLegend( "Empty(ZZ8->ZZ8_ERRO)", "GREEN", "Disponivel para atendimento" )
        oBrowse:AddLegend( "!Empty(ZZ8->ZZ8_ERRO)", "RED",   "Ocorreram erros" )

    EndIf
   
    //Ativa a Browse
    oBrowse:Activate()

    //Seta a fun��o de chamada anterior
    SetFunName(cFunBkp)

    RestArea(aArea)

Return Nil

/*---------------------------------------------------------------------*
| Func:  MenuDef                                                      |
| Autor: Thiago Marcato                                  |
| Data:  16/09/2023                                                   |
| Desc:  Cria��o do menu MVC                                          |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/
Static Function MenuDef()

Local aRot := {}

 
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ALU002' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 2
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.ALU002' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ALU002' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ALU002' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Copiar'     ACTION 'VIEWDEF.ALU002' OPERATION 9                      ACCESS 0 //OPERATION 9
 
Return aRot

/*---------------------------------------------------------------------*

| Func:  ModelDef                                                     |
| Autor: Thiago Marcato                                  |
| Data:  16/09/2023                                                   |
| Desc:  Cria��o do modelo de dados MVC                               |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/
Static Function ModelDef()

    //Cria o objeto do modelo de dados
    Local oModel := Nil

    //Cria a estrutura de dados utilizada na interface
    Local oStru   := FWFormStruct(1, cTabela)

    //Declara a vari�vel para o verifica��o de �ndice �nico
    Local lIndUnq:= .F.

    //Declara a vari�vel para o receber a chave prim�ria caso a tabela n�o tenha �ndice �nico
    Local aPrmKey:= {}

    //Declara a vari�vel para o t�tulo
    Local cTitulo:= ""

    //Declara o Array para verificar se existe �ndice �nico para a tabela
    Local aX2Unico := FwSX2Util():GetSX2data(cTabela, {"X2_UNICO"})

    //LOCAL aVinc := {}

    //Verifica se existe �ndice �nico para o a tabela
    lIndUnq:= IIF(!Vazio(aX2Unico[1][2]),.T.,.F.)

    //Define o t�tulo da tela com base no SX2
    cTitulo:= Capital(FwSX2Util():GetX2Name(cTabela, .T.))

    //Instancia o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("Gen"+cTabela,{ |oModel|AlteraCampo(oModel)}, { |oModel|SalvaForm(oModel)}, { |oModel|Salvou(oModel)},/*bCancel*/)

    //Atribui formul�rios para o modelo
    oModel:AddFields("FORM"+cTabela,/*cOwner*/,oStru)

    If !lIndUnq
       
        //Determina a PrimaryKey da entidade Modelo
        aPrmKey:= PrmKeyDef(cTabela)
       
        //Seta a chave prim�ria da rotina
        oModel:SetPrimaryKey(aPrmKey)
       
    EndIf


    //Adiciona a descri��o ao modelo
    oModel:SetDescription(cTitulo)

    //Seta a descri��o do formul�rio
    oModel:GetModel("FORM"+cTabela):SetDescription(cTitulo)

Return oModel

/*---------------------------------------------------------------------*
| Func:  ViewDef                                                      |
| Autor: Thiago Marcato                                  |
| Data:  16/09/2023                                                   |
| Desc:  Cria��o da vis�o MVC                                         |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/
Static Function ViewDef()

    //Cria o objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("ALU002")

    //Cria a estrutura de dados utilizada na interface do cadastro de Autor
    Local oStru   := FWFormStruct(2, cTabela)


    //Cria o objeto oView como nulo
    Local oView := Nil

    //Declara��o de vari�vel para o t�tulo
    Local cTitulo := " "

    //For�a posicionamento na tabela no arquivo SX2
    //PosSx2(cTabela)

    //Define o t�tulo da tela com base no SX2
    //cTitulo:= Capital(AllTrim(FwSX2Util():GetSX2data(cTabela, {"X2_NOME"})))
    cTitulo:= Capital(FwSX2Util():GetX2Name(cTabela, .T.))

    //Cria a view que ser� o retorno da fun��o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)

    

    //Atribui formul�rios para interface
    oView:AddField("VIEW_"+cTabela, oStru, "FORM"+cTabela)
  

    //Cria um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)

    //Adiciona o t�tulo do formul�rio
    oView:EnableTitleView("VIEW_"+cTabela, cTitulo)

    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})

    //Aloca o formul�rio da interface dentro do container
    oView:SetOwnerView("VIEW_"+cTabela,"TELA")

Return oView

/*---------------------------------------------------------------------*
| Func:  PrmKeyDef                                                    |
| Autor: Thiago Marcato                                  |
| Data:  16/09/2023                                                   |
| Desc:  Fun��o para determinar a PrimaryKey da entidade Modelo       |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/
Static Function PrmKeyDef(cTab)


    //Declara o vetor para o receber a chave prim�ria da tabela
    Local aPrmKey := {}

    //Declara a vari�vel para o FOR
    Local nInd

    //Seta a vari�vel com os campo(s) para composi��o do �ndice da tabela
    aRet := FWSIXUtil():GetAliasIndexes(cTab)

    If Len(aRet) > 0

        For nInd:= 1 To Len(aRet[1])
           
            //Adiciona as informa��es em uma �nica linha do array
            aAdd(aPrmKey,aRet[1][nInd])
           
        Next nInd

    EndIf

Return aPrmKey

Static Function AlteraCampo(oModel)
   
Return.T.



//finalizacao
Static Function Salvou(oModel)
 
Return .T.




//Buscar os Endere�os e unitizadores disponeiveis//

Static Function SalvaForm(oModel)

Local lRet   := .T.
Local cQuery := ""
Local nQtdT  := 0
Local aPorEnd := {}
Local nI 
Local aArea   := GetArea()
Local nRec := 0


   if(oModel:GetValue('FORMZZ8','ZZ8_QUANT') > oModel:GetValue('FORMZZ8','ZZ8_SALDO') )
      lRet := .F.
      Alert("Saldo insuficiente")  
   endif 
   
   if(lRet)
     if(FWFormCommit(oModel))
     nRec := ZZ8->(Recno())
            ////////SEPARANDO POR ENDERECO
                         nQtdT  := ZZ8->ZZ8_QUANT

                            cQuery:= " select D14.D14_ENDER as ENDERECO, sum((D14.D14_QTDEST - D14.D14_QTDSPR)) as SALDO , D14.D14_PRIOR "
                            cQuery+= " from "+RetSqlName('D14')+"  as D14 "
                            cQuery+= " join "+RetSqlName('DC8')+"  as DC8 "
                            cQuery+= "      on D14.D14_ESTFIS = DC8.DC8_CODEST and DC8.DC8_TPESTR not in (7,8,5) "
                            cQuery+= " where D14.D14_PRODUT = '"+ZZ8->ZZ8_CODPRO+"'  "
                            cQuery+= "       and D14.D14_FILIAL = '010101' " 
                            cQuery+= "       and D14.D14_LOCAL='"+ZZ8->ZZ8_LOCAL+"' "
                            cQuery+= "       and D14.D_E_L_E_T_ = '' and  DC8.D_E_L_E_T_ = '' "
                            cQuery+= "       and (D14.D14_QTDEST - D14.D14_QTDSPR) > 0 "
                            cQuery+= " group by D14.D14_PRIOR,D14.D14_ENDER "
                            cQuery+= " order by D14.D14_PRIOR, D14.D14_ENDER asc "
                            cQuery := ChangeQuery(cQuery)
                            cAliasQry := GetNextAlias()
                            DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasQry,.F.,.T.)

                            Do while (cAliasQry)->(!Eof() )
                                //distribuindo nos endere�os
                                if((cAliasQry)->SALDO < nQtdT) 
                                   AAdd( aPorEnd, {(cAliasQry)->ENDERECO,   (cAliasQry)->SALDO} )
                                   nQtdT-=(cAliasQry)->SALDO
                                else
                                   AAdd( aPorEnd, {(cAliasQry)->ENDERECO,   nQtdT} ) 
                                   nQtdT:=0 
                                endif
                               (cAliasQry)->(DbSkip())
                            Enddo
	                        (cAliasQry)->(dbCloseArea())
            //trocando registros
                  
            BeginTran()
               
                //DisarmTransaction()
                For nI := 1 to len(aPorEnd)
                if(aPorEnd[nI][2] > 0)
                 aArea   := GetArea()  
                    RecLock("ZZ8",.T.)
                     ZZ8->ZZ8_CODPRO:= M->ZZ8_CODPRO
                     ZZ8->ZZ8_QUANT := aPorEnd[nI][2]
                     ZZ8->ZZ8_SERVIC:= M->ZZ8_SERVIC
                     ZZ8->ZZ8_LOCAL := M->ZZ8_LOCAL
                     ZZ8->ZZ8_ENDER := aPorEnd[nI][1]
                     ZZ8->ZZ8_UNITIZ:= M->ZZ8_UNITIZ
                     ZZ8->ZZ8_LOCDES:= M->ZZ8_LOCDES
                     ZZ8->ZZ8_ENDDES:= M->ZZ8_ENDDES
                     ZZ8->ZZ8_RECORI := nRec
                     ZZ8->ZZ8_RESP:= alltrim(UsrRetName(RetCodUsr()))
                    ZZ8->(MsUnlock())
	                ZZ8->(DbSkip(1)) 
                    RestArea(aArea)	
                ENDIF   
                Next 
                

                aArea   := GetArea()		
                //deletando o registro original
    	        dbSelectArea('ZZ8')
		           ZZ8->( dbGoTo( nRec ) )
            	   ZZ8->(RecLock("ZZ8",.F.))
				   ZZ8->(DbDelete())
			       ZZ8->(MsUnLock())
	            RestArea(aArea)	
		   
            EndTran()

            ///FIM SEPARACAO POR ENDERECO
     endif


   endif
    
   
Return lRet

















static Function zVid0045(aDados)
    Local aArea     := FWGetArea()
    Local cTabela   := "ZZ8"
  
    Local cTudoOk   := ""
    Local cTransact := ""
    Local nRetorno  := 0
    Private lMsErroAuto := .F.
  
                //Local aDados    := {}

                //aDados    := {}
                //aAdd(aDados, {"ZZ8_CODPRO", M->ZZ8_CODPRO,     Nil})
                //aAdd(aDados, {"ZZ8_QUANT", aPorEnd[nI][2],     Nil})
                ///aAdd(aDados, {"ZZ8_SERVIC", M->ZZ8_SERVIC,     Nil})
                //aAdd(aDados, {"ZZ8_LOCAL", M->ZZ8_LOCAL,       Nil})
                //aAdd(aDados, {"ZZ8_ENDER", aPorEnd[nI][1],     Nil})
                //aAdd(aDados, {"ZZ8_UNITIZ", M->ZZ8_UNITIZ,     Nil})
                //aAdd(aDados, {"ZZ8_LOCDES", M->ZZ8_LOCDES,     Nil})
                //aAdd(aDados, {"ZZ8_ENDDES", M->ZZ8_ENDDES,     Nil})
                //zVid0045(aDados)

    //Inicializa a transa��o

        //Joga a tabela para a mem�ria (M->)
        RegToMemory(;
            cTabela,; // cAlias - Alias da Tabela
            .T.,;     // lInc   - Define se � uma opera��o de inclus�o ou atualiza��o
            .F.;      // lDic   - Define se ir� inicilizar os campos conforme o dicion�rio
        )
  
        //Se conseguir fazer a execu��o autom�tica
        If EnchAuto(;
            cTabela,; // cAlias  - Alias da Tabela
            aDados,;  // aField  - Array com os campos e valores
            cTudoOk,; // uTUDOOK - Valida��o do bot�o confirmar
            3;        // nOPC    - Opera��o do Menu (3=inclus�o, 4=altera��o, 5=exclus�o)
        )
  
            //Aciona a efetiva��o da grava��o
            nRetorno := AxIncluiAuto(;
                cTabela,;   // cAlias     - Alias da Tabela
                ,;          // cTudoOk    - Opera��o do TudoOk (se usado no EnchAuto n�o precisa usar aqui)
                cTransact,; // cTransact  - Opera��o acionada ap�s a grava��o mas dentro da transa��o
                3;          // nOpcaoAuto - Opera��o do Menu (3=inclus�o, 4=altera��o, 5=exclus�o)
            )
  
        Else
            DisarmTransaction()
            return .F.
        EndIf

  
    FWRestArea(aArea)
Return








//VErifica estoque do produto antes da soliciata��o//////
user function ALU003(cProd,cLocal)
Local lRet := 0
Local cQuery := ""
                cQuery := "select sum((D14.D14_QTDEST - D14.D14_QTDSPR)) as SALDO " 
                cQuery +=  "from "+RetSqlName('D14')+" D14 "
                cQuery +=  "join "+RetSqlName('DC8')+" DC8 " 
                cQuery +=  "on D14.D14_ESTFIS = DC8.DC8_CODEST and DC8.DC8_TPESTR not in (7,8,5) "
                cQuery +=  "where D14.D14_PRODUT = '"+cProd+"' " 
                cQuery +=  "and D14.D14_FILIAL = '"+xFilial("D14")+"' "
                cQuery +=  "and D14.D14_LOCAL='"+cLocal+"' "
                cQuery +=  "and D14.D_E_L_E_T_ = '' and  DC8.D_E_L_E_T_ = '' "
                cQuery +=  "and (D14.D14_QTDEST - D14.D14_QTDSPR) > 0 "
				cQuery := ChangeQuery(cQuery)


    cAliasQry := GetNextAlias()
    DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasQry,.F.,.T.)
    If (cAliasQry)->(!Eof())
       lRet := (cAliasQry)->SALDO
    EndIf
	(cAliasQry)->(dbCloseArea())


return lRet
