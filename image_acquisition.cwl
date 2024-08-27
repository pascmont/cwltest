cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo

inputs:
  prepared_samples:
    type: File

arguments:
  - valueFrom: "Captured images from prepared samples: ${inputs.prepared_samples.path}"
    shellQuote: false

outputs:
  raw_images:
    type: File
    outputBinding:
      glob: raw_images.txt

stdout: raw_images.txt
