chain_file = chain.pem
chain_content_files = ca.pem sub.class1.server.ca.pem

all:
	@echo "make either [subdomain.]hostname.csr.pem or [subdomain.]hostname.jks"

%.csr.pem:
	openssl req -config csr.conf -newkey rsa:2048 -nodes -keyout $(@:.csr.pem=.key.pem) -out $@

%.p12: %.crt.pem $(chain_file)
	openssl pkcs12 -export -chain -inkey $(subst .crt.pem,.key.pem,$<) -in $< -CAfile $(chain_file) -out $@

%.jks: %.p12
	keytool -importkeystore -srckeystore $< -srcstoretype pkcs12 -destkeystore $@

$(chain_file): $(chain_content_files)
	cat $(chain_content_files) > $@

$(chain_content_files):
	curl --output $@ https://www.startssl.com/certs/$@

clean:
	-rm $(chain_file) $(chain_content_files)
