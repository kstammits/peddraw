
source("settings.txt")


found=require(kinship)

if(!found){
	print("run the R console and try 'install.packages('kinship')' ");
	#stop("the 'kinship' package needs to be installed in R first."); 
}

found=require(kinship2)

if(!found){
	print("run the R console and try 'install.packages('kinship2')' ");
	stop("the 'kinship2' package needs to be installed in R first."); 
}



args=commandArgs(trailingOnly=TRUE);

if(length(args)>0){
	inf=args[1];
	print(paste("Reading",inf));
	if(file.exists(inf)){
		print("File found.");
	}else{
		stop("file not found");
	}
}else{
	stop("no file specified on command line argument");
}
STATUS2=STATUS3=STATUS4=F
PhenoNames="Affected"

# read in faimly data:
FD=read.csv(inf,as.is=TRUE);
if("status2" %in% colnames(FD)) {
	STATUS2=T;
	PhenoNames=paste("Status",c(1,2));
}
if("status3" %in% colnames(FD)){
	STATUS3=T;
	PhenoNames=paste("Status",c(1,2,3));
}
if("status4" %in% colnames(FD)){
	STATUS4=T;
	PhenoNames=paste("Status",c(1,2,3,4));
}

#update the status columns
if(file.exists("PhenoNames.csv")){
	print("reading PhenoNames.csv")
	PN=read.csv("PhenoNames.csv",as.is=T,header=T)
	PhenoNames=PN$status[1]
	if(STATUS2)
		PhenoNames=c(PhenoNames,PN$status2[1])
	if(STATUS3)
		PhenoNames=c(PhenoNames,PN$status3[1])
	if(STATUS4)
		PhenoNames=c(PhenoNames,PN$status4[1])
}
	
	
#make separate files for each family ID.
families=unique(FD$pedID)
for(i in 1:length(families)) {

	#sub select the data rows for this family.
	rows=which(FD$pedID==families[i]);
	D=list();
	

D$indID=FD$indID[rows];
	D$patID=FD$patID[rows];
	D$matID=FD$matID[rows];
	

D$sex=FD$sex[rows];
	D$status=FD$status[rows];
	D$color=FD$color[rows];
	
	D$tag=FD$Tag[rows];
	
	if(STATUS2)
		D$status=cbind(D$status,FD$status2[rows])
	if(STATUS3)
		D$status=cbind(D$status,FD$status3[rows])
	if(STATUS4)
		D$status=cbind(D$status,FD$status4[rows])
	
	if("dead" %in% colnames(FD)){
		D$dead=FD$dead[rows];
	}else{
		D$dead=rep(FALSE,length(rows))
	}
	D$dead[D$dead==TRUE] <- 1
	D$dead[D$dead==FALSE] <- 0
	
	
	#construct the family tree from this information.
	#print(D)
	print(D)
	D$status[is.na(D$status)]<-FALSE
	
	ped=pedigree(id=D$indID , dadid=D$patID , momid=D$matID , sex=D$sex, status=D$dead, affected = D$status , missid=0)
	
	
	#Draw two different files!
	imfile=paste(families[i],".png",sep="");
	png(file=imfile,width=480, height=480); #pixels
		plot(ped , col=D$color,id=paste(D$indID,D$tag,sep="\n"));
		title(main=paste(families[i],"Pedigree"));
		if(length(PhenoNames)>1)
			pedigree.legend(ped,radius=0.15,labels=PhenoNames, location=LEGEND_POSITION)
	dev.off();
	print(paste("Written",imfile));
	
	imfile=paste(families[i],".pdf",sep="");
	pdf(file=imfile,width=PDF_WIDTH,height=PDF_HEIGHT);  #inches
		plot(ped , col=D$color,id=paste(D$indID,D$tag,sep="\n"));
		title(main=paste(families[i],"Pedigree"));
		if(length(PhenoNames)>1)
			pedigree.legend(ped,radius=0.15,labels=PhenoNames, location=LEGEND_POSITION)
	dev.off();
	print(paste("Written",imfile));
	
}
print(warnings())
print("Done.")






