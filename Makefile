all:
	@echo "make either [subdomain.]hostname.csr.pem or [subdomain.]hostname.jks"

%.csr.pem:
	openssl req -config csr.conf -newkey rsa:2048 -nodes -keyout $(@:.csr.pem=.key.pem) -out $@

%.jks: %.crt.pem ca.pem sub.class1.server.ca.pem
	keytool -importcert -alias ca -file ca.pem -keystore $@
	keytool -importcert -alias sub.class1.server.ca -file sub.class1.server.ca.pem -keystore $@
	keytool -importcert -trustcacerts -alias $(@:.jks=) -file $< -keystore $@

sub.class1.server.ca.pem:
	curl https://www.startssl.com/certs/sub.class1.server.ca.pem > $@

ca.pem:
	curl https://www.startssl.com/certs/ca.pem > $@
