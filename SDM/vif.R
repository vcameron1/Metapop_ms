vif<-function(mat, threshold=0, print.vif=TRUE){
#
# This function returns a vector containing Variance Inflation Factors (VIF)
# for the explanatory variables X. VIFs are the diagonal terms of the inverse
# of the correlation matrix.
#
# Reference: p. 386 of
#    Neter, J. et al. 1996. Applied linear statistical models. 4th edition.
#    Richard D. Irwin Inc., Chicago.
#
# mat = matrix to be filtered for collinearity.
# threshold = value defining the threshold for considering that a covariance matrix
#    has a zero determinant. A covariance or correlation matrix having a zero determinant
#    contains at least one variable that is completely collinear with the others.
#
# Output:
#
# - A list of variables with null variances.
# - The variables that are completely collinear with the previously entered variables receive 0.
# - The other variables receive Variance Inflation Factors (VIF). VIF > 10 (or > 20 for other
#   authors) represent high collinearity.
#
# Sebastien Durand and Pierre Legendre, March 2005
#
	library(MASS)
	# Check the presence of variables with null variances
	mat.cov <- cov(mat)
	problem = FALSE
	for(i in 1:nrow(mat.cov)) {
	   if(mat.cov[i,i] == 0) {
	      cat(" Variable No.",i," has a null variance",'\n')
	      problem = TRUE
	      }
	   }
	if(problem == TRUE) stop("The program was stopped. Verify/modify your X matrix.")
	
	# Assign 0 to the variables that are completely collinear with the previous variables
	mat.cor <- cor(mat)
	mm=0
	for(i in 2:ncol(mat)){
		look<-c(1:i)
		if(mm!=0)
			look<-look[-mrk]
		if( det(mat.cor[look,look]) <= threshold ){
			if(print.vif==T){
				cat('\n')
				cat("Variable '",colnames(mat)[i],"' is collinear: determinant is ", 
				    det(mat.cor),'\n')
			}
			if(mm==0){
				mrk<-i
				mm<-1
			}else{
				mrk<-c(mrk,i)
			}
		}
	}
	
	# Compute VIF for the remaining variables
	if(mm==1){
		vif1<-diag(ginv(cor(mat[,-mrk])))
		vif0<-rep(0,length(mrk))
		vif<-c(vif0,vif1)
		nn<-1:ncol(mat)
		vif<-round(vif[sort(c(mrk,nn[-mrk]),index.return=T)$ix],digit=2)
	}else{
		vif<-round(diag(ginv(cor(mat))),digit=2)
	}
	names(vif)<-colnames(mat)
	
	#
	return(vif)
}
