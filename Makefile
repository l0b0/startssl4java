all:
	@echo "make either [subdomain.]hostname.csr.pem or [subdomain.]hostname.jks"

%.csr.pem:
	openssl req -config csr.conf -newkey rsa:2048 -nodes -keyout $(@:.csr.pem=.key.pem) -out $@

%.p12: %.crt.pem chain.pem
	openssl pkcs12 -export -chain -inkey $(subst .crt.pem,.key.pem,$<) -in $< -CAfile chain.pem -out $@

%.jks: %.p12
	keytool -importkeystore -srckeystore $< -srcstoretype pkcs12 -destkeystore $@

chain.pem: ca.pem sub.class1.server.ca.pem
	cat ca.pem sub.class1.server.ca.pem > $@

sub.class1.server.ca.pem:
	curl https://www.startssl.com/certs/sub.class1.server.ca.pem > $@

ca.pem:
	curl https://www.startssl.com/certs/ca.pem > $@
