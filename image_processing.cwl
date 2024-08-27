cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo

inputs:
  raw_images:
    type: File

arguments:
  - valueFrom: |
      "Processed images and segmentation data from raw images: ${inputs.raw_images.path}"
    shellQuote: false

outputs:
  processed_images:
    type: File
    outputBinding:
      glob: processed_images.txt
  segmentation_data:
    type: File
    outputBinding:
      glob: segmentation_data.txt

stdout: segmentation_data.txt
