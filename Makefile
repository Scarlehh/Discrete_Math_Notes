SRC = main.tex

.PHONY: all
all:
	pdflatex $(SRC)
	pdflatex $(SRC)
	mv main.pdf Discrete_Math_Notes.pdf

.PHONY: clean
clean:
	rm *.log
	rm *.aux
	rm *.out
	rm *.toc
