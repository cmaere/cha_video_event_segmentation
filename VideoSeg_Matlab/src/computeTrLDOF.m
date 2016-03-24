function tr=computeTrLDOF(imnames,para)


%% compute optical flow
computeFlowLDOF(imnames,para);

%% link flow fields
tr=linkFlowLDOF(imnames,para);
