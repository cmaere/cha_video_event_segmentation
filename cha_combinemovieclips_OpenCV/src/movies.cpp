/*
 * movies.cpp
 *
 *  Created on: Dec 21, 2014
 *      Author: charlie
 */

#include "opencv2/video/tracking.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include <opencv2/core/core.hpp>        // Basic OpenCV structures (cv::Mat)
#include <opencv2/highgui/highgui.hpp>
#include <iostream>		// standard C++ I/O
#include <dirent.h>
#include <string>
#include <stdlib.h>
using namespace cv;
using namespace std;


int main (int c, char *v[]) {
	CvCapture *capture=cvCaptureFromAVI(v[1]);
	//int fps=(int) cvGetCaptureProperty(capture,CV_CAP_PROP_FPS);
	int frames=(int) cvGetCaptureProperty(capture,CV_CAP_PROP_FRAME_COUNT);
	cout<< frames;
    return 0;
}


