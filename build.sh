cd site_data
escript ../xslt_extn < pagedata.xml > fullsite.xml 2> errors.txt
xsltproc ../src/make_web2.xsl fullsite.xml > allpages.xml
escript ../xslt_extn +finaloutput < allpages.xml 
mv *.html ../html
