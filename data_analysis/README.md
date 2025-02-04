### Summary ###

The Python notebook in this repository demonstrates the data analysis pipelines and regenerates the figures in the main text and the supplementary materials of the above-mentioned paper. To run the code on CoLab, you do not need to install any dependencies as the code takes care of it if you click ‘Run all’  from the ‘Runtime’ dropdown menu. All the data necessary for running the code is deposited in data folder. Also, the code is divided into different sections which can help you to navigate it and/or run the desired ones (make sure to run the necessary parts for performing the section before).

Although, the code has compromised of different parts, it does the following steps in its core:

1.	Loads the data from Google Drive and prepare it for pre-processing steps.
2.	Identifies UCN3 co-expressing GABA cells and drops them from the data set.
3.	Slices the baseline (pre-stimulation) intervention (stimulation or stress) period of recording from the entire calcium recording.
4.	Calculates the (Signed Lagged Cross-Correlation (SLxCorr) or covariance) distance matrix.
5.	Classifies the neurons into K_s groups by applying Agglomerative hierarchical clustering and K-means using the pre-computed distance metrics calculated in step 4.
6.	Plotting and displaying the data.


### How to use ###

Currently, the code is prepared to be run on Google CoLab. The only pre-requisite for executing the code is internet connection and a Google drive.

A Python version of the code will be added in future to make running the code locally possible.

### Code Author ###

Saeed Farjami (University of Exeter)
