Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794531018;
	b=ijzXhCi5GUPrJ9q8HUiuIsmSQdoicgwNvGR+B7NR/9tt+0eM3GbQmrKc2voa75JP4R3O
	 nOJjhkkv2TNuk3BJeQzCjRre3CV1WQo3Ig3MCRp2trkfivoRhx/iuQ7ZM/Wh7FZG+j6Pu
	 Ks1Y9iB5waJ2GDNsh5i0/jfKOOQ/Qt8EKqaKQAPQ94L9gzusHfJLUHTUDkJg9m81MAWhP
	 vmLEHKK6EmyQ25lzBSPcSaESfgYOltGqFrnpweKBEZAyiRJkItZtR2CBgkDzU1Agd5Ys2
	 OzVm9mir+3J7swfRBnmhdH+ZpYrv3ZKYoBlg7GT2piSLntyCL/qK3FEjmPw1dPZen4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794531018;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=xQFcFPClXFZRCvlfFA+mRwTNyZht83bdmfpfjduJBas=;
	b=zfvQ7MHtISce6F6P9axltcXkxhQ3DGKfE//y630FcK0Fef1807ezYphWFAUM+WQ7Tk75
	 9O+QP0GDuD3BIFbqKMNn4KQG32pJ4aJ6yGrLdTkJTgvigoa6Maq1zqZRwbH2f/iNMEUDa
	 +lCcMpLETtXGZTdfovxUL8zC/oacFGDlbijpKn3oP5SEyhk6ii2VCWXZ1nhCaE2gspgUX
	 9t5M3FzCBa/dW7/1bZmCIarhlUsWc3TTCnSQIvDIJuYFf0d+viCGUzQxa40ssvM1Eke6y
	 hxJgekJZUUf9m/COvYE+3q13CdzHOJVtYbCnlk6OMlXO2oRvKWkKmOyZw7y9pAYSgrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dzWbJuON;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 24F3B606A886;
	Fri, 13 Nov 2026 00:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dzWbJuON
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3A6F11F000C4;
	Fri, 13 Nov 2026 00:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794531017;
	bh=xQFcFPClXFZRCvlfFA+mRwTNyZht83bdmfpfjduJBas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dzWbJuONSZfASp7zQjegKNRyOjp1b3SqjfAwFiyyPI5xzHiNNG1M+UmKFyZ7bL/s5
	 SDaXTn2qiXESWZAu8NBoeMBRQk7kz5/8+LHtcyJ1Aro+k0ANX7KjhE/VvzffKxM2D7
	 MV6OMHDSs24v5nTijj7qX3gQk2EznC5Hg05uArsP6Xhe+SlO6TizpPS65lfIU/h1FZ
	 EOrnMstDd6OL3fXe1U2284sfJGQiPUL3tQWDwjOh77NbHXHeMSN5cgnkd4eFUS5dOW
	 TLNPpmtA56jISI4g6lTaMkBGgK/MAo2r+WPmwNCyn+670hqKTIm3m0eGv8+t/JXIja
	 LyS9DtPBsmeew==
Date: Fri, 13 Nov 2026 02:50:13 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <avZexVrCBhWgrslq@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-2-matthewg@nvidia.com>
 <avZcgwi7EetC2DtG@kernel.org>
 <avZdj5oROgc0HL4L@kernel.org>
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
In-Reply-To: <avZdj5oROgc0HL4L@kernel.org>

On Fri, Nov 13, 2026 at 02:45:07AM +0200, Jarkko Sakkinen wrote:
> On Fri, Nov 13, 2026 at 02:40:39AM +0200, Jarkko Sakkinen wrote:
> > On Thu, Oct 08, 2026 at 06:20:17AM -0700, Matthew Garrett wrote:
> > > +#ifdef CONFIG_TCG_TPM_KERNEL_NVINDEX
> > > +/*
> > > + * Commands that undefine or modify an NV index, and the position of the
> > > + * NV index in the command's handle area.
> > > + */
> > > +static const struct {
> > > +	u32 cc;
> > > +	unsigned int handle;
> > > +} tpm2_nv_modify_cmds[] = {
> > > +	{ TPM2_CC_NV_UNDEFINE_SPACE_SPECIAL,	0 },
> > > +	{ TPM2_CC_NV_UNDEFINE_SPACE,		1 },
> > > +	{ TPM2_CC_NV_INCREMENT,			1 },
> > > +	{ TPM2_CC_NV_SET_BITS,			1 },
> > > +	{ TPM2_CC_NV_EXTEND,			1 },
> > > +	{ TPM2_CC_NV_WRITE,			1 },
> > > +	{ TPM2_CC_NV_WRITE_LOCK,		1 },
> > > +	{ TPM2_CC_NV_CHANGE_AUTH,		0 },
> > > +	{ TPM2_CC_NV_READ_LOCK,			1 },
> > > +};
> > 
> > There's also tpm2_ordinal_duration_map:
> > 
> > 	static const struct {
> > 		unsigned long ordinal;
> > 		unsigned long duration;
> > 	} tpm2_ordinal_duration_map[] = {
> > 		{TPM2_CC_STARTUP, 750},
> > 		{TPM2_CC_SELF_TEST, 3000},
> > 		{TPM2_CC_GET_RANDOM, 2000},
> > 		{TPM2_CC_SEQUENCE_UPDATE, 750},
> > 		{TPM2_CC_SEQUENCE_COMPLETE, 750},
> > 		{TPM2_CC_EVENT_SEQUENCE_COMPLETE, 750},
> > 		{TPM2_CC_HASH_SEQUENCE_START, 750},
> > 		{TPM2_CC_VERIFY_SIGNATURE, 30000},
> > 		{TPM2_CC_PCR_EXTEND, 750},
> > 		{TPM2_CC_HIERARCHY_CONTROL, 2000},
> > 		{TPM2_CC_HIERARCHY_CHANGE_AUTH, 2000},
> > 		{TPM2_CC_GET_CAPABILITY, 750},
> > 		{TPM2_CC_NV_READ, 2000},
> > 		{TPM2_CC_CREATE_PRIMARY, 300000},
> > 		{TPM2_CC_CREATE, 300000},
> > 		{TPM2_CC_CREATE_LOADED, 300000},
> > 	};
> > 
> > I'd consider something along the lines of:
> > 
> > 	enum tpm2_cc_nv {
> > 		TPM2_CC_NV_NA = -1,	/* not available */
> > 		TPM2_CC_NV_H0 = 0,
> > 		TPM2_CC_NV_H1 = 1,
> > 	};
> > 
> > 	static const struct {
> > 		u32 cc;
> > 		u32 duration;
> > 		enum tpm2_cc_nv nv;
> > 	} tpm2_cc_map[] {
> > 		/* ... */
> > 	};
> > 
> 
> And I'd do this as a separate patch without adding new command codes or
> other NV specific shenanigans. I.e. all entries have just TPM2_CC_NV_NA
> set.
> 
> Further I'd sequence this like:
> 
> 1. A patch that does above refactor.
> 2. A patch that adds the mechanics. This is a point that can be already
>    tested separately, thus it is important.
> 3. A patch that adds the new CC's and populates the entries to
>    tpm2_cc_map.

Not dictating on this but I'd probably think that it is best to retain
the array as static and move the required amount of code/wiring to
tpm2-cmd.c.

Br, Jarkko
