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









//Buscar os Endere�os e unitizadores disponeiveis//

Static Function SalvaForm(oModel)

Local lRet := .T.
   if(oModel:GetValue('FORMZZ8','ZZ8_QUANT') > oModel:GetValue('FORMZZ8','ZZ8_SALDO') )
      lRet := .F.
      Alert("Saldo insuficiente")  
   endif 
   
   if(lRet)
     FWFormCommit(oModel)
   end

   alert('TESTE')
Return lRet

Static Function Salvou(oModel)
 
Return .T.

















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
