--Servi�o
SELECT * FROM [ALUMBRAHML].[CMT8F4_145046_PR_DV].[dbo].[DCF010] where DCF_DATA ='20240125'
 
SELECT * FROM [ALUMBRAHML].[CMT8F4_145046_PR_DV].[dbo].[D12010] where D12_DTGERA='20240125'

SELECT * FROM [ALUMBRAHML].[CMT8F4_145046_PR_DV].[dbo].[SB1010] where B1_cod = '0030631         '
SELECT * FROM [ALUMBRAHML].[CMT8F4_145046_PR_DV].[dbo].[SB5010] where B5_cod = '0030631         '
0990300         

SELECT *  
-- delete
FROM [ALUMBRAHML].[CMT8F4_145046_PR_DV].[dbo].[ZZ8ZZ8010]
where R_E_C_N_O_ ='13'


update [ALUMBRAHML].[CMT8F4_145046_PR_DV].[dbo].[ZZ8ZZ8010]
set d_e_l_e_t_=''
where R_E_C_N_O_ ='3'
 
 
SELECT * FROM [ALUMBRAHML].[CMT8F4_145046_PR_DV].[dbo].[SX3010] where X3_ARQUIVO='ZZ8'

 


 
select  (D14.D14_QTDEST - D14.D14_QTDSPR) as SALDO,
D14.*, DC8.DC8_TPESTR 
from [ALUMBRAHML].[CMT8F4_145046_PR_DV].[dbo].[D14010] as D14
join [ALUMBRAHML].[CMT8F4_145046_PR_DV].[dbo].[DC8010] as DC8 
on D14.D14_ESTFIS = DC8.DC8_CODEST and DC8.DC8_TPESTR  in (7,8,5)
where D14.D14_PRODUT = '0030631' and D14.D14_LOCAL='004'
and D14.D_E_L_E_T_ = '' and  DC8.D_E_L_E_T_ = ''
and (D14.D14_QTDEST - D14.D14_QTDSPR) > 0
order by D14.D14_PRIOR, D14.D14_ENDER asc


 select D14.D14_ENDER, sum((D14.D14_QTDEST - D14.D14_QTDSPR)) as SALDO , D14.D14_PRIOR
 from [ALUMBRAHML].[CMT8F4_145046_PR_DV].[dbo].[D14010] as D14 
 join [ALUMBRAHML].[CMT8F4_145046_PR_DV].[dbo].[DC8010] as DC8 
      on D14.D14_ESTFIS = DC8.DC8_CODEST and DC8.DC8_TPESTR not in (7,8,5) 
 where D14.D14_PRODUT = '0970110'  
       and D14.D14_FILIAL = '010101' 
       and D14.D14_LOCAL='005' and D14.D_E_L_E_T_ = '' and  DC8.D_E_L_E_T_ = '' 
       --and (D14.D14_QTDEST - D14.D14_QTDSPR) > 0 
 group by D14.D14_PRIOR,D14.D14_ENDER
 order by D14.D14_PRIOR, D14.D14_ENDER asc


 select *
 from [ALUMBRAHML].[CMT8F4_145046_PR_DV].[dbo].[D14010] as D14 
 where     D14.D14_PRODUT = '0030631'  
       and D14.D14_FILIAL = '010101' 
       and D14.D14_LOCAL  ='004' 
	   and D14.D_E_L_E_T_ = ''  
       and (D14.D14_QTDEST - D14.D14_QTDSPR) > 0 
	   and D14.D14_ENDER = '3A01P113'
	   and D14.D14_IDUNIT in ('000000000100','000000000101')


select len('Administrador                                                                   ')
 Administrador                                                                   