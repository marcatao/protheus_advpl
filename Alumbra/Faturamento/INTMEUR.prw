//Bibliotecas
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} INTMEUR
Função genérica de cadastro para Modelo 1 em MVC
@author Carlos Henrique de Oliveira
@since 08/09/2017
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_INTMEUR()
    @obs Não se pode executar função MVC dentro do fórmulas
/*/
User Function INTMEUR(cTab, aLeg, cOpc)      

    //Cria o objeto de apresentação do browse
    Local oBrowse

    //Guarda a área atual
    Local aArea     := GetArea()

    //Guarda função de chamada anterior
    Local cFunBkp   := FunName()

    //Declara a variável para o título
    Local cTitulo   := "Integração Protheus  e Mercanet"

    //Declara a variável para o FOR
    Local nLeg

    //Declara a variável cTabela como private para manter seu valor durante toda execução da rotina
    Private cTabela := "ZZQ"

    //Declara o vetor aLegenda como private para manter seu valor durante toda execução da rotina
    Private aLegenda:= {}

    //Declara a variável cTabela como private para manter seu valor durante toda execução da rotina
    Private cOpcoes := ""

    //Define a variável cTab com um valor Default
    Default cTab    := "ZZQ"

    //Define o vetor aLeg com um valor Default
    Default aLeg    := {}

    //Define o vetor aLeg com um valor Default
    Default cOpc    := ""

    //Atribui valor a variável cTabela
    cTabela := cTab

    //Atribui valor ao vetor aLegenda
    aLegenda:= aLeg

    //Atribui valor a variável cOpcoes
    cOpcoes := cOpc

    //Seta a função atual
    SetFunName("INTMEUR")

    //Cria a tabela utilizada no processo
    ChkFile(cTabela)

    //Força posicionamento na tabela no arquivo SX2
    //PosSx2(cTabela)

    //Define o título da tabela baseado no arquivo SX2
    cTitulo:= Capital(FwSX2Util():GetX2Name(cTabela, .T.))

    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse:= FWMBrowse():New()

    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias(cTabela)

    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)

    //Legendas
    If Len(aLeg) > 0
        For nLeg:= 1 To Len(aLeg)
            //Vetor aLeg: aAdd(aLeg{Regra_Legenda,Cor_Legenda,Texto_Legenda})
            oBrowse:AddLegend( aLeg[nLeg,1], aLeg[nLeg,2], aLeg[nLeg,3] )
            //Adicionando as Legendas
        Next nLeg
    else
        oBrowse:AddLegend( "ZZQ->ZZQ_STATUS == 'PRO'", "GREEN",   "Sincronizado" )
        oBrowse:AddLegend( "ZZQ->ZZQ_STATUS == 'INS'", "YELLOW",  "Aguardando" )
        oBrowse:AddLegend( "ZZQ->ZZQ_STATUS == 'ERR'", "RED",     "Erro na Importação" )
    EndIf
   
    //Ativa a Browse
    oBrowse:Activate()

    //Seta a função de chamada anterior
    SetFunName(cFunBkp)

    RestArea(aArea)

Return Nil

/*---------------------------------------------------------------------*
| Func:  MenuDef                                                      |
| Autor: Carlos Henrique de Oliveira                                  |
| Data:  08/09/2017                                                   |
| Desc:  Criação do menu MVC                                          |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/
Static Function MenuDef()

Local aRot := {}

 
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.INTMEUR' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 2
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.INTMEUR' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.INTMEUR' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.INTMEUR' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Copiar'     ACTION 'VIEWDEF.INTMEUR' OPERATION 9                      ACCESS 0 //OPERATION 9
    ADD OPTION aRot TITLE 'sincronizar'ACTION 'u_INTMER01'      OPERATION 8                      ACCESS 0
    ADD OPTION aRot TITLE 'Reprocessar'ACTION 'u_reproped'      OPERATION 8                      ACCESS 0
 
Return aRot

/*---------------------------------------------------------------------*
| Func:  ModelDef                                                     |
| Autor: Carlos Henrique de Oliveira                                  |
| Data:  08/09/2017                                                   |
| Desc:  Criação do modelo de dados MVC                               |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/
Static Function ModelDef()

    //Cria o objeto do modelo de dados
    Local oModel := Nil

    //Cria a estrutura de dados utilizada na interface
    Local oStru  := FWFormStruct(1, cTabela)

    //Declara a variável para o verificação de índice único
    Local lIndUnq:= .F.

    //Declara a variável para o receber a chave primária caso a tabela não tenha índice único
    Local aPrmKey:= {}

    //Declara a variável para o título
    Local cTitulo:= ""

    //Declara o Array para verificar se existe índice único para a tabela
    Local aX2Unico := FwSX2Util():GetSX2data(cTabela, {"X2_UNICO"})

    //Verifica se existe índice único para o a tabela
    lIndUnq:= IIF(!Vazio(aX2Unico[1][2]),.T.,.F.)

    //Define o título da tela com base no SX2
    cTitulo:= Capital(FwSX2Util():GetX2Name(cTabela, .T.))

    //Instancia o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("Gen"+cTabela,/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/)

    //Atribui formulários para o modelo
    oModel:AddFields("FORM"+cTabela,/*cOwner*/,oStru)

    If !lIndUnq
       
        //Determina a PrimaryKey da entidade Modelo
        aPrmKey:= PrmKeyDef(cTabela)
       
        //Seta a chave primária da rotina
        oModel:SetPrimaryKey(aPrmKey)
       
    EndIf

    //Adiciona a descrição ao modelo
    oModel:SetDescription(cTitulo)

    //Seta a descrição do formulário
    oModel:GetModel("FORM"+cTabela):SetDescription(cTitulo)

Return oModel

/*---------------------------------------------------------------------*
| Func:  ViewDef                                                      |
| Autor: Carlos Henrique de Oliveira                                  |
| Data:  08/09/2017                                                   |
| Desc:  Criação da visão MVC                                         |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/
Static Function ViewDef()

    //Cria o objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("INTMEUR")

    //Cria a estrutura de dados utilizada na interface do cadastro de Autor
    Local oStru := FWFormStruct(2, cTabela)

    //Cria o objeto oView como nulo
    Local oView := Nil

    //Declaração de variável para o título
    Local cTitulo := " "

    //Força posicionamento na tabela no arquivo SX2
    //PosSx2(cTabela)

    //Define o título da tela com base no SX2
    //cTitulo:= Capital(AllTrim(FwSX2Util():GetSX2data(cTabela, {"X2_NOME"})))
    cTitulo:= Capital(FwSX2Util():GetX2Name(cTabela, .T.))

    //Cria a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)

    

    //Atribui formulários para interface
    oView:AddField("VIEW_"+cTabela, oStru, "FORM"+cTabela)

    //Cria um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)

    //Adiciona o título do formulário
    oView:EnableTitleView("VIEW_"+cTabela, cTitulo)

    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})

    //Aloca o formulário da interface dentro do container
    oView:SetOwnerView("VIEW_"+cTabela,"TELA")

Return oView

/*---------------------------------------------------------------------*
| Func:  PrmKeyDef                                                    |
| Autor: Carlos Henrique de Oliveira                                  |
| Data:  08/09/2017                                                   |
| Desc:  Função para determinar a PrimaryKey da entidade Modelo       |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/
Static Function PrmKeyDef(cTab)


    //Declara o vetor para o receber a chave primária da tabela
    Local aPrmKey := {}

    //Declara a variável para o FOR
    Local nInd

    //Seta a variável com os campo(s) para composição do índice da tabela
    aRet := FWSIXUtil():GetAliasIndexes(cTab)

    If Len(aRet) > 0

        For nInd:= 1 To Len(aRet[1])
           
            //Adiciona as informações em uma única linha do array
            aAdd(aPrmKey,aRet[1][nInd])
           
        Next nInd

    EndIf

Return aPrmKey


user function reproped()

    IF (ZZQ->ZZQ_STATUS='PRO')
        alert('O pedido não pode ser reprocessado')
    ELSE
        dbSelectArea("ZZQ")
    	ZZQ->(dbSetOrder(1)) //FILIAL + PED MERC
        dbSeek(ZZQ->ZZQ_FILIAL+ZZQ->ZZQ_PEDMER)
        IF FOUND()
             RECLOCK("ZZQ", .F.)
                ZZQ->ZZQ_STATUS := 'INS'
              MSUNLOCK()     // Destrava o registro
        ENDIF
    ENDIF
return
