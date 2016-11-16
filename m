From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/9] PKCS#7: Handle blacklisted certificates
Date: Wed, 16 Nov 2016 18:11:06 +0000
Message-ID: <147931986662.16460.18285955227981592741.stgit@warthog.procyon.org.uk>
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

PKCS#7: Handle certificates that are blacklisted when verifying the chain
of trust on the signatures on a PKCS#7 message.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_parser.h |    1 +
 crypto/asymmetric_keys/pkcs7_verify.c |   32 ++++++++++++++++++++++++--------
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.h b/crypto/asymmetric_keys/pkcs7_parser.h
index f4e81074f5e0..ac341e19e530 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.h
+++ b/crypto/asymmetric_keys/pkcs7_parser.h
@@ -23,6 +23,7 @@ struct pkcs7_signed_info {
 	struct x509_certificate *signer; /* Signing certificate (in msg->certs) */
 	unsigned	index;
 	bool		unsupported_crypto;	/* T if not usable due to missing crypto */
+	bool		blacklisted;
 
 	/* Message digest - the digest of the Content Data (or NULL) */
 	const void	*msgdigest;
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 2ffd69769466..2d93d9eccb4d 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -190,6 +190,18 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 			 x509->subject,
 			 x509->raw_serial_size, x509->raw_serial);
 		x509->seen = true;
+
+		if (x509->blacklisted) {
+			/* If this cert is blacklisted, then mark everything
+			 * that depends on this as blacklisted too.
+			 */
+			sinfo->blacklisted = true;
+			for (p = sinfo->signer; p != x509; p = p->signer)
+				p->blacklisted = true;
+			pr_debug("- blacklisted\n");
+			return 0;
+		}
+
 		if (x509->unsupported_key)
 			goto unsupported_crypto_in_x509;
 
@@ -357,17 +369,19 @@ static int pkcs7_verify_one(struct pkcs7_message *pkcs7,
  *
  *  (*) -EBADMSG if some part of the message was invalid, or:
  *
- *  (*) -ENOPKG if none of the signature chains are verifiable because suitable
- *	crypto modules couldn't be found, or:
+ *  (*) 0 if no signature chains were found to be blacklisted or to contain
+ *	unsupported crypto, or:
  *
- *  (*) 0 if all the signature chains that don't incur -ENOPKG can be verified
- *	(note that a signature chain may be of zero length), or:
+ *  (*) -EKEYREJECTED if a blacklisted key was encountered, or:
+ *
+ *  (*) -ENOPKG if none of the signature chains are verifiable because suitable
+ *	crypto modules couldn't be found.
  */
 int pkcs7_verify(struct pkcs7_message *pkcs7,
 		 enum key_being_used_for usage)
 {
 	struct pkcs7_signed_info *sinfo;
-	int enopkg = -ENOPKG;
+	int actual_ret = -ENOPKG;
 	int ret;
 
 	kenter("");
@@ -412,6 +426,8 @@ int pkcs7_verify(struct pkcs7_message *pkcs7,
 
 	for (sinfo = pkcs7->signed_infos; sinfo; sinfo = sinfo->next) {
 		ret = pkcs7_verify_one(pkcs7, sinfo);
+		if (sinfo->blacklisted && actual_ret == -ENOPKG)
+			actual_ret = -EKEYREJECTED;
 		if (ret < 0) {
 			if (ret == -ENOPKG) {
 				sinfo->unsupported_crypto = true;
@@ -420,11 +436,11 @@ int pkcs7_verify(struct pkcs7_message *pkcs7,
 			kleave(" = %d", ret);
 			return ret;
 		}
-		enopkg = 0;
+		actual_ret = 0;
 	}
 
-	kleave(" = %d", enopkg);
-	return enopkg;
+	kleave(" = %d", actual_ret);
+	return actual_ret;
 }
 EXPORT_SYMBOL_GPL(pkcs7_verify);
 
