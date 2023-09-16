#INCLUDE 'MATR903.CH'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR903  � Autor � Ricardo Berti         � Data � 22.06.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de produtos com problema na baixa FIFO             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR903()			                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum		                                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MATR903()
Local oReport

oReport := ReportDef()
oReport:PrintDialog()

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Ricardo Berti 		� Data �22.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relatorio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR903                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport 
Local oSection 
Local cCell         
Local oCell         

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//��������������������������������������������������������������������������
oReport := TReport():New("MATR903",STR0001,/*cPerg*/, {|oReport| ReportPrint(oReport)},STR0002+" "+STR0003)//'RELACAO DE PRODUTOS COM PROBLEMAS NA BAIXA"##"O objetivo deste relatorio e exibir detalhadamente todos os produtos com"##"problemas na baixa quando do processamento do custo FIFO.

oSection := TRSection():New(oReport,STR0009,{"TRB"}) //"Produtos"
oSection:SetHeaderPage()

oCell := TRCell():New(oSection,"TRB_COD","TRB",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
oCell:GetFieldInfo("D8_PRODUTO")

oCell := TRCell():New(oSection,"TRB_LOCAL","TRB")
oCell:GetFieldInfo("D8_LOCAL")

oCell := TRCell():New(oSection,"TRB_DESC","TRB")
oCell:GetFieldInfo("B1_DESC")
oCell:SetSize(25)

cCell := Posicione("SX3",2,"D8_QUANT","X3TITULO()")
TRCell():New(oSection,"TRB_QUANT","TRB",cCell,PesqPict("SD8","D8_QUANT"),,,{|| Val(TRB_QUANT) })

oCell := TRCell():New(oSection,"TRB_CF","TRB")
oCell:GetFieldInfo("D8_CF")
oCell := TRCell():New(oSection,"TRB_TM","TRB")
oCell:GetFieldInfo("D8_TM")
oCell := TRCell():New(oSection,"TRB_DOC","TRB")
oCell:GetFieldInfo("D8_DOC")

oCell := TRCell():New(oSection,"TRB_SERIE","TRB")
IF(SerieNfId("SD8",3,"D8_SERIE")=="D8_SERIE")
	If TamSX3( AllTrim("D8_SERIE"))[1] == 14
		oCell:GetFieldInfo("D8_SDOC")
	Else
		oCell:GetFieldInfo("D8_SERIE")
	Endif
Else
	oCell:GetFieldInfo("D8_SDOC")
Endif

oCell := TRCell():New(oSection,"TRB_OP","TRB")
oCell:GetFieldInfo("D8_OP")

cCell := Posicione("SX3",2,"D2_EMISSAO","X3TITULO()")
TRCell():New(oSection,"TRB_DTBASE","TRB",cCell,,8)

Return(oReport)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Ricardo Berti 		� Data �22.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)

Local aCampos	:= {}
Local cArqDif	:= "LOGDIF"+cEmpAnt+cFilAnt+".TXT"
Local cNomTrb	:= ''
Local cNomTrb1	:= ''
Local oTmpTable	:= NIL

//�������������������������������������������������������������������Ŀ
//� Cria arquivo de trabalho para processar pela sequencia.           �
//���������������������������������������������������������������������
AADD(aCampos,{ "TRB_FILIAL"	    ,"C",02,0 } )
AADD(aCampos,{ "TRB_COD"	    ,"C",15,0 } )
AADD(aCampos,{ "TRB_LOCAL"	    ,"C",02,0 } )
AADD(aCampos,{ "TRB_DESC"	    ,"C",25,0 } )
AADD(aCampos,{ "TRB_QUANT"		,"C",16,0 } )
AADD(aCampos,{ "TRB_CF"			,"C",03,0 } )
AADD(aCampos,{ "TRB_TM"			,"C",03,0 } )
AADD(aCampos,{ "TRB_DOC"		,"C",06,0 } )
AADD(aCampos,{ "TRB_SERIE"		,"C",03,0 } )
AADD(aCampos,{ "TRB_OP"			,"C",13,0 } )
AADD(aCampos,{ "TRB_DTBASE"	    ,"C",08,0 } )

oTmpTable := FWTemporaryTable():New( "TRB" )
oTmpTable:SetFields( aCampos )
oTmpTable:AddIndex("indice1", {"TRB_FILIAL","TRB_COD","TRB_LOCAL","TRB_OP","TRB_DTBASE"} )
oTmpTable:Create()

If File(cArqDif)
	Append From (cArqDif) SDF
Endif
dbGoTop()

oReport:Section(1):Print()

//�������������������������������������������������������������������Ŀ
//� Deleta Arquivo de Trabalho (TRB)                                  �
//���������������������������������������������������������������������
oTmpTable:Delete()

Return NIL