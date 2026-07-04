@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '/EACM/I_RPDETTMDE - Dett.provv.maturande'
@Metadata.ignorePropagatedAnnotations: true

define root view entity /EACM/I_RPDETTMDE
  as select from /eacm/prdo as Prdo

    left outer join /EACM/I_RPMAT_AGENT_ACTIVE as AgentActive
      on AgentActive.Zcdaz = Prdo.zcdaz

    left outer join /eacm/zpraa as Agent
      on Agent.zcdaz = AgentActive.Zcdaz
     and Agent.erdat = AgentActive.Erdat
     and Agent.zstre <> 'A'
     and Agent.zstre <> 'S'

    left outer join /eacm/zpr02 as AgentType
      on AgentType.ztpag = Agent.ztpag

    left outer join /eacm/zpr48 as SignRule
      on SignRule.vbtyp = Prdo.vbtyp

    left outer join /EACM/I_RPDETTMDE_SOSPESO as Susp
      on  Susp.Vkorg = Prdo.vkorg
      and Susp.Vtweg = Prdo.vtweg
      and Susp.Zclpr = Prdo.zclpr
      and Susp.Vbeln = Prdo.vbeln
      and Susp.Zcdaz = Prdo.zcdaz
{
  key Prdo.vkorg             as Vkorg,
  key Prdo.vtweg             as Vtweg,
  key Prdo.zclpr             as Zclpr,
  key Prdo.vbeln             as Vbeln,
  key Prdo.posnr             as Posnr,
  key Prdo.zcdaz             as Zcdaz, 
  key Prdo.zidag             as Zidag,

      Prdo.bukrs             as Bukrs,
      
      Agent.name1            as Namea,
      Agent.ztpag            as Ztpag,
      AgentType.zdeag        as Zdeag,
      Prdo.vkgrp             as Vkgrp,
      Prdo.vkbur             as Vkbur,
      Prdo.waerk             as Waerk,
      Prdo.zwaer             as Zzwaer,
      Prdo.kunrg             as Kunrg,     
      Prdo.fkart             as Fkart,
      Prdo.vbtyp             as Vbtyp,
      Prdo.fkdat             as Fkdat,
      Prdo.belnr             as Belnr,
      Prdo.bldat             as Bldat,
      Prdo.budat             as Budat,
      Prdo.blart             as Blart,
      Prdo.matnr             as Matnr,
      Prdo.maktx             as MaktxDoc,
      Prdo.zutmx             as Zutmx,
      Prdo.zstre             as Zstre,
      Prdo.zpcpr             as Zpcpr,
      Prdo.zdest             as Zdest,
      Prdo.zhistor           as Zhistor,
      Prdo.zabin             as Zabin,
      Prdo.kostl             as Kostl,
      Prdo.ztprv             as Ztprv,
      Prdo.kurrf             as Kurrf,

      case when SignRule.zsegn = '-1' then -1 else 1 end as SignMultiplier,
      @Semantics.amount.currencyCode: 'Waerk'
      cast( case
        when SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.zimpp ) * -1
        else curr_to_decfloat_amount( Prdo.zimpp )
      end as abap.dec( 23, 2 ) ) as Zimpp,
      @Semantics.amount.currencyCode: 'Waerk'
      cast( case
        when SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.zimco ) * -1
        else curr_to_decfloat_amount( Prdo.zimco )
      end as abap.dec( 23, 2 ) ) as Zimco,
      @Semantics.amount.currencyCode: 'Waerk'
      cast( case
        when SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.zimmg ) * -1
        else curr_to_decfloat_amount( Prdo.zimmg )
      end as abap.dec( 23, 2 ) ) as Zimmg,
      @Semantics.amount.currencyCode: 'Waerk'
      cast( case
        when SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.ziman ) * -1
        else curr_to_decfloat_amount( Prdo.ziman )
      end as abap.dec( 23, 2 ) ) as Ziman,
      @Semantics.amount.currencyCode: 'Waerk'
      cast( case
        when Prdo.ziman <> 0 and SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.ziman ) * -1
        when Prdo.ziman <> 0
          then curr_to_decfloat_amount( Prdo.ziman )
        when SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.zimco ) * -1
        else curr_to_decfloat_amount( Prdo.zimco )
      end as abap.dec( 23, 2 ) ) as ImpProvv,
      @Semantics.amount.currencyCode: 'Waerk'
      cast( case
        when Prdo.ziman <> 0 and Prdo.zstre = 'C' and SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.ziman ) * -1
        when Prdo.ziman <> 0 and Prdo.zstre = 'C'
          then curr_to_decfloat_amount( Prdo.ziman )
        when Prdo.ziman <> 0
          then 0
        when SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.zimmg ) * -1
        else curr_to_decfloat_amount( Prdo.zimmg )
      end as abap.dec( 23, 2 ) ) as ImpMatur,
      @Semantics.amount.currencyCode: 'Waerk'
      cast( case
        when Prdo.ziman <> 0 and Prdo.zstre = 'C'
          then 0
        when Prdo.ziman <> 0 and SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.ziman ) * -1
        when Prdo.ziman <> 0
          then curr_to_decfloat_amount( Prdo.ziman )
        when SignRule.zsegn = '-1'
          then ( curr_to_decfloat_amount( Prdo.zimco ) - curr_to_decfloat_amount( Prdo.zimmg ) ) * -1
        else curr_to_decfloat_amount( Prdo.zimco ) - curr_to_decfloat_amount( Prdo.zimmg )
      end as abap.dec( 23, 2 ) ) as ImpDaMat,

      cast( Prdo.zimpu as abap.dec( 23, 2 ) ) as Zimpu,

      cast( Prdo.koein as abap.dec( 23, 2 ) ) as Koein,

      @Semantics.amount.currencyCode: 'Waerk'
      cast( case
        when SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.zimii ) * -1
        else curr_to_decfloat_amount( Prdo.zimii )
      end as abap.dec( 23, 2 ) ) as Zimii,

      @Semantics.amount.currencyCode: 'Waerk'
      cast( case
        when SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.zimiidd ) * -1
        else curr_to_decfloat_amount( Prdo.zimiidd )
      end as abap.dec( 23, 2 ) ) as Zimiidd,

      @Semantics.amount.currencyCode: 'Waerk'
      cast( case
        when SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.zimpe ) * -1
        else curr_to_decfloat_amount( Prdo.zimpe )
      end as abap.dec( 23, 2 ) ) as Zimpe,

      @Semantics.amount.currencyCode: 'Waerk'
      cast( case
        when SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.zimst ) * -1
        else curr_to_decfloat_amount( Prdo.zimst )
      end as abap.dec( 23, 2 ) ) as Zimst,

      @Semantics.amount.currencyCode: 'Waerk'
      cast( case
        when SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.zlord ) * -1
        else curr_to_decfloat_amount( Prdo.zlord )
      end as abap.dec( 23, 2 ) ) as Zlord,

      @Semantics.amount.currencyCode: 'Zzwaer'
      cast( case
        when SignRule.zsegn = '-1'
          then curr_to_decfloat_amount( Prdo.zimlr ) * -1
        else curr_to_decfloat_amount( Prdo.zimlr )
      end as abap.dec( 23, 2 ) ) as Zimlr,

      @Semantics.amount.currencyCode: 'Waerk'
      Susp.Sospeso as Sospeso
}
where AgentActive.Zcdaz is not null
  and Prdo.zstre <> 'D'
  and Prdo.zstre <> 'C'
  and Prdo.zstre <> 'M'
