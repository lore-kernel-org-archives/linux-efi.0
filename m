Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795794319;
	b=x3o6BL9o0IMHv0LyQwK7hb+JU3H1I4e6MJ2du13ShqCwdoNfXXx2oRVAcoiNI914ain/
	 QOaN/SV8Kvg21DNlZHh5xVFhORCBAgEehLM/J0mkXbi2TQXQ4Q1GVCjAVVUaiXK3Lq/mB
	 rG1Y7g1O3p+7fNaIfcmVPc/9kg1ueo73N6Z2EarKbrBtf6+tyoIQBfbbovzM4aAt+iXDt
	 un7/uxZaTIGz7OlJ123A8PB+gL1DqzrcLAQdzIReHjxN07lVFw2J/4LzBgweVRoHBx45d
	 uFiLDq4gFd4X8pomGPpqSXooe/mdlzVdMy4BNnDOKJfXr6BUrqYchO65Zc5SFnf++ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795794319;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=gnDEMS0iHt15gL5KaJ+Nn57X9otTzk+I58v16QdRYcc=;
	b=uMdH9S+a+ApWaJRI56VpfIS7iWRMkFIYkoYwSCPf1HcIIAVE4kH+XbXRWxEJdQ8ItraM
	 Y1cxFuFzlw4WBi1Rbi6Al5YmJhZfRJMP5/cq6F1G/sK+1AtxFSRx9Pfyz08M6vhoimyr5
	 Oln3Bc36oTxauTBuHiXPRIldBeKuyHzTt9ZelGWHaeFFb+qLtpYntYwHecVf84/Cci1kk
	 WWE2xYG9oWWtxn+eaXufz1UEhaVgoc55Hh/TdbNJD+SPsAedP7q2VwuGfcvP2JnO6Z5mH
	 aHWU9poIPhg48xp2IO2DGKBmYYItQwRdgh++VzUtWj8VVEpcZHV6v9vykEhtHzs03RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JB1zssfY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B048E606A324
	for <linux-efi@vger.kernel.org>; Fri, 27 Nov 2026 15:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JB1zssfY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA121F00897;
	Fri, 27 Nov 2026 15:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795794319;
	bh=gnDEMS0iHt15gL5KaJ+Nn57X9otTzk+I58v16QdRYcc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=JB1zssfYw+imHpGzqwtC5bxeRAT3TilT/4N6aggkc/2aQrIFfSKYPjPnNGrDnNuCD
	 i6Q3iaDTFqGIsVtaIEed0I+jvbQmNjOGY0hNBmtE6voI8JTkFcYDjmfcF92t2aRQN+
	 ENcGwC6L1Hmee6FlpOuUsmYvSvvIMUcYf885vMlscaWmV719ZBNjtMUuQus6NE4q+1
	 GuDMExlzxK9s0A0z0wzpLqi6uXoEDtouKh3pCKrlizfJO+Peo0U2usbiuYYHnWVCuf
	 b3Wmdnn8kJMsf1oSSjL+Rjjv+3RkqB2T8knDrwlRloS6lt1DluS9/MFbEx3LpgZ2JN
	 Xe/yFxDspXKbg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3DDC4198003A;
	Fri, 27 Nov 2026 10:45:16 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 27 Nov 2026 10:45:16 -0500
X-ME-Sender: <xms:iKUJa5AkdJxnKccLXcMCurc131x9BzxkyDtyblVcz7UTk0qCfK6l8Q>
    <xme:iKUJayXFm2YhzIgi9SPInDUX-UJiV53UZOU4RVdrD_eqdQDtpoqTcX_P3iLfD7CKv
    TjTZCJ83aqifQrHscXBVAfYTsDfYsa4nS7m01fyEiM889CWl_Fv8CmX>
X-ME-Proxy-Cause: dmFkZTFMcXaa74Ww3Kiq0njNmC6WTjACVv1LMbtEsqeSpRVSFbR/Ii5MZNWGX9Zt0PDC4H
    QxR9lt1bmXDfrRIrCorv6+5mFL40Wh4Sb/IbRj/BEfQvKKf2rrQS9jZJs2KpQ++T3wSoLD
    HNqyZ0pThIqEcsGyNXKeRbGfLfgvIjr5ltrRA4kRQMAh57Sv/vW40wLB5ugCQoAwYP+yDn
    mqcN6PXz8tAquh0HX0rjDTsI5AoO0CDjNZ9dJZhAXhuICxzq9EfL7Fytc6bGOS0h+qgiFD
    r4m02mBJrAEFL2pn0rfl2R8X7FfezgjnyIqIWsi8BdeUbjGCeYNUokspCipztY5uB13oL4
    YuyWH8KtSnS4uQoxE7PMGHY1LlmlFxxm1KE3zJprK9tqrPEVmOck569OEc4Z34p1jVo+q2
    3ivF3fonc3VfONZur+ttGBJiQPDOFX7bO7YbRRwS90s8oKkKqrAOSAp+bDHExf7PFpN9/2
    MYSpyRRZaH5knqwf1zivHKPr3PkJ8A/L4rbGoWpOAQEudRzQJbmBkT/2j4k+aBm4BxMI8/
    7ie4vqieF2IT3VtbrVvRPx/II5OdY1AE31VoMtNRQFbUR9Jq9KMDKqtqe5GqBnHYYI6KCZ
    Osa26CLih0vjr119q8j7LlNbXu+EoLzZC+4Ve+yd15O4D/joKlh0TnVomAvg
X-ME-Proxy: <xmx:jKUJa_qdFYIe-J18cgVIcEIWWYMT9YX8BlOTTPoAY2dY5zm3U0iWFg>
    <xmx:jKUJawt29v05zGj1N-U8j50ppQcmBWYQ0-C0cQ6JoAXHx8VrtcezgA>
    <xmx:jKUJaz5G7PV1fTi4fQ5s08qRx5AGl_yw_XHl41HZSDv4ismPsQ3SZw>
    <xmx:jKUJa5RQ7EvBTiz9Kx9a6LpxkswJ6z8kJ7JlqwouQwm3fnLCCmpRLg>
    <xmx:jKUJa7lULcOKouAxtdiZ0dgPwmK6qX1xlLeMs44QyW3EBqEInflytp2p>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 5658AF80093; Fri, 27 Nov 2026 10:45:12 -0500 (EST)
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
Date: Fri, 27 Nov 2026 16:44:51 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "George Guo" <dongtai.guo@linux.dev>,
 "Huacai Chen" <chenhuacai@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>
Cc: "Mike Rapoport" <rppt@kernel.org>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>, shuah@kernel.org,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, baoquan.he@linux.dev,
 ruirui.yang@linux.dev, guodongtai@kylinos.cn,
 "WANG Xuerui" <kernel@xen0n.name>, "Alexander Graf" <graf@amazon.com>,
 liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Message-Id: <976f1220-a259-4bad-9eb4-ae1cc78a79a7@app.fastmail.com>
In-Reply-To: <20261119082252.9120-1-dongtai.guo@linux.dev>
References: 
 <CAAhV-H5Vse=pKC3Beqhqxa7fqadiGVNqkSy_06HZ3Luw2Pmj5Q@mail.gmail.com>
 <20261119082252.9120-1-dongtai.guo@linux.dev>
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a configuration
 table
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 19 Nov 2026, at 09:22, George Guo wrote:
> Hi Huacai, Ard, Pratyush,
>
> On Wed, Nov 04 2026, Huacai Chen wrote:
>> I prefer to keep it in LoongArch until a second architecture, and I
>> think Ard is the same. But this is not a strong objection to Pratyush.
>
> Kexin Liu and I have tried x86 as the second user, to see whether the
> common table holds up. It needed only small changes:
>
> - The x86 EFI stub installs the table, as the LoongArch stub does.
>   install_kho_table() moves from efi-stub.c to efi-stub-helper.c so
>   that the x86 stub can call it.
>
> - kexec_file_load() skips the SETUP_KEXEC_KHO record when the table
>   exists and the next kernel will get efi_info. Otherwise, for example
>   on a legacy BIOS boot or with noefi, it falls back to setup_data.
>
> - When there is no SETUP_KEXEC_KHO record, the decompressor's KASLR
>   code looks up the KHO bootmem areas in the table, so the kernel is
>   not decompressed onto preserved memory.
>
> The table layout did not change. The only change to the common code is
> that efi_kho_table_found() is no longer __init, since x86 calls it at
> kexec load time.
>
> Tested in QEMU on x86_64. With OVMF, the KHO vmtest and
> luo_kexec_simple pass, and the second kernel finds the KHO state
> through the table. With SeaBIOS, the KHO vmtest passes through
> setup_data.
>
> So I would like to keep the table common in v7.

Fair enough.

> Would you prefer the
> x86 patches in the same series, so that the generic code comes with a
> second user, or as a separate series on top?
>

I'd like to see both tbh, but only if it is not too much of a hassle.
