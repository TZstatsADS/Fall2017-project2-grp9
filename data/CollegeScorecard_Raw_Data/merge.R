


#data1=read.csv("MERGED2014_15_PP.csv",header=T)
#data2=read.csv("MERGED2015_16_PP.csv",header=T)

library(data.table)

### read in data
data12=fread("data/MERGED2011_12_PP.csv")
data12=cbind(Year=2012,data12)
data13=fread("data/MERGED2012_13_PP.csv")
data13=cbind(Year=2013,data13)
data14=fread("data/MERGED2013_14_PP.csv")
data14=cbind(Year=2014,data14)
data15=fread("data/MERGED2014_15_PP.csv")
data15=cbind(Year=2015,data15)
data16=fread("data/MERGED2015_16_PP.csv")
data16=cbind(Year=2016,data16)


### universities intersection
Colleges.Need=unlist(Reduce(fintersect,
                            list(data12[,2],data13[,2],data14[,2],data15[,2],data16[,2])))

data12=subset(data12,is.element(data12$UNITID,Colleges.Need))
data13=subset(data13,is.element(data13$UNITID,Colleges.Need))
data14=subset(data14,is.element(data14$UNITID,Colleges.Need))
data15=subset(data15,is.element(data15$UNITID,Colleges.Need))
data16=subset(data16,is.element(data16$UNITID,Colleges.Need))


### Select used columes
Columes.Need=c("Year", "UNITID", "INSTNM", "CITY", "STABBR", "ZIP", "ACCREDAGENCY",
            "INSTURL", "NPCURL", "SCH_DEG", "HIGHDEG", "CONTROL", "LOCALE", "LATITUDE",
            "LONGITUDE", "ADM_RATE", "SATVR25", "SATVR75", "SATMT25", "SATMT75",
            "SATWR25", "SATWR75", "SATVRMID", "SATMTMID", "SATWRMID", "ACTCM25",
            "ACTCM75", "ACTEN25", "ACTEN75", "ACTMT25", "ACTMT75", "ACTWR25",
            "ACTWR75", "ACTCMMID", "ACTENMID", "ACTMTMID", "ACTWRMID", "SAT_AVG", 
            "CIP01CERT1", "CIP01CERT2", "CIP01ASSOC", "CIP01CERT4", "CIP01BACHL", 
            "CIP03CERT1", "CIP03CERT2", "CIP03ASSOC", "CIP03CERT4", "CIP03BACHL", 
            "CIP04CERT1", "CIP04CERT2", "CIP04ASSOC", "CIP04CERT4", "CIP04BACHL", 
            "CIP05CERT1", "CIP05CERT2", "CIP05ASSOC", "CIP05CERT4", "CIP05BACHL", 
            "CIP09CERT1", "CIP09CERT2", "CIP09ASSOC", "CIP09CERT4", "CIP09BACHL", 
            "CIP10CERT1", "CIP10CERT2", "CIP10ASSOC", "CIP10CERT4", "CIP10BACHL", 
            "CIP11CERT1", "CIP11CERT2", "CIP11ASSOC", "CIP11CERT4", "CIP11BACHL", 
            "CIP12CERT1", "CIP12CERT2", "CIP12ASSOC", "CIP12CERT4", "CIP12BACHL", 
            "CIP13CERT1", "CIP13CERT2", "CIP13ASSOC", "CIP13CERT4", "CIP13BACHL", 
            "CIP14CERT1", "CIP14CERT2", "CIP14ASSOC", "CIP14CERT4", "CIP14BACHL", 
            "CIP15CERT1", "CIP15CERT2", "CIP15ASSOC", "CIP15CERT4", "CIP15BACHL", 
            "CIP16CERT1", "CIP16CERT2", "CIP16ASSOC", "CIP16CERT4", "CIP16BACHL", 
            "CIP19CERT1", "CIP19CERT2", "CIP19ASSOC", "CIP19CERT4", "CIP19BACHL", 
            "CIP22CERT1", "CIP22CERT2", "CIP22ASSOC", "CIP22CERT4", "CIP22BACHL", 
            "CIP23CERT1", "CIP23CERT2", "CIP23ASSOC", "CIP23CERT4", "CIP23BACHL", 
            "CIP24CERT1", "CIP24CERT2", "CIP24ASSOC", "CIP24CERT4", "CIP24BACHL", 
            "CIP25CERT1", "CIP25CERT2", "CIP25ASSOC", "CIP25CERT4", "CIP25BACHL", 
            "CIP26CERT1", "CIP26CERT2", "CIP26ASSOC", "CIP26CERT4", "CIP26BACHL", 
            "CIP27CERT1", "CIP27CERT2", "CIP27ASSOC", "CIP27CERT4", "CIP27BACHL", 
            "CIP29CERT1", "CIP29CERT2", "CIP29ASSOC", "CIP29CERT4", "CIP29BACHL", 
            "CIP30CERT1", "CIP30CERT2", "CIP30ASSOC", "CIP30CERT4", "CIP30BACHL", 
            "CIP31CERT1", "CIP31CERT2", "CIP31ASSOC", "CIP31CERT4", "CIP31BACHL", 
            "CIP38CERT1", "CIP38CERT2", "CIP38ASSOC", "CIP38CERT4", "CIP38BACHL", 
            "CIP39CERT1", "CIP39CERT2", "CIP39ASSOC", "CIP39CERT4", "CIP39BACHL", 
            "CIP40CERT1", "CIP40CERT2", "CIP40ASSOC", "CIP40CERT4", "CIP40BACHL", 
            "CIP41CERT1", "CIP41CERT2", "CIP41ASSOC", "CIP41CERT4", "CIP41BACHL", 
            "CIP42CERT1", "CIP42CERT2", "CIP42ASSOC", "CIP42CERT4", "CIP42BACHL", 
            "CIP43CERT1", "CIP43CERT2", "CIP43ASSOC", "CIP43CERT4", "CIP43BACHL", 
            "CIP44CERT1", "CIP44CERT2", "CIP44ASSOC", "CIP44CERT4", "CIP44BACHL", 
            "CIP45CERT1", "CIP45CERT2", "CIP45ASSOC", "CIP45CERT4", "CIP45BACHL", 
            "CIP46CERT1", "CIP46CERT2", "CIP46ASSOC", "CIP46CERT4", "CIP46BACHL", 
            "CIP47CERT1", "CIP47CERT2", "CIP47ASSOC", "CIP47CERT4", "CIP47BACHL", 
            "CIP48CERT1", "CIP48CERT2", "CIP48ASSOC", "CIP48CERT4", "CIP48BACHL", 
            "CIP49CERT1", "CIP49CERT2", "CIP49ASSOC", "CIP49CERT4", "CIP49BACHL", 
            "CIP50CERT1", "CIP50CERT2", "CIP50ASSOC", "CIP50CERT4", "CIP50BACHL", 
            "CIP51CERT1", "CIP51CERT2", "CIP51ASSOC", "CIP51CERT4", "CIP51BACHL", 
            "CIP52CERT1", "CIP52CERT2", "CIP52ASSOC", "CIP52CERT4", "CIP52BACHL", 
            "CIP54CERT1", "CIP54CERT2", "CIP54ASSOC", "CIP54CERT4", "CIP54BACHL", 
            "DISTANCEONLY", "UG", "CURROPER", "COSTT4_A", "TUITIONFEE_IN", 
            "TUITIONFEE_OUT", "PCTFLOAN", "UG25ABV", "INC_PCT_LO",  "DEBT_MDN",
            "GRAD_DEBT_MDN", "WDRAW_DEBT_MDN", "REPAY_DT_MDN", "REPAY_DT_N", 
            "COUNT_ED", "AGE_ENTRY", "FEMALE", "MARRIED", "DEPENDENT", "VETERAN",
            "COUNT_NWNE_P10", "COUNT_WNE_P10", "MN_EARN_WNE_P10", "MD_EARN_WNE_P10", 
            "PCT10_EARN_WNE_P10", "PCT25_EARN_WNE_P10", "PCT75_EARN_WNE_P10", 
            "PCT90_EARN_WNE_P10", "SD_EARN_WNE_P10", "COUNT_NWNE_P6", "COUNT_WNE_P6",
            "MN_EARN_WNE_P6", "MD_EARN_WNE_P6", "PCT10_EARN_WNE_P6",
            "PCT25_EARN_WNE_P6", "PCT75_EARN_WNE_P6", "PCT90_EARN_WNE_P6",
            "SD_EARN_WNE_P6", "GRAD_DEBT_MDN10YR_SUPP", "UGDS_MEN", "UGDS_WOMEN")


### Merge data and order by UNITID
Data=rbind(data12,data13,data14,data15,data16)
Data=Data[, Columes.Need, with=F]
Data=setorder(Data,UNITID)


### Create major list

Major=c('Agriculture, Agriculture Operations, and Related Sciences',
        'Natural Resources and Conservation',
        'Architecture and Related Services',
        'Area, Ethnic, Cultural, Gender, and Group Studies',
        'Communication, Journalism, and Related Programs',
        'Communications Technologies/Technicians and Support Services',
        'Computer and Information Sciences and Support Services',
        'Personal and Culinary Services',
        'Education',
        'Engineering',
        'Engineering Technologies and Engineering-Related Fields',
        'Foreign Languages, Literatures, and Linguistics',
        'Family and Consumer Sciences/Human Sciences',
        'Legal Professions and Studies',
        'English Language and Literature/Letters',
        'Liberal Arts and Sciences, General Studies and Humanities',
        'Library Science',
        'Biological and Biomedical Sciences',
        'Mathematics and Statistics',
        'Military Technologies and Applied Sciences',
        'Multi/Interdisciplinary Studies',
        'Parks, Recreation, Leisure, and Fitness Studies',
        'Philosophy and Religious Studies',
        'Theology and Religious Vocations',
        'Physical Sciences',
        'Science Technologies/Technicians',
        'Psychology',
        'Homeland Security, Law Enforcement, Firefighting and Related Protective Services',
        'Public Administration and Social Service Professions',
        'Social Sciences',
        'Construction Trades',
        'Mechanic and Repair Technologies/Technicians',
        'Precision Production',
        'Transportation and Materials Moving',
        'Visual and Performing Arts',
        'Health Professions and Related Programs',
        'Business, Management, Marketing, and Related Support Services',
        'History')


















