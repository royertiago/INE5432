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

all:
	latexmk -pdf

# For some reason, .nav and .snm files are not cleaned by latexmk.
# So, we do by hand.
mostlyclean:
	$(call clean-section,LaTeX temporaries)

clean: mostlyclean
	$(call clean-section,Binary output)
