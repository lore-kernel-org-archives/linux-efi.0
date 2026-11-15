Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755337;
	b=BoPItDBisVXVquoIFBaRoSv/dqmxxIrlmUIU+T02kn6vZC65dTPX5UbbNb7YTisF5zag
	 W/EThRt/frDdvnq5NXMYrDYDCpN1oZwuYCaZmqJO/qTT0NOlCcw1aCo/yKsmxCxI1R0ER
	 Qd2neAEVLXk7J0A9nf2lgXfLU8eS3HtAJNAF4DK41qJpFOT6yeDsiRkGC8mFT/Y9PH/Bg
	 lAyT+7Yq/ukAJqPAykzcM+LymzW46FT8FaWDNfVNNp0fh/dR9fjJoPtml5hf004zoWu12
	 ZS6Nr7iQu3ojzsXjKmiTcXcFzxfM7766TTPAX18uFyQYQ1Rf/kNp9YI4ZMx2EMbcy6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755337;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=lOguy/S8c9u6xzgdAy6W60n1sBr34+L27vgGza1yPg4=;
	b=ldtvUp3S+iGCKlRrQiltpK9DXn0FQFX75oT0U/1U/K1bjav7YT6BufnFTlchD2PoytP6
	 aCDcgTijDtJez63uzjKR/+2k1Y42B9I720TrCYOfrXkCgT+Zq/ivQ6RO7Uuy2do93cEDM
	 hJpBffRwKBUSuoETM7xdXMDPNTfqE3PxlE2pXEHrJWqR428KuiK7sl50WyXwqOrtFCKwh
	 ESPLst/F53IekkGbiIX/CkGwCFV3XA7L6yTtKD8E271YbrIZBuKEYSzH3X9e7lWe34+jU
	 I56oNwgNyXVPE32xJndhIPYXpxFhiLJ0oSL9jgeqPMT97+9Rjt98LrTlPG1cOXO4mXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gw49muHX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CE534606A31D;
	Sun, 15 Nov 2026 15:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gw49muHX
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CA8671F000C4;
	Sun, 15 Nov 2026 15:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755337;
	bh=lOguy/S8c9u6xzgdAy6W60n1sBr34+L27vgGza1yPg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gw49muHXLYg2JKVS4e4OUStRhUkN1wEVwyunT+5VFqgwqRdnBWbMTBAcEToYK0ZKB
	 oR/q7UxygiKFqBJS+Fdn4EP4EZVbMXIK5LAfHw4oqFW1XKfzUxxTen3IlShKX3uMSj
	 F5DBNZ+xFyMaqfLni8TtbeRPl9QiGYLOE7O5lY7BFq+quPbqYT+lVEqf4uccsY0M4q
	 w4pHoHvrLuVG4yb1BzJV95pGJPx6JtkZz0PbpVrVS9KN4Q9+dzR7JNk7jUSTH11dzq
	 6I91/Ss8+c2I9l4jI2B2MSd4RuBp3DvGrGu171i+BUSmmZVEhPRb3udwNVvjQl30he
	 mLgYYw1dsUGIA==
Date: Sun, 15 Nov 2026 17:08:53 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Make hibernation work with lockdown
Message-ID: <avnLBQwPuF5AFQh2@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <avnJh0nsORR45i4m@kernel.org>
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
In-Reply-To: <avnJh0nsORR45i4m@kernel.org>

On Sun, Nov 15, 2026 at 05:02:35PM +0200, Jarkko Sakkinen wrote:
> Here's a patch that encapsulates my thoughts.
> 
> Br, Jarkko

> From c9a5b8d99278874bdd79d19bddd1d4a56ad8a38a Mon Sep 17 00:00:00 2001
> From: Jarkko Sakkinen <jarkko@kernel.org>
> Date: Sun, 15 Nov 2026 17:00:47 +0200
> Subject: [PATCH] tpm: Deny access to the hibernate NV index
> 
> 1. Add the TPM2 command codes mutating the reserved NV index, and describe
>    their target handles.
> 2. Replace tpm2_ordinal_duration_map with tpm2_cc_map providing handle
>    indices for the commands mutating NV indices.
> 3. Add tpm2_is_user_command() for identifying commands allowed from user
>    space. It will block commands trying to mutate the reserve NV index.
> 
> NV index should be protected regardless whether hibernate is used or not
> because not doing that introduces unwanted asymmetry.
> 
> Co-developed-by: Matthew Garrett <matthewg@nvidia.com>
> Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  drivers/char/tpm/tpm-dev-common.c |  4 ++
>  drivers/char/tpm/tpm.h            |  1 +
>  drivers/char/tpm/tpm2-cmd.c       | 96 +++++++++++++++++++++++--------
>  include/linux/tpm.h               |  6 ++
>  include/linux/tpm_command.h       |  9 +++
>  5 files changed, 91 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
> index ee91f456f975..4394b8f59012 100644
> --- a/drivers/char/tpm/tpm-dev-common.c
> +++ b/drivers/char/tpm/tpm-dev-common.c
> @@ -27,6 +27,10 @@ static ssize_t tpm_dev_transmit(struct tpm_chip *chip, struct tpm_space *space,
>  	struct tpm_header *header = (void *)buf;
>  	ssize_t ret, len;
>  
> +	if ((chip->flags & TPM_CHIP_FLAG_TPM2) &&
> +	    !tpm2_is_user_command(buf, bufsiz))
> +		return -EPERM;
> +
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		tpm2_end_auth_session(chip);
>  
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index fa554c5ad80b..2b18acaae920 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -107,6 +107,7 @@ static inline void tpm_add_ppi(struct tpm_chip *chip)
>  }
>  #endif
>  
> +bool tpm2_is_user_command(const u8 *buf, size_t bufsiz);
>  int tpm2_get_timeouts(struct tpm_chip *chip);
>  int tpm2_pcr_read(struct tpm_chip *chip, u32 pcr_idx,
>  		  struct tpm_digest *digest, u16 *digest_size_ptr);
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 4b2bb2ddc321..50c7ada9a4d6 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -51,29 +51,43 @@ int tpm2_get_timeouts(struct tpm_chip *chip)
>  	return 0;
>  }
>  
> -/*
> - * Contains the maximum durations in milliseconds for TPM2 commands.
> - */
> +enum tpm2_cc_nv {
> +	TPM2_CC_NV_NA = -1, /* not available */
> +	TPM2_CC_NV_H0 = 0,
> +	TPM2_CC_NV_H1 = 1,
> +};
> +
> +/* Command durations in milliseconds and NV index handle positions. */
>  static const struct {
> -	unsigned long ordinal;
> -	unsigned long duration;
> -} tpm2_ordinal_duration_map[] = {
> -	{TPM2_CC_STARTUP, 750},
> -	{TPM2_CC_SELF_TEST, 3000},
> -	{TPM2_CC_GET_RANDOM, 2000},
> -	{TPM2_CC_SEQUENCE_UPDATE, 750},
> -	{TPM2_CC_SEQUENCE_COMPLETE, 750},
> -	{TPM2_CC_EVENT_SEQUENCE_COMPLETE, 750},
> -	{TPM2_CC_HASH_SEQUENCE_START, 750},
> -	{TPM2_CC_VERIFY_SIGNATURE, 30000},
> -	{TPM2_CC_PCR_EXTEND, 750},
> -	{TPM2_CC_HIERARCHY_CONTROL, 2000},
> -	{TPM2_CC_HIERARCHY_CHANGE_AUTH, 2000},
> -	{TPM2_CC_GET_CAPABILITY, 750},
> -	{TPM2_CC_NV_READ, 2000},
> -	{TPM2_CC_CREATE_PRIMARY, 300000},
> -	{TPM2_CC_CREATE, 300000},
> -	{TPM2_CC_CREATE_LOADED, 300000},
> +	u32 cc;
> +	u32 duration;
> +	enum tpm2_cc_nv nv;
> +} tpm2_cc_map[] = {
> +	{TPM2_CC_STARTUP, 750, TPM2_CC_NV_NA},
> +	{TPM2_CC_SELF_TEST, 3000, TPM2_CC_NV_NA},
> +	{TPM2_CC_GET_RANDOM, 2000, TPM2_CC_NV_NA},
> +	{TPM2_CC_SEQUENCE_UPDATE, 750, TPM2_CC_NV_NA},
> +	{TPM2_CC_SEQUENCE_COMPLETE, 750, TPM2_CC_NV_NA},
> +	{TPM2_CC_EVENT_SEQUENCE_COMPLETE, 750, TPM2_CC_NV_NA},
> +	{TPM2_CC_HASH_SEQUENCE_START, 750, TPM2_CC_NV_NA},
> +	{TPM2_CC_VERIFY_SIGNATURE, 30000, TPM2_CC_NV_NA},
> +	{TPM2_CC_PCR_EXTEND, 750, TPM2_CC_NV_NA},
> +	{TPM2_CC_HIERARCHY_CONTROL, 2000, TPM2_CC_NV_NA},
> +	{TPM2_CC_HIERARCHY_CHANGE_AUTH, 2000, TPM2_CC_NV_NA},
> +	{TPM2_CC_GET_CAPABILITY, 750, TPM2_CC_NV_NA},
> +	{TPM2_CC_NV_READ, 2000, TPM2_CC_NV_NA},
> +	{TPM2_CC_CREATE_PRIMARY, 300000, TPM2_CC_NV_NA},
> +	{TPM2_CC_CREATE, 300000, TPM2_CC_NV_NA},
> +	{TPM2_CC_CREATE_LOADED, 300000, TPM2_CC_NV_NA},
> +	{TPM2_CC_NV_UNDEFINE_SPACE_SPECIAL, TPM2_DURATION_DEFAULT, TPM2_CC_NV_H0},
> +	{TPM2_CC_NV_UNDEFINE_SPACE, TPM2_DURATION_DEFAULT, TPM2_CC_NV_H1},
> +	{TPM2_CC_NV_INCREMENT, TPM2_DURATION_DEFAULT, TPM2_CC_NV_H1},
> +	{TPM2_CC_NV_SET_BITS, TPM2_DURATION_DEFAULT, TPM2_CC_NV_H1},
> +	{TPM2_CC_NV_EXTEND, TPM2_DURATION_DEFAULT, TPM2_CC_NV_H1},
> +	{TPM2_CC_NV_WRITE, TPM2_DURATION_DEFAULT, TPM2_CC_NV_H1},
> +	{TPM2_CC_NV_WRITE_LOCK, TPM2_DURATION_DEFAULT, TPM2_CC_NV_H1},
> +	{TPM2_CC_NV_CHANGE_AUTH, TPM2_DURATION_DEFAULT, TPM2_CC_NV_H0},
> +	{TPM2_CC_NV_READ_LOCK, TPM2_DURATION_DEFAULT, TPM2_CC_NV_H1},
>  };
>  
>  /**
> @@ -87,13 +101,45 @@ unsigned long tpm2_calc_ordinal_duration(u32 ordinal)
>  {
>  	int i;
>  
> -	for (i = 0; i < ARRAY_SIZE(tpm2_ordinal_duration_map); i++)
> -		if (ordinal == tpm2_ordinal_duration_map[i].ordinal)
> -			return msecs_to_jiffies(tpm2_ordinal_duration_map[i].duration);
> +	for (i = 0; i < ARRAY_SIZE(tpm2_cc_map); i++)
> +		if (ordinal == tpm2_cc_map[i].cc)
> +			return msecs_to_jiffies(tpm2_cc_map[i].duration);
>  
>  	return msecs_to_jiffies(TPM2_DURATION_DEFAULT);
>  }
>  
> +/* Check whether a command is permitted through the userspace interface. */
> +bool tpm2_is_user_command(const u8 *buf, size_t bufsiz)
> +{
> +	const struct tpm_header *header = (const void *)buf;
> +	size_t len, offset;
> +	u32 cc, index;
> +	int i;
> +
> +	if (bufsiz < TPM_HEADER_SIZE)
> +		return true;
> +
> +	len = min_t(size_t, be32_to_cpu(header->length), bufsiz);
> +	if (len < TPM_HEADER_SIZE)
> +		return true;
> +
> +	cc = be32_to_cpu(header->ordinal);
> +
> +	for (i = 0; i < ARRAY_SIZE(tpm2_cc_map); i++) {
> +		if (tpm2_cc_map[i].cc != cc || tpm2_cc_map[i].nv == TPM2_CC_NV_NA)
> +			continue;
> +
> +		offset = TPM_HEADER_SIZE + tpm2_cc_map[i].nv * sizeof(u32);
> +		if (len < offset + sizeof(u32))
> +			return true;
> +
> +		index = get_unaligned_be32(&buf[offset]);
> +		return index != TPM2_KERNEL_NV_INDEX;
> +	}
> +
> +	return true;
> +}
> +
>  /**
>   * tpm2_pcr_read() - read a PCR value
>   * @chip:	TPM chip to use.
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index 0db277af45c3..2a114c0ffcf9 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -178,6 +178,12 @@ static inline enum tpm2_mso_type tpm2_handle_mso(u32 handle)
>  	return handle >> 24;
>  }
>  
> +/*
> + * Provisional kernel-owned NV index. Userspace is not permitted to undefine
> + * or modify it. The allocation has not yet been finalized.
> + */
> +#define TPM2_KERNEL_NV_INDEX	0x014c4853
> +
>  #define TPM_VID_INTEL    0x8086
>  #define TPM_VID_WINBOND  0x1050
>  #define TPM_VID_STM      0x104A
> diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
> index 9ea1ee3cbef1..9224e81cb8f2 100644
> --- a/include/linux/tpm_command.h
> +++ b/include/linux/tpm_command.h
> @@ -208,14 +208,23 @@ enum tpm2_return_codes {
>  
>  enum tpm2_command_codes {
>  	TPM2_CC_FIRST			= 0x011F,
> +	TPM2_CC_NV_UNDEFINE_SPACE_SPECIAL = 0x011F,
>  	TPM2_CC_HIERARCHY_CONTROL	= 0x0121,
> +	TPM2_CC_NV_UNDEFINE_SPACE	= 0x0122,
>  	TPM2_CC_HIERARCHY_CHANGE_AUTH	= 0x0129,
>  	TPM2_CC_CREATE_PRIMARY		= 0x0131,
> +	TPM2_CC_NV_INCREMENT		= 0x0134,
> +	TPM2_CC_NV_SET_BITS		= 0x0135,
> +	TPM2_CC_NV_EXTEND		= 0x0136,
> +	TPM2_CC_NV_WRITE			= 0x0137,
> +	TPM2_CC_NV_WRITE_LOCK		= 0x0138,
> +	TPM2_CC_NV_CHANGE_AUTH		= 0x013B,
>  	TPM2_CC_SEQUENCE_COMPLETE	= 0x013E,
>  	TPM2_CC_SELF_TEST		= 0x0143,
>  	TPM2_CC_STARTUP			= 0x0144,
>  	TPM2_CC_SHUTDOWN		= 0x0145,
>  	TPM2_CC_NV_READ			= 0x014E,
> +	TPM2_CC_NV_READ_LOCK		= 0x014F,
>  	TPM2_CC_CREATE			= 0x0153,
>  	TPM2_CC_LOAD			= 0x0157,
>  	TPM2_CC_SEQUENCE_UPDATE		= 0x015C,
> -- 
> 2.47.3
> 

The additional benefit of this: we can create a kselftest if we want.

Br, Jarkko
