cwlVersion: v1.2
class: CommandLineTool

baseCommand: [python3, read_excel.py]
inputs:
  excel_file:
    type: File
    inputBinding:
      position: 1
outputs:
  sop_data:
    type: File
    outputBinding:
      glob: sop_data.csv
