cwlVersion: v1.2
class: Workflow

inputs:
  sop_references:
    type: File
    format: edam:format_3752
    doc: "Excel file containing SOP references"

  parameters_store:
    type: File
    format: edam:format_3750
    doc: "CSV file containing experimental parameters"

outputs:
  experiment_plan:
    type: File
    outputSource: organize_experiment/output_file
    doc: "Final experimental setup plan"

  registered_samples:
    type: File
    outputSource: register_samples/output_file
    doc: "List of registered samples for the experiment"

steps:
  read_sop:
    run: read_excel.cwl
    in:
      excel_file: sop_references
    out: [sop_data]

  read_parameters:
    run: read_csv.cwl
    in:
      csv_file: parameters_store
    out: [parameters_data]

  doe_screening:
    run: doe.cwl
    in:
      sop_data: read_sop/sop_data
      parameters_data: read_parameters/parameters_data
    out: [doe_output]

  organize_experiment:
    run: organize.cwl
    in:
      doe_output: doe_screening/doe_output
    out: [output_file]

  register_samples:
    run: register.cwl
    in:
      experiment_plan: organize_experiment/output_file
    out: [output_file]
