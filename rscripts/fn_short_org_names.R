fn_short_org_names <- function(df, code_column){
names_lookup <- data.frame(
  org_code = c(
    #bob
    'RHW','RTH','RXQ','RNU',
    #Frimley
    'RDU','RWX',
    #HIOW
    'R1F','RHM','RHU','RN5','R1C','RW1','RYE',
    #KM
    'RN7','RPA','RVV','RWF','RYY','RXY',
    #Surrey
    'RA2','RTK','RTP','RXX',
    #Sussex
    'RPC','RXC','RYR','RX2','RYD',
    #ICS codes
    'QU9','QNQ','QRL','QKS','QXU','QNX'),
  org_short_name = c(
    #bob
    'RBH','OUH','BHT','OHealth',
    #frimley
    'Frimley','Berks Health',
    #HIOW
    'IOW','UHS','PHU','HHFT','Solent','SHealth','SCAS',
    #KM 
    'DGT','MFT','EKH','MTW','KCH','KM SCP',
    #Surrey
    'RSCH','ASP','SASH','SBorders','SsxP',
    #Sussex
    'QVH','ESH','UHSX','SECAMB',
    #ICS names
    'BOB ICS','Frimley ICS','HIOW ICS','KM ICS','Surrey ICS','Sussex ICS'))

df <- left_join(df,
                names_lookup,
                by = setNames('org_code',code_column))
return(df)

}



 
