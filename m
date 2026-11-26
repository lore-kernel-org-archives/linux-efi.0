Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795692597;
	b=zr2n2v1z9m6mkjcz0wkRHJ68N5SyJl47HjTKSIITCbe/vwqRs8M4C7kfN6ii7kfv0esJ
	 7nNY43jQI27ME0LQqgKOlfggk7PBr0FLoHdN3bFfkMQCt1DHo5xD9r5TXGox2up1iFq+/
	 tDCjmCx+HBnjfM3ipH+a9bkklcH2G3Hz9EQdYJYndScq54wSfU44lAyeHE122eSDnvHnA
	 b3XxIvjfEUT0AvWGqj/PR9kril4xTQi1nv/h5/kFwBxb1gzMjGwKwuxfI4fK3FbxlxlnY
	 ZaPLbEK/9NOKh2uTZ8gvFD8lAUjdACWkjPXuWdIN1gbh9p1+WutR4wbT35bdgwxr7Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795692597;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=XhbpXDScqac1UhRIrZyeVYHcl98st9w4XVtGw+jNWnI=;
	b=P5Sm1MtPuncuxg9a8yNykwvrBaZLt27JlYOxh9qyTPaFGn++LQEmkIzE4+1rcQRaXixE
	 OiijGwE533EC8g/GZsEqCWPfRSu4Tt++q5obBrKxmQJN4XCM0w8ryYXcm0ohaZoakw5tX
	 ptBKf/iKNBb5EKVRlAHE9W2/OFx53lxKCsy5NeMu5OWcK7fJ5vQ69jv1NA9bbyWftEuJ7
	 PN9iAsDtlbksVlSNUVPRlxZUDkDiJx9T5fTx2xTPBg7ZKzeloSY6GvNVs/cef+rRxWI1O
	 LiHxhnG+GQJdR9eVboqkq8IJvIhBlk0Kn06uRQkwEuDLDYcmsU5G5AuzQjLWSgiBUXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VEmjJRX9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDCB606A32E;
	Thu, 26 Nov 2026 11:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VEmjJRX9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16541F000ED;
	Thu, 26 Nov 2026 11:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692597;
	bh=XhbpXDScqac1UhRIrZyeVYHcl98st9w4XVtGw+jNWnI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=VEmjJRX9Qy6mjHpVUdDhtSHI0XorPt+27beB9pwkFgmHQ06TxOFaTgECAD0354+uT
	 thnOpte60eU82qW2zVEvAQ1kXOGzi7T46Bovls1bJERasGUIFmqrM9iQfZIeiLCmdL
	 oe9W4/9Pmf8grdqnpHC7M58S7TQOBE3lS6y68V0h5UrU7tM1eXz8jdbowO48Z1CUNG
	 1dkaBSEEK/8ECtq+xl6L6IEXXmUwj/Vkz3JYvAFM2t6Vm7WMoII9ANm14cMMSWuMA/
	 tyvQP1rqzlTcTM85yPN4gEKdgxdQOw2dF5zXuNKN023U+JkoOKYL6T8p+662xtmoaO
	 LpcEfUX4Mihmw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id C61B51980047;
	Thu, 26 Nov 2026 06:29:53 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 26 Nov 2026 06:29:53 -0500
X-ME-Sender: <xms:LhgIa0AousP7ER93-v2O8AnqUTW-qnae7ljZWnumadC8kBZLEjtu8w>
    <xme:LhgIaxV3-wyHVeJuL5hetuhkzkM6obB8zdY9izOZOQmCo1gKsr31v2P3Q0suggqYY
    hCCMW7mHp9aAAdbu4CIfF-bx4bVubCB_QjZLYKOn3UiThEY9qSmvD3aOA>
X-ME-Proxy-Cause: dmFkZTGEvntK3qpQAIuytMySgY5S3YFtOdMVQ5q6UkR4hsNzS17dYCT4A4VJ8mlotDkeWU
    hWnKFssqpk5GJ0VN4nozi3zfUlc12igXAEGezZ8fZxy3j7EqmHd4ZtmeEBT7kGQ6a8dpRB
    OqWQ44yxQLMIacqWRMXinqpRuNl+hdRn+KPjngyMxcphE5G4hR91+Il67Z/2F1pBKa8zqA
    JnAxmdT+ioZ5ywX9OJ+RVXb2EWzvOy4GrwYMSSGwFu8+luKzUH03y08s6jq4sfQ2sJ89x2
    ZziuiJEA/bK3Vqe83dm0ANtspTYKBe2ezvv/qZA1OIb5sxM1FjeXmbiLwrmy0ccYb4VcWN
    zXcf5GyJtYpwDFELG75VNScmgFlEpuWbDnbQIJY+2uGiI+zZH/0o2qOMYmskeSqdNWvhG0
    PwClG0/6LlwAH7KDHH/JVJ7sRxwhqmo43QUyqeUKMnSUHtSBaqt3PurLbS9Xt3TXkjqVQH
    ADft7ezwNPwJm+1M79hvjAC/affJNu0OhkMp2MtiZ4e381o27S2Negf/xGHkJ40DO93I4s
    FgTT5iebhDp3Ms4GVBgHMEhuz3DdjcshRrJpHVDt5DuUDbDZEv1iMW+SOakudNfUKN/hWy
    aSlL7TgWSrZLeUNWkh1lEVjNxOQpwjaiOLHiyrAOmgILkwGajcO0/3ZaPV2g
X-ME-Proxy: <xmx:MRgIa1Z_rg5EcSV9DKtda6y_bX2jEcuTPsm-QLQdiZEIGv0jgZjq4g>
    <xmx:MRgIa3FUoSAnRrqRWfVUA7LInHCSYa6jm52wC520sggTM3Q1hr236g>
    <xmx:MRgIa-ksermYbNQnkPHwxIAE-isdMnMzpNZFo4HjVej66PZ6D6lEFQ>
    <xmx:MRgIa-kQU8_UdoJy8zIKrToJN6zOhgU7j7V9S16-7TiNQ_UfUOgLeQ>
    <xmx:MRgIa7Wo-taHsLgBJjN4YNHgZyisJugpp62n-35rNOj-bu-eMNkkpFaF>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 9131DF800A2; Thu, 26 Nov 2026 06:29:50 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Thu, 26 Nov 2026 12:29:30 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, "Mike Rapoport" <rppt@kernel.org>,
 "Tom Lendacky" <thomas.lendacky@amd.com>,
 "Rick Edgecombe" <rick.p.edgecombe@intel.com>,
 "Pankaj Gupta" <pankaj.gupta@amd.com>, linux-efi@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, stable@vger.kernel.org
Message-Id: <2c075daa-978b-4efc-bb36-736909ec5ff6@app.fastmail.com>
In-Reply-To: <20261125173338.1250080-1-kas@kernel.org>
References: <20261125173338.1250080-1-kas@kernel.org>
Subject: Re: [PATCH] x86/efi: Handle EFI_UNACCEPTED_MEMORY in do_add_efi_memmap()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 25 Nov 2026, at 18:33, Kiryl Shutsemau (Meta) wrote:
> The EFI stub reports unaccepted memory to the kernel as E820 RAM.
> do_add_efi_memmap() has no case for EFI_UNACCEPTED_MEMORY and adds the
> same range again as E820_TYPE_RESERVED. e820__update_table() resolves
> the overlap in favour of the reserved type, so the kernel never uses
> the range.
>
> do_add_efi_memmap() runs when soft reservation is enabled and the
> firmware marks any conventional memory EFI_MEMORY_SP; that takes no
> command-line option. It also runs with the add_efi_memmap boot
> parameter. A TDX or SEV-SNP guest booted either way loses the memory the
> firmware left unaccepted, and it does not show up in MemTotal.
>
> Add unaccepted memory as RAM, as the stub does. Without
> CONFIG_UNACCEPTED_MEMORY the kernel cannot accept it, so keep it
> reserved there.
>
> Fixes: 745e3ed85f71 ("efi/libstub: Implement support for unaccepted memory")
> Reported-by: Mike Rapoport <rppt@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
> Build-tested only, with and without CONFIG_UNACCEPTED_MEMORY.
>
>  arch/x86/platform/efi/efi.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

I can take this via efi/urgent if desired.
