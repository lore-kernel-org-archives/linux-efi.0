Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794530440;
	b=kPhbl6Hid9hhHxOfnop9N04Gu4T1bQoOHF65SpLJc3LIP+0AGXGXjkdmx2BQGIxrO/Lr
	 L1psLD8NH5TMZHMbBI2XyCfbXKp+Oe8HCSq4JOGWlyZ6UgaZUXbbb66BmD7NsYq0XwADt
	 hqkkFIA67qyDhhemhgFtmykaFcRMEYAOguXZ/gIIYlbcbfbWVnjXIcF7jk5S4ExqETcax
	 SK+urS7f+WRtt7rwWNGLRaNjNheJJXLKwkohkDlQnCINOoYCyoHgA+CNh5MowtTqUXNzW
	 LrylrSBXkTJA16RCxeuKtH3xfNpJq0BijoMMrhwMCViF7se+kvdl9PUiIdSYuHTM4dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794530440;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wQZq4Iw8WxxwgMOfIPNmGlyXcgiNiLX4O096jCX342o=;
	b=y57XMtFqmbwUnRBNDbdnF3HhnOmX0dSrQISaWxsZrczdbCvvN6aqqMH1gr46hFuNiMwC
	 AzblacgHOXeoToPmva0lW9D8M/wEnkIaqnfBCwHkseKSTJay9wWq01WSgwgxiOK62qp1X
	 DTNzqQrcIqq6ONOiRyODOW5Q4RwUblYpKCfXFVSSy+WVvgRBaDIkRbbBZ2cI2wF6TqlHp
	 CDUs9NaeTrHj3JfZ8OUTP107eISAAvKSia0FfpLI6wSB5UI0S916FmsG1zboxSyoi4CJz
	 QE7c2shKA88XRQAtMs0P3FRKy7vPT19bjLzVMOcaPNLU3QwndCv3A6PW9eIn4fTQ+dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aEfXf8OA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id F1768606A333;
	Fri, 13 Nov 2026 00:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aEfXf8OA
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B76561F000C4;
	Fri, 13 Nov 2026 00:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794530439;
	bh=wQZq4Iw8WxxwgMOfIPNmGlyXcgiNiLX4O096jCX342o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aEfXf8OAietr8+Jcrfj8PE7oMKRfA2/tK66kr8JSz7/uCEjHi9T9Hoci2ipHqCcH2
	 a9WTZtNxOdlOotcAWYoalQX4Wkr3OLxyW5kQ6UsJHaRt30bpQm0DOWaSRS0Bqya04j
	 Oqn+qUNel9Izrl6waP4JNdLFj+mQgqdSjE3wR3qOepUv8GqMUaCZMm1I55sn3gJYHi
	 LK3BEBj67GUJj+BdUAk6tRU5pjbxr7H8hFvhPQK7c4B4Dl0zZrQyZ53W8K803WMgHU
	 68TNh7mzV+7l+09fnURfPlCeSe/940eQ0D70GZ8K21yqd6HTDdd//5biq0YVN8FRTh
	 FDQF7GzTdwM8g==
Date: Fri, 13 Nov 2026 02:40:35 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <avZcgwi7EetC2DtG@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-2-matthewg@nvidia.com>
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
In-Reply-To: <20261008132532.1155166-2-matthewg@nvidia.com>

On Thu, Oct 08, 2026 at 06:20:17AM -0700, Matthew Garrett wrote:
> +#ifdef CONFIG_TCG_TPM_KERNEL_NVINDEX
> +/*
> + * Commands that undefine or modify an NV index, and the position of the
> + * NV index in the command's handle area.
> + */
> +static const struct {
> +	u32 cc;
> +	unsigned int handle;
> +} tpm2_nv_modify_cmds[] = {
> +	{ TPM2_CC_NV_UNDEFINE_SPACE_SPECIAL,	0 },
> +	{ TPM2_CC_NV_UNDEFINE_SPACE,		1 },
> +	{ TPM2_CC_NV_INCREMENT,			1 },
> +	{ TPM2_CC_NV_SET_BITS,			1 },
> +	{ TPM2_CC_NV_EXTEND,			1 },
> +	{ TPM2_CC_NV_WRITE,			1 },
> +	{ TPM2_CC_NV_WRITE_LOCK,		1 },
> +	{ TPM2_CC_NV_CHANGE_AUTH,		0 },
> +	{ TPM2_CC_NV_READ_LOCK,			1 },
> +};

There's also tpm2_ordinal_duration_map:

	static const struct {
		unsigned long ordinal;
		unsigned long duration;
	} tpm2_ordinal_duration_map[] = {
		{TPM2_CC_STARTUP, 750},
		{TPM2_CC_SELF_TEST, 3000},
		{TPM2_CC_GET_RANDOM, 2000},
		{TPM2_CC_SEQUENCE_UPDATE, 750},
		{TPM2_CC_SEQUENCE_COMPLETE, 750},
		{TPM2_CC_EVENT_SEQUENCE_COMPLETE, 750},
		{TPM2_CC_HASH_SEQUENCE_START, 750},
		{TPM2_CC_VERIFY_SIGNATURE, 30000},
		{TPM2_CC_PCR_EXTEND, 750},
		{TPM2_CC_HIERARCHY_CONTROL, 2000},
		{TPM2_CC_HIERARCHY_CHANGE_AUTH, 2000},
		{TPM2_CC_GET_CAPABILITY, 750},
		{TPM2_CC_NV_READ, 2000},
		{TPM2_CC_CREATE_PRIMARY, 300000},
		{TPM2_CC_CREATE, 300000},
		{TPM2_CC_CREATE_LOADED, 300000},
	};

I'd consider something along the lines of:

	enum tpm2_cc_nv {
		TPM2_CC_NV_NA = -1,	/* not available */
		TPM2_CC_NV_H0 = 0,
		TPM2_CC_NV_H1 = 1,
	};

	static const struct {
		u32 cc;
		u32 duration;
		enum tpm2_cc_nv nv;
	} tpm2_cc_map[] {
		/* ... */
	};

Br, Jarkko
