Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE3925228C
	for <linux-efi@vger.kernel.org>; Fri, 21 Aug 2026 07:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787296755; cv=none; b=KVpkcSv/DN31TXQ4RgBnxq9p1DH+BRqTkcRSa3BSt0czdOnHIiDfSsU+B3ZUm/FcrRrphxlOEEIxfVMlUTg1irJoNnRwt+rbDPmo43RFHwDvGV83kRyDz/azzikDkb/PhynGe+mtUu6RJUb/hzXrLGpiFpkTYWqWYLCwnQ04h+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787296755; c=relaxed/simple;
	bh=xNbeQvAC0iHgJQjIzRpxPYT58n1Q8bbUEXvX26y/908=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=umHeWtOgTJOnO2ctjSgUDAxZ7DWIXimlxPXM62jUuhYsZ+f7jdclBDRHrNelhMYN44IQw8YMsRZlSbEjnjJCyM2S5g/zdRNoX7g1CO5SSGgmdSeAnw2nX1W3yreKo8nYdSt1f3MqyGjTdKwDDJIJLd/x9IyDiI1saO8u/NFgZDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ow3ur4eW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ow3ur4eW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B9B1F000E9
	for <linux-efi@vger.kernel.org>; Fri, 21 Aug 2026 07:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787296754;
	bh=M2IdRUn9RG5Rxt3E7ICZpCrekKoDcaVSTD4ItT6VP6A=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Ow3ur4eWEd5N3Am4aOdFSluoragxWQ3sMCRz+nPJP1l3fYJqvWFRHA/F/M1MSlaK6
	 VMeCCsV4jMVf9ChMXQv5DH9G1GEjcuqaRE0hEBQZrzOE131kZcYVbdSqn1P4UtBisd
	 ZgBH26ZoWd6DtIewojaF0fPHdCqxykXO+K/NxU4J6LC3/XynQpSDUdO3T+OwvnPoND
	 4mLCA6WJqEaRO7ikAJxyYWL+3dSr6gvj4VJNUdxPTlXTbdkkzalsasnaBnuyLll+wt
	 LPJle0/tFQOMu7cO8feiOHFUGcpAP0eSoib8ZMHzGTNuFDiXsZn3zc1aO5beCDdvhx
	 UxTLOV5PIUt0A==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 780DE1980060;
	Fri, 21 Aug 2026 03:19:12 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 21 Aug 2026 03:19:12 -0400
X-ME-Sender: <xms:7vuHamQx29p-sXdZ9KVUkQx0EfyXSVCWSU0uVrBuhKljLbBZKGbH3A>
    <xme:7vuHammzcjl6Hrt2d4VgNKmdPQEp2e48EutyNy1ElwSA8l4nuzO8yUZmm8BriXLgN
    SbAGJ1EHpipTw6OIFREZA1-brp3vxDD4M3xvANzbhkqEjm7VqmaAOw>
X-ME-Proxy-Cause: dmFkZTFQteDxwU6oZkM5DHA5hBbB5MEhl30d76igv8rNsoV6LpXHtD+V7O4D/vgwCLBWNQ
    1iZ1+WVPQoFde7koNjVZD9nYmDM5v6KTiQAWq0uAF/ndX9cTc84kkH0QlTocjx3QKDUmU5
    dEhL5zyE/TLN5kkW3AVXUp8KuDHWWdE0qaHQoq+uv3qeaAKK7hzmX61hasGVvW5JYgAbsw
    V/Ek8QiLDRNTK8M/S3KXn1zQMKKdsUQuhcN6FOfCZgY3SjLTnOAltDClM6qdWrxCb0QD+k
    upcOfYucXMGQtg8zQhd3JPc6d8Y5PMQE5CfMm2K2IDGeNBT+7Gcnl/5TdH6SFdEVJlXxPg
    szM5vn/iBatHNdkPehCyHoS7DM04njRk/GMPC8fADaH+uid/nVTSdSrROef/4EpVJ1IEwG
    TZrcGCn4FUWahedWGBhnT3TOB9ZKIBAz+Hir3vF/+A/lWF/qnBuw+pSGVCjvY5PT3zBZE2
    YVL8tv43orMZ8Bf3azbKpP0Izx1beyIPHuV5c479vkPZE2K11EEn+iFPL3ECxXE4ET7Mk3
    yD6MRnxtyMXugyYza+/VWpr1h4we+eUyDE3WX8GW5ByaMhHoBGS+sFZLtyv5IXQIuSbEye
    6/5Gn3VmcCjEl2RLpqv6geiX9wZX8P0ZiuIexI8ksebjJX+rJih39JY/dDQg
X-ME-Proxy: <xmx:8PuHar4WC8HRrp-kUcdRzo66C3k3bZqzdRXjEiIfYjgiitIzuWvFCA>
    <xmx:8PuHaq_CnDWjcQIZ3GwGsADKiyDba8ogsc-81gaW94gg-pzBXC3Qpw>
    <xmx:8PuHaiV61llS1d__qjftxkLa7PpqZdVpEwUPIshAJp3wQSA2L-0_fw>
    <xmx:8PuHato6lDCIPfFk_WUdNiTjJNFptcH8oWOrwu5eTT-HzQG9Kyb6WQ>
    <xmx:8PuHasmogbw4XpdjbyCvxk-Js0F611CV3gVY6v8lebpfTLOL3bcNzkhJ>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 3984AF80071; Fri, 21 Aug 2026 03:19:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 21 Aug 2026 10:18:48 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Theodore Tucker" <theodore@tti0.net>, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 "Tony Luck" <tony.luck@intel.com>, "Kees Cook" <kees@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Message-Id: <4068dc87-df3b-4c08-b4e7-ee8746861d52@app.fastmail.com>
In-Reply-To: <04e11e34-1b3f-4892-adc5-ae2ea040c004@tti0.net>
References: <20260625171214.8058-1-theodore@tti0.net>
 <6ecd6385-37c6-4ae8-8413-53a6e8602635@app.fastmail.com>
 <55870f62-ee17-4aed-850e-790517f68eee@app.fastmail.com>
 <04e11e34-1b3f-4892-adc5-ae2ea040c004@tti0.net>
Subject: Re: [PATCH] efi: Make EFI_VARS_PSTORE depend on EFIVAR_FS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 20 Aug 2026, at 20:54, Theodore Tucker wrote:
> Hi,
>
> On 20/08/2026 12:49, Ard Biesheuvel wrote:
>> 
>> Actually, EFI pstore does not depend on efivarfs, it only depends on
>> the efivars layer.
>> 
>> Why do you think it needs to depend on EFIVAR_FS?
>
> When building a 7.0 kernel for x86 with `make alldefconfig` and then 
> enabling CONFIG_EFI, CONFIG_PSTORE, and CONFIG_EFI_VARS_PSTORE, I found 
> that the EFI pstore backend failed to register 
> (/sys/module/pstore/parameters/backend was empty after boot) unless 
> CONFIG_EFIVAR_FS had also been enabled explicitly.
>
> I can see now that EFI pstore code should not need the efivarfs, and 
> neither should userspace, since it gets access to any logs through 
> /sys/fs/pstore. So I do appreciate that my patch may not be the right 
> fix here, and I proposed it not as an expert on the internals of EFI 
> pstore, but from experimentation as a user. Sorry for the noise.
>

No worries.

> I eventually ended up using the ramoops pstore backend so unfortunately 
> no longer have the exact kernel configurations I used when this tripped 
> me up.
>
> Thanks and kind regards,
>

Thanks for the context. I've dropped your patch from the queue.

It would be nice to understand what exactly went wrong in your case,
but I agree it is probably not worth your time (or mine) to try and
reproduce the exact conditions under which it occurred.

-- 
Ard.
