fn_short_org_names <- function(df, code_column){
names_lookup <- data.frame(
  org_code = c(
    #bob
    'QU9','RXQ','RTH','RHW','RNU',
    #Frimley
    'QNQ','RDU','RWX',
    #HIOW
    'QRL','RN5','R1F','RHU','RHM','RW1','R1C','RYE',
    #KM
    'QKS','RN7','RVV','RPA','RWF','RYY','RXY',
    #Surrey
    'QXU','RTK','RA2','RTP','RXX','RPC',
    #Sussex
    'QNX','RYR','RXC','RX2','RYD'),
  org_short_name = c(
    #bob
    'BOB ICS','BHT','OUH','RBH','OHealth',
    #frimley
    'Frimley ICS','Frimley','Berks Health',
    #HIOW
    'HIOW ICS','HHFT','IOW','PHU','UHS','SHealth','Solent','SCAS',
    #KM 
    'KM ICS','DGT','EKH','MFT','MTW','KCH','KM SCP',
    #Surrey
    'Surrey ICS','ASP','RSCH','SASH','SBorders','SsxP',
    #Sussex
    'Sussex ICS','ESH','QVH','UHSX','SECAMB'))

df <- left_join(df,
                names_lookup,
                by = setNames('org_code',code_column))

return(df)

}