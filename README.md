Caffe is a perfect platform for training Convolutional Neural Networks. Models can be trained there and then be exported to other platforms for inference phase. As a case in point, in some applications, a CNN is trained on a workstation using Caffe and then it will be moved to a mobile platform to be used. 
This script is designed to extract Neural Network parameters from a Caffe model files and store them as plain binary files. Moreover, the script can extract intermediate results as well. To use this tool, it is required to modify the Config.txt file.

## Citing
Our [research group](http://lepsucd.com) is working on CNN acceleration for mobile phones. If this project
helped your research, please kindly cite our latest conference paper:
```
Mohammad Motamedi, Philipp Gysel, Venkatesh Akella and Soheil Ghiasi, “Design Space Exploration of FPGA-Based Deep Convolutional Neural Network”, IEEE/ACM Asia-South Pacific Design Automation Conference (ASPDAC), January 2016.
```