cwlVersion: v1.0
class: Workflow

inputs: {}

steps:
  - id: assay_design
    run: assay_design.cwl
    in: {}
    out: [assay_setup]

  - id: sample_preparation
    run: sample_preparation.cwl
    in:
      assay_setup: assay_design/assay_setup
    out: [prepared_samples]

  - id: image_acquisition
    run: image_acquisition.cwl
    in:
      prepared_samples: sample_preparation/prepared_samples
    out: [raw_images]

  - id: image_processing
    run: image_processing.cwl
    in:
      raw_images: image_acquisition/raw_images
    out: [processed_images, segmentation_data]

  - id: feature_extraction
    run: feature_extraction.cwl
    in:
      segmentation_data: image_processing/segmentation_data
    out: [extracted_features]

  - id: data_analysis
    run: data_analysis.cwl
    in:
      extracted_features: feature_extraction/extracted_features
    out: [phenotypic_profiles, hits]

  - id: biological_interpretation
    run: biological_interpretation.cwl
    in:
      phenotypic_profiles: data_analysis/phenotypic_profiles
    out: [biological_insights]

  - id: reporting
    run: reporting.cwl
    in:
      hits: data_analysis/hits
      biological_insights: biological_interpretation/biological_insights
    out: [final_report]

outputs:
  final_report: reporting/final_report
