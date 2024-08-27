cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo

inputs:
  hits:
    type: File
  biological_insights:
    type: File

arguments:
  - valueFrom: |
      "Final report with hits and biological insights:
      Hits: ${inputs.hits.path}
      Biological Insights: ${inputs.biological_insights.path}"
    shellQuote: false

outputs:
  final_report:
    type: File
    outputBinding:
      glob: final_report.txt

stdout: final_report.txt
