Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339EA426422
	for <linux-efi@vger.kernel.org>; Mon, 20 Jul 2026 13:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784553734; cv=none; b=rT4JxtdX+wdVxOv+loCpJZ29CzCzJS+aM+hoW4VreP0v+4DqskbchD9e9X7zZyaUyJBUdTYAPiuN6+2dfx/bnNjjEenY+Qtp5o6wJ6V2RhkO7V3q2OMO1E6QaTu69L1+AULqwcfeR1SfbDPgsYqsjZ9Snr/cdIkq42kD52kpCj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784553734; c=relaxed/simple;
	bh=yche3ppa4pUDYlcuwbbwlPu7poTfxVtiqgbyTMwmvOI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=XZM/fPzAGGnabVB9O1TEktE5ldj/OEii/qQvZiUD3v9Ou/mLf+s33/Sgnoasoy0Hz2fI/FlYy1hEZ5QaXGZov45DHBX0CuqKEZ/1qohTUryT5B5u1Hyy4kdEuvoNx6JjQxuenzb40+sebf6K66XvS8KRTJT3idRV9+Bs4JwHbls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OFQiHMyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OFQiHMyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E49C1F00A3A;
	Mon, 20 Jul 2026 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784553733;
	bh=kbAR87gObYj06eRbvrp7FEuuEMmLYmXEI/kdpCLyIBg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=OFQiHMylE1E8Q/ZJCFTu0jTuRhECNEj8AZLMZPhq8W0RzlM6naBq7vKzfTF86ZrKD
	 NdIX2FuUWGANkoHwGf9g0NQvXfoFNYoJQGxlNYVw/T/0SuKRF2XhiOcvdaeQxf8z1U
	 NBY6TOvwUBd2E+RSrAFUKJEAKhHUVq5RamNwwOUt+zOjtztaM87XcAGyHf3YKctv0r
	 LPErwgyuXJPKHpVUZrexKWNtEFOEY+oWSoVmw+b1gkDDF90u2/Me6fckAVANRmBKUj
	 ikPgLG+VfbkAdIKNipe+IWE1DCl5bAePg/E3YfkDDglAiI3sMHHl+ZLn22c4b6b9vd
	 Fk6VGMzPGhn3Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 825EBF40072;
	Mon, 20 Jul 2026 09:22:11 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Mon, 20 Jul 2026 09:22:11 -0400
X-ME-Sender: <xms:AyFeatJGsi_yrB86WVxH6uxXeWqlpSa3rUHuf0tC64cwjtxd0iyMGg>
    <xme:AyFeaj-nr7tKNHNrdR_eVUW0QDBXA71XdqGEgq9tIRLdZVG-L8uwK772DYrazw2Mo
    R9kZZN-8Q8wbR9CgyE0fhbTlQeXi6tDfrMwWCjCmkaqSJYlGmeGKMez>
X-ME-Proxy-Cause: dmFkZTEoX8KU91uxhYGA/5jN8vcn2m5yb4/OXt/3mAOjLEEMQqFoEa2hDDnxDXHRG4DXkB
    2idfMHpDWuyaQX6YpZA/2lESAiKg6bkyV6uPlfEu6B1sH414Ib3b4GVKWAjLnN4K1RRTfO
    3nlMgiKqgMnh8XjWVAebvkgSVQEbYAtvkTdIIiqRF2Ga7m5yGvUaBvQU52vbxWxA+CsS2E
    sajEL2xZfaP/50aYLhvcHhLP2olQqTHfWbRQLJrHA2Hk9yvu3obO6+GJURH+7mN8M0Iw66
    CLGVvr7b74PkvW5Z+avKZZqskthyeEgt5QInLHyp2BFpJt9gU3Zu3CNkqys5RXWfHONHbw
    9Ev1kRVme+xaT4wYtMR+2FjtPxk218dFKiKLiVnoxuKTGzwAAYBpsfa0rZh7aGugP4oVDo
    Amj5Cxb3FZGPymBm4UR0VkFxBc2+3tXJGTs51BdEbQQy8ClgJoDCRbny0/JkEJDr3mOBOt
    9ofXlaQ1VlG27vASIV5kndLNK5zr4kD3qAvQ/zhLiAVgHanEU4yY7oU1nh1ItRu4fcXlcO
    NhFSQGLcGGB9jZ48m24ib+SA9yoewrpHxm/G9DlJEiqUR+oL2dlNwhOGtB3oUhF1y/Rj6d
    gA33fCLGvfXmZflRnMhM0yU7MjMe+4k54ss9VEu7SHG/57v27mMbfyaEmEjg
X-ME-Proxy: <xmx:AyFeaugdArhsMvqWHfuiVqCLc14pJXU_dRPx2FBatgjrrx-TyTxjxQ>
    <xmx:AyFeaj4Dd34CtK7_LykLhWdMjUo8gb2un9dlut8O6i9PLJobs975bQ>
    <xmx:AyFeaupdCrr88b5roR6x3PNAcpiPOVxNuuV0T-rT2pSLdTdbeS-cKg>
    <xmx:AyFeaoiHheIJPRhzqUt0sFh2b476wTR9B3eNlwlLJnRjdLR5WcpRmA>
    <xmx:AyFeauvLElU-xWdirbAaBtpJSB_2tzLAXbMhoVu9oCgTm5t7oO1PHgPx>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 4F9CB1820086; Mon, 20 Jul 2026 09:22:11 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 20 Jul 2026 15:21:50 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Koki Iwata" <iwata.koki@fujitsu.com>, "Jonathan Corbet" <corbet@lwn.net>
Cc: "Shuah Khan" <skhan@linuxfoundation.org>,
 "Matthew Garrett" <matthew.garrett@nebula.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Borislav Petkov" <bp@alien8.de>, "Randy Dunlap" <rdunlap@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>,
 "Feng Tang" <feng.tang@linux.alibaba.com>,
 "Dapeng Mi" <dapeng1.mi@linux.intel.com>, "Marco Elver" <elver@google.com>,
 "Jakub Kicinski" <kuba@kernel.org>, "Eric Biggers" <ebiggers@kernel.org>,
 lirongqing <lirongqing@baidu.com>, "Paul E . McKenney" <paulmck@kernel.org>,
 "Matt Fleming" <mfleming@cloudflare.com>, linux-doc@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <ba44c9ad-6cff-4e7e-bcb7-c46196db25e2@app.fastmail.com>
In-Reply-To: <20260710062306.1204206-1-iwata.koki@fujitsu.com>
References: <20260710062306.1204206-1-iwata.koki@fujitsu.com>
Subject: Re: [PATCH RESEND] Documentation: admin-guide: fix a doc for
 efi_no_storage_paranoia the "5KB" instead of the "50%"
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 10 Jul 2026, at 08:22, Koki Iwata wrote:
> From: Iwata Koki <iwata.koki@fujitsu.com>
>
> The documentation for 'efi_no_storage_paranoia' incorrectly states
> the kernel cannot use "more than 50%" of the EFI variable storage.
>
> This percentage-based explanation has been outdated since commit
> f8b8404337de ("Modify UEFI anti-bricking code") introduced a fixed 5KB
> minimum reserve threshold (EFI_MIN_RESERVE) in
> arch/x86/platform/efi/quirks.c. At that time, the documentation was not
> updated to reflect this change.
>
> Update the documentation to reflect the "5KB" instead of the "50%".
>
> Fixes: f8b8404337de ("Modify UEFI anti-bricking code")
> Signed-off-by: Koki Iwata <iwata.koki@fujitsu.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>


> ---
>  Documentation/admin-guide/kernel-parameters.txt | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt 
> b/Documentation/admin-guide/kernel-parameters.txt
> index b5493a7f8f22..3f75969a679b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1614,10 +1614,17 @@ Kernel parameters
>  			on all PCI bridges while in the EFI boot stub
> 
>  	efi_no_storage_paranoia [EFI,X86,EARLY]
> -			Using this parameter you can use more than 50% of
> -			your efi variable storage. Use this parameter only if
> -			you are really sure that your UEFI does sane gc and
> -			fulfills the spec otherwise your board may brick.
> +			The kernel reserves 5KB of EFI variable storage for
> +			safety, because some UEFI implementation may fail to
> +			boot if there's insufficient space in the EFI variable
> +			storage.
> +
> +			Using this parameter, you can use the 5KB reservation
> +			in the EFI variable storage.
> +
> +			However, Use this parameter only if you are really
> +			sure that your UEFI does sane gc and fulfills the spec
> +			otherwise your board may brick.
> 
>  	efivar_ssdt=	[EFI; X86] Name of an EFI variable that contains an SSDT
>  			that is to be dynamically loaded by Linux. If there are
> -- 
> 2.52.0
