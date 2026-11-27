Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795763610;
	b=vabXmlZTnRhIKnFvrB6WfwudrhDiyhZK7cdjKWOj35pRmHxeecwcF6a+ENAtzbL1S4zT
	 izQ8ae6TV3LKcxQamz8dgDomOgi/l2u7e1IA6lPP6xmvTpY483IFYAVxaoyX8nvYeruUn
	 9aHd/sETACqxvYUX0pucDFS3fgAQ+8sSiUgxSTrGnk87RUmX+i/arhldEqSu6aD728vW3
	 NyRThPdFd9p5sk9+c8MkDJOBlHKZ6CrHwfDlVtd57A9fM47J1sJ5xbR4UGPLeC6D4ZN1q
	 iSFXVaEGmr+wMV6TPTrTM9AzsDLFOn3m8lCg9L6zDg6+km9kB9zcpxUMzUy3KjhTpLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795763610;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=VySj4RtGNOlQjvvgVju7/YNpGHUf/42jTgBkiZKRTR8=;
	b=xkgJtZzWSqMdehA/kgbkl2tb7qc6bC8y+ebXGuo/KzQh4PDlfBiSjQ74bZF2DB9oeTzs
	 HMQA0EyzUEICDvSUnLNFI5pw2mYxT6g3uCA8T9iQ/iyCtw95uXQaYeicvN8x73XF2bv6h
	 pmUBVBDAjbJT3hZDtmSYIMX4dNhS1VdyYKdUg2n5LxWYQpTXJw4vc9dLBECEWH5D1hdtq
	 6o0jvlgr8M06C6S6aOrCaNcM4YUziUuuqOQmFBhFuKzdqHAvDFP78vNpPcyM/cE2QESND
	 9JDFVMxI/pGgAXJI8hp8MDCsScWoF7ieLKWbRQyeaCvX/RSua1L62+5xzek2xFK6NVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AQ2J7LB+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F5D606A31C
	for <linux-efi@vger.kernel.org>; Fri, 27 Nov 2026 07:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AQ2J7LB+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821321F00897;
	Fri, 27 Nov 2026 07:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795763610;
	bh=VySj4RtGNOlQjvvgVju7/YNpGHUf/42jTgBkiZKRTR8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=AQ2J7LB+A788Wxhld0tMxUfrfN4UiVT954f4YtPcgEEdo8NgXv57ZlT4yqYtjWzTs
	 79wgIw0NZc7At0SMW9dSpzl7l1xYZ+Y44iVPli4u0pCOCc8dY13mgXAL4ly4GpsH4O
	 bu60QLnLhNbJC6DxFpKslWakW31gjjNPPZuOIl7R9qtlAX1MdbysQskBdL0V3T9Ylv
	 qFWKK1tzgMvA+n7+LkWgsuv6+oRa4fwhir8gpm2PbZifzx1Ysb3Y7wtMx4XpLSCQGB
	 RIaZwvi174Nhq+cz3Ld1VKLaUIGOCRzKRYQ5t+IN+JQIy3joNesNeE4wHowmprmgy6
	 P2+oMjNQ+p78g==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id C2B40198005E;
	Fri, 27 Nov 2026 02:13:27 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 27 Nov 2026 02:13:27 -0500
X-ME-Sender: <xms:lS0Ja_QRS73sgE3tR_Zwv6ZDIE5ZZnerWyLTEBOxTcOq93Sk7aAqmA>
    <xme:lS0Ja7mwlgsSDZtqkn99HA2Y-FiyJqgkYXusxF0jSl8h8D7gpEUvzDUNH-uiZEvkM
    Uy3iCQ4Ui7eDPSJ3ilxXIkiaZd_nY_vx2YRYaekHaB6PN9jB2rPACs>
X-ME-Proxy-Cause: dmFkZTEJqCiaCW7EYidaP5P7zgy4J5/Z41+BzAB2YWUuCz1zM103rrgu13MhHOSHU1Ttwc
    /Dv3ewGUTqVIklTgsPIcIeJ8g1WTa2EUgWAZUeMxNiTlw/FBtP1AXgdQsek5FoKtb+HW7j
    Xbbl8mFmIXQiClNAYnhvPqJS7SLoMAAp7qkPBYwwvMin3ONijBUGugYrQ60qbvM8TB/TW8
    P6QAKMAmCMgooENggMJheOkW+PQw0m51AVy4LIzBQgaHJ+9PHtajdodGot7LqWsfNLvmJ9
    mWm5bZSVDWpJ++rFSF4+Je4d0ZO6iE+LstXkHdzVscG9cTsg/TeqOe/Z1GCL30qbI/ABtZ
    PzSP2cqgZT99Ef6BEsDGBwHuQamH3nHN+wUaTYdbi0vRQvDLOrDsLU1FVkvmdAPyXgStok
    ukvJ2uzAHsLJKKdq+zWXWrovYB4sUXLAcoXuj9lII0nx5MV/mW9i7dNcrqBuBQq1NQHD0M
    TtP2wzYbt1Rcs8POPepRGh4O9oeZgopXgg84HkEusm++yS4NlbcKOPGafXoJE7un5BKqyR
    I4lvDlwdCmbhfl+6bGxlEhM+H1d8UMS9uDgmkiVARXYmtDdRCZqqUFLelqnns3YGtMd2nu
    vhP0vdrQHRS3Mq0oaNZEqxybikHneUkvouhouaXaqSuv/Lor8IzawgVjtzug
X-ME-Proxy: <xmx:ly0Ja_Rc_0egCGUmT5jfrDkt_Uxb39lgbVTJ7Y-SJAt-9AEr6gxXQw>
    <xmx:ly0Ja7vqXe3F9oc_lHH67qGcRy61-gxdudNFP7WdbaSJIUiDjjaVnw>
    <xmx:ly0Jaz1qTQ6S9atWpj648NgLE8B8s-OHrg5EjHPVv3Z89YWDvq7XsA>
    <xmx:ly0Ja0UOc3k_qjdV7KzQ6PWBb2jjPQhkvDkNfXgBqueMIzqQCeZLYw>
    <xmx:ly0Ja2Ltrv1zXHkHD-yHCK_7kmAZRt8zngMnzoe5ujGphS0UFGxNDEuO>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id BFC0DF80093; Fri, 27 Nov 2026 02:13:25 -0500 (EST)
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
Date: Fri, 27 Nov 2026 08:13:05 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Huacai Chen" <chenhuacai@kernel.org>,
 "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, loongarch@lists.linux.dev,
 "Dmitry Antipov" <dmantipov@yandex.ru>, "WANG Xuerui" <kernel@xen0n.name>
Message-Id: <b6479785-6d26-43f6-92db-627bc2bfe11f@app.fastmail.com>
In-Reply-To: 
 <CAAhV-H5fd2K4WTPRSe7bdX3fgqxcC_MkOzwrxfMk1xnJdBW=Yg@mail.gmail.com>
References: <20261126155017.2401147-5-ardb+git@google.com>
 <20261126155017.2401147-8-ardb+git@google.com>
 <CAAhV-H5fd2K4WTPRSe7bdX3fgqxcC_MkOzwrxfMk1xnJdBW=Yg@mail.gmail.com>
Subject: Re: [PATCH 3/3] efi/libstub: Provide library helpers only where needed
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Fri, 27 Nov 2026, at 03:28, Huacai Chen wrote:
> Hi, Ard,
>
> Does this series wan to solve the same problem as below?
> https://lore.kernel.org/loongarch/97a95c9d-6736-4eee-ac9d-cbfb47d60492=
@app.fastmail.com/T/#t
>

Yes.

> On Thu, Nov 26, 2026 at 11:50=E2=80=AFPM Ard Biesheuvel <ardb+git@goog=
le.com> wrote:
>>
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> Now that dead stub code is being eliminated by the linker, the only
>> remaining user of the 64-bit left shift and clz/ctz helper routines is
>> ZSTD compression, and only in some cases:
>>
>> - the 64-bit left shift is only needed on 32-bit architectures
>> - the clz/ctz helper is needed on all RISC-V and 32-bit reduced
>>   LoongArch
>>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>  drivers/firmware/efi/libstub/Makefile | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware=
/efi/libstub/Makefile
>> index 20b5b77956d1..ba6d67e5cd78 100644
>> --- a/drivers/firmware/efi/libstub/Makefile
>> +++ b/drivers/firmware/efi/libstub/Makefile
>> @@ -98,14 +98,15 @@ CFLAGS_arm32-stub.o         :=3D -DTEXT_OFFSET=3D=
$(TEXT_OFFSET)
>>
>>  zboot-obj-y                    :=3D zboot-decompress-gzip.o
>>  CFLAGS_zboot-decompress-gzip.o +=3D -I$(srctree)/lib/zlib_inflate
>> -zboot-obj-$(CONFIG_KERNEL_ZSTD)        :=3D zboot-decompress-zstd.o =
lib-xxhash.o
>> +
>> +zstd-obj-$(CONFIG_32BIT)       :=3D lib-ashldi3.o
>> +zstd-obj-$(CONFIG_RISCV)       +=3D lib-clz_ctz.o
>> +zstd-obj-$(CONFIG_32BIT_REDUCED) +=3D lib-clz_ctz.o # loongarch
> I don't want to use CONFIG_32BIT_REDUCED outside arch/loongarch, can
> we use CONFIG_LOONGARCH which is similar  to RISCV?
>

I could change this to

zstd-obj-$(CONFIG_32BIT) :=3D lib-clz_ctz.o
zstd-obj-$(CONFIG_RISCV) :=3D lib-clz_ctz.o
zstd-obj-$(CONFIG_32BIT) +=3D lib-ashldi3.o

if you prefer? LoongArch64 never needs it, right?

> And it seems the first patch can be folded with this one...
>

This is an optimization, the first one is a build fix.
