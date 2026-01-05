### Summary

This folder contains the data-analysis pipeline used in the paper "Amygdala GABA Neurons: Gatekeepers of Stress and Reproduction in Female Mice". The analysis is implemented as Jupyter notebooks and data files are under `data/`.


- `analysis_pipeline.ipynb` — The analysis pipeline with step-by-step execution and iterative figure development. Contains all analysis building blocks (preprocessing, signal analysis, clustering, plotting).

- `calculate_riemannian_distances.ipynb` — Utility notebook for Riemannian-geometry based analyses: constructs random correlation matrices, computes affine-invariant Riemannian distances between SPD matrices, and summarises distance statistics. 

- `extract_corr.ipynb` — Helper utilities to extract correlation / distance matrices from raw calcium traces, perform normalisation (min-max, z-score), slice pre-stim / stim windows, and assemble data for downstream clustering and plotting.