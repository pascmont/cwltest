cwlVersion: v1.2
class: Workflow
doc: |
  Workflow for the synthesis and purification of 5-methoxytryptamine, based on a series of chemical reactions, extractions, filtrations, and other unit operations.

inputs:
  input_water: 
    type: File
    doc: "Water input file."
  input_phosphoric_acid: 
    type: File
    doc: "Phosphoric acid input file."
  input_sulfuric_acid: 
    type: File
    doc: "Sulfuric acid input file."
  input_int5: 
    type: File
    doc: "Intermediate 5 input file."
  input_dichloromethane: 
    type: File
    doc: "Dichloromethane input file."
  input_naoh: 
    type: File
    doc: "Sodium hydroxide solution input file."
  input_acetic_acid: 
    type: File
    doc: "Acetic acid input file."
  input_charcoal: 
    type: File
    doc: "Activated charcoal input file."
  input_methanol: 
    type: File
    doc: "Methanol input file."
  input_toluene: 
    type: File
    doc: "Toluene input file."

outputs:
  final_product:
    type: File
    outputSource: drying/output_product
    doc: "Final dried 5-methoxytryptamine product."

steps:
  acidic_solution_formation:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python3, create_acidic_solution.py]
      inputs:
        water_input:
          type: File
        phosphoric_acid_input:
          type: File
        sulfuric_acid_input:
          type: File
      outputs:
        acidic_solution:
          type: File
          outputBinding:
            glob: acidic_solution.txt
    in:
      water_input: input_water
      phosphoric_acid_input: input_phosphoric_acid
      sulfuric_acid_input: input_sulfuric_acid
    out: [acidic_solution]

  int5_addition_and_reaction:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python3, add_int5_and_react.py]
      inputs:
        acidic_solution:
          type: File
        int5_input:
          type: File
      outputs:
        reaction_mixture:
          type: File
          outputBinding:
            glob: reaction_mixture.txt
    in:
      acidic_solution: acidic_solution_formation/acidic_solution
      int5_input: input_int5
    out: [reaction_mixture]

  first_organic_washing:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python3, perform_washing.py]
      inputs:
        reaction_mixture:
          type: File
        dichloromethane_input:
          type: File
      outputs:
        washed_mixture:
          type: File
          outputBinding:
            glob: washed_mixture.txt
    in:
      reaction_mixture: int5_addition_and_reaction/reaction_mixture
      dichloromethane_input: input_dichloromethane
    out: [washed_mixture]

  ph_adjustment:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python3, adjust_ph.py]
      inputs:
        washed_mixture:
          type: File
        naoh_input:
          type: File
      outputs:
        adjusted_solution:
          type: File
          outputBinding:
            glob: adjusted_solution.txt
    in:
      washed_mixture: first_organic_washing/washed_mixture
      naoh_input: input_naoh
    out: [adjusted_solution]

  filtration:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python3, perform_filtration.py]
      inputs:
        adjusted_solution:
          type: File
      outputs:
        crude_solid:
          type: File
          outputBinding:
            glob: crude_solid.txt
    in:
      adjusted_solution: ph_adjustment/adjusted_solution
    out: [crude_solid]

  re_slurry:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python3, perform_re_slurry.py]
      inputs:
        crude_solid:
          type: File
      outputs:
        slurry_solid:
          type: File
          outputBinding:
            glob: slurry_solid.txt
    in:
      crude_solid: filtration/crude_solid
    out: [slurry_solid]

  reprecipitation:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python3, perform_reprecipitation.py]
      inputs:
        slurry_solid:
          type: File
        acetic_acid_input:
          type: File
        naoh_input:
          type: File
      outputs:
        reprecipitated_solid:
          type: File
          outputBinding:
            glob: reprecipitated_solid.txt
    in:
      slurry_solid: re_slurry/slurry_solid
      acetic_acid_input: input_acetic_acid
      naoh_input: input_naoh
    out: [reprecipitated_solid]

  decolorization:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python3, perform_decolorization.py]
      inputs:
        reprecipitated_solid:
          type: File
        charcoal_input:
          type: File
        methanol_input:
          type: File
      outputs:
        decolorized_solid:
          type: File
          outputBinding:
            glob: decolorized_solid.txt
    in:
      reprecipitated_solid: reprecipitation/reprecipitated_solid
      charcoal_input: input_charcoal
      methanol_input: input_methanol
    out: [decolorized_solid]

  concentration:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python3, perform_concentration.py]
      inputs:
        decolorized_solid:
          type: File
      outputs:
        concentrated_solid:
          type: File
          outputBinding:
            glob: concentrated_solid.txt
    in:
      decolorized_solid: decolorization/decolorized_solid
    out: [concentrated_solid]

  solvent_exchange:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python3, perform_solvent_exchange.py]
      inputs:
        concentrated_solid:
          type: File
        toluene_input:
          type: File
      outputs:
        exchanged_solid:
          type: File
          outputBinding:
            glob: exchanged_solid.txt
    in:
      concentrated_solid: concentration/concentrated_solid
      toluene_input: input_toluene
    out: [exchanged_solid]

  drying:
    run:
      cwlVersion: v1.2
      class: CommandLineTool
      baseCommand: [python3, perform_drying.py]
      inputs:
        exchanged_solid:
          type: File
      outputs:
        output_product:
          type: File
          outputBinding:
            glob: final_product.txt
    in:
      exchanged_solid: solvent_exchange/exchanged_solid
    out: [output_product]
