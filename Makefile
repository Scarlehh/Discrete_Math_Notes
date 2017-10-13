SRC = Discrete_Math_Notes.tex

.PHONY: all
all:
	pdflatex $(SRC)
	pdflatex $(SRC)

.PHONY: clean
clean:
	rm *.log
	rm *.aux
	rm *.out
	rm *.toc
