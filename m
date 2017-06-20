From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Problem with new X.509 is_hash_blacklisted() interface
Date: Tue, 20 Jun 2017 17:09:43 +0100
Message-ID: <26151.1497974983@warthog.procyon.org.uk>
References: <1495897525.3458.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495897525.3458.7.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Content-ID: <26150.1497974983.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:

> Added by
> 
> commit 436529562df2748fd9918f578205b22cf8ced277
> Author: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Mon Apr 3 16:07:25 2017 +0100
> 
>     X.509: Allow X.509 certs to be blacklisted
>  
> Ironically it duplicates a UEFI bug we've been struggling with for a
> while in the pkcs11 handlers:  namely if you have a blacklist based on
> certificate hashes, an interface which only takes a hash cannot
> definitively tell you if the certificate is on the blacklist or not
> because the hash the cert is blacklisted by may be a different
> algorithm from the hash you feed in to is_hash_blacklisted().  This
> means that the only safe way to use the interface is to construct every
> possible hash of the cert and feed them one at a time into
> is_hash_blacklisted().  This makes it an almost unusable API.
> 
> I suggest you deprecate this interface immediately and introduce an
> is_cert_blacklisted() one which takes a pointer to the TBS data.  Then
> the implementation can loop over the blacklists, see the hash type and
> construct the hash of the TBS data for comparison (caching the hashes
> for efficiency).  That way you'll be assured of a definitive answer and
> an easy API.
> 
> It might be reasonable to cc linux-efi on future kernel keyring stuff,
> because some of the other issues may have also come up in the UEFI
> keyrings.

You should also cc keyrings and possibly l-s-m.

How about the attached patch?

David
---
KEYS: Make the blacklisting check all possible types of hash

The blacklisting facility is not limited to hashes of a specific type, so
certificate and message blocks that need to be checked may have to be
checked against hashes of more than one hash type.

Make the blacklisting facility check all the types of hash it has blacklist
entries for.

To this end:

 (1) Blacklist type key names now can take an optional type name at the
     end:

        "<type>:<hash-as-hex>[:<algo>]"

     If the algorithm is omitted, it's assumed to refer to a shaNNN
     algorithm, where NNN is defined by the number of bits in the hex hash.

 (2) mark_hash_blacklisted() maintains a list of types we've marked.  Only
     this function can modify the blacklist keyring, so this is an good
     place to do it.

     Adding to the list in the blacklist key type ops would allow userspace
     to add an unlimited number of type names to the list.

 (3) is_hash_blacklisted() is given an extra parameter for the hash
     algorithm name.  It will now check for a matching description with the
     algorithm name attached and then, if the algorithm name begins "sha",
     it will chop off the algorithm name and try that too.

 (4) is_data_blacklisted() is added to iterate through all the known
     blacklist hashes, for which it will hash the data it is given and
     invoke is_hash_blacklisted() on the digest it obtained.

     This can be told to skip a particular algorithm for when the caller
     has one precalculated.  The precalculated hash can be passed to
     is_hash_blacklisted().  This would typically be the case for a signed
     X.509 message.

Fixes: 734114f8782f ("KEYS: Add a system blacklist keyring")
Suggested-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 certs/blacklist.c                        |  263 +++++++++++++++++++++++++++++--
 crypto/asymmetric_keys/x509_public_key.c |   24 ++
 include/keys/system_keyring.h            |   11 +
 3 files changed, 279 insertions(+), 19 deletions(-)

diff --git a/certs/blacklist.c b/certs/blacklist.c
index 3a507b9e2568..3be5ae5e5606 100644
--- a/certs/blacklist.c
+++ b/certs/blacklist.c
@@ -18,14 +18,42 @@
 #include <linux/ctype.h>
 #include <linux/err.h>
 #include <linux/seq_file.h>
+#include <crypto/hash.h>
 #include <keys/system_keyring.h>
 #include "blacklist.h"
 
+struct blacklist_hash {
+	struct blacklist_hash *next;
+	u8 name_len;
+	char name[];
+};
+
 static struct key *blacklist_keyring;
+static struct blacklist_hash blacklist_sha256 = { NULL, 6, "sha256" };
+static struct blacklist_hash *blacklist_hash_types = &blacklist_sha256;
+static DEFINE_SPINLOCK(blacklist_hash_types_lock);
+
+static const struct blacklist_hash *blacklist_hash_type(const char *hash_algo,
+							size_t name_len)
+{
+	const struct blacklist_hash *bhash;
+
+	bhash = blacklist_hash_types;
+	smp_rmb(); /* Content after pointer.  List tail is immutable */
+	for (; bhash; bhash = bhash->next)
+		if (name_len == bhash->name_len &&
+		    memcmp(hash_algo, bhash->name, name_len) == 0)
+			return bhash;
+	return NULL;
+}
 
 /*
  * The description must be a type prefix, a colon and then an even number of
- * hex digits.  The hash is kept in the description.
+ * hex digits then optionally another colon and the hash type.  If the hash
+ * type isn't specified, it's assumed to be SHAnnn where nnn is the number of
+ * bits in the hash.
+ *
+ * The hash data is kept in the description.
  */
 static int blacklist_vet_description(const char *desc)
 {
@@ -42,13 +70,18 @@ static int blacklist_vet_description(const char *desc)
 	desc++;
 	for (; *desc; desc++) {
 		if (!isxdigit(*desc))
-			return -EINVAL;
+			goto found_hash_algo;
 		n++;
 	}
 
 	if (n == 0 || n & 1)
 		return -EINVAL;
 	return 0;
+
+found_hash_algo:
+	if (*desc != ':')
+		return -EINVAL;
+	return 0;
 }
 
 /*
@@ -80,13 +113,115 @@ static struct key_type key_type_blacklist = {
 	.describe		= blacklist_describe,
 };
 
+/*
+ * Extract the type.
+ */
+static const char *blacklist_extract_type(const char *desc, size_t *_len)
+{
+	const char *h, *algo;
+	size_t len;
+
+	/* Prepare a hash record if this is a new hash.  It may be discarded
+	 * during instantiation if we find we raced with someone else.
+	 */
+	h = strchr(desc, ':');
+	if (!h)
+		return NULL;
+	h++;
+	algo = strchr(h, ':');
+	if (algo) {
+		algo++;
+		len = strlen(algo);
+		if (len <= 0 || len > 255)
+			return NULL;
+	} else {
+		/* The hash wasn't specified - assume it to be the SHA with the
+		 * same number of bits as the hash data.
+		 */
+		len = strlen(h) * 4;
+		switch (len) {
+		case 160:
+			algo = "sha1";
+			break;
+		case 224:
+			algo = "sha224";
+			break;
+		case 256:
+			algo = "sha256";
+			break;
+		case 384:
+			algo = "sha384";
+			break;
+		case 512:
+			algo = "sha512";
+			break;
+		default:
+			return NULL;
+		}
+	}
+
+	*_len = strlen(algo);
+	return algo;
+}
+
+/*
+ * Make sure the type is listed.
+ */
+static int blacklist_add_type(const char *desc)
+{
+	struct blacklist_hash *bhash;
+	const char *algo;
+	size_t len;
+
+	algo = blacklist_extract_type(desc, &len);
+	if (!algo)
+		return -EINVAL;
+
+	if (blacklist_hash_type(algo, len))
+		return 0;
+
+	bhash = kmalloc(sizeof(*bhash) + len + 1, GFP_KERNEL);
+	if (!bhash)
+		return -ENOMEM;
+	memcpy(bhash->name, algo, len);
+	bhash->name[len] = 0;
+
+	spin_lock(&blacklist_hash_types_lock);
+	if (!blacklist_hash_type(bhash->name, bhash->name_len)) {
+		bhash->next = blacklist_hash_types;
+		smp_wmb(); /* Content before pointer */
+		blacklist_hash_types = bhash;
+		bhash = NULL;
+	}
+	spin_unlock(&blacklist_hash_types_lock);
+
+	kfree(bhash);
+	return 0;
+}
+
 /**
  * mark_hash_blacklisted - Add a hash to the system blacklist
- * @hash - The hash as a hex string with a type prefix (eg. "tbs:23aa429783")
+ * @hash - The hash as a formatted string.
+ *
+ * The hash string is formatted as:
+ *
+ *	"<type>:<hash-as-hex>[:<algo>]"
+ *
+ * Where <algo> is optional and defaults to shaNNN where NNN is the number of
+ * bits in hash-as-hex, eg.:
+ *
+ *	"tbs:23aa429783:foohash"
+ *
+ * The hash must have all leading zeros present.
  */
 int mark_hash_blacklisted(const char *hash)
 {
 	key_ref_t key;
+	int ret;
+
+	ret = blacklist_add_type(hash);
+	if (ret < 0)
+		return ret;
 
 	key = key_create_or_update(make_key_ref(blacklist_keyring, true),
 				   "blacklist",
@@ -109,15 +244,18 @@ int mark_hash_blacklisted(const char *hash)
  * @hash: The hash to be checked as a binary blob
  * @hash_len: The length of the binary hash
  * @type: Type of hash
+ * @hash_algo: Hash algorithm used
  */
-int is_hash_blacklisted(const u8 *hash, size_t hash_len, const char *type)
+int is_hash_blacklisted(const u8 *hash, size_t hash_len, const char *type,
+			const char *hash_algo)
 {
 	key_ref_t kref;
-	size_t type_len = strlen(type);
+	size_t type_len = strlen(type), hash_algo_len = strlen(hash);
 	char *buffer, *p;
 	int ret = 0;
 
-	buffer = kmalloc(type_len + 1 + hash_len * 2 + 1, GFP_KERNEL);
+	buffer = kmalloc(type_len + 1 + hash_len * 2 + 1 + hash_algo_len + 1,
+			 GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 	p = memcpy(buffer, type, type_len);
@@ -125,21 +263,126 @@ int is_hash_blacklisted(const u8 *hash, size_t hash_len, const char *type)
 	*p++ = ':';
 	bin2hex(p, hash, hash_len);
 	p += hash_len * 2;
-	*p = 0;
+	*p++ = ':';
+	p = memcpy(p, hash_algo, hash_algo_len);
+	p[hash_algo_len] = 0;
 
 	kref = keyring_search(make_key_ref(blacklist_keyring, true),
 			      &key_type_blacklist, buffer);
-	if (!IS_ERR(kref)) {
-		key_ref_put(kref);
-		ret = -EKEYREJECTED;
+	if (!IS_ERR(kref))
+		goto black;
+
+	/* For SHA hashes, the hash type is optional. */
+	if (hash_algo[0] == 's' &&
+	    hash_algo[1] == 'h' &&
+	    hash_algo[2] == 'a') {
+		p[-1] = 0;
+
+		kref = keyring_search(make_key_ref(blacklist_keyring, true),
+				      &key_type_blacklist, buffer);
+		if (!IS_ERR(kref))
+			goto black;
 	}
 
+out:
 	kfree(buffer);
 	return ret;
+
+black:
+	key_ref_put(kref);
+	ret = -EKEYREJECTED;
+	goto out;
 }
 EXPORT_SYMBOL_GPL(is_hash_blacklisted);
 
 /*
+ * Test the blacklistedness of one combination of data and hash.
+ */
+static int blacklist_test_one(const void *data, size_t data_len,
+			      const char *type, const char *hash_algo)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	size_t digest_size, desc_size;
+	u8 *digest;
+	int ret;
+
+	/* Allocate the hashing algorithm we're going to need and find out how
+	 * big the hash operational data will be.  We skip any hash type for
+	 * which we don't have a crypto module available.
+	 */
+	tfm = crypto_alloc_shash(hash_algo, 0, 0);
+	if (IS_ERR(tfm))
+		return (PTR_ERR(tfm) == -ENOENT) ? 0 : PTR_ERR(tfm);
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	digest_size = crypto_shash_digestsize(tfm);
+
+	ret = -ENOMEM;
+	digest = kmalloc(digest_size, GFP_KERNEL);
+	if (!digest)
+		goto error_tfm;
+
+	desc = kzalloc(desc_size, GFP_KERNEL);
+	if (!desc)
+		goto error_digest;
+
+	desc->tfm   = tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	/* Digest the message [RFC2315 9.3] */
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error_desc;
+	ret = crypto_shash_finup(desc, data, data_len, digest);
+	if (ret < 0)
+		goto error_desc;
+
+	ret = is_hash_blacklisted(digest, digest_size, type, hash_algo);
+error_desc:
+	kfree(desc);
+error_digest:
+	kfree(digest);
+error_tfm:
+	crypto_free_shash(tfm);
+	return ret;
+}
+
+/**
+ * is_data_blacklisted - Determine if a data blob is blacklisted
+ * @data: The data to check.
+ * @data_len: The amount of data.
+ * @type: The type of object.
+ * @skip_hash: A hash type to skip
+ *
+ * Iterate through all the types of hash for which we have blacklisted hashes
+ * and generate a hash for each and check it against the blacklist.
+ *
+ * If the caller has a precomputed hash, they can call is_hash_blacklisted() on
+ * it and then call this function with @skip_hash set to the hash type to skip.
+ */
+int is_data_blacklisted(const void *data, size_t data_len,
+			const char *type, const char *skip_hash)
+{
+	const struct blacklist_hash *bhash;
+	int ret = 0;
+
+	bhash = blacklist_hash_types;
+	smp_rmb(); /* Content after pointer.  List tail is immutable */
+
+	for (; bhash; bhash = bhash->next) {
+		if (strcmp(skip_hash, bhash->name) == 0)
+			continue;
+		ret = blacklist_test_one(data, data_len, type, bhash->name);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(is_data_blacklisted);
+
+/*
  * Initialise the blacklist
  */
 static int __init blacklist_init(void)
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index eea71dc9686c..57be229dd7bf 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -87,20 +87,30 @@ int x509_get_sig_params(struct x509_certificate *cert)
 	if (ret < 0)
 		goto error_2;
 
-	ret = is_hash_blacklisted(sig->digest, sig->digest_size, "tbs");
-	if (ret == -EKEYREJECTED) {
-		pr_err("Cert %*phN is blacklisted\n",
-		       sig->digest_size, sig->digest);
-		cert->blacklisted = true;
-		ret = 0;
-	}
+	ret = is_hash_blacklisted(sig->digest, sig->digest_size, "tbs",
+				  sig->hash_algo);
+	if (ret == -EKEYREJECTED)
+		goto blacklisted;
+	if (ret < 0)
+		goto error_2;
 
+	ret = is_data_blacklisted(cert->tbs, cert->tbs_size, "tbs",
+				  sig->hash_algo);
+	if (ret == -EKEYREJECTED)
+		goto blacklisted;
+	
 error_2:
 	kfree(desc);
 error:
 	crypto_free_shash(tfm);
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
+
+blacklisted:
+	pr_err("Cert %*phN is blacklisted\n", sig->digest_size, sig->digest);
+	cert->blacklisted = true;
+	ret = 0;
+	goto error_2;
 }
 
 /*
diff --git a/include/keys/system_keyring.h b/include/keys/system_keyring.h
index 359c2f936004..6ab1260893eb 100644
--- a/include/keys/system_keyring.h
+++ b/include/keys/system_keyring.h
@@ -38,10 +38,17 @@ extern int restrict_link_by_builtin_and_secondary_trusted(
 #ifdef CONFIG_SYSTEM_BLACKLIST_KEYRING
 extern int mark_hash_blacklisted(const char *hash);
 extern int is_hash_blacklisted(const u8 *hash, size_t hash_len,
-			       const char *type);
+			       const char *type, const char *hash_algo);
+extern int is_data_blacklisted(const void *data, size_t data_len,
+			       const char *type, const char *skip_hash);
 #else
 static inline int is_hash_blacklisted(const u8 *hash, size_t hash_len,
-				      const char *type)
+				      const char *type, const char *hash_algo)
+{
+	return 0;
+}
+static inline int is_data_blacklisted(const void *data, size_t data_len,
+				      const char *type, const char *skip_hash)
 {
 	return 0;
 }
