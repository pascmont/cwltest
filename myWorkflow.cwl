cwlVersion: v1.0
class: Workflow

inputs:
  cell_model: Any
  compound_library: Any
  assay_parameters: Any
  staining_protocol: Any
  imaging_parameters: Any

steps:
  - id: assay_design
    run: AssayDesign.cwl
    in:
      cell_model: cell_model
      assay_parameters: assay_parameters
    out: [assay_setup]

  - id: sample_preparation
    run: SamplePreparation.cwl
    in:
      assay_setup: assay_design/assay_setup
      compound_library: compound_library
    out: [prepared_samples]

  - id: image_acquisition
    run: ImageAcquisition.cwl
    in:
      prepared_samples: sample_preparation/prepared_samples
      staining_protocol: staining_protocol
      imaging_parameters: imaging_parameters
    out: [raw_images]

  - id: image_processing
    run: ImageProcessing.cwl
    in:
      raw_images: image_acquisition/raw_images
      imaging_parameters: imaging_parameters
    out: [processed_images, segmentation_data]

  - id: feature_extraction
    run: FeatureExtraction.cwl
    in:
      segmentation_data: image_processing/segmentation_data
    out: [extracted_features]

  - id: data_analysis
    run: DataAnalysis.cwl
    in:
      extracted_features: feature_extraction/extracted_features
    out: [phenotypic_profiles, hits]

  - id: biological_interpretation
    run: BiologicalInterpretation.cwl
    in:
      phenotypic_profiles: data_analysis/phenotypic_profiles
    out: [biological_insights]

  - id: reporting
    run: Reporting.cwl
    in:
      hits: data_analysis/hits
      biological_insights: biological_interpretation/biological_insights
    out: [final_report]

outputs:
  final_report: reporting/final_report
