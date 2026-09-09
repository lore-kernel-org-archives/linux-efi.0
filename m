Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19B6563FAC
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788968009; cv=none; b=AQqac05+p/W6YWrSyeu0m01OWTKZdAyc7DH53FBerXNkbMdWFKmBws00LrMbZ7qG5/eQgX/KgPKynjCLZUWfoUohxpxFzkp4WFdu0h6ZNNIBfXuAYfpN5ieDSZbCXWkqNWYaUdMpQX0zdw7ahv0VyTH0Ntfy/h7mM3zgEXv/xrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788968009; c=relaxed/simple;
	bh=pmMRAIJutnk3RAdFT275ZvLGsPRVo3eefCHeXF7xHo8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=pPcCOPK0HfnsvsTM0xNdOdLcd+2KZxI2yzKSPnTojoTLAl+ZeQN28g1mPeUAXiiEazbH/0NZ8AnDDP92DtbKu4KlTnlvVMvm2c8oc+Ogh5u9c3+Rlk+wpxU0MyT7qB8Q8gbgBxBHp3cF8rWeuufkC9V76o91U0nefWvk0Sh2PfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbLahzXK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbLahzXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0081A1F00A3D;
	Wed,  9 Sep 2026 15:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788968007;
	bh=O/7yjukVpaYoYC3upwRCQBRk3zXSImiSToMpsxi8EpM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=fbLahzXKPNusT9MDJ3quZekZ8cPOjj949I5ZjXPvptlKnqPuatbIsP0oobwOsJPmL
	 VuEkIdm2nlTfkdRS+RL0ohqrTriIICfvHwe2Ay0Rpvv8uq/hzF0o0g0aUG0PkjxOko
	 yEBxYUQd8oVtY/MYt2MXPCBolMT51LMQrn8dmmNDYa97L7Y/R7Kyad75FcvBG2uxYR
	 68pps7mJNVfsjxIUd/6jEdvDWZMvYKGdslzNHIneVc9mz1XnV0Mw6CyN8MV4Ixmwii
	 VnzXlPMsq0fB+hEHNaEB+RfNb08UGySHofzbFjifhykal0rxmDt9C6r1M2hLnDEJxK
	 J59nY/4FrSk+w==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6FBA6198003A;
	Wed,  9 Sep 2026 11:33:25 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 09 Sep 2026 11:33:25 -0400
X-ME-Sender: <xms:Q3yhahBvAqjl384R5JUckP2jP_UnYRJ8Dz4pRa-WA7B9ecpBrlSYHg>
    <xme:Q3yhaqV9INeOxZ_MPbivLTAsYi9VnHM64uKrE7c45p1cKORAu8VpNkQb50o51fuWF
    KaK5o-vG-GtTZKKUdCAOdSvFpzU51uD7OpDhIN_MC4wrsz6kdzFXmAg>
X-ME-Proxy-Cause: dmFkZTF1zARIWJeyfo7agylEVa4pRQ4PJDgfdTnOUABSB7j2xisFi4lJlKCCWDthM0G71F
    V3V4Fbyk6YYPlje6U08oOdJm/chhGmNp8cxRNmbmW38c9vXTzR2W4cErxRdmLj1flTMC3c
    aOwunmLr4+PXga/5dR+42eHLPyO+ReiAnzt/fV52sQz0lsmmmUn25Yvc+Wwx6HSCMRp2ob
    jeho8V+x9O+zqRa2G9JuFyzsycTIsLqeAo4flxnLzQZHVlQg/xOmpfsiOIoX/DZzgaKvAk
    Jju+XdMzWyMILQOlZtsFBCp0sjGRhScBScZcirZJLDoOYJnzlDq7+w+RRBodhUflIQf/jD
    HxKLTcujaGU39IDcDrNGG2g8Vz19R7Zr2mAA0+Sr336xwyzyzOZ8y1qfvouea+yC5ydzJg
    Hc5KJfgJdGENePfX1IelKp5r3mrr85Qrbqh2AvQynj/rNnHUq2TfXdA72Qbu9kQoPQT3eR
    xzDTQJ/qo+eAiyYQralffAEz7s9K5OB/ACg11+YpqwLlMaFmN/ycoBHYNByWZV+rs6oEuD
    4cR/y6jMueVbdw8oZ67Sd1FzfG05P/PJyziq/tlv6xwOT40GS/O6fvVTaTFbtXUVrcSUtG
    r0A8+lntlGduHpXG+UAP/ygkdfi0+BlAXjUpTePEshJiUDvtvAYDd4Ofo/QQ
X-ME-Proxy: <xmx:RXyhaghcOI5Q38ho65UWKV7Vnua2IT2fiaHev4woAP22U8iBUB99pA>
    <xmx:RXyhallG2m91njc40Ln7h2MvOhy-pbINkNLTxACOIg4-tgWkoup3-Q>
    <xmx:RXyhasgi1jYpaOHpboL5CEZ6Zd0iw90T0XFYXpb2WE95AYcSPvJmOQ>
    <xmx:RXyhaoGAQW1SRxjnvcbFjVXbuTstzsBOjaGA4DclGpSf-TApam5flg>
    <xmx:RXyhaut0YQ_GCzYoz02_0994GOmnNP5siNdLUfCu2Q076FvURpI2t_-1>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 6A165F8007D; Wed,  9 Sep 2026 11:33:23 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 09 Sep 2026 17:32:57 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: linux-efi@vger.kernel.org, linux-hardening@vger.kernel.org,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Kees Cook" <kees@kernel.org>, "Tony Luck" <tony.luck@intel.com>,
 stable@vger.kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net
Message-Id: <273c9217-4630-4585-8cb5-3c5c8f0b77d3@app.fastmail.com>
In-Reply-To: <20260906235838.2928815-1-gpiccoli@igalia.com>
References: <20260906235838.2928815-1-gpiccoli@igalia.com>
Subject: Re: [PATCH] efi: pstore: Fix pstore_disable parameter setting (if built as
 module)
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Guilherme,

On Mon, 7 Sep 2026, at 01:55, Guilherme G. Piccoli wrote:
> Commit a28655c330ab ("efi: pstore: Allow dynamic initialization based 
> on module parameter")
> introduced the functionality of switching the pstore_disable parameter,
> effectively allowing efi-pstore to be used even if builtin and having
> pstore_disabled=Y (a lot of distros do that at Kconfig level).
>
> Well, it also introduced a bug if efi-pstore is built as module and loaded
> with pstore_disable=N parameter. On load time, load_module() -> parse_args()
> calls our mod_param callback efi_pstore_disable_set(), which initializes
> efi_pstore, registering it as a pstore backend. Happens that, slightly
> later in the module loading process, do_init_module() calls our module
> init function, which currently ... retries registering us as a pstore
> backend. Since this was done successfully before, in the module parameter
> parsing, pstore_register() refuses to re-register us and efi-pstore ends-up
> clearing some structures, like freeing its data buffer allocated memory
> and setting its size to 0.
>
> Net effect of that: efi-pstore ends-up in a weird state, partially
> initialized but with cleared structures. More than that, if we try to
> unload it, it won't call pstore_unregister() but will get the module
> unloaded, hence pstore writes on oops or with other frontends will
> trigger NULL pointer dereferences.
>
> Fix it by guarding efivars_pstore_init() against re-running if the
> driver was previously initialized - this is kind of an analog to
> what is already done on efivars_pstore_exit() and fixes the issue.
>
> Fixes: a28655c330ab ("efi: pstore: Allow dynamic initialization based 
> on module parameter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
>
>
> Hi folks, apologies for introducing this bug =|

No worries :-)

>
>  drivers/firmware/efi/efi-pstore.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/firmware/efi/efi-pstore.c 
> b/drivers/firmware/efi/efi-pstore.c
> index a5db3534f0a6..2e125db7d43b 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -263,6 +263,9 @@ static int efivars_pstore_init(void)
>  	if (pstore_disable)
>  		return 0;
> 
> +	if (efi_pstore_info.bufsize)
> +		return 0;
> +

Can we please address the root cause rather than paper over it here?

What is the point of having a) a pstore_disable= param on a module
(which can be blacklisted or simply not loaded) and b) having it
runtime writable so pstore-efi can be toggled on/off at will?

Also, the practice of controlling the functionality of a builtin
diagnostic feature by poking something under /sys/module/foo/params
is in rather poor taste IMNSHO.




>  	/*
>  	 * Notice that 1024 is the minimum here to prevent issues with
>  	 * decompression algorithms that were spotted during tests;
> -- 
> 2.50.1
