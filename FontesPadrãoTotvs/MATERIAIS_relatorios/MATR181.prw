#INCLUDE "PROTHEUS.CH"
#INCLUDE "MATR181.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �MATR181   � Autor �Andressa Fagundes      � Data �08.05.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impress�o do Complemento de Produto                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
    
Function MATR181()
    Local cReport	:= "MATR181"	//Nome do Programa
    Local cAlias	:= "SB5"		//Alias da tabela
    Local cTitle	:= STR0001		//Titulo do relat�rio apresentado no cabe�alho
    Local cDesc		:= STR0002		//Descri��o do relat�rio
    Local lInd		:= .T.			// Retorna Indice SIX
    MPReport(cReport,cAlias,cTitle,cDesc,,lInd)
Return
