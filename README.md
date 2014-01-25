startssl4java
=============

Commands to get a free [StartSSL](https://www.startssl.com/) host certificate and use it in Java-based applications like Jenkins. Based on `man` pages, a [gist by mgedmin](https://gist.github.com/mgedmin/7124635) and a [Stack Overflow answer by Zap](https://stackoverflow.com/a/7094044/96588).

How to use
----------

1. Modify `csr.conf` to fit your request. You'll have to modify at least the domain names.
2. Create a certificate signing request (and a new private key):

        make subdomain.example.org.csr.pem
3. Submit the resulting file contents to StartSSL (see the [gist](https://gist.github.com/mgedmin/7124635) if you're unsure).
4. Save the returned certificate as `subdomain.example.org.crt.pem`.
5. If you need the resulting certificate as a [Java KeyStore](https://en.wikipedia.org/wiki/Keystore) file:

        make subdomain.example.org.jks

You'll have to provide the KeyStore password *four times*, first twice to set up the file and import the top level CA certificate, then once to import the StartSSL server CA, then lastly to import your own certificate.
