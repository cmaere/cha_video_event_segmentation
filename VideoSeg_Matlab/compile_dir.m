root_dir = pwd;

cd([root_dir '/src/']);
mex -largeArrayDims sparse_kernel.cpp

cd([root_dir '/src/']);
mex -largeArrayDims parmatV.c
mex -largeArrayDims spmtimesd.c

cd([root_dir '/src/']);
mex -largeArrayDims compute_Atraj_neighbour.cpp
mex -largeArrayDims compute_tr_max_measurement_diff_mex.cpp
mex -largeArrayDims compute_tr_max_measurement_diff_ut_mex.cpp


cd(root_dir);






