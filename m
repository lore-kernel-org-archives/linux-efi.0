Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFDA50C2A6;
	Thu,  3 Sep 2026 20:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788465831; cv=none; b=E0dtEgQ3K8ckFrrtsCl6NFd2E1v1D6q+teLF9awt9ImdV90xdYaPSPObO5t2Xp3gS/sp8VR+MMCeR3OpEUdcvk+zISZ8kYdF1wBlaxeYTNJ0jjrerE1kWX1ysJx+1OsLzkfwHU27LwiPyUQDUS6VU6KoJ3WEeVo0T7UXP3ujmBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788465831; c=relaxed/simple;
	bh=fgRmwkMOKGZ6qvZrfAiJ063FQc/4qEzqXvA+rlkMJI4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=dnRwyeooIySPTAGw1b7j/Og8w09SZF0CjMePQ0SNLA8sHy1mBvUH7ywGvyWqzPwx8XcGHf/qQyTBF+rKh6ZBzHnDdPcHbAmFkuxfI9R3OFfn3vIUZIrcxmaltv/NthB0x8juYh4dm2ZvTDZUzlFm0OqdhDmf84CctoUbIZ5BKAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PL7vFoyu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PL7vFoyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3ECB1F00A3D;
	Thu,  3 Sep 2026 20:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788465823;
	bh=RliiC8EX5eSyxMCkV7diaMrRCSbGjrTaVnnO3YM73+k=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=PL7vFoyur6XNM4keWNC+yzFMjP9+ejBIAirqK1yApvYvIBK+hq29LlS2CDhy/YoPS
	 pTf7FZXCBoTRO7zxbjSTbCmcJqWakhP5xwBNFBWRLDOdrfWVgujIe6ITPhexfneL5m
	 C3i1db0lSF+mmRgh9FszNjUB/QT6M6nwjhmfHjyYM9s2G0CcEHbvdC5rwsFHNRAQ5O
	 sJ/TmlzSuJEOxU0gU7i+kR0GJt/x2Zt17ig05Yxi1WYr8SembSMC9xqSjtEk6YXh9s
	 3OqgYB775o6tBZBc26eAMIcz9dA+muk7AxQGnFMeYPhL7EVcpn/x2MwsQNh5ruxe8s
	 BWNAeTAoFt5EA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3DDCF1980047;
	Thu,  3 Sep 2026 16:03:41 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 03 Sep 2026 16:03:41 -0400
X-ME-Sender: <xms:m9KZamdxoigxJrkBAzr3AlBnlLWKwu_8etI0xmwhCfQ_-sOmF98Bhg>
    <xme:m9KZarCmj_exLCC5x3X3knvqAnhK12bcvA5-kMc7mlGGPJ62HNLcLfrj-h7WwK4oz
    -TNyAKoCBvG9zH_COCnXm1T63Skvt6Enz-BMeTeS5BVUQckA5WNxbPv>
X-ME-Proxy-Cause: dmFkZTECfpid2lhpXufZEYzL2XMdRevnf45kqa+1a4KlG6wTv4FeNJenT5cC1dXQfxZ5LV
    fuwKsmK/bvWpZTHR93scuGWexucUPP/UwNn5cPNSUAVjFlHfvp6DrBzjj3BhftWtD48/RM
    l1IUc0fxpFkTdkBiC7lQl/EYjzmIYHFWTYALdHKRTIrW2yqUnmyAD5DlROBXWhLLrSZ1pL
    Mtm8kKNCLQ1bKoW4xIx7ZXgBX1Z2wCMxlsisbbakL9YK4Nh1njm4ss1QVrX16ydoru2WUO
    Knpch6DxcTEckMElvoCWaEO9CIxK3/8e08TMXmy6nV8dFfULLPmQIka872vEh4UcnJy+eZ
    YvsqMrGTBYT1H3zJvbFpE/D7XRpEGIXpZwL1PHWK8z4KMu+lRV3kf049NCuwx9KYsTUB1u
    G/71xcnIgFs2zPXe+uPnlkffVhnoblgFxRPL87eQMCHZckRjCDs/xv4hj1xSe6LQwC98lE
    zzy3kdSSRUZOdHvsRcdRO/s5Q9MibodCTF5zvxUu2d5sWIMBYYGJHbPLYborQ5n5faqS05
    B+47dQHQ/1kTQL47lZnHalUfT/xceotUgYU5N3d0rT4Qv4itvXeF53sOUP+sLR1EWbGN6d
    v+Iw8aXK4bQDKtFwRgzllBD6T1KAjn6U3Z0tph1i6m/VZViwLLhpKEllzCqw
X-ME-Proxy: <xmx:ndKZartRkg-NGPIOGTYoNGheUA9b0bbRKDY3I9niP5ryK8bUaYg3Xw>
    <xmx:ndKZajMf4huICw_Ec8DaV8aEj1flei0NznmoNJ30EXhpsdLdfeQ8aA>
    <xmx:ndKZagj7BjdfVSBoj6lhHqDi3CtNjT7O11DTtRcGjIsrIp10CYUr_g>
    <xmx:ndKZal7n_5UWImx46n561Pi6xjmH8xCAMpLi_f6JhrW76GJHXW69NA>
    <xmx:ndKZan2sCKQszI1uU9ssdJ7S-B1FguawPuinZPyK99TEsNIe80om5RUS>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 5A67BF8007B; Thu,  3 Sep 2026 16:03:39 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 03 Sep 2026 22:03:18 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jonggeun Park" <jakejgpark@gmail.com>, "Jeremy Kerr" <jk@ozlabs.org>
Cc: "Kees Cook" <kees@kernel.org>, "Tony Luck" <tony.luck@intel.com>,
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <5b13119c-105a-4197-8f5c-711acc47ac0c@app.fastmail.com>
In-Reply-To: <20260903115516.32495-1-jakejgpark@gmail.com>
References: <20260815074844.1330-1-jakejgpark@gmail.com>
 <20260903115516.32495-1-jakejgpark@gmail.com>
Subject: Re: [PATCH v2] efi: vars: commonize the 512-byte name buffer quirk
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Thanks for respinning this.

Some additional thoughts below.

On Thu, 3 Sep 2026, at 13:55, Jonggeun Park wrote:
> Some old UEFI implementations reject GetNextVariableName() calls with
> a name buffer size larger than 512 bytes. Both efivar_init() and
> efi_pstore_read() open-code the same workaround of resetting the size
> to 512 on every iteration.
>
> Move this workaround into efivar_get_next_variable(), which keeps this
> quirk in one place, resolving the TODO in efi-pstore.c.
>
> No functional change intended.
>
> Signed-off-by: Jonggeun Park <jakejgpark@gmail.com>
> ---
> v2:
> - Move the workaround into the existing efivar_get_next_variable().
> ---
>  drivers/firmware/efi/efi-pstore.c | 10 ----------
>  drivers/firmware/efi/vars.c       |  7 +++++++
>  fs/efivarfs/vars.c                | 12 +-----------
>  3 files changed, 8 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi-pstore.c 
> b/drivers/firmware/efi/efi-pstore.c
> index a5db3534f..4f2594d08 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -164,16 +164,6 @@ static ssize_t efi_pstore_read(struct 
> pstore_record *record)
>  	efi_status_t status;
> 
>  	for (;;) {
> -		/*
> -		 * A small set of old UEFI implementations reject sizes
> -		 * above a certain threshold, the lowest seen in the wild
> -		 * is 512.
> -		 *
> -		 * TODO: Commonize with the iteration implementation in
> -		 *       fs/efivarfs to keep all the quirks in one place.
> -		 */
> -		varname_size = 512;
> -
>  		/*
>  		 * If this is the first read() call in the pstore enumeration,
>  		 * varname will be the empty string, and the GetNextVariable()
> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> index 3700e9869..0f95fc60d 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -191,11 +191,18 @@ EXPORT_SYMBOL_NS_GPL(efivar_get_variable, 
> "EFIVAR");
>  /*
>   * efivar_get_next_variable() - enumerate the next name/vendor pair
>   *
> + * A small set of old UEFI implementations reject sizes above a certain
> + * threshold, the lowest seen in the wild is 512. Set the name buffer 
> size
> + * to 512 on each call.
> + *
>   * Must be called with efivars_lock held.
>   */
>  efi_status_t efivar_get_next_variable(unsigned long *name_size,
>  				      efi_char16_t *name, efi_guid_t *vendor)
>  {
> +	BUILD_BUG_ON(EFI_VAR_NAME_LEN < 512);
> +	*name_size = 512;
> +

This should really be

  *name_size = min(*name_size, 512UL);

so that a smaller buffer size provided by the caller is respected.

That also removes the need for the BUILD_BUG_ON().

No need to send a v3, I can fix that up when applying.

>  	return __efivars->ops->get_next_variable(name_size, name, vendor);
>  }
>  EXPORT_SYMBOL_NS_GPL(efivar_get_next_variable, "EFIVAR");
> diff --git a/fs/efivarfs/vars.c b/fs/efivarfs/vars.c
> index 6833c3d24..5a01833a6 100644
> --- a/fs/efivarfs/vars.c
> +++ b/fs/efivarfs/vars.c
> @@ -391,18 +391,8 @@ int efivar_init(int (*func)(efi_char16_t *, 
> efi_guid_t, unsigned long, void *),
>  	if (err)
>  		goto free;
> 
> -	/*
> -	 * A small set of old UEFI implementations reject sizes
> -	 * above a certain threshold, the lowest seen in the wild
> -	 * is 512.
> -	 */
> -
>  	do {
> -		variable_name_size = 512;
> -		BUILD_BUG_ON(EFI_VAR_NAME_LEN < 512);
> -
> -		status = efivar_get_next_variable(&variable_name_size,
> -						  variable_name,
> +		status = efivar_get_next_variable(&variable_name_size, variable_name,
>  						  &vendor_guid);
>  		switch (status) {
>  		case EFI_SUCCESS:
> -- 
> 2.43.0
