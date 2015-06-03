define clean-section
set -f; \
pattern_list=$$( \
	sed '0,/^# $(1)$$/d' .gitignore \
	| sed '/^$$/,$$d' \
); \
for pattern in $$pattern_list; do \
	find -name $$pattern -exec rm {} +; \
done
endef

define dirss
$(patsubst %/,%,$(dir $1))
endef

TEX := $(shell find . -name "*.tex" -exec \
	grep --files-with-matches '^\\end{document}$$' {} +)

# Dependências
DEP := $(TEX:%.tex=%.dep.mk)

PDF := $(TEX:%.tex=%.pdf)

# Regras

.DEFAULT_GOAL := all

all: $(PDF)

$(DEP): %.dep.mk:

$(PDF): %.pdf: %.dep.mk
	latexmk -pdf   -M -MF $*.dep.mk -MP   $*.tex   -g\
		-outdir=$(call dirss, $*.pdf) -auxdir=$(call dirss $*.pdf)
	touch $*.pdf

mostlyclean:
	$(call clean-section,LaTeX temporaries)

clean: mostlyclean
	$(call clean-section,Binary output)
