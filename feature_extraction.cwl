cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo

inputs:
  segmentation_data:
    type: File

arguments:
  - valueFrom: "Extracted features from segmentation data: ${inputs.segmentation_data.path}"
    shellQuote: false

outputs:
  extracted_features:
    type: File
    outputBinding:
      glob: extracted_features.txt

stdout: extracted_features.txt
