
# Setup / Hold time of HSEL
set Tissel [expr $Tclk * 0.5]
set Tihsel [expr $Tclk * 0.03]

# Setup / Hold time of HTRANS
set Tistr [expr $Tclk * 0.5]
set Tihtr [expr $Tclk * 0.03]

# Setup / Hold time of HADDR
set Tisa [expr $Tclk * 0.5]
set Tiha [expr $Tclk * 0.03]

# Setup / Hold time of HWRITE / HSIZE / HBURST 
set Tisctl [expr $Tclk * 0.5]
set Tihctl [expr $Tclk * 0.03]

# Setup / Hold time of HWDATA
set Tiswd [expr $Tclk * 0.5]
set Tihwd [expr $Tclk * 0.03]

# Setup / Hold time of HPROT
set Tispr [expr $Tclk * 0.5]
set Tihpr [expr $Tclk * 0.03]

# Setup / Hold time of HREADY_IN
set Tisrdy [expr $Tclk * 0.5]
set Tihrdy [expr $Tclk * 0.03]

# Setup / Hold time of HMASTER
set Tismst [expr $Tclk * 0.5]
set Tihmst [expr $Tclk * 0.03]

# Output Valid / Hold time of HRESP
set Tovrsp [expr $Tclk * 0.1]
set Tohrsp [expr $Tclk * 0.05]

# Output Valid / Hold time of HREADY_OUT
set Tovrdy [expr $Tclk * 0.1]
set Tohrdy [expr $Tclk * 0.05]

# Output Valid / Hold time of HRDATA
set Tovrd [expr $Tclk * 0.1]
set Tohrd [expr $Tclk * 0.05]

# Output Valid / Hold time of HSPLIT
set Tovspt [expr $Tclk * 0.1]
set Tohspt [expr $Tclk * 0.05]

# Setup / Hold time of HGRANT
set Tisgnt [expr $Tclk * 0.5]
set Tihgnt [expr $Tclk * 0.03]

# Setup / Hold time of HRESP
set Tisrsp [expr $Tclk * 0.5]
set Tihrsp [expr $Tclk * 0.03]

# Setup / Hold time of HRDATA
set Tisrd [expr $Tclk * 0.5]
set Tihrd [expr $Tclk * 0.03]

# Output Valid / Hold time of HREQUEST
set Tovreq [expr $Tclk * 0.1]
set Tohreq [expr $Tclk * 0.05]

# Output Valid / Hold time of HLOCK
set Tovlck [expr $Tclk * 0.1]
set Tohlck [expr $Tclk * 0.05]

# Output Valid / Hold time of HADDR
set Tovadr [expr $Tclk * 0.1]
set Tohadr [expr $Tclk * 0.05]

# Output Valid / Hold time of HWRITE
set Tovctl [expr $Tclk * 0.1]
set Tohctl [expr $Tclk * 0.05]

# Output Valid / Hold time of HTRANS
set Tovtr [expr $Tclk * 0.1]
set Tohtr [expr $Tclk * 0.05]

# Output Valid / Hold time of HSIZE
set Tovctl [expr $Tclk * 0.1]
set Tohctl [expr $Tclk * 0.05]

# Output Valid / Hold time of HBURST
set Tovctl [expr $Tclk * 0.1]
set Tohctl [expr $Tclk * 0.05]

# Output Valid / Hold time of HWDATA
set Tovwd [expr $Tclk * 0.1]
set Tohwd [expr $Tclk * 0.05]

# Output Valid / Hold time of HPROT
set Tovprt [expr $Tclk * 0.1]
set Tohprt [expr $Tclk * 0.05]

# Output Valid / Hold time of HSEL
set Tovsel [expr $Tclk * 0.1]
set Tohsel [expr $Tclk * 0.05]

# Output Valid / Hold time of DMA_OUT
set Tovdmao [expr $Tclk * 0.1]
set Tohdmao [expr $Tclk * 0.05]

# Setup / Hold time of DMA_IN
set Tisdmai [expr $Tclk * 0.5]
set Tihdmai [expr $Tclk * 0.03]

