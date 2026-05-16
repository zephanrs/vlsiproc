; Read-only CDF/terminal-order checker for the active processor libraries.
; Run from /home/dnb68/processor/cadence with:
;   virtuoso -nograph -restore check_cdf.il

procedure(cxNamesFromTerms(terms)
  foreach(mapcar term terms term~>name)
)

procedure(cxOpenTerms(libName cellName viewName)
  let((cv names)
    cv = dbOpenCellViewByType(libName cellName viewName "" "r")
    when(cv
      names = cxNamesFromTerms(cv~>terminals)
      dbClose(cv)
    )
    names
  )
)

procedure(cxPrintList(out label vals)
  fprintf(out "  %s: " label)
  if(vals then fprintf(out "%L\n" vals) else fprintf(out "nil\n"))
)

procedure(cxPrintCDF(out libName cellName)
  let((cellObj cdf simInfo)
    fprintf(out "\nCELL %s/%s\n" libName cellName)
    cellObj = ddGetObj(libName cellName)
    unless(cellObj
      fprintf(out "  cell object missing\n")
    )
    when(cellObj
      cdf = cdfGetBaseCellCDF(cellObj)
      unless(cdf
        fprintf(out "  CDF: missing\n")
      )
      when(cdf
        fprintf(out "  CDF: present\n")
      )
      cxPrintList(out "symbol terminals" cxOpenTerms(libName cellName "symbol"))
      cxPrintList(out "schematic terminals" cxOpenTerms(libName cellName "schematic"))
      cxPrintList(out "av_extracted terminals" cxOpenTerms(libName cellName "av_extracted"))
      cxPrintList(out "functional terminals" cxOpenTerms(libName cellName "functional"))
      when(cdf
        simInfo = cdf~>simInfo
        fprintf(out "  simInfo: %L\n" simInfo)
      )
    )
  )
)

procedure(cxRun()
  let((out processorCells stdCells)
    out = outfile("/home/dnb68/processor/cadence/cdf_check_report.txt" "w")
    fprintf(out "CDF/terminal-order report\n")
    processorCells = list(
      "Proc" "ProcDpath" "ProcCtrl" "ProcClkTree" "TestMemory"
      "ALU_8b" "Regfile" "Register_8b" "Register_16b_ena"
      "Mux2_8b" "Mux4_8b" "Inv1x_8b" "Inv4x_8b"
      "Imm_Gen" "Incrementer_4b" "reg_ena" "reg_rst_4b"
      "read_decoder" "write_decoder" "RFslice"
    )
    stdCells = list("inv_x1" "inv_x4" "Mux2" "FullAdder" "FF_reset")
    foreach(cell processorCells cxPrintCDF(out "processor" cell))
    foreach(cell stdCells cxPrintCDF(out "standard_cells" cell))
    close(out)
  )
)

cxRun()
exit()
