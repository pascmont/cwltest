cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo

inputs:
  extracted_features:
    type: File

arguments:
  - valueFrom: |
      "Performed data analysis on extracted features: ${inputs.extracted_features.path}. Identified hits and phenotypic profiles."
    shellQuote: false

outputs:
  phenotypic_profiles:
    type: File
    outputBinding:
      glob: phenotypic_profiles.txt
  hits:
    type: File
    outputBinding:
      glob: hits.txt

stdout: phenotypic_profiles.txt
