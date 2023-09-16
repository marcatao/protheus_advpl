#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


User Function tela_old()
 
Private cGCod      := Space(5)
Private cGNome     := Space(20)
Private cGEnde     := Space(30)


//ARRAY DE ARMAZENAMENTO
Private aDados := {}


SetPrvt("oDlg1","osCod","osNome","oSEnd","oGCod","oGNome","oGEnde","oBIncluir","oBtShow","oBtShow1","oBtShow2")

//TELA PRINCIPAL
oDlg1      := MSDialog():New( 094,225,500,800,"Primeiro Crudx",,,.F.,,,,,,.T.,,,.T. )

//RÓTULOS DOS CAMPOS 
osCod      := TSay():New( 012,016,{||"Codigo"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
osNome     := TSay():New( 012,104,{||"Nome"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSEnd      := TSay():New( 012,176,{||"Endereco"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

//GETS PARA RECEPÇÃO DE VALORES
oGCod      := TGet():New( 020,016,{|u| If(PCount()>0,cGCod:=u,cGCod)},oDlg1,30,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGCod",,)
oGNome     := TGet():New( 020,104,{|u| If(PCount()>0,cGNome:=u,cGNome)},oDlg1,70,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGNome",,)
oGEnde     := TGet():New( 020,176,{|u| If(PCount()>0,cGEnde:=u,cGEnde)},oDlg1,100,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGEnde",,)

//BOTÕES DE INTERAÇÃO
oBIncluir  	 := TButton():New( 040,016,"Incluir",oDlg1,{|u| fInclui()},037,012,,,,.T.,,"",,,,.F. )
oBtShow      := TButton():New( 076,016,"Buscar registro",oDlg1,,048,012,,,,.T.,,"",,,,.F. )
oBtShow1     := TButton():New( 100,016,"Mostrar Todos",oDlg1,{|u| fShowAll()},048,012,,,,.T.,,"",,,,.F. )
oBtShow2     := TButton():New( 125,016,"Alterar",oDlg1,{|u| fAltera()},048,012,,,,.T.,,"",,,,.F. )
oBtShow3     := TButton():New( 150,016,"Excluir",oDlg1,{|u| fDeleta()},048,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

 
return    

static function fInclui()
	alert(XFILIAL('SB1'))
 
	DbSelectArea('THI')
	THI->(DbGoBottom())
		RecLock('THI', .T.)
		THI->THI_FILIAL:= '1'
		THI->THI_COD   := cGCod
		THI->THI_IDADE :=2.1
		THI->THI_DESC  :='3'
		THI->THI_USER  :=cUserName

		MsUnlock()
	DBCLOSEAREA(  )

	cGCod := Space(5)
	cGNome  := Space(10)
	cGEnde  := Space(20)

return

static function fShowAll()
	alert('mostrar')
return
