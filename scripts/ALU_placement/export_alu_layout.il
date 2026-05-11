;; =========================================================================
;; export_alu_layout.il
;;
;; Minimal SKILL script to extract layout-only data from the ALU_8b cell
;; in Cadence Virtuoso.  This produces TWO files:
;;
;;   cell_dimensions.tsv — unique cell types with bounding-box dimensions
;;   inst_positions.tsv  — per-instance placement (origin, bbox, orient)
;;
;; These get merged with the Python-parsed netlist (parse_alu_netlist.py)
;; to produce the full blocks.tsv needed by alu_anneal.py.
;;
;; Usage in CIW (with ALU_8b layout open):
;;
;;   load("/path/to/export_alu_layout.il")
;;   aluLayoutExport("/path/to/export")
;;
;; =========================================================================

procedure(aluLDbuPerUU(cv)
  let((d)
    d = cv~>DBUPerUU
    if(d then d else 1.0)
  )
)

procedure(aluLayoutExport(outDir)
  let((layCv dbu f fDim instTab cellTab
       inst bb ox oy w h cell orient)

    layCv = geGetEditCellView()
    unless(layCv
      error("Open the ALU_8b layout first.\n")
    )

    dbu = aluLDbuPerUU(layCv)
    system(strcat("mkdir -p " outDir))

    ;; ----- inst_positions.tsv -----
    f = outfile(strcat(outDir "/inst_positions.tsv"))
    fprintf(f "inst\tlib\tcell\tview\torient\torigin_x\torigin_y\txlo\tylo\txhi\tyhi\twidth\theight\tcx\tcy\n")

    cellTab = makeTable('cellTab nil)

    foreach(inst layCv~>instances
      bb = inst~>bBox
      when(bb
        ox = car(inst~>xy) / dbu
        oy = cadr(inst~>xy) / dbu
        w  = (car(cadr(bb)) - car(car(bb))) / dbu
        h  = (cadr(cadr(bb)) - cadr(car(bb))) / dbu

        cell = if(inst~>master then inst~>master~>cellName else "")
        orient = if(inst~>orient then inst~>orient else "R0")

        fprintf(f "%s\t%s\t%s\t%s\t%s\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\n"
          inst~>name
          if(inst~>master then inst~>master~>libName else "")
          cell
          if(inst~>master then inst~>master~>viewName else "")
          orient
          ox oy
          car(car(bb)) / dbu     ;; xlo
          cadr(car(bb)) / dbu    ;; ylo
          car(cadr(bb)) / dbu    ;; xhi
          cadr(cadr(bb)) / dbu   ;; yhi
          w h
          (car(car(bb)) + car(cadr(bb))) / 2.0 / dbu    ;; cx
          (cadr(car(bb)) + cadr(cadr(bb))) / 2.0 / dbu  ;; cy
        )

        ;; Track unique cell dimensions.
        unless(cellTab[cell]
          cellTab[cell] = list(w h)
        )
      )
    )
    close(f)

    ;; ----- cell_dimensions.tsv -----
    fDim = outfile(strcat(outDir "/cell_dimensions.tsv"))
    fprintf(fDim "cell\twidth\theight\n")
    foreach(key cellTab
      let((dims)
        dims = cellTab[key]
        fprintf(fDim "%s\t%g\t%g\n" key car(dims) cadr(dims))
      )
    )
    close(fDim)

    printf("Exported layout data for %s/%s to %s\n"
      layCv~>libName layCv~>cellName outDir)
    printf("  inst_positions.tsv  (%d instances)\n" length(layCv~>instances))
    printf("  cell_dimensions.tsv\n")
  )
)
