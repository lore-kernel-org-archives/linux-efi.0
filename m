Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770732;
	b=FtOrnC6Jb3JboZK+2H1sKnaEVEzO8wSURMgyxRvyViAhU5AVPho0dzpPLlQZ0K/CbXUC
	 HwgaddTkclRJvOms8YAdgqZVA5nTnzPgxAMRP32zHma0J30j8ygiaOhVlqz+ESMxYwKk7
	 EZ94RNWJ8oa4UuRcxAO+t5/0rHYCJgi1PtKFirUsph6/ZgtP2p2L4H+zK1X7EqG7aIxe3
	 XSWmafC3EpmWVeznUzuXAlg4nfbywpGnO21q+5P/lL8jrjyg0IeSXsOTTATtJiJIvTvQT
	 k3ExTghsYScClgxTmd30R+Ozy3WeBeCKsMn//POFFgc1H5mH7XNHGfmS6AxTK9MSoMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770732;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=rpZ+aThaaf6JKOCZR6eHW8p6EprLy1ZPV/lvnEseKMs=;
	b=myeCyGgvZ8b1VjPQpflABqCRQratdGKfRxc8cAWlNodWxaCoD7+J4vCDGP0V9nVvBo20
	 HAZXYG9p8qhOOoZd5LTkJFd+z2h1EfG5lt8SXgxTR9kn47jfhmY+JzOLqL+ZeghosSVL1
	 Hn2nXJU7qrbD8SAAvhDOZg2UGxYODCF1xi+5CuRoFFhnY5DUTCQZ9QW4B0iOYHdiM3wad
	 nj6p7WSuw9WPJSts869or9U5/aDrJm8yZKfQ4WL64FiUBJJSPnnRK0EpXK6UbF2LYYTVe
	 sbbHes93fWcwec7ERR4CujXBw84W+ToIatjpV8NrrI6cX6DeQ77Oqb755h3p1PtWnfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KHfbXPkG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85618606A682
	for <linux-efi@vger.kernel.org>; Fri, 27 Nov 2026 09:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KHfbXPkG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4953C1F00937;
	Fri, 27 Nov 2026 09:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795770731;
	bh=rpZ+aThaaf6JKOCZR6eHW8p6EprLy1ZPV/lvnEseKMs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=KHfbXPkGniNPKEiaggG0YtCFldlwFKA466Cp6jj9d97rZDwcjAap64lKPd9Jz/U0/
	 BSuNXcfIn5jEiwv/w6yh/QJTqjB+3jGkf8WSfWYMCAqOOXLef6eVlpayvp2HKJvm/K
	 JVfrelr0GgXopzUIJ+08ipOkVcaz86Y2JSEIrzpnp92pBekpA7cGp2BvQ3LBPUKkQx
	 ahRTI6qceb2SGMieqMON6ZQHPEWUg9vhHdSjkOdbES9skdRFEDO6YwrPX23XXgZ9mN
	 Z4sYIsLfgz6oyozS71B6Kf+RCNBbcyB7qPgmTKN+0rd22LQcY3uPFQDCthznggHvrj
	 /Fh7LNyZcTV6Q==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7EB8D1980060;
	Fri, 27 Nov 2026 04:12:09 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 27 Nov 2026 04:12:09 -0500
X-ME-Sender: <xms:Z0kJazA017So31OFLsI-Xv62556732b7oJV2uGlLxziDsCB49ILtig>
    <xme:Z0kJa0UsU_D4jm1BY2K05TFZDPp0J5zgaEPp59jOYFPyeYbDl11bs3k4TmnTFyIn5
    stAciLqKCMfGylLAILlRAgLju6Xqv2fVp6cyqP2of4GrAGi22lmTzk>
X-ME-Proxy-Cause: dmFkZTGzX5rbUO1NoG3TCpvZNJ36eub2tKVRe5PnFGGsOG2nDTHVk4T9089xzX9DXjrbO2
    qBjBsDbmubD1CYxtG0dYD6irpsmrjyBUny364QfbCo+M+wSpG3s8kbhBBrpluFCg7teyvg
    fUf1fs3KoyEVccMvk6/0y0h6iJB29YSaqbWwWwG4Ne1dxetbI67MfrQYfAnRLJqDtZjED8
    i0zRCZ0rbl79oSjPbBGXktbmZ71lS+uKps4+tStboVFyvpolcgEIem2tpfKPFjt3RElMBT
    NoBtGcpmIQG8u/G+C/Th+83Vw2AFe0vv1y0dvRc2DhGWPNw9Xs8fAYN/mCeqhflZKm57NQ
    gHNt7B2wiYohutSogcD8YMm8vwEBBFg8/4BZn81xs4uOOjBlvkX2o/QCG2E2cArRd51toD
    44traoyO2oLU54M4Eyl2Ph4LhugvDfb5Ro7ETdI8svNlNsot2bTHGQQRDbzNmCbTCQ19TK
    v3JFAXcKAydmooH/rCRfClEtd3qvmwpAzAma5TrX64yKlm+cK3YdcSu/itKIRLd8oZUYaC
    iyExybbeiDDOXPi8eqPb/mLBOTQLk0gjQrw3YZs8/Nxx4sNACoJSpsNZxCDZsaScJdzjst
    8thuTLq1HEuxW+Vvr4NTkZagwtCO3xaGe0iMmLkxsQSRxpcYU5rax+YRwtSg
X-ME-Proxy: <xmx:aUkJaxA16lstdj8zk9Xs4DbkkDjPidtq-o7vxkfpWIfun3gXxMClVA>
    <xmx:aUkJa6cWVej0lp4ePJjnpLj4FhyNnuznVPYyp-va2TptdVXvBbLKsw>
    <xmx:aUkJa7klkSACnMgnc8zMuPPk6GqToxTWoAoaXKP_l94A8_GdWx4Nsg>
    <xmx:aUkJaxFKC3mcVRp1LWEKdbFjBy90Sb0M_zAR1nOk0FYlgYdLMKni4A>
    <xmx:aUkJaz6rSZ_WjzB221EXl5BCQqw-GZ4BKnuqzKRT2Uqa61-HyWrI0kOw>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 4D6ABF80093; Fri, 27 Nov 2026 04:12:07 -0500 (EST)
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
Date: Fri, 27 Nov 2026 10:11:46 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Huacai Chen" <chenhuacai@kernel.org>,
 "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, loongarch@lists.linux.dev,
 "Dmitry Antipov" <dmantipov@yandex.ru>, "WANG Xuerui" <kernel@xen0n.name>
Message-Id: <a4e1054d-dc7d-4d62-a539-562dae4b5ee9@app.fastmail.com>
In-Reply-To: <b6479785-6d26-43f6-92db-627bc2bfe11f@app.fastmail.com>
References: <20261126155017.2401147-5-ardb+git@google.com>
 <20261126155017.2401147-8-ardb+git@google.com>
 <CAAhV-H5fd2K4WTPRSe7bdX3fgqxcC_MkOzwrxfMk1xnJdBW=Yg@mail.gmail.com>
 <b6479785-6d26-43f6-92db-627bc2bfe11f@app.fastmail.com>
Subject: Re: [PATCH 3/3] efi/libstub: Provide library helpers only where needed
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Fri, 27 Nov 2026, at 08:13, Ard Biesheuvel wrote:
> On Fri, 27 Nov 2026, at 03:28, Huacai Chen wrote:
>> Hi, Ard,
>>
>> Does this series wan to solve the same problem as below?
>> https://lore.kernel.org/loongarch/97a95c9d-6736-4eee-ac9d-cbfb47d6049=
2@app.fastmail.com/T/#t
>>
>
> Yes.
>
>> On Thu, Nov 26, 2026 at 11:50=E2=80=AFPM Ard Biesheuvel <ardb+git@goo=
gle.com> wrote:
>>>
>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>
>>> Now that dead stub code is being eliminated by the linker, the only
>>> remaining user of the 64-bit left shift and clz/ctz helper routines =
is
>>> ZSTD compression, and only in some cases:
>>>
>>> - the 64-bit left shift is only needed on 32-bit architectures
>>> - the clz/ctz helper is needed on all RISC-V and 32-bit reduced
>>>   LoongArch
>>>
>>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>> ---
>>>  drivers/firmware/efi/libstub/Makefile | 11 ++++++-----
>>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmwar=
e/efi/libstub/Makefile
>>> index 20b5b77956d1..ba6d67e5cd78 100644
>>> --- a/drivers/firmware/efi/libstub/Makefile
>>> +++ b/drivers/firmware/efi/libstub/Makefile
>>> @@ -98,14 +98,15 @@ CFLAGS_arm32-stub.o         :=3D -DTEXT_OFFSET=3D=
$(TEXT_OFFSET)
>>>
>>>  zboot-obj-y                    :=3D zboot-decompress-gzip.o
>>>  CFLAGS_zboot-decompress-gzip.o +=3D -I$(srctree)/lib/zlib_inflate
>>> -zboot-obj-$(CONFIG_KERNEL_ZSTD)        :=3D zboot-decompress-zstd.o=
 lib-xxhash.o
>>> +
>>> +zstd-obj-$(CONFIG_32BIT)       :=3D lib-ashldi3.o
>>> +zstd-obj-$(CONFIG_RISCV)       +=3D lib-clz_ctz.o
>>> +zstd-obj-$(CONFIG_32BIT_REDUCED) +=3D lib-clz_ctz.o # loongarch
...
>> And it seems the first patch can be folded with this one...
>>
>
> This is an optimization, the first one is a build fix.

Yes, it does seem that the first patch is superseded by this change, as
the left-shift helper is only used in zstd.

I'll respin this.

