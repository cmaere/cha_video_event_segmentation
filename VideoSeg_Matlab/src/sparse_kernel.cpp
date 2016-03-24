// function A=sparse_kernel(F, ntr, pi, pj, verbose);
// Input: 
// F (double)      : feature vector. #element * #feature dimension
// ntr             : number of element
// [pi, pj]        : index pair representation for MATLAB sparse matrix
// verbose         : if 2, display info

// Out: 
//  A = kernel matrix (inner product) of feature vector. 

//  Weiyu Zhang, Jan 12 2012
//  Based on Katerina's code
 

# include "mex.h"
# include "math.h"

double max(double a, double b) {
	double big;
	if(a>b)
		big = a;
	else
		big = b;
	return big;
}

double min(double a, double b) {
	double small;
	if(a<b)
		small = a;
	else
		small = b;
	return small;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,
        const mxArray *prhs[]) {
    
    /* declare variables */
    double *F;   
    int    ntr;
    int    i, j, k, l, total;
    unsigned int *pi, *pj;
     double * w;
    mwIndex *ir,*jc;
    
    
    if (nrhs != 5) {
        mexErrMsgTxt("Not enough input arguments!! 5 Input Argument expected");
    }
    
    F=mxGetPr(prhs[0]);    
    ntr      = (int) mxGetScalar(prhs[1]);
    
    if (!mxIsUint32(prhs[2]) | !mxIsUint32(prhs[3])) {
        mexErrMsgTxt("Index pair shall be of type UINT32");
    }
    
    pi = (unsigned int*)mxGetData(prhs[2]);
    pj = (unsigned int*)mxGetData(prhs[3]);    
    
    int verbose = (int) mxGetScalar(prhs[4]);

    /* Check Input */
    int nx = mxGetM(prhs[0]);
    if (nx!= ntr)
        mexErrMsgTxt("problem in the rows of input F");
    
    int ndim = mxGetN(prhs[0]);
    
    
    if (verbose>=2)
        mexPrintf("\t\t\t %d Element, %d dimension\n", ntr, ndim);
    
    
    
    if (nlhs>0){
        plhs[0] = mxCreateSparse(ntr, ntr, pj[ntr], mxREAL);
    }
    if (plhs[0]==NULL) {
	    mexErrMsgTxt("Not enough memory for the plhsput matrix");
	}
    
	w = mxGetPr(plhs[0]);
	ir = mxGetIr(plhs[0]);
	jc = mxGetJc(plhs[0]);
//    
//     
//     /* computation */
    total=0;
    for(j=0; j<ntr; j++){
        jc[j] = total;
        for (k=pj[j]; k<pj[j+1]; k++) {
            i = pi[k];
            if (i==j){
                continue;
            }
            ir[total] = i;
            w[total] = 0;
            for (l=0; l<ndim; l++) {
            w[total] += F[i+l*ntr]*F[j+l*ntr];
            //w[total] = 0.1;
            }
            total = total + 1;     
        }/*i*/
       // mexPrintf("j = %d \t, pj(end) = %d \t, Total =  %d \n",j, pj[j], total);
    }/*j*/
    
    jc[ntr] = total;
}
