
Last update: 28 January 2025

This repository consists of the code for data analysis carried out in the manuscript:

***** Amygdala GABA Neurons: Gatekeepers of Stress and Reproduction *****

### Authors ###

	⁃	Junru Yu
	⁃	Saeed Farjami
	⁃	Kateryna Nechyporenko
	⁃	Xiao Feng Li
	⁃	Hafsa Yaseen
	⁃	Yanyan Lin
	⁃	Jinbin Ye
	⁃	Owen Hollings
	⁃	Ross de Burgh
	⁃	Kevin T. O’Byrne
	⁃	Krasimira Tsaneva-Atanasova
	⁃	Margaritis Voliotis

### Abstract ###

Stress can disrupt menstrual cycles, cause infertility, and lead to other reproductive disorders. The posterodorsal medial amygdala (MePD) processes stress signals and regulates the gonadotropin-releasing hormone (GnRH) pulse generator through GABAergic inhibitory projections to the hypothalamus. However, how stress is processed in the MePD—especially involving its dense GABAergic and Urocortin-3 (UCN3) neurons—remains poorly understood.
 
In this study, we combine in vivo GRadient-INdex (GRIN) lens mini-endoscopic calcium imaging (to track neuronal activity), optogenetics, clustering analysis, and computational modelling to investigate MePD circuitry. Our findings reveal two anti-correlated GABAergic sub-populations in the MePD that dictate responses to both UCN3 neuron stimulation and restraint stress. Our computational modelling suggests that mutual inhibition between these GABAergic groups drives this anti-correlated activity and predicts how these interactions shape downstream-responses to stimulation of GABAergic and UCN3 neurons.
 
We test these predictions using optogenetics and confirm that GABAergic neurons operate downstream of the UCN3 population, playing a crucial role in transmitting UCN3 signals to regulate luteinising hormone (LH) pulse frequency. Our study is the first to show how GABAergic neurons in the amygdala mediate stress effects on reproductive health, uncovering key neural mechanisms linking emotional and reproductive functions.



### Code Author ###

Saeed Farjami (University of Exeter)


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
