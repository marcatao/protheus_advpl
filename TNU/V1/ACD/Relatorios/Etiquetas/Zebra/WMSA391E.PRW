#Include "Protheus.ch"
#Include "APVT100.CH"

/*/{Protheus.doc} WMSA391E
description
@type function
@version  
@author Deosdete Deo
@since 17/03/2023
@return variant, return_description
/*/
User Function WMSA391E()
Local aItens   := PARAMIXB[1]
//Local nTotVol  := PARAMIXB[2]
Local nQuebr  := If(Len(aItens) < 11,Len(aItens),11)
Local nVolAtu := 1
Local nItens  := 1
Local nlinha  := 0
Local cVolAtu := ""
Local cDesc   := ""
Local lRasLot := (AllTrim(SuperGetMV("MV_RASTRO",.F.,"N")) == "S") .And. SuperGetMV("MV_WMSLOTE",.F.,.F.)
Local cDocAnt := ""
Local aArea   := GetArea()
Local aAreaSC9:= SC9->(GetArea())

While nItens <= Len(aItens) // Trata todos os Itens do Volume
    
    // Dados do Cliente
    SA1->(dbSetOrder(1))
    SA1->(dbSeek(xFilial("SA1")+aItens[nItens][8]+aItens[nItens][9]))
    cNomeCli := AllTrim(SA1->A1_NOME)
    cEnderec := AllTrim(SA1->A1_END)
    cCidade  := AllTrim(SA1->A1_MUN)
    cUf      := AllTrim(SA1->A1_EST)

    //Dados da logistica-embarque
    DbSelectArea("SC9")
    DbSetorder(1) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO+C9_BLEST+C9_BLCRED                                                                                             
    If SC9->(DbSeek(xFilial("SC9")+aItens[nItens,7]))
        cDocaSai := SC9->C9_ENDPAD
    EndIf	

    MSCBINFOETI("STEtiqueta de Volume") 

    cVolAtu := Alltrim(aItens[nItens,3])
    MSCBBEGIN(1,6,70)
    MSCBLineH(00,16,150,3) // Primeira Linha H
    MSCBLineH(59,26,150,3) // Segunda Linha H

    //MSCBLineV - Imprime uma linha vertical (nX1,nY1,nY2,nEspessura,cCor)
    MSCBLineV(63,00,16,3) // Linha um V
    MSCBLineV(50,16,40,3) // Linha dois V
    MSCBLineV(59,16,40,3) // Linha tres V

    //BSay - Imprime uma String (nX,nY,cTexto,cRotação,cFont,cTam,lReverso,lSerial,cIncr,lZerosL,lNoAlltrim)
    MSCBSAY(003,005, NoAcentoCte(SUBSTR(cNomeCli,1,42)),"N","C","1,2",,,,.T.)
    MSCBSAY(003,009, NoAcentoCte(SUBSTR(cEnderec,1,42)),"N","C","1,2",,,,.T.)
    MSCBSAY(003,013, SUBSTR(cCidade +' - '+ cUf ,1,42),"N","C","1,2",,,,.T.)

    MSCBSAY(003,017, "Produto","N","C","1,2",,,,.T.) // Produto
    MSCBSAY(051,017, "Qtde","N","C","1,2",,,,.T.) // Qtde.
    If lRasLot
        MSCBSAY(034,017, "Lote","N","C","1,2",,,,.T.) // Lote
    EndIf

    nl    := 021
    cDocAnt := aItens[nItens,7]

    For nlinha := 1 To nQuebr
        
        cDesc := aItens[nItens,1] //Posicione("SB1",1,xFilial("SB1")+aItens[nItens,1],"B1_DESC") // Descricao

        MSCBSAY(003,nl,SUBSTR(cDesc,1,IIf(lRasLot,20,30)),"N","C","1,2",,,,.T.) // Item
        MSCBSAY(051,nl,Transform(aItens[nItens,2],'@E 99999'),"N","C","1,2",,,,.T.) // Qtde.
        If lRasLot
            MSCBSAY(034,nl, aItens[nItens,4],"N","C","1,2",,,,.T.) // Lote
        EndIf

        nItens++
        nl += 4
        If nItens > Len(aItens) .Or. Alltrim(aItens[nItens,3]) <> cVolAtu
            Exit
        Endif

        If cDocAnt <> aItens[nItens + IIf(nItens == Len(aItens),0,1),7]
            MSCBSAY(065,005, "Pedido","N","C","1,2",,,,.T.) 
            MSCBSAY(065,009, aItens[nItens,7],"N","E","1,2",,,,.T.) 
            //DOCA DE SAIDA
            MSCBSAY(084,005, "Doca","N","C","1,2",,,,.T.) 
            MSCBSAY(084,009, cDocaSai,"N","E","1,2",,,,.T.) 
            
            cDocAnt := aItens[nItens,7]
        EndIf
    
    Next

    If cDocAnt == aItens[nItens - 1,7]
        MSCBSAY(065,005, "Pedido","N","C","1,2",,,,.T.) 
        MSCBSAY(065,009, aItens[nItens - 1,7],"N","E","1,2",,,,.T.) 
        //DOCA DE SAIDA
        MSCBSAY(084,005, "Doca","N","C","1,2",,,,.T.) 
        MSCBSAY(084,009, cDocaSai,"N","E","1,2",,,,.T.) 
    EndIf

    If nItens <= Len(aItens)
        If Alltrim(aItens[nItens,3]) <> cVolAtu
            nVolAtu++
        EndIf
    EndIf

    MSCBSAY(072,017, "Volume","N","F","1,2",,,,.T.)
    cVolAtu := AllTrim(cVolAtu)
    MSCBSAY(077,021, SubStr(cVolAtu,Len(cVolAtu)-2, 3),"N","F","1,2",,,,.T.)
    If Val(cVolAtu) > 0
        MSCBSAYBAR(IIf(Val(cVolAtu)>0,061,055),028, ALLTRIM(cVolAtu),'N','MB07',9,.F.,.F.,,'B',2.3,2,) // Opcao B -> Utilizado no code128/ para aceitar letras e numeros.
    Else
        MSCBSAYBAR(055,028, ALLTRIM(cVolAtu),'N','MB07',9,.F.,.F.,,'B',2.3,2,) // Opcao B -> Utilizado no code128/ para aceitar letras e numeros.
    EndIf

    MSCBSAY(070,039, cVolAtu,"N","F","1,2",,,,.T.)

    MSCBEND()

EndDo

RestArea(aArea)
RestArea(aAreaSC9)

Return
