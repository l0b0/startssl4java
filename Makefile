all:
	@echo "make either [subdomain.]hostname.csr.pem or [subdomain.]hostname.jks"

%.csr.pem:
	openssl req -config csr.conf -newkey rsa:2048 -nodes -keyout $(@:.csr.pem=.key.pem) -out $@

%.p12: %.crt.pem
	openssl pkcs12 -export -inkey $(subst .crt.pem,.key.pem,$<) -in $< -out $@

%.jks: %.p12 ca.pem sub.class1.server.ca.pem
	keytool -importkeystore -srckeystore $< -srcstoretype pkcs12 -destkeystore $@

sub.class1.server.ca.pem:
	curl https://www.startssl.com/certs/sub.class1.server.ca.pem > $@

ca.pem:
	curl https://www.startssl.com/certs/ca.pem > $@
