@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Suspended amount per document agent'
@Metadata.ignorePropagatedAnnotations: true

define view entity /EACM/I_RPDETTMDE_SOSPESO
  as select from /eacm/zprdp as Dp
    inner join /eacm/prdo as Do
      on  Do.vkorg = Dp.vkorg
      and Do.vtweg = Dp.vtweg
      and Do.zclpr = Dp.zclpr
      and Do.vbeln = Dp.vbeln
      and Do.posnr = Dp.posnr
      and Do.zcdaz = Dp.zcdaz
      and Do.zidag = Dp.zidag
    left outer join /eacm/zpr48 as SignRule 
      on SignRule.vbtyp = Do.vbtyp
{
  key Dp.vkorg as Vkorg,
  key Dp.vtweg as Vtweg,
  key Dp.zclpr as Zclpr,
  key Dp.vbeln as Vbeln,
  key Dp.zcdaz as Zcdaz,

      cast(
        sum(
          case
            when SignRule.zsegn = '-1'
              then cast( curr_to_decfloat_amount( Dp.ziprv ) * -1 as abap.dec( 23, 2 ) )
            else cast( curr_to_decfloat_amount( Dp.ziprv ) as abap.dec( 23, 2 ) )
          end
        )
        as abap.dec( 23, 2 ) ) as Sospeso
}
where Dp.zstre <> 'D'
  and Do.zstre <> 'D'
  and Dp.ztpcd = 'S'
group by
  Dp.vkorg,
  Dp.vtweg,
  Dp.zclpr,
  Dp.vbeln,
  Dp.zcdaz
