#INCLUDE "MATR959.CH"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �Matr959   � Autor � Mary C. Hergert       � Data �09/05/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relacao de Excecoes de Fiscais                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function Matr959()

Local cReport   := "MATR959"    //Nome do Programa
Local cAlias    := "SF7"        //Alias da tabela
Local cTitle	:= STR0001		//Exce��es Fiscais
Local cDesc     := STR0002     	//Este relat�rio apresenta uma rela��o das Exce��es Fiscais cadastradas.
Local lInd		:= .T.			//Retorna Indice SIX

If cPaisLoc == "BRA"
	cAlias    := "SF7"
Else
	cAlias    := "SFF"
Endif

MPReport(cReport,cAlias,cTitle,cDesc,,lInd)

Return
