# CloudCompare CLI – LAS Point Cloud Filtering

## Download the script

[View the LiDAR filtering script](./LIDAR_Filter.bat)

To download it, open the link above and click "Download raw file"
in the upper-right corner of the file view.

## Overview

This script implements a point cloud filtering workflow using the CloudCompare command-line interface (CLI). It is designed for LAS point clouds acquired with the DJI Zenmuse L2 and processed in DJI Terra.

The workflow aims to reduce noise and recover as many ground points as possible.

## Requirements

* Windows (batch script execution)
* CloudCompare version 2.14 or later
* LAS point clouds processed in DJI Terra

### DJI Terra processing settings

The expected processing settings are:

* Point cloud density: 100%
* Smoothing enabled
* Accuracy optimization enabled

## Setup

Open the `.bat` file in a text editor and specify the path to the CloudCompare executable.

The typical installation path is:

```text
C:\\Program Files\\CloudCompare\\CloudCompare.exe
```

## Usage

1. Place the `.bat` file in the directory containing the unfiltered LAS files.
2. Run the batch script directly from that directory.

## Processing Workflow

The script combines four CloudCompare processing methods:

1. **Scan angle filtering** – Corrects distortions associated with excessive scan angles using the LAS `Scan Angle Rank` attribute.
2. [**Rasterization**](https://www.cloudcompare.org/doc/wiki/index.php/Rasterize) – Extracts points representing the minimum Z elevation within each grid cell.
3. [**Geometric feature computation**](https://www.cloudcompare.org/doc/wiki/index.php/Compute_geometric_features) – Uses the `ANISOTROPY` geometric feature to identify noisy areas.
4. [**Cloud-to-cloud distance**](https://www.cloudcompare.org/doc/wiki/index.php/Cloud-to-Cloud_Distance) – Compares the original LAS point cloud with the rasterized point cloud to recover as many ground points as possible.

## Usage Restrictions

This implementation of the CloudCompare processing workflow is provided exclusively for use by *Nature* reviewers and editors during the peer-review process.

The full implementation of the algorithms will be published separately.

