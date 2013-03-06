# Deformable Surface Tracking

This [MatLab](http://www.mathworks.com/products/matlab/) project performs deformable surface tracking using a meshless registration model.

The idea is to have nodes that are represented by 2D gaussians to perform the image registration.  Using the optical flow constraint, we apply a series of transformations on the nodes to find the transformation from one frame to the next.

Using this, we can do augmented reality with clothing, point tracking (maybe for medical image analysis or something), and more.

## Requirements

* Optimization Toolbox

### Other

This could more that likely **does not** work under [Octave](http://www.gnu.org/software/octave/) without some heavy adjustments.