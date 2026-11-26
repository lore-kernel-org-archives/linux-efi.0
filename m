Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795688886;
	b=Wmdfy5RXot77sakhaeXAmDBG2E67E9NyW+zImo5OSstDUG9kJFhp/u7jPyjs3ueMplqK
	 MzW6bhwpNo57JkjImTCNKaeX2Zyu0hXJU0bDdIirooitKPgDcr1RUyTfRIqgO0Tt7d7XW
	 /Pg+SJLRLqwx3nwVk3SDV5PS8miyKuNgCVnqGLkLXXhnfTEwpAhwiCPr+J5xxITP5dAoK
	 /zZNGlAAROijI7vSOE1vXAPEQHlzk8nEL6YY5g1WEHlPIXJ0Nea27ATReHITF/m9lcwVY
	 /EvRNHT9tIjOUqILPGaTq7NbleVg+Dk+G+oWbF+zcEOC0J1MRgmKKb81eG+T6GdCASA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795688886;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=MwPo1SbEkJSMwvyfYZrrVFgF447rpl/A4wWmxlOULV0=;
	b=xHbdlSnGe8qES2l6mjsHgRxuJQR3A+8TUFcdm1Pm2fwSgIbaIm5DM4t0L2Gq/Ce0ivzG
	 tfO7IwB42v98HPXdeJcwRHDgpb/goVt7JfCPf9vk4RXh+lP7euA0zBSvfJnIl7flhV0P0
	 wA5Dbpv/KDFRWEzYl+X/iiT1b2HWnOP3bWU90CLusn1vScwrw94FLvnN+ufvzskvDVJIc
	 Q1Nc6J5Apc9/2FKXuF3pqnRg3EkzDZyM6mRxhlkjt3uga2KYWd9DC5le8SAAn0/Gp81HS
	 9ZNKcHzgqAbGWRj+W2Xi7F0IGMfBJLRQG3KFTES4wbHA0pZ2f/MdARIb8mjLePLmfvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mf9bmvjl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9F6606A31C
	for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 10:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mf9bmvjl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7331F000CA;
	Thu, 26 Nov 2026 10:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795688885;
	bh=MwPo1SbEkJSMwvyfYZrrVFgF447rpl/A4wWmxlOULV0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=mf9bmvjl1U5wqTY1mB2O4KUGGnvMNSNncHPpd9/7PgCYmE64gXL3ndShasXNZruGd
	 IxDmNoqmFmMkJ8tlnc9veBbALhayjD8YhJzQZKkk93XABb3OjpHFVqGCmCisDUgkBM
	 Vzrpis23XnVfV13EEynGH3TvaCiZ777UCdMb8O9h5znskZbEGFSUjMmUddg+qNujM0
	 x3r2chqp9a0Qzn/sKb/Myd+DlAGK4Ih10QPP25STNyD5jCM2uWhwEQmbYAAHRFjNBy
	 Mi9eNL80zJcmU0PBNJdZtabKtd7+C8hNBob5hcmx8o1ti8weAsG6UEbASg+ZPbaWX2
	 yaYkrTVmCD61A==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 62E4D1980052;
	Thu, 26 Nov 2026 05:28:03 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 26 Nov 2026 05:28:03 -0500
X-ME-Sender: <xms:sAkIa4skbmHC73v2upP0f0Op5b8e1jHAKoUja-N3FKGPna53MW40ew>
    <xme:sAkIawRFbYYwg9SyMFzPIlBjEtoH1k0ACHvTk-9jY7xuWOjiYIeWU02i93ZYBnMeM
    S8HJ4vlSqfXB2M3q6FU8aFc2c021BF-ZaIpcPRLfZWAJ3moJNR7BQX5>
X-ME-Proxy-Cause: dmFkZTELNwvqaE9jHxFHcD+ED4o2ETZsR6w/vYVjUWe3YegFlFpLsxmeHQSIJgyNrG1Q92
    2KRmGRSNfQh+QqEvaylQ+P9l1fmyBlgWvkkl23T/05sF32Y7IIaw2Tze+e72NAlDYKU3Rz
    QwabmXJTlGrmsSJ5SLS6V7czjl2luBBtYDbtyX0GlTahKj4wz3Gifp1LUUWopLNyklvcs+
    RKuP/8wZOq3zTTiNIWLWr2s1DhFvmjB6g0krgJ+FgxbOiKMSgHsPB+BuK0EQz+hJxwKvQ2
    aKj5UlFyHK1KM4ptgQ/xqfO2GhlaO5qCe4Gm+VGHL/fDmxNqzSKwyFVhdmo0it7Oj/DdGo
    tj1RxFUgagQ2Pqhh/VIp3Zd0Za3xIM0UOt2QcduxjxUNGzRJ6TKGu2R/klDkeQkXWoY9W7
    mJ8ICcdLM5C47BDNX8mh05ONIhFIlzJUgwFbSpunZzlQhVMp/58G+9o8zTzaKZwKuveZUw
    DJxQyfrql4cTERNizKplR1KtpHb3dGJXfP0ggeutXzzXH+M62nsYKVhZE/u4VjiDagckOw
    4CI60LdBLqD4+bWWiWDpHiXtIwSZIV1LAGxDSvfLffFL+LNHhQ8bDfEcE3ivL6jGgPSyAK
    WMsJ9ono1c2tHJfnY2T/bGTGBhdGcnmeQfb+ztXTNoUb3FiUXMU1isO27ADw
X-ME-Proxy: <xmx:swkIa4axoGPvjzw1uZZ23X4uvlN0NrivII5g1pa_XT7XKa7Uazmfnw>
    <xmx:swkIaxqA6gjXk0pq710itYZE3OP_HBqM_4SrgSrud9Bg10sHeQ2MlA>
    <xmx:swkIa8QqNhbXv00qX_1fInBQ8rik95iTW3zXTqgmbFC59tr89obd5g>
    <xmx:swkIa1ogEXscMOOoZgkF3tAG1Lo-w2SVT4IcGR_WApA89kW7YeIpuA>
    <xmx:swkIa229HngrpqPfgPEC1cjJ1ap903UDIBzgl_LyMoj00Bo1ivKSsoIk>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 4E101F80093; Thu, 26 Nov 2026 05:28:00 -0500 (EST)
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
Date: Thu, 26 Nov 2026 11:27:39 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Dmitry Antipov" <dmantipov@yandex.ru>
Cc: "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>,
 "WANG Xuerui" <kernel@xen0n.name>, linux-efi@vger.kernel.org,
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
 "kernel test robot" <lkp@intel.com>
Message-Id: <088e4dcc-8f8d-4b89-b33f-8ec39fb857ae@app.fastmail.com>
In-Reply-To: <20261126101452.590895-1-dmantipov@yandex.ru>
References: <20261126101452.590895-1-dmantipov@yandex.ru>
Subject: Re: [PATCH] efi/libstub: fix building loongarch32 without zboot enabled
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 26 Nov 2026, at 11:14, Dmitry Antipov wrote:
> Kernel test robot has reported the following error observed on loongarch:
>
> loongarch64-linux-ld: 
> ./drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function 
> `__efistub_.L47':
> __efistub_cmdline.c:(.init.text+0x258): undefined reference to 
> `__efistub___ashldi3'
> loongarch64-linux-ld: __efistub_cmdline.c:(.init.text+0x268): undefined 
> reference to `__efistub___lshrdi3'
>
> Since this happens with CONFIG_EFI_GENERIC_STUB enabled but
> CONFIG_EFI_ZBOOT disabled, tweak loongarch32 build to hook
> extra library objects on the former rather than latter. And
> this quirk seems no longer neeeded on riscv32 because it has
> architecture-specific implementations of ashldi3() and lsrdi3()
> which are aliased to corresponding EFI stubs via
> arch/riscv/kernel/image-vars.h.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: 
> https://lore.kernel.org/oe-kbuild-all/20261122125352.gAcg5yLx-lkp@intel.com/
> Fixes: 442082297e3d ("riscv: fix building compressed EFI image")
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  drivers/firmware/efi/libstub/Makefile | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>

Would this work as well?

--- a/arch/loongarch/kernel/image-vars.h
+++ b/arch/loongarch/kernel/image-vars.h
@@ -8,7 +8,8 @@
 #ifdef CONFIG_EFI_STUB
 
 __efistub_strcmp               = strcmp;
-
+__efistub___lshrdi3            = __lshrdi3;
+__efistub___ashldi3            = __ashldi3;
 #endif
 
 #endif /* __LOONGARCH_KERNEL_IMAGE_VARS_H */
