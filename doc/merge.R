

#data1=read.csv("MERGED2014_15_PP.csv",header=T)
#data2=read.csv("MERGED2015_16_PP.csv",header=T)

library(data.table)

### read in data
data07=fread("data/MERGED2006_07_PP.csv")
data07=cbind(Year=2007,data07)
data08=fread("data/MERGED2007_08_PP.csv")
data08=cbind(Year=2008,data08)
data09=fread("data/MERGED2008_09_PP.csv")
data09=cbind(Year=2009,data09)
data10=fread("data/MERGED2009_10_PP.csv")
data10=cbind(Year=2010,data10)
data11=fread("data/MERGED2010_11_PP.csv")
data11=cbind(Year=2011,data11)
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
                            list(data07[,2],data08[,2],
                                 data09[,2],data10[,2],
                                 data11[,2],data12[,2],
                                 data13[,2],data14[,2],
                                 data15[,2],data16[,2])))

data07=subset(data07,is.element(data07$UNITID,Colleges.Need))
data08=subset(data08,is.element(data08$UNITID,Colleges.Need))
data09=subset(data09,is.element(data09$UNITID,Colleges.Need))
data10=subset(data10,is.element(data10$UNITID,Colleges.Need))
data11=subset(data11,is.element(data11$UNITID,Colleges.Need))
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
            "DISTANCEONLY", "UGDS", "UG", "CURROPER", "COSTT4_A", "TUITIONFEE_IN", 
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
Data=rbind(data07,data08,data09,data10,data11,
           data12,data13,data14,data15,data16)
Data=Data[, Columes.Need, with=F]
fulldata=setorder(Data,UNITID)

fulldata$UGDS=as.numeric(fulldata$UGDS)

save(fulldata,file="./data/fulldata.Rdata")


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


















