Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794530707;
	b=cmcLOLLn9zW1ut9jKcbgVouq61QoMJk6S96fh7QddIePblLmPrMx1vqpTv7YQc/sc0ib
	 umMM1lCF/LPEK7nJstNnHtYiXPKrSfjOcl4EE2OpHCAIsjWZFzdWCH9Nvs9MHCD8itoKn
	 6Sze/f7kxCfc953GYi6T1QudusxfnDWna21l9BFBMPy3L697pj4ZCzlYXYCmeFbSov2/Z
	 we0FUD4GhOChqvKSuaTpN3Il6wf0S11kId5aMrIl89RF9yvI8+tbqGmOfH6TiIQRI33nl
	 73pHdxogMZIlNZW5H0MS2qRKEEMZj05XrlpdjUb9KD+zcafoNW73OgbuHohikkSjijg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794530707;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ie3C8hphcPLV84ZpJpi3r6G810Ubn5RcgO5MvBQ0KBM=;
	b=LnPnOLCpw3oMfo7x11DG+xJj9ZonveVuL/OrysKatTCQeF1gpSWgGj+eF9z9/eemZApR
	 vkQG+DUETDV1v8Y1WgtUYfJhQrJ6hzNIBQas6odK93me5/3i6KGSCWjRUCfBPJ44ogklo
	 D9rFc3dG60H/tKAySQhX5IjoVFY+viTxHUhCaH4Uw7WEV7p/wnDUcEQCqeKDRTqGhv3DW
	 bCZEvRxZzcwYzwRqsQEBAkv1tZugwVkf/rF4cCxtpPUmdFLf39klfSqIlJhp1BiXBV36x
	 uZQowsdBgJ7cPAhhWXnusiakVCglnF43yxKMhsQhAX1b7YSRU+k2yK///5K19WG+dtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GyJBM0Aw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 966EF606A321;
	Fri, 13 Nov 2026 00:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GyJBM0Aw
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BCA2C1F000C4;
	Fri, 13 Nov 2026 00:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794530707;
	bh=ie3C8hphcPLV84ZpJpi3r6G810Ubn5RcgO5MvBQ0KBM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GyJBM0Aw2WxUexkof7GY/3npru9JxW3HLf+9t78CVtokcjfsDkW0VWviPEr/0fymA
	 ricb9oU27sr9GLAfRnUVSz2RAoD+uJM6ONdwg9TbSQKIgg/DaXo4hFFA8hIpPt5Gv+
	 sIspN17MlFrjGSq1vX1K1Dsw1hIG1/NCQayCrmD7iRQmNbiCVav/v3ZYmboBuZihHG
	 c1HEDcKjIgrt3IHZgZBv1CLjnG5X7Bs76HOwJxeFu0pooMwaak2Yu/oaUQ4l4doPWn
	 0Z2Rsbsx7ZfZ0vOGqJg+O/MvhDtq0j3kzvrGMepyboRrUdB0PMa9RPMAFw4gAi9a33
	 X71FwROqPwO5A==
Date: Fri, 13 Nov 2026 02:45:03 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <avZdj5oROgc0HL4L@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-2-matthewg@nvidia.com>
 <avZcgwi7EetC2DtG@kernel.org>
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
In-Reply-To: <avZcgwi7EetC2DtG@kernel.org>

On Fri, Nov 13, 2026 at 02:40:39AM +0200, Jarkko Sakkinen wrote:
> On Thu, Oct 08, 2026 at 06:20:17AM -0700, Matthew Garrett wrote:
> > +#ifdef CONFIG_TCG_TPM_KERNEL_NVINDEX
> > +/*
> > + * Commands that undefine or modify an NV index, and the position of the
> > + * NV index in the command's handle area.
> > + */
> > +static const struct {
> > +	u32 cc;
> > +	unsigned int handle;
> > +} tpm2_nv_modify_cmds[] = {
> > +	{ TPM2_CC_NV_UNDEFINE_SPACE_SPECIAL,	0 },
> > +	{ TPM2_CC_NV_UNDEFINE_SPACE,		1 },
> > +	{ TPM2_CC_NV_INCREMENT,			1 },
> > +	{ TPM2_CC_NV_SET_BITS,			1 },
> > +	{ TPM2_CC_NV_EXTEND,			1 },
> > +	{ TPM2_CC_NV_WRITE,			1 },
> > +	{ TPM2_CC_NV_WRITE_LOCK,		1 },
> > +	{ TPM2_CC_NV_CHANGE_AUTH,		0 },
> > +	{ TPM2_CC_NV_READ_LOCK,			1 },
> > +};
> 
> There's also tpm2_ordinal_duration_map:
> 
> 	static const struct {
> 		unsigned long ordinal;
> 		unsigned long duration;
> 	} tpm2_ordinal_duration_map[] = {
> 		{TPM2_CC_STARTUP, 750},
> 		{TPM2_CC_SELF_TEST, 3000},
> 		{TPM2_CC_GET_RANDOM, 2000},
> 		{TPM2_CC_SEQUENCE_UPDATE, 750},
> 		{TPM2_CC_SEQUENCE_COMPLETE, 750},
> 		{TPM2_CC_EVENT_SEQUENCE_COMPLETE, 750},
> 		{TPM2_CC_HASH_SEQUENCE_START, 750},
> 		{TPM2_CC_VERIFY_SIGNATURE, 30000},
> 		{TPM2_CC_PCR_EXTEND, 750},
> 		{TPM2_CC_HIERARCHY_CONTROL, 2000},
> 		{TPM2_CC_HIERARCHY_CHANGE_AUTH, 2000},
> 		{TPM2_CC_GET_CAPABILITY, 750},
> 		{TPM2_CC_NV_READ, 2000},
> 		{TPM2_CC_CREATE_PRIMARY, 300000},
> 		{TPM2_CC_CREATE, 300000},
> 		{TPM2_CC_CREATE_LOADED, 300000},
> 	};
> 
> I'd consider something along the lines of:
> 
> 	enum tpm2_cc_nv {
> 		TPM2_CC_NV_NA = -1,	/* not available */
> 		TPM2_CC_NV_H0 = 0,
> 		TPM2_CC_NV_H1 = 1,
> 	};
> 
> 	static const struct {
> 		u32 cc;
> 		u32 duration;
> 		enum tpm2_cc_nv nv;
> 	} tpm2_cc_map[] {
> 		/* ... */
> 	};
> 

And I'd do this as a separate patch without adding new command codes or
other NV specific shenanigans. I.e. all entries have just TPM2_CC_NV_NA
set.

Further I'd sequence this like:

1. A patch that does above refactor.
2. A patch that adds the mechanics. This is a point that can be already
   tested separately, thus it is important.
3. A patch that adds the new CC's and populates the entries to
   tpm2_cc_map.


Br, Jarkko
