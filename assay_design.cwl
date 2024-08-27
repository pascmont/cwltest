cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo

inputs: {}

arguments:
  - valueFrom: "Assay Setup: Defined standard assay conditions."
    shellQuote: false

outputs:
  assay_setup:
    type: File
    outputBinding:
      glob: assay_setup.txt

stdout: assay_setup.txt
