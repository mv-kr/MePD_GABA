## CONTENTS OF THE FOLDER 
1. Folder "**simulations**" contains code to reproduce the simulations
 - "**MePDU.m**": function to define the ODE system of the MePD circuitry during UCN3 stimulation
- "**MePD_stress.m**": function to define the ODE system of the MePD circuitry during stress intervention 
- "**KNDyXMePDU**.m": function to define the ODE system of the MePD circuitry coupled to the KNDy network model during UCN3 stimulation, GABA stimulation and GABA\glutamate suppression
- "**KNDyXMePD_stress.m**": function to define the ODE system of the MePD circuitry coupled to the KNDy network model during stress intervention
- "**parameter_def.m**": file to define the parameters for the coupled MePDxKNDy model
- "**par.mat**": .mat file with parameters for the coupled MePDxKNDy model
- "**combinedMePDv1.m**": file to produce figures depicting the simulations of the MePD model during UCN3 stimulation (Fig. 3(**A**)) and during restraint stress intervention (Fig. 3(**B**))
- "**supplementary.m**": produce Supplementary Fig. 6 showing the coupled model during control period(**A**), UCN3 stimulation(**B**), GABA suppression(**C**), GABA suppression + UCN3 stimulation (**D**), glutamate suppression (**E**), glutamate suppression + UCN3 stimulation (**F**)
- "**coupled_simulation.m**": produce simulations in Fig. 4 during UCN3 stimulation (**A**), GABA stimulation (**B**), GABA suppression + UCN3 stimulation (**C**), restraint stress (**D**). Produces the Supplementary Fig. 7 showing long-term behaviour of MePD circuit during the same interventions
2. Folder "**UCN3**" contains code to produce visualisation of UCN3 calcium data 
- "**G15stress.csv**": UCN3 calcium traces during restraint stress
- "**G16stim.csv**": UCN3 calcium traces during UCN3 stimulation 
- "**UCN3traces.m**": produces visualisation of average UCN3 calcium activity during UCN3 stimulation and restraint stress 
- "**heatmaps.m**": produces visualisation of the heatmaps of the UCN3 calcium activity during UCN3 stimulation and restraint stress 
