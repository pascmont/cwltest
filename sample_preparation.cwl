cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo

inputs:
  assay_setup:
    type: File

arguments:
  - valueFrom: "Prepared samples based on assay setup: ${inputs.assay_setup.path}"
    shellQuote: false

outputs:
  prepared_samples:
    type: File
    outputBinding:
      glob: prepared_samples.txt

stdout: prepared_samples.txt
