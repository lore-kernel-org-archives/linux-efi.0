From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/9] X.509: Allow X.509 certs to be blacklisted
Date: Wed, 16 Nov 2016 18:10:59 +0000
Message-ID: <147931985960.16460.11893119915668524284.stgit@warthog.procyon.org.uk>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: dhowells@redhat.com, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Allow X.509 certs to be blacklisted based on their TBSCertificate hash.
This is convenient since we have to determine this anyway to be able to
check the signature on an X.509 certificate.  This is also what UEFI uses
in its blacklist.

If a certificate built into the kernel is blacklisted, something like the
following might then be seen during boot:

	X.509: Cert 123412341234c55c1dcc601ab8e172917706aa32fb5eaf826813547fdf02dd46 is blacklisted
	Problem loading in-kernel X.509 certificate (-129)

where the hex string shown is the blacklisted hash.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/x509_parser.h     |    1 +
 crypto/asymmetric_keys/x509_public_key.c |   15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 05eef1c68881..e373e7483812 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -42,6 +42,7 @@ struct x509_certificate {
 	bool		self_signed;		/* T if self-signed (check unsupported_sig too) */
 	bool		unsupported_key;	/* T if key uses unsupported crypto */
 	bool		unsupported_sig;	/* T if signature uses unsupported crypto */
+	bool		blacklisted;
 };
 
 /*
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index fb732296cd36..eea71dc9686c 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -84,6 +84,16 @@ int x509_get_sig_params(struct x509_certificate *cert)
 		goto error_2;
 	might_sleep();
 	ret = crypto_shash_finup(desc, cert->tbs, cert->tbs_size, sig->digest);
+	if (ret < 0)
+		goto error_2;
+
+	ret = is_hash_blacklisted(sig->digest, sig->digest_size, "tbs");
+	if (ret == -EKEYREJECTED) {
+		pr_err("Cert %*phN is blacklisted\n",
+		       sig->digest_size, sig->digest);
+		cert->blacklisted = true;
+		ret = 0;
+	}
 
 error_2:
 	kfree(desc);
@@ -186,6 +196,11 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 			 cert->sig->pkey_algo, cert->sig->hash_algo);
 	}
 
+	/* Don't permit addition of blacklisted keys */
+	ret = -EKEYREJECTED;
+	if (cert->blacklisted)
+		goto error_free_cert;
+
 	/* Propose a description */
 	sulen = strlen(cert->subject);
 	if (cert->raw_skid) {
