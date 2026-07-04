@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Last active agent for maturande'
@Metadata.ignorePropagatedAnnotations: true

define view entity /EACM/I_RPMAT_AGENT_ACTIVE
  as select from /eacm/zpraa
{
  key zcdaz       as Zcdaz,
      max( erdat ) as Erdat
} 
where zstre <> 'A'
  and erdat <= $session.system_date
group by zcdaz
