cwlVersion: v1.0
class: Workflow

inputs: {}

steps:
  - id: assay_design
    run:
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
    in: {}
    out: [assay_setup]

  - id: sample_preparation
    run:
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
    in:
      assay_setup: assay_design/assay_setup
    out: [prepared_samples]

  - id: image_acquisition
    run:
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
    in:
      prepared_samples: sample_preparation/prepared_samples
    out: [raw_images]

  - id: image_processing
    run:
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
    in:
      raw_images: image_acquisition/raw_images
    out: [processed_images, segmentation_data]

  - id: feature_extraction
    run:
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
    in:
      segmentation_data: image_processing/segmentation_data
    out: [extracted_features]

  - id: data_analysis
    run:
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
    in:
      extracted_features: feature_extraction/extracted_features
    out: [phenotypic_profiles, hits]

  - id: biological_interpretation
    run:
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
    in:
      phenotypic_profiles: data_analysis/phenotypic_profiles
    out: [biological_insights]

  - id: reporting
    run:
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
    in:
      hits: data_analysis
