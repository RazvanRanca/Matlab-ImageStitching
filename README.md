Matlab-ImageStitching
=====================

This is a project I did in my junior year for a computer vision class. 

**Running**: call the stitch function with the two images you want stiched. Eg: *stitch('Samples/monkeys1.png', 'Samples/monkeys2.png')*

**Approach**: 
* The local features of the two images are detected and described with the SIFT algorithm ( http://en.wikipedia.org/wiki/Scale-invariant_feature_transform )
* The two sets of SIFT featurs are then analyzed for similar datapoints which are likely to refer to the same image feature
* If insufficient matching points have been found, then we quit as there isn't enough overlapping area to stitch the images
* Otherwise, the RANSAC toolbox is used to apply a homographic transformation to one of the images such that the two images can be superimposed, and the resulting panorama view is outputed.  

**Samples**: 
* The Samples folder shows several starting images and their stitched result. 
* Circles represent the features we matched on from the first image and crosses represent the corresponding features from the second image. 
* The quality of the match can be visually inspected by the amount of crosses which ended up on top of their circle.
* Notice how in the case of the *airView* image very few matches are detected but the information is still sufficient to generate a good stitching. This shows that quality of matching points if significantly more important than quantity.
