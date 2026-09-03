Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208743F5BD7
	for <linux-efi@vger.kernel.org>; Thu,  3 Sep 2026 09:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788429331; cv=none; b=rO50q6Cb+oHO3UL524LA21DHCJ+HRxnbwsZeVhxLZ6LIxTZhfRFdQcTr4oOZwRz1Vca3hyncqktGUtsdZmVgGgm58zGs9+oPCmguAZVVfp/E5Zlb+EnAJI9auapqvvZ5246s9eveOKdu+GATqlHI5fs9hsvhEgM722dQ1woTmrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788429331; c=relaxed/simple;
	bh=5D5RioOePvVVVpqlzVLVZzhRBSmcrL+ZmJ7BWotiz0g=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=XdCEDMtEMNfhQmkDL2j4CbtDPlUXoBdogHzQscSWKR17N+Kje75rv3QtPNonA2khEPIfBTlLziypbeVagVSNsgP7ftP1rqUlYOYkPK/Oh34FkbBerw1LQ+aLG1gk+5RFuJlO7bRmNwENJVgq73kFPzw1eCLF5pGJTDkCTW6RlWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PhVSO4Tp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PhVSO4Tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5442F1F00A3A;
	Thu,  3 Sep 2026 09:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788429329;
	bh=edAs9iwUUkB+qKwn4NBrCpSSruEg/xQFdmG7j35BHQY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=PhVSO4TpalnfcAeBc6GvXbNTICbMv6rJ8Bv591egbWVVVMz4a70BVRj9OchwvAg2/
	 vf3Ce0LhtWa5sbrCmHOluaU8+WmM61eM7XIEo4GaE+nqIXQB1K3YyHhXFV1fl2fZkB
	 PzG3oGB2Sw4YyExzJt/iltwPiw1pMK/CdmO5Bkhu0bbTWD/aVTJ0Ebhzfkz1sYjB9W
	 7po05NFz9WVhLhNzMbLs0Qhc5FbJCtiJSDHsKmMDFeh3q5OlCe5Nn+83Yw0wWJ1EYS
	 uxj5A4KYqPQL5fBhgXeSEHhWhEqH+ir+jK/ERnEcwX+NBKdg2gFKv5vHaSXTSGR2nI
	 MuDp32JP5IIhA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 07D6A198004A;
	Thu,  3 Sep 2026 05:55:28 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 03 Sep 2026 05:55:28 -0400
X-ME-Sender: <xms:DkSZaio7-YJd86itkj7QUc4k3lrLiCRTKakONjHctj7PXdpL48d4QQ>
    <xme:DkSZarfAjIHe8AmCSxGy0titkHAULOAUNlzit1MfWR_YsFSZWk8Jqtw4OfyFupal6
    9IB0iGGznF6XOqysnvBodivsyuIQp3Obwm71eoQhrbHst5eYI8BXlTG>
X-ME-Proxy-Cause: dmFkZTFXvIm2nLWDRS+GlxQzSpTVvLiNwldFZ85yC5hu3iZ+vpblvux6xymJ1M3oKFaNOZ
    awHr8IIr+s0sORHGVgpgqxqnGSf7Gh0ruBCsoQPQoTdF6+miGXAqFRenrQzzM3gHiw6JfG
    O20ZG4FzPkhxBacIInOb9tg7WAtc/ofXx7lkuFJBljjs+3frJVNPRS3/enZhOtlTZDE6fx
    sH4gVSpobS8sUjZjlGmasQDxSLLsYgn7hzhg9uSxBJtuZ/xkK89cu6APGOzFueM7OqHDel
    vpSeoey1vI+LHdzduGfdONUb/HGa86ZqPikoWYqTLBSSYhigyIFOGoHOjxsFg90sza3gCV
    +OU0Lr6hi1UZ4ZVcQDDpF1PmOBQOO7SdWrPUFEpVozSTIh34R4qN7WFM368vZO+D5iCnAt
    g8/tshrpujT/FuhDk9176OxgKgilxUmBamu6Oc2e0uhVGCWCueUgYw/vC8lLrl0eaHP5Bz
    57aVE1TJ79FwLuNFziESn8YEWSOi1eFuJLF+Z5XWCLpW5LijH4xlSDgxjC02zfS7MLTrwu
    IlR1pQOTPwCbBsVfqt9qDP6QrDNiQz9igTXUokfefQ4/OpPU7mLCe6+uX7Uu7msVY260Om
    0Rv0j0+50fa3TnrBTTbDOI/Rp763JeYYfDeHbKjg9pQUY6dyJ8Dcga+sCnhw
X-ME-Proxy: <xmx:EESZaioBkv0kWLyCO1mBfRPyAj5A2d2kGufuI3Te9hYx2EmD4pIZhQ>
    <xmx:EESZaso4poOahvOib_qybRi6RLjyJmTQ1RGWey9TJ6gxNOY1k2lUpg>
    <xmx:EESZapb6xm1NtpwJ0xC57Pes3W-0SnHso8CCiSpuYUcmq1Mr4HjIVA>
    <xmx:EESZai9W18uBhwjZVk0uRI06eFtbQXpszuU9A9F-806ta-pkAKUWyQ>
    <xmx:EESZavnAj_66rpFJ-hKSfGVTo7gGGCrg9fswTwbmfIrgsYix4UtiX0xi>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 2DB08F8007B; Thu,  3 Sep 2026 05:55:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 03 Sep 2026 11:55:06 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jonggeun Park" <jakejgpark@gmail.com>, "Jeremy Kerr" <jk@ozlabs.org>
Cc: "Kees Cook" <kees@kernel.org>, "Tony Luck" <tony.luck@intel.com>,
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <b567665e-9792-42e1-a37a-3ea245ccf9bd@app.fastmail.com>
In-Reply-To: <20260815074844.1330-1-jakejgpark@gmail.com>
References: <20260815074844.1330-1-jakejgpark@gmail.com>
Subject: Re: [PATCH] efi: vars: commonize the 512-byte name buffer quirk
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Jonggeun,


On Sat, 15 Aug 2026, at 09:48, Jonggeun Park wrote:
> Some old UEFI implementations reject GetNextVariableName() calls with
> a name buffer size larger than 512 bytes. Both efivar_init() and
> efi_pstore_read() open-code the same workaround of resetting the size
> to 512 on every iteration.
>
> Introduce efivar_get_next_variable_safe() which keeps this quirk in a
> single place, resolving the TODO in efi-pstore.c.
>
> No functional change intended.
>
> Signed-off-by: Jonggeun Park <jakejgpark@gmail.com>
> ---
>  drivers/firmware/efi/efi-pstore.c | 16 +++++-----------
>  drivers/firmware/efi/vars.c       | 21 +++++++++++++++++++++
>  fs/efivarfs/vars.c                |  4 +---
>  include/linux/efi.h               |  4 ++++
>  4 files changed, 31 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi-pstore.c 
> b/drivers/firmware/efi/efi-pstore.c
> index a5db3534f..a135d6e2f 100644
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
> @@ -185,8 +175,12 @@ static ssize_t efi_pstore_read(struct 
> pstore_record *record)
>  		 * store varname in record->psi->data. Given that we only
>  		 * enumerate variables with the efi-pstore GUID, there is no
>  		 * need to record the guid return value.
> +		 *
> +		 * The 512-byte name buffer quirk is handled inside
> +		 * efivar_get_next_variable_safe().
>  		 */
> -		status = efivar_get_next_variable(&varname_size, varname, &guid);
> +		status = efivar_get_next_variable_safe(&varname_size, varname,
> +						       &guid);
>  		if (status == EFI_NOT_FOUND)
>  			return 0;
> 
> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> index 3700e9869..8e69f3632 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -265,3 +265,24 @@ efi_status_t efivar_query_variable_info(u32 attr,
>  			remaining_space, max_variable_size);
>  }
>  EXPORT_SYMBOL_NS_GPL(efivar_query_variable_info, "EFIVAR");
> +
> +/*
> + * efivar_get_next_variable_safe() - enumerate the next name/vendor 
> pair
> + *
> + * Wrapper around efivar_get_next_variable() that keeps the 512-byte 
> name
> + * buffer quirk in one place. Some old UEFI implementations reject 
> name buffer
> + * sizes larger than 512 bytes (the lowest seen in the wild), so this 
> always
> + * requests 512 bytes; callers must provide a buffer of at least that 
> size.
> + *
> + * Must be called with efivars_lock held.
> + */
> +efi_status_t efivar_get_next_variable_safe(unsigned long *name_size,
> +					   efi_char16_t *name,
> +					   efi_guid_t *vendor)
> +{
> +	BUILD_BUG_ON(EFI_VAR_NAME_LEN < 512);
> +	*name_size = 512;
> +
> +	return efivar_get_next_variable(name_size, name, vendor);
> +}
> +EXPORT_SYMBOL_NS_GPL(efivar_get_next_variable_safe, "EFIVAR");

Don't add a new function here - just move the logic into the existing
efivar_get_next_variable(), which has only two callers.

