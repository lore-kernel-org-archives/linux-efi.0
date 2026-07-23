Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F865378824;
	Thu, 23 Jul 2026 06:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784788795; cv=none; b=Dno0NaKQCOSpVLc+5hnr8+p5Lp0ZrosymYgc0xIF7+j9mn9tk7yD2s036Vj/ffsbJ/r/O45VmwuNTiWebMuBInU5gVR5uzEoFPuEo7hTmbhRU8nIewHOhdYqIQ2KkRxz5GK4nVcwUqusZWQ2BpFLni6mT6diHjwPI50lDboLSDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784788795; c=relaxed/simple;
	bh=blEDyXMNrsqzaoRJbD54QBLuUtWmi3qLVUx5AnwoIq8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=XjM6Y2aALcWjzZ4mJG1AxPdL/Fou8AYG9yfglCteyabuq+va7ICAojh1oeQmZvXM9mOlfpo+ZxFc7MU3PWJly5ua+R7UoW8STGE6r8mFIj9Qvhq7PFWCaPAJc+Gm1UZ20EWQFXMh4ZcYAbiN6gFnlCwytHA+INAiKsch7YcDqYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z2Mi9pm6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z2Mi9pm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE6E1F000E9;
	Thu, 23 Jul 2026 06:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784788794;
	bh=40VDNjAQG+YzCgA1Z3kr+OTh3bZkhrn0NrCAnhn1qrU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Z2Mi9pm6e2cdStOHugO8bPCTYln6waZ5X2sSsaGNR7C7XKsmpek2LLZtes/+QSwCF
	 VbvI4W4y5C+uAyR7uOxmY/2SDSlhzEW3RNuFE+rrN9YJyVvElZnK2rwRauR8ZdYYd/
	 VEJ52WblVeJKtP9YIqAu4JVL9wyFhXIsfNuUVO+lMss4N7Na9B5571nuZ5xcs8D0C2
	 G4jPXOVsSFy8jcZr8ZOZb+AjfWNen+MFt2bDCFUgOs76KA0S/PHjIkI4QlhDc9z4M6
	 2JyATVd8R4SFAx/vwNCZIS1RsbvJLgEkZ7gzlZu1bHx63M1/FDyTtn9qyrVxwzzK8Q
	 1cgp00Bq7VITg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1BFB7F40079;
	Thu, 23 Jul 2026 02:39:53 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Thu, 23 Jul 2026 02:39:53 -0400
X-ME-Sender: <xms:Obdham9EijHV06aH6KpJ5Vj30sqRDA1KEipfwARZokwEyUmmffJteg>
    <xme:ObdhahixPYVdWdQhz8lRnhAUjsELWTT2yd9maoQb8MxNR0hSVBDv5wMoo0KsR8BD8
    my3eVLJeSlCLZLHDu9I1ccFqc9LNFLyd_MNxvHy4HOzkYIIH0Qoemc>
X-ME-Proxy-Cause: dmFkZTGVkFTzjmp6bUS+jilILXKAflN33xaLoK+3uL32H7zk7AVqWgVPepM2rJcTdErR5a
    jRGd0RzF4AUgR1vF2PcVfOHwMtQBc6CmIi9tnwMOXM1fjOIdqieBzhYELXCsxB1PIF2pNd
    10vvmFfINJz45YPOv2V+zXZQ8xHC/c2zGclQ5rowWn00bdEB/8huGGDdcnIgy3WBJQmuf2
    5h6aMoBU+FO7aRPZPKcGZhGXf/KWNONwL264fS23p7wvvGBWXnnAy+cB9ZOyzcVvtjsYcY
    Qju6v+jaZLbT7VzHvADMzaVkPOz+KlSu/VnQh8nAtm9gcHdtWY7w7ll8Rt21J4nD87+QtA
    rV+ErnWf8nmFVaRdGxnAPsuJPlj7eHmw3w/pRQ1iFUgYXoA89UOikbkgw78PDpXTZ3JvQf
    Ukbmi5ROA/XDnI64VWlMBKZ4kqQcHhUmT1BMfXkqQ3hGrTN4dhdeTyCINEHSbnfF67lFrp
    pgLJPdgoWRdTEPkMS2f9KZnKhqUwLJKz4Er2NKaxJPf0czz425KSnIau1M7LuLLieS+qqE
    tNz1Gu6ZaQV+CXfD8Y1yaazWvM5HCaifG9oSPiNcGf/9JzAAnrcPMcgP9DLCUVjjcqPEpA
    pYRS24sH5gJBEX8n2jCZB6k4clIelQSZT/RB9uNS74Q4SKm0AsLmacl5SPRg
X-ME-Proxy: <xmx:ObdhagnE8dyR0hWNL8R9SQrDCnD9xwuVhIPj6mFG5Vz_rtBFNjKT8g>
    <xmx:Obdhap7tqSF4Q9hFwds5JIWYaNeHsl4kXL4LfxyAHlg091_DcZ3vtQ>
    <xmx:Obdhauh7WIamceYFa-0tePFWh2gWEyg4vk8pr8bar8AmWlwrNI9RSQ>
    <xmx:ObdhauEsSKuKH2ib8mx_z9VRsByl8QWMUb1Rbv7WaT693_N8q7TzOQ>
    <xmx:ObdhasT_Bdd26SKJlZadU3xauaEQm-poRFDZ11cKUOEvdSnCzIZ1_8fl>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 02D8A182007E; Thu, 23 Jul 2026 02:39:53 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 23 Jul 2026 08:39:31 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Theodore Tucker" <theodore@tti0.net>, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 "Tony Luck" <tony.luck@intel.com>, "Kees Cook" <kees@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Message-Id: <6ecd6385-37c6-4ae8-8413-53a6e8602635@app.fastmail.com>
In-Reply-To: <20260625171214.8058-1-theodore@tti0.net>
References: <20260625171214.8058-1-theodore@tti0.net>
Subject: Re: [PATCH] efi: Make EFI_VARS_PSTORE depend on EFIVAR_FS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 25 Jun 2026, at 19:12, Theodore Tucker wrote:
> The efivars backend to pstore will not register if the efivarfs is
> not available. The efivars sysfs interface was removed in Linux 6.0,
> meaning efivarfs is now the only way pstore can write into EFI
> variables. Making the dependency on the efivarfs explicit removes
> a stumbling block when configuring a kernel with pstore.
>
> Signed-off-by: Theodore Tucker <theodore@tti0.net>
> ---
>  drivers/firmware/efi/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Applied, thanks.

> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 29e0729299f5..8dfd21e7a8e4 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -9,7 +9,7 @@ config EFI_ESRT
> 
>  config EFI_VARS_PSTORE
>  	tristate "Register efivars backend for pstore"
> -	depends on PSTORE
> +	depends on PSTORE && EFIVAR_FS
>  	select UCS2_STRING
>  	default y
>  	help
> -- 
> 2.47.3
