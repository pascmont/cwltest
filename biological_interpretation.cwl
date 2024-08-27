cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo

inputs:
  phenotypic_profiles:
    type: File

arguments:
  - valueFrom: "Interpreted biological insights from phenotypic profiles: ${inputs.phenotypic_profiles.path}"
    shellQuote: false

outputs:
  biological_insights:
    type: File
    outputBinding:
      glob: biological_insights.txt

stdout: biological_insights.txt
