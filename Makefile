
xslt_extn: ebin/xslt_extn.beam
	./mad release script xslt_extn
ebin/%.beam: src/%.erl
	erlc -o ebin $<
html/%.xhtml: clean site_data/%.xml site_data/pagedata.xml xslt_extn
	sh build.sh 
.PHONY:clean
clean:
	-rm ebin/*.beam
	-rm -v site_data/fullsite.xml site_data/errors.txt site_data/allpages.xml site_data/logfile site_data/*.html site_data/*.xhtml
	-rm html/*.xhtml
