#!/usr/bin/env cwl-runner

class: CommandLineTool

dct:contributor:
  foaf:name: Andy Yang
  foaf:mbox: mailto:ayang@oicr.on.ca
dct:creator:
  '@id': http://orcid.org/0000-0001-9102-5681
  foaf:name: Andrey Kartashov
  foaf:mbox: mailto:Andrey.Kartashov@cchmc.org
dct:description: 'Developed at Cincinnati Children’s Hospital Medical Center for the
  CWL consortium http://commonwl.org/ Original URL: https://github.com/common-workflow-language/workflows'
cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: quay.io/cancercollaboratory/dockstore-tool-liftover
inputs:
  genePred:
    type: boolean?
    inputBinding:
      position: 1
      prefix: -genePred
    doc: |
      File is in genePred format
  multiple:
    type: boolean?
    inputBinding:
      position: 1
      prefix: -multiple
    doc: |
      Allow multiple output regions
  tab:
    type: boolean?
    inputBinding:
      position: 1
      prefix: -tab
  ends:
    type: int?
    inputBinding:
      separate: false
      position: 1
      prefix: -ends=
    doc: |
      =N - Lift the first and last N bases of each record and combine the
               result. This is useful for lifting large regions like BAC end pairs.
  positions:
    type: boolean?
    inputBinding:
      position: 1
      prefix: -positions
    doc: |
      File is in browser "position" format
  chainTable:
    type: string?
    inputBinding:
      position: 1
      prefix: -chainTable
    doc: |
      Min matching region size in query with -multiple.
  fudgeThick:
    type: boolean?
    inputBinding:
      position: 1
      prefix: -fudgeThick
    doc: |
      (bed 12 or 12+ only) If thickStart/thickEnd is not mapped,
                    use the closest mapped base.  Recommended if using
                    -minBlocks.
  hasBin:
    type: boolean?
    inputBinding:
      position: 1
      prefix: -hasBin
    doc: |
      File has bin value (used only with -bedPlus)
  minChainQ:
    type: int?
    inputBinding:
      position: 1
      prefix: -minChainQ
    doc: |
      Minimum chain size in target/query, when mapping
                             to multiple output regions (default 0, 0)
  sample:
    type: boolean?
    inputBinding:
      position: 1
      prefix: -sample
    doc: |
      File is in sample format
  minChainT:
    type: int?
    inputBinding:
      position: 1
      prefix: -minChainT
    doc: |
      Minimum chain size in target/query, when mapping
                             to multiple output regions (default 0, 0)
  minSizeQ:
    type: int?
    inputBinding:
      position: 1
      prefix: -minSizeQ
    doc: |
      Min matching region size in query with -multiple.
  oldFile:
    type: File
    inputBinding:
      position: 2

  unMapped:
    type: string
    inputBinding:
      position: 5

  mapChain:
    type: File
    inputBinding:
      position: 3

    doc: |
      The map.chain file has the old genome as the target and the new genome
      as the query.
  pslT:
    type: boolean?
    inputBinding:
      position: 1
      prefix: -pslT
    doc: |
      File is in psl format, map target side only
  minMatch:
    type: int?
    inputBinding:
      separate: false
      position: 1
      prefix: -minMatch=
    doc: |
      -minMatch=0.N Minimum ratio of bases that must remap. Default 0.95
  gff:
    type: boolean?
    inputBinding:
      position: 1
      prefix: -gff
    doc: |
      File is in gff/gtf format.  Note that the gff lines are converted
       separately.  It would be good to have a separate check after this
       that the lines that make up a gene model still make a plausible gene
       after liftOver
  minBlocks:
    type: int?
    inputBinding:
      separate: false
      position: 1
      prefix: -minBlocks=
    doc: |
      .N Minimum ratio of alignment blocks or exons that must map
                    (default 1.00)
  bedPlus:
    type: int?
    inputBinding:
      separate: false
      position: 1
      prefix: -bedPlus=
    doc: |
      =N - File is bed N+ format
  newFile:
    type: string
    inputBinding:
      position: 4

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.newFile)

    doc: The sorted file
  unMappedFile:
    type: File
    outputBinding:
      glob: $(inputs.unMapped)


    doc: The sorted file
baseCommand: [liftOver]
doc: |
  Move annotations from one assembly to another

  usage:
     liftOver oldFile map.chain newFile unMapped
  oldFile and newFile are in bed format by default, but can be in GFF and
  maybe eventually others with the appropriate flags below.
  The map.chain file has the old genome as the target and the new genome
  as the query.

  ***********************************************************************
  WARNING: liftOver was only designed to work between different
           assemblies of the same organism. It may not do what you want
           if you are lifting between different organisms. If there has
           been a rearrangement in one of the species, the size of the
           region being mapped may change dramatically after mapping.
  ***********************************************************************

