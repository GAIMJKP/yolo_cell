# yolo_cell

Development of a deep convolutional regression network for detection and location of multiple-phenotype cells in confocal microscopy reflectance images. Codes include those for network architecture definition, dataset production, training, and evaluation.

classify_large_image.m marches classifier across full multi-GB image to locate cells

classify_yolo_cell.m locates cells in single 224x224 or 448x448 pixel sub-image

collate_manual_training_data.m imports training images and metadata into single structure

create_network_yolo creates a modified YOLO network with trained YOLO weights. Output layers are modified for cell detection.

crop_large_test_image.m crops a large test image

dataset_production....m  These codes produce datasets with varios ground truth methods.

train_yolo_cell.m trains the modified YOLO nework for cell detection

validation_error.m calculates a simple RSME error on a set of images

visualize_image_labels.m visualizes training images and ground truth labels

yolocellcoords.m function to convert regresion output vector/tensor to cartesian cell locations

yolocellvector.m function to convert cartesian cell locations to regression output vector/tensor

