# Face-Detection-by-AdaBoost-and-RealBoost
How many features do you need to detect a face in a crowd?

Detecting Faces in Images by Boosting Technique
 
 
Objectives : 

Boosting is a general method for improving the accuracy of any given learning algorithm. One can use it to combine simple or weak classifiers, each performing only slightly better than random guess,  to form a strong classifier. One successful example of the Boosting techniques was Face detection. In this project, you are required to implement the Adaboost and RealBoost algorithms for  frontal human face detection. Cascade is not required. 

1. Construction of weak classifiers

    Design a few types of features as we discussed in class. For each feature plot the histograms for the positive and negative populations. Determine the threshold. [note that as the samples change their weight over time, the histogram and threshold will change]
    Each feature corresponds to a weak classifier, and is also called a tree-stump. 

2. AdaBoosting

   i)  Display the best ten features as images (after boosting)

   ii) At steps T=0, 10, 50, 100 respectively, plot the curve for the errors of  top 1000 weak classifiers among the pool of weak classifiers in increasing order.  Compare these four curves  and see how many of the weak classifiers have errors close to 1/2
    
    iii)Plot the histograms of the  positive and negative populations over the F(x) axis, for T=10, 50, 100 respectively.
        From the three histograms, you plot their corresponding ROC curves.

3. RealBoosting

    Implement RealBoosting algorithm using the top T=10, 50, 100 features you chose at Adaboosting step.
    
   (iv) Plot the histograms of the positive and negative populations over the F(x) axis, for T=10, 50, 100 respectively. 

   (v)  Plot the three ROC curves and comparing them against the histograms and  ROC's in 2.2.



Datasets:

The dataset includes a total of 11,800 frontal faces in two sizes: 16x16 pixels and 24x24 pixels, and 45,000 non-faces which are also in two sizes. These non-faces are collected through a "negative mining" procedure: running the detection code on "background" images without faces and adding false alarms (hard examples) to the non-face set.
   
We will use a background image from our classroom when it has no people for what people called  Hard Negative Mining. Thus you can run your strong classifier on these images, and add any false detection as negative images in the later training stage.



Test images:
     
An image taken at the class is used for testing, not for training. Note that  you need to rescale the image to multiple sizes so that the largest and smallest faces appear as 24x24 pixels or 16x16 pixels in the pyramid at least once. Or you keep multiple sizes, and run your detection on all these images, and apply a Non-Maximum Suppression (remove detected positive windows that overlaps heavily).



References:

  [1] P.Viola, M.Jones, "Rapid Object Detection using a Boosted Cascade of Simple Features", CVPR 2001.[pdf]
  
  [2] C. Huang, H. Ai, Y. Li, and S. Lao, "High-performance Rotation Invariant Multi-View Face Detection", IEEE Trans. on PAMI, 29(4), 2007. [pdf]
      (This paper uses other type of features, uses RealBoost and deals with multi-views)
     

