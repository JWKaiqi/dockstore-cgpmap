#!/usr/bin/env cwl-runner

class: CommandLineTool
id: "cgpmap"
label: "CGP BWA-mem mapping flow"
cwlVersion: v1.0
doc: |
    ![build_status](https://quay.io/repository/keiranmraine/cgpmap/status)
    A Docker container for the CGP BWA-mem mapping flow. See the [cgpmap](https://github.com/keiranmraine/cgpmap) website for more information.

dct:creator:
  "@id": "http://orcid.org/0000-0002-5634-1539"
  foaf:name: Keiran M Raine
  foaf:mbox: "mailto:keiranmraine@gmail.com"

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/keiranmraine/cgpmap:0.0"

hints:
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 12288 # the process requires at least 12G of RAM
    outdirMin: 5000000 # ~5GB or ref won't even fit

inputs:
  reference:
    type: File
    doc: "The core reference and BW indexes as a tar.gz"
    inputBinding:
      prefix: -reference
      position: 1
      separate: true

  sample:
    type: string
    doc: "Sample name to be included in output [B|CR]AM header, also used to name final file"
    inputBinding:
      prefix: -sample
      position: 2
      separate: true

  scramble:
    type: string
    doc: "Options to pass to scramble when generating CRAM output, see scramble docs"
    inputBinding:
      prefix: -scramble
      position: 3
      separate: true
      shellQuote: true

  bwa:
    type: string
    default: '\-Y'
    doc: "Mapping and output parameters to pass to BWA-mem, see BWA docs, default '-Y'"
    inputBinding:
      prefix: -bwa
      position: 4
      separate: true
      shellQuote: true

  cram:
    type: boolean
    doc: ""
    inputBinding:
      prefix: -cram
      position: 5

  bams_in:
    type:
      type: array
      items: File
    doc: ""
    inputBinding:
      position 6

outputs:
  mapped_out:
    type: File
    outputBinding:
      glob: $(inputs.sample).bam
    secondaryFiles:
      - .bai
      - .bas
      - .md5
      - .met


baseCommand: ["bash", "/opt/wtsi-cgp/bin/ds-wrapper.sh"]
