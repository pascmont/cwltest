cwlVersion: v1.2
class: Workflow
doc: |
  This CWL workflow outlines the steps for setting up and executing an experiment based on objectives, SOP references, parameters, and experimental design.
  Version: 1.0
  Description: Workflow for executing and tracking experiments. Includes validation and logging steps.

inputs:
  text_view: 
    type: File
    inputBinding:
      position: 1
    doc: "Input file containing experiment objectives."

  sop_references: 
    type: File
    inputBinding:
      position: 2
    doc: "Excel file containing SOP references."

  parameters_store: 
    type: File
    inputBinding:
      position: 3
    doc: "CSV file with experiment parameters."

outputs:
  experiment_setup: 
    type: File
    outputBinding:
      glob: experiment_setup.json
    doc: "Final setup file for the experiments."

steps:
  text_view:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python, text_view_script.py]
      inputs:
        input_file:
          type: File
          inputBinding:
            position: 1
      outputs:
        objectives:
          type: File
          outputBinding:
            glob: objectives.json
      doc: "Step for processing experiment objectives."

  sop_references:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python, excel_reader_script.py]
      inputs:
        input_file:
          type: File
          inputBinding:
            position: 1
      outputs:
        sop_data:
          type: File
          outputBinding:
            glob: sop_data.json
      doc: "Step for reading SOP references from Excel."

  parameters_store:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python, csv_reader_script.py]
      inputs:
        input_file:
          type: File
          inputBinding:
            position: 1
      outputs:
        parameters:
          type: File
          outputBinding:
            glob: parameters.csv
      doc: "Step for reading parameters from CSV."

  doe_screening:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python, doe_screening_script.py]
      inputs:
        sop_data:
          type: File
        parameters:
          type: File
      outputs:
        design:
          type: File
          outputBinding:
            glob: design.json
      doc: "Step for generating experimental design."

  create_experiments:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python, joiner_script.py]
      inputs:
        design:
          type: File
      outputs:
        experiment_details:
          type: File
          outputBinding:
            glob: experiment_details.json
      doc: "Step for creating experiment details from design."

  cultures_layout:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python, layout_script.py]
      inputs:
        design:
          type: File
      outputs:
        culture_layout:
          type: File
          outputBinding:
            glob: culture_layout.json
      doc: "Step for laying out cultures based on design."

  plate_mapping:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python, plate_mapping_script.py]
      inputs:
        layout:
          type: File
      outputs:
        plate_mapping_data:
          type: File
          outputBinding:
            glob: plate_mapping_data.json
      doc: "Step for mapping experimental conditions to plates."

  register_samples:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python, register_samples_script.py]
      inputs:
        plate_mapping:
          type: File
      outputs:
        experiment_setup:
          type: File
          outputBinding:
            glob: experiment_setup.json
      doc: "Final step for registering samples and producing the setup file."
