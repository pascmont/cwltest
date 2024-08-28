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
    in:
      input_file: text_view
    out:
      - objectives

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
    in:
      input_file: sop_references
    out:
      - sop_data

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
    in:
      input_file: parameters_store
    out:
      - parameters

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
    in:
      sop_data: sop_references/sop_data
      parameters: parameters_store/parameters
    out:
      - design

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
    in:
      design: doe_screening/design
    out:
      - experiment_details

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
    in:
      design: doe_screening/design
    out:
      - culture_layout

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
    in:
      layout: cultures_layout/culture_layout
    out:
      - plate_mapping_data

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
    in:
      plate_mapping: plate_mapping/plate_mapping_data
    out:
      - experiment_setup
