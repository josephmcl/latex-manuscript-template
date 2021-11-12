output   := manuscript
builddir := build
texdir   := tex
infile   := paper
genfile  := $(infile).generated
texext   := tex
auxext   := aux
pdfext   := pdf
cc       := xelatex
bc       := bibtex
cflags   := -output-directory=./$(builddir) -jobname=$(output)
.texs    := $(sort \
			$(shell find ./$(texdir)/ \
		 		-type f \
		 		-not -path "./$(texdir)//.*" \
		 		-name "*_.tex"))
null  	 :=
space 	 := $(null) $(null)
metafile := ./$(texdir)//.Meta/_.$(texext)
bibfile  := ./$(texdir)//.Bibliography/_.$(texext)

.texz 	 := \\input{$(subst \
				$(space),}\\n\\input{,$(strip \
					$(.texs)))}\\n

texcontent += "\\\\input{$(metafile)}\n"
texcontent += "\\\\begin{document}\n"
texcontent += $(.texz)
texcontent += "\\\\input{$(bibfile)}\n"
texcontent += "\\\\end{document}\n"
texcontent := $(subst $(space),$(null),$(strip $(texcontent)))

all: build
.PHONY: clean
build: 
	if [ ! -d "./$(builddir)" ]; then mkdir ./$(builddir); fi
	@echo $(texcontent) > "./$(builddir)/$(genfile).$(texext)"
	$(cc) $(cflags) ./$(builddir)/$(genfile).$(texext)
	$(bc) ./$(builddir)/$(output).$(auxext)
	$(cc) $(cflags) ./$(builddir)/$(genfile).$(texext)
	$(cc) $(cflags) ./$(builddir)/$(genfile).$(texext)
view: 
	open ./$(builddir)/$(output).$(pdfext)
clean:
	rm -rf ./$(builddir)
