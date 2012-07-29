# Format of intel-ref.txt: FILENAME;LINE;INST;Desc
.PHONY: all clean reallyclean install
all: intel-ref.txt 

PDFS=$(wildcard intelref_*.pdf)
PDFXML=$(patsubst %.pdf,%.xml2,$(PDFS))
PDFTXT=$(patsubst %.xml2,%.txt,$(PDFXML))
DESTDIR?=/usr/local

.PRECIOUS: %.xml2
%.xml2: %.pdf
	dumppdf -T $^ | xml2 > $@

%.txt: %.xml2
	cat $^ | \
		awk -F= \
			'/@title/{ \
				if (!match($$2,"^(Chapter|[0-9])")) \
					title=$$2 \
			} \
			/pageno/{ \
				if (title) \
					printf("%s;%s\n",$$2,title); \
				title="" \
			}' | \
		sed -e 's/^/$(patsubst %.xml2,%.pdf,$^);/' -e 's/-/;/' > $@.tmp || exit 1
	mv $@.tmp $@


intel-ref.txt: $(PDFTXT)
	cat $^ > $@

clean:
	rm -f $(PDFTXT)

reallyclean: clean
	rm -f $(PDFXML)

cleaninstall:
	rm -rf $(DESTDIR)/share/intel-ref
	rm -f $(DESTDIR)/bin/intel-ref

INTELREF = \
\#!/bin/bash\n\
cd $(DESTDIR)/share/intel-ref\n\
opcode=\`echo \$$1 | tr [a-z] [A-Z]\`\n\
pdf2txt -p \`awk -F';' '\$$3~'/\$$opcode/'{print \$$2+1,\$$1}' IGNORECASE=1 intel-ref.txt\`\n
#

install: intel-ref.txt $(PDFS)
	mkdir -p $(DESTDIR)/share/intel-ref
	cp -a $^ $(DESTDIR)/share/intel-ref
	mkdir -p $(DESTDIR)/bin
	echo "$(INTELREF)" | sed -e 's/^[ ]//' > $(DESTDIR)/bin/intel-ref
	chmod +x $(DESTDIR)/bin/intel-ref

