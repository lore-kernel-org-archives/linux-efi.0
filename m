Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F171D3F4859
	for <linux-efi@vger.kernel.org>; Thu,  3 Sep 2026 09:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788427662; cv=none; b=MKGMQr3M2YddldkkNPnUhbUCFfLdlvCjlCdFCyfjpVmwzeGeCKIRi544ggEL8FrKB/ap94KOvhX50wTVHphhquPhQgnl39RdsA/xfvSSq1gtWvhUYHGw3XLeiTKn9wOdrm54PLnbBCuAJ1G1u0C5u1LwQt5LWbHtgRcX+YRugek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788427662; c=relaxed/simple;
	bh=XibIeOSWpX+DZUMfWBL2ZIv7odIeN1k1W89wv0bX3pw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=GBF5Kp7rcXOTctGCGMzC/h8veke8mBt2EQmwr3K1dMDJa/DLS//nW4jhxK8AOv30TfNouQ7DawcNGxuyxYjkxMMoTfYQOdq8CjlqzhjQvg4SvSgWkxQ7GiNBy9xO7qarHoUd6htXmPyIHtaKgSxIaSOKmCOWLhwbAnWjP86x0CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jENeiXHj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jENeiXHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE12F1F000E9
	for <linux-efi@vger.kernel.org>; Thu,  3 Sep 2026 09:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788427651;
	bh=BtmkQEYIOFuzftiSvZas/3kbN1nxqaqnvOyXFVrkfVc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=jENeiXHj3DRFXgl2ZRELy7afmPNeyo3DjhxNjP5wd9qs3fLE/D6Inu4GshZqSnFrw
	 HdrPU9HDW5Lj6Nj5X5NcUsVNwcaz46Yjjb+j7U8WZQhXo1bgYQ0NTdNN1RXJIO072t
	 XzZqPYDi9N4s0GqVendIoC/r/WahKFEOzRUBy3NWaPBcVPKPApae5L0UeIZJM9EbSG
	 vIctsKjq2/KxsBmF34xQFVj6ZNCYnC4svk2cHTkXwP8YWIXolsnEo0+J3pdaoXcyVV
	 VZt2IYppZbLB5yjM531pD4lSFKHD+BeqZsfBYzUoGlxfgU1O947kQAGIgOPzlz08iP
	 rAyObY9Y8L82Q==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 16595198003A;
	Thu,  3 Sep 2026 05:27:29 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 03 Sep 2026 05:27:29 -0400
X-ME-Sender: <xms:fz2Zau7MWLhU9XB3n9-UCZyIngv3xEW9_rMPD06pOh66gUt_pdKkCQ>
    <xme:fz2Zaivp43AO6UhHwHM7cdQsmV6dbhRiRtY-0Zz3zqAmr5Gw_hBFLS0piY4S65Sly
    A9wdnAdiSG7IXsUK9D7zpwbucAsukQ-Xd__h3hE9b_7Zls3OvHceAVm>
X-ME-Proxy-Cause: dmFkZTEjoeUZn9fs8BThQtUPV37JxisngAiNk6D5zfV44WDVNbk+riElQkXZd2JYz4S3aY
    tUjah9ZGtx8NSjfrokXlqZ43Stah8G10G33xApL4B2WDsUQ43jbwMUQG2haAv+mGjXhAau
    def5Ce0/cX5RMLvrV51ucR5OADHlBKx9Ng0//XIv/ZwpAMlNmK0du/XzsXG62v2aO6sB3A
    C6go7/sSLyHzd/8oehO/dthvXAqvriTyN0jhPIvUzC7Nu/oZc8FYbcnqQ1LRGk+8RUswdt
    2ejftr4LCrlRXRJqofvyhl5hkoloUxkQ+5TL8xj5DOXTjL7GsLwNzRGZZQLwiU0jzpwwrk
    3l3qh6lCp5w7guupLDOKQkUq+dMJqwYlCHvGFHo2rKBYqSMBwAw2HJNz2xAQnB/AbDWh9k
    lX5G75adOotT7jPnDstNBJRjbIFMOFVscKp5zX1XsK/iRM04ZBcV5WxTwlET+I/BmMHwPq
    Xja4Znh2lYwBQlgXT1fqSXZ6ytOdb+2bo8QN3d5uTIxAOVRUS/wwC0TW5pEPyqcJVHTy2S
    HvuDisdTyMtb3GB2Xnxoqm+Om960+2CkPHj81bCjqG5DTiIInjR9rWzNZUzfTmrLLFTwxO
    WNTIVza/Tz1u2cG+/7uxxjnq7QAaiwuT52MgXq8h1rQ1OiqgTutB1G4/dS7g
X-ME-Proxy: <xmx:gT2ZaljFHd4K5eTf7k3R2Kh7oh8Jj7kUe_BWMrED4GVRai207x3ovQ>
    <xmx:gT2ZaldksN2XN3sEZYsgZxbJ-r4HckkFpsNqXrzy4LrjzaH-G3NegQ>
    <xmx:gT2Zaon2X1hE6gMx3EIhK-R_wMpuD7S9BqB7UZG445I_0KeA6ultsw>
    <xmx:gT2Zauv00wdwnpkrTlVUuH_zT162ZzewTN7VAJv-ri2LyevIed75-g>
    <xmx:gT2Zau_8APnDvDTk_x_tSdoygSpDI1e1idRCwXfGPh_QLWGYdAYtqmBu>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id C7C14F8007B; Thu,  3 Sep 2026 05:27:27 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 03 Sep 2026 11:27:06 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Danish Khateeb" <danishkhateeb03@gmail.com>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <5c68db64-0647-40f3-b0ad-60aa24246b9b@app.fastmail.com>
In-Reply-To: <20260902201340.70189-1-danishkhateeb03@gmail.com>
References: <20260902201340.70189-1-danishkhateeb03@gmail.com>
Subject: Re: [PATCH] efi/capsule: Replace kmap_atomic() with kmap_local_page()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 2 Sep 2026, at 22:13, Danish Khateeb wrote:
> kmap_atomic() is deprecated in favour of kmap_local_page(), as described
> in Documentation/mm/highmem.rst.
>
> The conversion is safe here: the mapping is created and torn down within a
> single iteration of the sg_count loop, preserving the strict stack-based
> ordering that kmap_local_page() requires, and the mapped region is only
> written to, so neither pagefault_disable() nor preempt_disable() is needed.
> The surrounding code already sleeps (it allocates the pages with
> alloc_page(GFP_KERNEL) and later takes capsule_mutex), so there is no
> atomic context to preserve.
>
> Build-tested only.
>
> Assisted-by: LLM sparse
> Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
> ---
>  drivers/firmware/efi/capsule.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Queued up in efi/next - thanks
