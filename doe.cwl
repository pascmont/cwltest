cwlVersion: v1.2
class: CommandLineTool

baseCommand: [python3, doe_screening.py]
inputs:
  sop_data:
    type: File
    inputBinding:
      position: 1
  parameters_data:
    type: File
    inputBinding:
      position: 2
outputs:
  doe_output:
    type: File
    outputBinding:
      glob: doe_output.csv
