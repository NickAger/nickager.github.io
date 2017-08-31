---
title: "Calling a C++ library from Swift"
date: 2017-07-12
tags: [Swift, C++]
layout: post
---

```objc
//
//  OpenCVWrapper.h
//  OpenCVTest
//
//  Created by Nick Ager on 23/01/2017.
//  Copyright © 2017 Moletest Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject

+ (int) laplaceMax:(UIImage *)image;
+ (int) laplaceMaxEqualised:(UIImage *)image;
+ (double) laplaceAverage:(UIImage *)image;
+ (double) laplaceVariance:(UIImage *)image;
+ (double) modifiedLaplacian:(UIImage *)image;
+ (double) tenengrad:(UIImage *)image;
+ (double) normalizedGraylevelVariance:(UIImage *)image;
    

// debugging
+ (UIImage *) processImage:(UIImage *)image;
    
+ (UIImage *) convertToGray:(UIImage *)image;
+ (UIImage *) convertToGray2:(UIImage *)image;
+ (UIImage *) laplaceImage:(UIImage *)image;
+ (UIImage *) modifiedLaplacianImage:(UIImage *)image;
+ (UIImage *) tenengradImage:(UIImage *)image;
@end
```

Note the `.mm` extension:

```objc
//
//  OpenCVWrapper.mm
//  OpenCVTest
//
//  Created by Nick Ager on 23/01/2017.
//  Copyright © 2017 Moletest Ltd. All rights reserved.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
#import "UIImage+OpenCV.h"

@implementation OpenCVWrapper

+ (UIImage *) processImage:(UIImage *)image {
    cv::Mat cvImage = [image cvMatRepresentationColor];
    cv::Mat gray;
    // Convert the image to grayscale
    cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
    // Apply Gaussian filter to remove small edges
    cv::GaussianBlur(gray, gray,
                     cv::Size(5, 5), 1.2, 1.2);
    // Calculate edges with Canny
    cv::Mat edges;
    cv::Canny(gray, edges, 0, 50);
    // Fill image with white color
    cvImage.setTo(cv::Scalar::all(255));
    // Change color on edges
    cvImage.setTo(cv::Scalar(0, 128, 255, 255), edges);
    // Convert cv::Mat to UIImage* and show the resulting image
    return [UIImage imageFromCVMat: cvImage];
}

// "in-focus" calculations from calculation:
// http://stackoverflow.com/questions/7765810/is-there-a-way-to-detect-if-an-image-is-blurry

+ (UIImage *) convertToGray:(UIImage *)image {
    cv::Mat cvImage = [image cvMatRepresentationColor];
    cv::Mat gray;
    // Convert the image to grayscale
    cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
    
    return [UIImage imageFromCVMat: gray];
}

// doesn't appear to work
+ (UIImage *) convertToGray2:(UIImage *)image {
    cv::Mat cvImage = [image cvMatRepresentationGray];
    
    return [UIImage imageFromCVMat: cvImage];
}


+ (int) laplaceMax:(UIImage *)image {
    cv::Mat cvImage = [image cvMatRepresentationColor];
    cv::Mat gray;
    // Convert the image to grayscale
    cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
    
    cv::Mat blurredGrey;
    cv::GaussianBlur(gray, blurredGrey, cv::Size(3,3), 0);
    
    cv::Mat laplacianImage;
    cv::Laplacian( blurredGrey, laplacianImage, CV_16S, 1, 1, 0, cv::BORDER_DEFAULT );

    cv::Mat mask = cv::Mat::zeros(laplacianImage.size(), CV_8U);
    cv::circle(mask, cv::Point(mask.rows/2, mask.cols/2), (image.size.width/2)-3, cv::Scalar(255, 0, 0), -1, 8, 0);

    cv::Mat maskedLaplacianImage;
    laplacianImage.copyTo(maskedLaplacianImage, mask);
    
    short max=0;
    for(int i = 0; i < maskedLaplacianImage.rows; i++)
    {
        short* Mi = maskedLaplacianImage.ptr<short>(i);
        for(int j = 0; j < maskedLaplacianImage.cols; j++)
            max = std::max(Mi[j], max);
    }
    return max;
}
    
+ (int) laplaceMaxEqualised:(UIImage *)image {
    cv::Mat cvImage = [image cvMatRepresentationColor];
    cv::Mat gray;
    // Convert the image to grayscale
    cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
    
    cv::Mat blurredGrey;
    cv::GaussianBlur(gray, blurredGrey, cv::Size(3,3), 0);
    
    cv::Mat equalised;
    cv::equalizeHist( blurredGrey, equalised );
    
    cv::Mat laplacianImage;
    cv::Laplacian( equalised, laplacianImage, CV_16S, 1, 1, 0, cv::BORDER_DEFAULT );
    
    cv::Mat mask = cv::Mat::zeros(laplacianImage.size(), CV_8U);
    cv::circle(mask, cv::Point(mask.rows/2, mask.cols/2), (image.size.width/2)-3, cv::Scalar(255, 0, 0), -1, 8, 0);
    
    cv::Mat maskedLaplacianImage;
    laplacianImage.copyTo(maskedLaplacianImage, mask);
    
    short max=0;
    for(int i = 0; i < maskedLaplacianImage.rows; i++)
    {
        short* Mi = maskedLaplacianImage.ptr<short>(i);
        for(int j = 0; j < maskedLaplacianImage.cols; j++)
        max = std::max(Mi[j], max);
    }
    return max;
}
    
+ (double) laplaceAverage:(UIImage *)image {
    cv::Mat cvImage = [image cvMatRepresentationColor];
    cv::Mat gray;
    // Convert the image to grayscale
    cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
    
    cv::Mat blurredGrey;
    cv::GaussianBlur(gray, blurredGrey, cv::Size(3,3), 0);
    
    cv::Mat laplacianImage;
    cv::Laplacian( blurredGrey, laplacianImage, CV_16S, 1, 1, 0, cv::BORDER_DEFAULT );
    
    cv::Mat mask = cv::Mat::zeros(laplacianImage.size(), CV_8U);
    cv::circle(mask, cv::Point(mask.rows/2, mask.cols/2), (image.size.width/2)-3, cv::Scalar(255, 0, 0), -1, 8, 0);
    
    cv::Mat maskedLaplacianImage;
    laplacianImage.copyTo(maskedLaplacianImage, mask);
    
    double focusMeasure = cv::mean(maskedLaplacianImage).val[0];
    return focusMeasure;
}

// OpenCV port of 'LAPV' algorithm (Pech2000)
+ (double) laplaceVariance:(UIImage *)image {
    cv::Mat cvImage = [image cvMatRepresentationColor];
    cv::Mat gray;
    // Convert the image to grayscale
    cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
    
    cv::Mat blurredGrey;
    cv::GaussianBlur(gray, blurredGrey, cv::Size(3,3), 0);
    
    cv::Mat laplacianImage;
    cv::Laplacian( blurredGrey, laplacianImage, CV_16S, 1, 1, 0, cv::BORDER_DEFAULT );
    
    cv::Mat mask = cv::Mat::zeros(laplacianImage.size(), CV_8U);
    cv::circle(mask, cv::Point(mask.rows/2, mask.cols/2), (image.size.width/2)-3, cv::Scalar(255, 0, 0), -1, 8, 0);
    
    cv::Mat maskedLaplacianImage;
    laplacianImage.copyTo(maskedLaplacianImage, mask);
    
    cv::Scalar mu, sigma;
    cv::meanStdDev(maskedLaplacianImage, mu, sigma);
    
    double focusMeasure = sigma.val[0]*sigma.val[0];
    return focusMeasure;
}
    
+ (UIImage *) laplaceImage:(UIImage *)image {
    cv::Mat cvImage = [image cvMatRepresentationColor];
    cv::Mat gray;
    // Convert the image to grayscale
    cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
    
    cv::Mat blurredGrey;
    cv::GaussianBlur(gray, blurredGrey, cv::Size(3,3), 0);
    
    cv::Mat laplacianImage;
    cv::Laplacian( blurredGrey, laplacianImage, CV_16SC2, 3, 1, 0, cv::BORDER_DEFAULT );
    
    cv::Mat mask = cv::Mat::zeros(laplacianImage.size(), CV_8U);
    cv::circle(mask, cv::Point(mask.rows/2, mask.cols/2), (image.size.width/2)-3, cv::Scalar(255, 0, 0), -1, 8, 0);
    
    cv::Mat maskedLaplacianImage;
    laplacianImage.copyTo(maskedLaplacianImage, mask);
    
    cv::Mat abs_dst;
    cv::convertScaleAbs( maskedLaplacianImage, abs_dst );
    return [UIImage imageFromCVMat: abs_dst];
}
    
// OpenCV port of 'LAPM' algorithm (Nayar89)
+ (double) modifiedLaplacian:(UIImage *)image {
    cv::Mat cvImage = [image cvMatRepresentationColor];
    cv::Mat gray;
    // Convert the image to grayscale
    cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
    
    cv::Mat M = (cv::Mat_<double>(3, 1) << -1, 2, -1);
    cv::Mat G = cv::getGaussianKernel(3, -1, CV_64F);
    
    cv::Mat Lx;
    cv::sepFilter2D(gray, Lx, CV_64F, M, G);
    
    cv::Mat Ly;
    cv::sepFilter2D(gray, Ly, CV_64F, G, M);
    
    cv::Mat FM = cv::abs(Lx) + cv::abs(Ly);

    cv::Mat mask = cv::Mat::zeros(FM.size(), CV_8U);
    cv::circle(mask, cv::Point(mask.rows/2, mask.cols/2), (image.size.width/2)-3, cv::Scalar(255, 0, 0), -1, 8, 0);
    
    cv::Mat maskedLaplacianImage;
    FM.copyTo(maskedLaplacianImage, mask);
    
    double focusMeasure = cv::mean(maskedLaplacianImage).val[0];
    return focusMeasure;
}
    
+ (UIImage *) modifiedLaplacianImage:(UIImage *)image {
    cv::Mat cvImage = [image cvMatRepresentationColor];
    cv::Mat gray;
    // Convert the image to grayscale
    cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
    
    cv::Mat M = (cv::Mat_<double>(3, 1) << -1, 2, -1);
    cv::Mat G = cv::getGaussianKernel(3, -1, CV_64F);
    
    cv::Mat Lx;
    cv::sepFilter2D(gray, Lx, CV_64F, M, G);
    
    cv::Mat Ly;
    cv::sepFilter2D(gray, Ly, CV_64F, G, M);
    
    cv::Mat FM = cv::abs(Lx) + cv::abs(Ly);
    
    cv::Mat mask = cv::Mat::zeros(FM.size(), CV_8U);
    cv::circle(mask, cv::Point(mask.rows/2, mask.cols/2), (image.size.width/2)-3, cv::Scalar(255, 0, 0), -1, 8, 0);
    
    cv::Mat maskedLaplacianImage;
    FM.copyTo(maskedLaplacianImage, mask);
    
    cv::Mat abs_dst;
    cv::convertScaleAbs( maskedLaplacianImage, abs_dst );
    return [UIImage imageFromCVMat: abs_dst];
}
 
    
// OpenCV port of 'TENG' algorithm (Krotkov86)
+ (double) tenengrad:(UIImage *)image
{
    cv::Mat cvImage = [image cvMatRepresentationColor];
    cv::Mat gray;
    
    // Convert the image to grayscale
    cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
    
    cv::Mat blurredGrey;
    cv::GaussianBlur(gray, blurredGrey, cv::Size(3,3), 0);
    
    cv::Mat Gx, Gy;
    cv::Sobel(blurredGrey, Gx, CV_64F, 1, 0, 3);
    cv::Sobel(blurredGrey, Gy, CV_64F, 0, 1, 3);
    
    cv::Mat FM = Gx.mul(Gx) + Gy.mul(Gy);
    
    double focusMeasure = cv::mean(FM).val[0];
    return focusMeasure;
}
    
+ (UIImage *) tenengradImage:(UIImage *)image
{
    cv::Mat cvImage = [image cvMatRepresentationColor];
    cv::Mat gray;
    // Convert the image to grayscale
    cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
    
    cv::Mat blurredGrey;
    cv::GaussianBlur(gray, blurredGrey, cv::Size(3,3), 0);
    
    cv::Mat Gx, Gy;
    cv::Sobel(blurredGrey, Gx, CV_64F, 1, 0, 3);
    cv::Sobel(blurredGrey, Gy, CV_64F, 0, 1, 3);
    
    cv::Mat FM = Gx.mul(Gx) + Gy.mul(Gy);
    
    cv::Mat mask = cv::Mat::zeros(FM.size(), CV_8U);
    cv::circle(mask, cv::Point(mask.rows/2, mask.cols/2), (image.size.width/2)-3, cv::Scalar(255, 0, 0), -1, 8, 0);
    
    cv::Mat maskedLaplacianImage;
    FM.copyTo(maskedLaplacianImage, mask);
    
    cv::Mat abs_dst;
    cv::convertScaleAbs( maskedLaplacianImage, abs_dst );
    return [UIImage imageFromCVMat: abs_dst];
}
    
// OpenCV port of 'GLVN' algorithm (Santos97)
+ (double) normalizedGraylevelVariance:(UIImage *)image
{
    cv::Mat cvImage = [image cvMatRepresentationColor];
    cv::Mat gray;
    // Convert the image to grayscale
    cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
    
    cv::Mat blurredGrey;
    cv::GaussianBlur(gray, blurredGrey, cv::Size(3,3), 0);
    
    cv::Mat mask = cv::Mat::zeros(cvImage.size(), CV_8U);
    cv::circle(mask, cv::Point(mask.rows/2, mask.cols/2), (image.size.width/2)-3, cv::Scalar(255, 0, 0), -1, 8, 0);
    
    cv::Mat maskedGreyImage;
    blurredGrey.copyTo(maskedGreyImage, mask);
                 
    cv::Scalar mu, sigma;
    cv::meanStdDev(maskedGreyImage, mu, sigma);
    
    double focusMeasure = (sigma.val[0]*sigma.val[0]) / mu.val[0];
    return focusMeasure;
}
        

@end
```