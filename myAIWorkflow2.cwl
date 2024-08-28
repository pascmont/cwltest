cwlVersion: v1.2
class: Workflow
doc: |
  This CWL workflow outlines the steps for setting up and executing an experiment based on objectives, SOP references, parameters, and experimental design.

inputs:
  text_view: 
    type: File
    inputBinding:
      position: 1
  sop_references: 
    type: File
    inputBinding:
      position: 2
  parameters_store: 
    type: File
    inputBinding:
      position: 3

outputs:
  experiment_setup: 
    type: File
    outputBinding:
      glob: experiment_setup.json

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

# Links between steps
  text_view:
    run: text_view_script.py
    in:
      input_file: text_view
    out:
      - objectives

  sop_references:
    run: excel_reader_script.py
    in:
      input_file: sop_references
    out:
      - sop_data

  parameters_store:
    run: csv_reader_script.py
    in:
      input_file: parameters_store
    out:
      - parameters

  doe_screening:
    run: doe_screening_script.py
    in:
      sop_data: sop_references/sop_data
      parameters: parameters_store/parameters
    out:
      - design

  create_experiments:
    run: joiner_script.py
    in:
      design: doe_screening/design
    out:
      - experiment_details

  cultures_layout:
    run: layout_script.py
    in:
      design: doe_screening/design
    out:
      - culture_layout

  plate_mapping:
    run: plate_mapping_script.py
    in:
      layout: cultures_layout/culture_layout
    out:
      - plate_mapping_data

  register_samples:
    run: register_samples_script.py
    in:
      plate_mapping: plate_mapping/plate_mapping_data
    out:
      - experiment_setup
