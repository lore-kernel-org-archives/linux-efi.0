Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794536715;
	b=OYLzoUTj/vtVsFqLu2T5a/XCeVFIG2TmSEHIUcmlycyi9taLttYCCeu8XcOXv/z5tu4K
	 tz5HL1rm/eMMGUVTOn4tMubyUdakQmySlTRnNb83Aa6kaXmwT4GvCpp/MdCWzzNRQOlM6
	 S/Z3gjwA28icr84S6aLZureBrcj3uONUMXzrOzm3U1GveDVrB0Z4mjwriPl45qe63CrVG
	 CAvMt9JSgM1E5SJpAIWc8C6OsaHfQFk6ooyaE/BYHiVBqjtTMkQUQa0I/mFG+20sToZMC
	 DLF4bclXM7G7F6NNWagP/3m4xDGSzoiWArCNF3E1Kl2ib2atW099k0jfxz+251DSB0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794536715;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4mZq/aruYtHZtR3LNwCASBiREH7mnp0HU2gRv3cHR9Q=;
	b=Q5QxTzAP0wsucK6stECBnMRN4pmQTGyRMWd4UyICe8yVBbHPtkFKnPZZuSn1frAQpmcK
	 KOvEhWsvhVTXQgTN/wtrWiPKQfKRBfDmHfyKlslDeQBqXsEwX+uu6FtlNr89gcCIAEXD+
	 AtAjk1RBAWMsIv0o2Ln3aJwn0I1OVVzLHH4Y8HVNmRUz893V7QtFEumSgYO+IuVGQgAmi
	 yNgVnos/JyUAQ8wCULgsH+6u7KyT4NEBmmWVkjqiC4le//Py1bvH27NlxYVYl4EHhSouA
	 hQaoCKa0FSkRPPj3bwEbKTfg7CmJcUHtRJGrahr1YUdHE/XF557R9W0kmcwBaxZmWZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZtBcQVQJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id DE184606A323;
	Fri, 13 Nov 2026 02:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZtBcQVQJ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9BC601F000C4;
	Fri, 13 Nov 2026 02:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794536715;
	bh=4mZq/aruYtHZtR3LNwCASBiREH7mnp0HU2gRv3cHR9Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZtBcQVQJ4RSrUOaFyvt9y3xwsDH2Tws8ys6tr7zYupS0xBI/geibRUFWVYFk2JjDc
	 kVd9CpsyPx/K1KGUSdjytWA+6/A751CWg4qFYJ0P+3qtNSKBqQB9IQvKJra8ifw6Cl
	 mF5F7j3hRRYDsIQbNteV/alMf2ajGoPhz0Ho+I+4PEgkDcLLkz7hVDmTT374nLi1K2
	 lWXjI2TrBOPWLM4G3FT5RUGbzG5VnDAbUKgudJdeFkpeXrK/XSq+1MZGqv+zZoeZjj
	 auL1K9aeHCiMBXPwUGlzBKcbW8LPxzSHjU8EM2yOoRIgbUhk4mJSAqTcZISFslg2lK
	 MxEq5sQGhTf3A==
Date: Fri, 13 Nov 2026 04:25:11 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 13/17] tpm: Add verification of kernel signing key
 provenance
Message-ID: <avZ1B2Jr5lK91JFL@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-14-matthewg@nvidia.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008132532.1155166-14-matthewg@nvidia.com>

On Thu, Oct 08, 2026 at 06:20:29AM -0700, Matthew Garrett wrote:
> Add tpm2_kernel_key_verify(), which checks the provenance produced by
> tpm2_kernel_key_create() and returns the public key it shows the kernel
> created. It checks that:
> 
> * The session audit attestation is signed by this TPM's kernel AK
> 
> * Replaying the logged cpHash and rpHash pairs from a zero digest
> reproduces the attested session digest
> 
> * Each logged rpHash matches the recorded response parameters, and the
> commands were PCR_Read, NV_Read, and CreateLoaded in that order
> 
> * PCR 5 was read, and held the value it holds now
> 
> * The read of the NV index returned the magic value
> 
> * The key created has exactly the attributes of a kernel signing key.
> 
> Since userspace cannot store the magic value in the kernel NV index,
> this shows that the key was created while the kernel was in control of
> the TPM.
> 
> Also add tpm2_kernel_key_verify_signature(), which verifies an ECDSA
> P-256 signature in software with a given public key, for checking data
> signed with a kernel signing key.
> 
> Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
> ---
>  drivers/char/tpm/Kconfig           |   1 +
>  drivers/char/tpm/tpm2-kernel-key.c | 372 +++++++++++++++++++++++++++++
>  include/linux/tpm.h                |  21 ++
>  3 files changed, 394 insertions(+)
> 
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index 15d204f8fa6d..c7ad2fef6d23 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -45,6 +45,7 @@ config TCG_TPM2_HMAC
>  config TCG_TPM2_KERNEL_KEY
>  	bool "Kernel-generated TPM signing keys with provenance"
>  	depends on TCG_TPM2_HMAC
> +	select CRYPTO_ECDSA
>  	help
>  	  Allow the kernel to create TPM signing keys along with evidence,
>  	  signed by the kernel attestation key, that the key was created
> diff --git a/drivers/char/tpm/tpm2-kernel-key.c b/drivers/char/tpm/tpm2-kernel-key.c
> index 89c11c78097a..3f9f6426a8a4 100644
> --- a/drivers/char/tpm/tpm2-kernel-key.c
> +++ b/drivers/char/tpm/tpm2-kernel-key.c
> @@ -31,6 +31,8 @@
>  #include <linux/random.h>
>  #include <linux/slab.h>
>  #include <linux/unaligned.h>
> +#include <crypto/sha2.h>
> +#include <crypto/sig.h>
>  #include "tpm.h"
>  #include "tpm2-rsp.h"
>  
> @@ -59,6 +61,16 @@ static const u8 tpm2_kkey_pcr5_select[] = {
>  	0x20, 0x00, 0x00,		/* PCR 5 */
>  };
>  
> +static const u8 tpm2_kkey_pcr5_bitmap[] = { 0x20, 0x00, 0x00 };
> +
> +static const struct {
> +	u16 alg;
> +	u16 size;
> +} tpm2_kkey_pcr5_banks[] = {
> +	{ TPM_ALG_SHA1,         SHA1_DIGEST_SIZE },
> +	{ TPM_ALG_SHA256,       SHA256_DIGEST_SIZE },
> +};
> +
>  /* The parameters of a response, as covered by the logged rpHash */
>  struct tpm2_kkey_rsp {
>  	u32 cc;
> @@ -500,3 +512,363 @@ void tpm2_kernel_key_destroy(struct tpm_chip *chip,
>  	memzero_explicit(key, sizeof(*key));
>  }
>  EXPORT_SYMBOL_GPL(tpm2_kernel_key_destroy);
> +
> +/**
> + * tpm2_kernel_key_verify_signature() - verify an ECDSA P-256 signature
> + * @x:		X coordinate of the public key
> + * @y:		Y coordinate of the public key
> + * @digest:	the SHA-256 digest that was signed
> + * @r:		R component of the signature
> + * @s:		S component of the signature
> + *
> + * Return: 0 if the signature is valid, -EKEYREJECTED if it is not, or
> + * another -errno on failure.
> + */
> +int tpm2_kernel_key_verify_signature(const u8 x[EC_PT_SZ],
> +				     const u8 y[EC_PT_SZ],
> +				     const u8 digest[SHA256_DIGEST_SIZE],
> +				     const u8 r[EC_PT_SZ],
> +				     const u8 s[EC_PT_SZ])
> +{
> +	u8 pub[1 + 2 * EC_PT_SZ], sig[2 * EC_PT_SZ];
> +	struct crypto_sig *tfm;
> +	int rc;
> +
> +	tfm = crypto_alloc_sig("p1363(ecdsa-nist-p256)", 0, 0);
> +	if (IS_ERR(tfm))
> +		return PTR_ERR(tfm);
> +
> +	/* uncompressed point */
> +	pub[0] = 0x04;
> +	memcpy(&pub[1], x, EC_PT_SZ);
> +	memcpy(&pub[1 + EC_PT_SZ], y, EC_PT_SZ);
> +	memcpy(sig, r, EC_PT_SZ);
> +	memcpy(&sig[EC_PT_SZ], s, EC_PT_SZ);
> +
> +	rc = crypto_sig_set_pubkey(tfm, pub, sizeof(pub));
> +	if (!rc)
> +		rc = crypto_sig_verify(tfm, sig, sizeof(sig), digest,
> +				       SHA256_DIGEST_SIZE);
> +
> +	crypto_free_sig(tfm);
> +	return rc == -EBADMSG ? -EKEYREJECTED : rc;
> +}
> +EXPORT_SYMBOL_GPL(tpm2_kernel_key_verify_signature);
> +
> +/* A logged command, parsed from the serialized provenance */
> +struct tpm2_kkey_entry {
> +	u32 cc;
> +	const u8 *cphash;
> +	const u8 *rphash;
> +	const u8 *params;
> +	u16 len;
> +};
> +
> +static const u32 tpm2_kkey_expected_cc[TPM2_KKEY_NR_CMDS] = {
> +	TPM2_CC_PCR_READ,
> +	TPM2_CC_NV_READ,
> +	TPM2_CC_CREATE_LOADED,
> +};
> +
> +/* Check that the attestation is a session audit, and find its digest */
> +static const u8 *tpm2_kkey_attest_digest(const u8 *attest, u16 len)
> +{
> +	struct tpm2_rsp r;
> +	const u8 *digest;
> +	u16 size;
> +
> +	tpm2_rsp_init_data(&r, attest, len);
> +	if (tpm2_rsp_u32(&r) != TPM2_GENERATED_VALUE ||
> +	    tpm2_rsp_u16(&r) != TPM2_ST_ATTEST_SESSION_AUDIT)
> +		return NULL;
> +
> +	/* qualifiedSigner, extraData */
> +	tpm2_rsp_tpm2b(&r, &size);
> +	tpm2_rsp_tpm2b(&r, &size);
> +	/* clockInfo (clock, resetCount, restartCount, safe), firmwareVersion */
> +	tpm2_rsp_bytes(&r, 8 + 4 + 4 + 1);
> +	tpm2_rsp_bytes(&r, 8);
> +	/* exclusiveSession */
> +	tpm2_rsp_u8(&r);
> +	digest = tpm2_rsp_tpm2b(&r, &size);
> +
> +	if (r.err || r.off != r.len || size != SHA256_DIGEST_SIZE)
> +		return NULL;
> +
> +	return digest;
> +}
> +
> +static bool tpm2_kkey_bank_allocated(struct tpm_chip *chip, u16 alg)
> +{
> +	int i;
> +
> +	for (i = 0; i < chip->nr_allocated_banks; i++)
> +		if (chip->allocated_banks[i].alg_id == alg)
> +			return true;
> +
> +	return false;
> +}
> +
> +/*
> + * Check a PCR_Read of PCR 5 against its current values.  Every bank that
> + * was read must hold the same value now, and the banks read must be
> + * exactly the SHA-1 and SHA-256 banks that are allocated.  A TPM leaves
> + * an unallocated bank out of the response or returns it with an empty
> + * selection, and since the response is covered by the attested audit
> + * digest, the set of banks read cannot be altered.
> + */
> +static int tpm2_kkey_check_pcr5(struct tpm_chip *chip,
> +				const struct tpm2_kkey_entry *e)
> +{
> +	bool read[ARRAY_SIZE(tpm2_kkey_pcr5_banks)] = { };
> +	u8 cphash[SHA256_DIGEST_SIZE];
> +	__be32 cc = cpu_to_be32(e->cc);
> +	unsigned int nr_read = 0;
> +	struct sha256_ctx ctx;
> +	struct tpm2_rsp r;
> +	int i, j, prev = -1, rc;
> +	u32 count;
> +
> +	sha256_init(&ctx);
> +	sha256_update(&ctx, (u8 *)&cc, sizeof(cc));
> +	sha256_update(&ctx, tpm2_kkey_pcr5_select,
> +		      sizeof(tpm2_kkey_pcr5_select));
> +	sha256_final(&ctx, cphash);
> +	if (memcmp(cphash, e->cphash, sizeof(cphash)))
> +		return -EKEYREJECTED;
> +
> +	tpm2_rsp_init_data(&r, e->params, e->len);
> +	/* pcrUpdateCounter */
> +	tpm2_rsp_u32(&r);
> +
> +	/* pcrSelectionOut: which banks were actually read, in order */
> +	count = tpm2_rsp_u32(&r);
> +	if (count > ARRAY_SIZE(tpm2_kkey_pcr5_banks))
> +		return -EKEYREJECTED;
> +
> +	for (i = 0; i < count; i++) {
> +		u16 alg = tpm2_rsp_u16(&r);
> +		const u8 *bitmap;
> +
> +		if (tpm2_rsp_u8(&r) != sizeof(tpm2_kkey_pcr5_bitmap))
> +			return -EKEYREJECTED;
> +		bitmap = tpm2_rsp_bytes(&r, sizeof(tpm2_kkey_pcr5_bitmap));
> +		if (!bitmap)
> +			return -EKEYREJECTED;
> +
> +		for (j = 0; j < ARRAY_SIZE(tpm2_kkey_pcr5_banks); j++)
> +			if (tpm2_kkey_pcr5_banks[j].alg == alg)
> +				break;
> +		/* banks must be distinct and in the order requested */
> +		if (j == ARRAY_SIZE(tpm2_kkey_pcr5_banks) || j <= prev)
> +			return -EKEYREJECTED;
> +		prev = j;
> +
> +		if (!memcmp(bitmap, tpm2_kkey_pcr5_bitmap,
> +			    sizeof(tpm2_kkey_pcr5_bitmap))) {
> +			read[j] = true;
> +			nr_read++;
> +		} else if (memchr_inv(bitmap, 0, sizeof(tpm2_kkey_pcr5_bitmap))) {
> +			return -EKEYREJECTED;
> +		}
> +	}
> +
> +	if (!nr_read)
> +		return -EKEYREJECTED;
> +
> +	/* TPML_DIGEST, one digest per bank read, in the same order */
> +	if (tpm2_rsp_u32(&r) != nr_read)
> +		return -EKEYREJECTED;
> +
> +	for (j = 0; j < ARRAY_SIZE(tpm2_kkey_pcr5_banks); j++) {
> +		struct tpm_digest pcr = { .alg_id = tpm2_kkey_pcr5_banks[j].alg };
> +		const u8 *digest;
> +		u16 size;
> +
> +		/* every allocated bank must have been read */
> +		if (!read[j]) {
> +			if (tpm2_kkey_bank_allocated(chip, pcr.alg_id))
> +				return -EKEYREJECTED;
> +			continue;
> +		}
> +
> +		digest = tpm2_rsp_tpm2b(&r, &size);
> +		if (!digest || size != tpm2_kkey_pcr5_banks[j].size)
> +			return -EKEYREJECTED;
> +
> +		rc = tpm2_pcr_read(chip, 5, &pcr, NULL);
> +		if (rc)
> +			return rc;
> +
> +		if (memcmp(digest, pcr.digest, size))
> +			return -EKEYREJECTED;
> +	}
> +
> +	return r.err || r.off != r.len ? -EKEYREJECTED : 0;
> +}
> +
> +/* Check an NV_Read of the kernel index, and that it returned the magic */
> +static int tpm2_kkey_check_nv_read(const struct tpm2_kkey_entry *e)
> +{
> +	u8 name[TPM2_NULL_NAME_SIZE], cphash[SHA256_DIGEST_SIZE];
> +	struct sha256_ctx ctx;
> +	__be32 cc = cpu_to_be32(e->cc);
> +	__be16 size = cpu_to_be16(TPM2_KERNEL_NV_SIZE), offset = 0;
> +
> +	/* authHandle and nvIndex are both the index, as last written */
> +	tpm2_kernel_nv_name(true, name);
> +	sha256_init(&ctx);
> +	sha256_update(&ctx, (u8 *)&cc, sizeof(cc));
> +	sha256_update(&ctx, name, sizeof(name));
> +	sha256_update(&ctx, name, sizeof(name));
> +	sha256_update(&ctx, (u8 *)&size, sizeof(size));
> +	sha256_update(&ctx, (u8 *)&offset, sizeof(offset));
> +	sha256_final(&ctx, cphash);
> +
> +	if (memcmp(cphash, e->cphash, sizeof(cphash)))
> +		return -EKEYREJECTED;
> +
> +	if (e->len != sizeof(u16) + TPM2_KERNEL_NV_SIZE ||
> +	    get_unaligned_be16(e->params) != TPM2_KERNEL_NV_SIZE ||
> +	    memcmp(e->params + sizeof(u16), tpm2_kernel_nv_magic,
> +		   TPM2_KERNEL_NV_SIZE))
> +		return -EKEYREJECTED;
> +
> +	return 0;
> +}
> +
> +/* Extract the public key from a CreateLoaded response */
> +static int tpm2_kkey_check_create(const struct tpm2_kkey_entry *e,
> +				  u8 x[EC_PT_SZ], u8 y[EC_PT_SZ])
> +{
> +	struct tpm2_rsp r;
> +	u16 size;
> +
> +	tpm2_rsp_init_data(&r, e->params, e->len);
> +	/* outPrivate */
> +	tpm2_rsp_tpm2b(&r, &size);
> +	if (tpm2_rsp_ecdsa_public(&r, TPM2_OA_KERNEL_KEY, x, y))
> +		return -EKEYREJECTED;
> +	/* name */
> +	tpm2_rsp_tpm2b(&r, &size);
> +
> +	return r.err || r.off != r.len ? -EKEYREJECTED : 0;
> +}
> +
> +/**
> + * tpm2_kernel_key_verify() - verify the provenance of a kernel signing key
> + * @chip:	the TPM chip
> + * @prov:	provenance returned by tpm2_kernel_key_create()
> + * @x:		filled with the X coordinate of the key's public key
> + * @y:		filled with the Y coordinate of the key's public key
> + *
> + * Checks that @prov shows the key was created by the kernel:
> + *
> + * - the attestation is signed by this TPM's kernel AK;
> + * - the logged commands reproduce the attested audit digest;
> + * - the logged responses match the recorded response parameters, and the
> + *   commands were PCR_Read, NV_Read, and CreateLoaded, in order;
> + * - PCR 5 was read and held the same value as it does now;
> + * - the kernel NV index was read, and returned the magic value;
> + * - the key created has the attributes of a kernel signing key.
> + *
> + * The caller must hold the chip's ops lock.
> + *
> + * Return: 0 if the provenance is valid, -EKEYREJECTED if it is not, or
> + * another -errno or a TPM error code on failure.
> + */
> +int tpm2_kernel_key_verify(struct tpm_chip *chip,
> +			   const struct tpm2_key_provenance *prov,
> +			   u8 x[EC_PT_SZ], u8 y[EC_PT_SZ])
> +{
> +	struct tpm2_kkey_entry e[TPM2_KKEY_NR_CMDS];
> +	u8 ak_x[EC_PT_SZ], ak_y[EC_PT_SZ];
> +	u8 digest[SHA256_DIGEST_SIZE];
> +	const u8 *attest, *sig_r, *sig_s, *session_digest;
> +	struct sha256_ctx ctx;
> +	struct tpm2_rsp r;
> +	u16 attest_len;
> +	u32 ak;
> +	int i, rc;
> +
> +	if (prov->len > sizeof(prov->data))
> +		return -EKEYREJECTED;
> +
> +	tpm2_rsp_init_data(&r, prov->data, prov->len);
> +	if (tpm2_rsp_u32(&r) != TPM2_KKEY_PROV_MAGIC ||
> +	    tpm2_rsp_u16(&r) != TPM2_KKEY_PROV_VERSION)
> +		return -EKEYREJECTED;
> +
> +	attest = tpm2_rsp_tpm2b(&r, &attest_len);
> +	sig_r = tpm2_rsp_bytes(&r, EC_PT_SZ);
> +	sig_s = tpm2_rsp_bytes(&r, EC_PT_SZ);
> +	if (tpm2_rsp_u8(&r) != TPM2_KKEY_NR_CMDS)
> +		return -EKEYREJECTED;
> +
> +	for (i = 0; i < TPM2_KKEY_NR_CMDS; i++) {
> +		e[i].cc = tpm2_rsp_u32(&r);
> +		e[i].cphash = tpm2_rsp_bytes(&r, SHA256_DIGEST_SIZE);
> +		e[i].rphash = tpm2_rsp_bytes(&r, SHA256_DIGEST_SIZE);
> +		e[i].params = tpm2_rsp_tpm2b(&r, &e[i].len);
> +		if (e[i].cc != tpm2_kkey_expected_cc[i])
> +			return -EKEYREJECTED;
> +	}
> +
> +	if (r.err || r.off != r.len)
> +		return -EKEYREJECTED;
> +
> +	/* the attestation must be signed by this TPM's kernel AK */
> +	rc = tpm2_create_kernel_ak(chip, &ak, ak_x, ak_y);
> +	if (rc)
> +		return rc;
> +	tpm2_flush_context(chip, ak);
> +
> +	sha256(attest, attest_len, digest);
> +	rc = tpm2_kernel_key_verify_signature(ak_x, ak_y, digest, sig_r,
> +					      sig_s);
> +	if (rc)
> +		return rc;
> +
> +	session_digest = tpm2_kkey_attest_digest(attest, attest_len);
> +	if (!session_digest)
> +		return -EKEYREJECTED;
> +
> +	/* replay the log from the initial zero digest */
> +	memset(digest, 0, sizeof(digest));
> +	for (i = 0; i < TPM2_KKEY_NR_CMDS; i++) {
> +		u8 rphash[SHA256_DIGEST_SIZE];
> +		__be32 cc = cpu_to_be32(e[i].cc);
> +		__be32 rc_success = 0;
> +
> +		/* the response must match the recorded parameters */
> +		sha256_init(&ctx);
> +		sha256_update(&ctx, (u8 *)&rc_success, sizeof(rc_success));
> +		sha256_update(&ctx, (u8 *)&cc, sizeof(cc));
> +		sha256_update(&ctx, e[i].params, e[i].len);
> +		sha256_final(&ctx, rphash);
> +		if (memcmp(rphash, e[i].rphash, sizeof(rphash)))
> +			return -EKEYREJECTED;
> +
> +		sha256_init(&ctx);
> +		sha256_update(&ctx, digest, sizeof(digest));
> +		sha256_update(&ctx, e[i].cphash, SHA256_DIGEST_SIZE);
> +		sha256_update(&ctx, e[i].rphash, SHA256_DIGEST_SIZE);
> +		sha256_final(&ctx, digest);
> +	}
> +
> +	if (memcmp(digest, session_digest, sizeof(digest)))
> +		return -EKEYREJECTED;
> +
> +	/* PCR 5 must hold the same value now */
> +	rc = tpm2_kkey_check_pcr5(chip, &e[0]);
> +	if (rc)
> +		return rc;
> +
> +	/* the key was created after a read of the magic value */
> +	rc = tpm2_kkey_check_nv_read(&e[1]);
> +	if (!rc)
> +		rc = tpm2_kkey_check_create(&e[2], x, y);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(tpm2_kernel_key_verify);
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index 505ea6f4bb46..9be88f1cc2aa 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -393,6 +393,14 @@ int tpm2_kernel_key_sign(struct tpm_chip *chip, struct tpm2_kernel_key *key,
>  			 u8 r[EC_PT_SZ], u8 s[EC_PT_SZ]);
>  void tpm2_kernel_key_destroy(struct tpm_chip *chip,
>  			     struct tpm2_kernel_key *key);
> +int tpm2_kernel_key_verify(struct tpm_chip *chip,
> +			   const struct tpm2_key_provenance *prov,
> +			   u8 x[EC_PT_SZ], u8 y[EC_PT_SZ]);
> +int tpm2_kernel_key_verify_signature(const u8 x[EC_PT_SZ],
> +				     const u8 y[EC_PT_SZ],
> +				     const u8 digest[SHA256_DIGEST_SIZE],
> +				     const u8 r[EC_PT_SZ],
> +				     const u8 s[EC_PT_SZ]);
>  #else
>  static inline int tpm2_kernel_key_create(struct tpm_chip *chip,
>  					 struct tpm2_kernel_key *key,
> @@ -411,6 +419,19 @@ static inline void tpm2_kernel_key_destroy(struct tpm_chip *chip,
>  					   struct tpm2_kernel_key *key)
>  {
>  }
> +static inline int tpm2_kernel_key_verify(struct tpm_chip *chip,
> +					 const struct tpm2_key_provenance *prov,
> +					 u8 x[EC_PT_SZ], u8 y[EC_PT_SZ])
> +{
> +	return -EOPNOTSUPP;
> +}
> +static inline int
> +tpm2_kernel_key_verify_signature(const u8 x[EC_PT_SZ], const u8 y[EC_PT_SZ],
> +				 const u8 digest[SHA256_DIGEST_SIZE],
> +				 const u8 r[EC_PT_SZ], const u8 s[EC_PT_SZ])
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif
>  
>  #ifdef CONFIG_TCG_TPM2_HMAC
> -- 
> 2.43.0
> 

I think it would make sense to iterate the patch set next as there is
enough accumulated scattered feedback to address. I.e. would be good
to see where are we at and pivot from there.

Br, Jarkko
