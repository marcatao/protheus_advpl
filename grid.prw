#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


User Function grid1() //U_exemplo1()
    Local aaCampos  	:= {"CODIGO"} //Variável contendo o campo editável no Grid
    Local aBotoes	:= {}         //Variável onde será incluido o botão para a legenda
    Private oLista                    //Declarando o objeto do browser
    Private aCabecalho  := {}         //Variavel que montará o aHeader do grid
    Private aColsEx 	:= {}         //Variável que receberá os dados
 
    //Declarando os objetos de cores para usar na coluna de status do grid
    Private oVerde  	:= LoadBitmap( GetResources(), "BR_VERDE")
    Private oAzul  	:= LoadBitmap( GetResources(), "BR_AZUL")
    Private oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO")
    Private oAmarelo	:= LoadBitmap( GetResources(), "BR_AMARELO")


    Private cGCod      := Space(5)  //variavel para construção do campo
    Private cGNome     := Space(20) //variavel para construção do campo
    Private cGEnde     := Space(30) //variavel para construção do campo


 
    DEFINE MSDIALOG oDlg TITLE "Cadastro de Protheuzeuros" FROM 000, 000  TO 300, 700  PIXEL


 

        //chamar a função que cria a estrutura do aHeader
        CriaCabec()
 
        //Monta o browser com inclusão, remoção e atualização
        oLista := MsNewGetDados():New( 350, 078, 415, 775, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabecalho, aColsEx)
 
        //Carregar os itens que irão compor o conteudo do grid
        Carregar()
 
        //Alinho o grid para ocupar todo o meu formulário
        oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
 

        oLista:oBrowse:SetFocus()
 
        //Crio o menu que irá aparece no botão Ações relacionadas
        aadd(aBotoes,{"NG_ICO_LEGENDA", {||Legenda()},"Legenda","Legenda"})
 
        EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,aBotoes)

    
        //RÓTULOS DOS CAMPOS 
        osCod      := TSay():New( 012,016,{||"Nome"},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
        osNome     := TSay():New( 012,104,{||"Idade"},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSEnd      := TSay():New( 012,176,{||"Nivel"},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

        //GETS PARA RECEPÇÃO DE VALORES
        oGCod      := TGet():New( 020,016,{|u| If(PCount()>0,cGCod:=u,cGCod)},oDlg,30,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGCod",,)
        oGNome     := TGet():New( 020,104,{|u| If(PCount()>0,cGNome:=u,cGNome)},oDlg,70,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGNome",,)
        oGEnde     := TGet():New( 020,176,{|u| If(PCount()>0,cGEnde:=u,cGEnde)},oDlg,100,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGEnde",,)

 
    ACTIVATE MSDIALOG oDlg CENTERED
Return


Static Function CriaCabec()
    Aadd(aCabecalho, {;
                  "",;//X3Titulo()
                  "IMAGEM",;  //X3_CAMPO
                  "@BMP",;		//X3_PICTURE
                  3,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  ".F.",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "V",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  "",;			//X3_WHEN
                  "V"})			//
    Aadd(aCabecalho, {;
                  "Nome",;//X3Titulo()
                  "Nome",;  //X3_CAMPO
                  "@!",;		//X3_PICTURE
                  5,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN
    Aadd(aCabecalho, {;
                  "Idade",;//X3Titulo()
                  "IDADE",;  //X3_CAMPO
                  "@!",;		//X3_PICTURE
                  5,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN
    Aadd(aCabecalho, {;
                  "Nivel",;	//X3Titulo()
                  "NIVEL",;  	//X3_CAMPO
                  "@!",;		//X3_PICTURE
                  10,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "SB1",;		//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN
    
 
Return


Static Function Carregar()
    Local aProdutos := {}
 
    aadd(aProdutos,{"000001","UN"})
    aadd(aProdutos,{"000002","UN"})
    aadd(aProdutos,{"000003","PC"})
    aadd(aProdutos,{"000004","MT"})
    aadd(aProdutos,{"000005","PC"})
    aadd(aProdutos,{"000006",""})
    Local i :=1 

    For i := 1 to len(aProdutos) Step 1
 
        if(aProdutos[i,2]=="UN")
            aadd(aColsEx,{oVerde,StrZero(i,2),aProdutos[i,2],aProdutos[i,1],.F.})
        Elseif(aProdutos[i,2]=="PC")
            aadd(aColsEx,{oAzul,StrZero(i,2),aProdutos[i,2],aProdutos[i,1],.F.})
        Elseif(aProdutos[i,2]=="MT")
            aadd(aColsEx,{oVermelho,StrZero(i,2),aProdutos[i,2],aProdutos[i,1],.F.})
        Else
            aadd(aColsEx,{oAmarelo,StrZero(i,2),aProdutos[i,2],aProdutos[i,1],.F.})
        Endif
    Next
 
    //Setar array do aCols do Objeto.
    oLista:SetArray(aColsEx,.T.)
 
    //Atualizo as informações no grid
    oLista:Refresh()
Return



Static function Legenda()
    Local aLegenda := {}
    AADD(aLegenda,{"BR_AMARELO"     ,"   Tipo não definido" })
    AADD(aLegenda,{"BR_AZUL"    	,"   Tipo PC" })
    AADD(aLegenda,{"BR_VERDE"    	,"   Tipo UN" })
    AADD(aLegenda,{"BR_VERMELHO" 	,"   Tipo MT" })
 
    BrwLegenda("Legenda", "Legenda", aLegenda)
Return Nil


