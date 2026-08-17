Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEDB3F4DD6
	for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 16:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786985973; cv=none; b=PtpG0U1yZZp7vpzesWqI7C3HvTB8UKZfkairiCK1zhzeRZeG3d8bPtuIkJ8syrvu7gcJTjpT0f6Ml9AWIjqKXUS7cDH5LaYWOlb1sMimYdDLuGwvDh+oHG+oWEk/yOf5mt56GPQK7vZgvrAXe18FdevN4yUFAyPu+OImNVVrtKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786985973; c=relaxed/simple;
	bh=I9DTOyheYyPBwAxvgQtljKt2grxTR66OUmiIZz1Fnzk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=usgGr1N1ARiqyaIRHvpWdAa09xVPcDuxPXbU9VG0t1BeH6nGlZK+P0VZNYcm1Q9hVW+Eyi/iHlMkVOAXz8e+C1h77EeCgK69kbEqitinV5tJzHcnGyO0CqjfX66a2RV7y+kUsFXVRzrjpIxBB+FkQl2ibSi9Pvx/PT6yz2SKUDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mnBw6EIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mnBw6EIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5491F000E9;
	Mon, 17 Aug 2026 16:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786985967;
	bh=3llulX3328L3Ek3yxprc6vIvWXNUGeLhpBQoQq6NfSI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=mnBw6EIWGNULVx0W8kvE/NLBA5bt3cfsKbMg12I2bZiOg0VYkksZvlnG53qFDLK/8
	 rOlB9Oy/Lf22hL6rGJeu34lRvCh4Iyi0OP9c7PSMDgL7Tlqk1i+MM+5cyxe+JFwuIa
	 8gdO1hQueYZ8IveAlXulQOSIIkJ09hHJRD8EfSbbFKknUkWGNyyOqOYSVJcx3QT+gT
	 4r6V2cp6ugQANfoXV5CqvtPuqzaLRqvHupw0rBfjoHcxdv+3hGtnJLTO4hL3c6WA/H
	 pQqhxMBd8h1vnaSwDEzwfBz4Hq1Nv479ulAyPlxO8jOY2YswIvXIGzhutpNseh7A4M
	 gtlvYZ0B6a7Ew==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id F2635198005A;
	Mon, 17 Aug 2026 12:59:24 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 17 Aug 2026 12:59:24 -0400
X-ME-Sender: <xms:6j2DajBLqUlsCMxiWpJVM57j4vDzsqoGdXqibdORWyEbL__RQA2yxw>
    <xme:6j2DakX3cEIQiTkFEKIs2Hsw0opViKFDAnoFQis8ch5YRH--a5IadIO8fp9wXHiU8
    3S0J5J-hhzVzp64TbCIgVNK8RQ8SFHf0q9W20G32plG7GZ0UT0IWXGR>
X-ME-Proxy-Cause: dmFkZTGWu6WDxCMnrRb1S3oKmk5iStRE3JaOXC54KSBpqPeipijwwR2HrCmeM/GVeLZWSt
    s/eB1469nVCVVflUTjbd+qswpbrqXXrhXA4ApuQS8LI2sKJzb8PHg/IImzC7JB/jP1Sytq
    cReM4bk+nka73PAkzlFdd6UuaZaoz8JkNOhc7QqtpOuETM92JuVHOyJ7x7rTLP/wjCqjqY
    9NyiJTlNHR0yJSfrSmL0vKxlP8oqqrzRKDlcVeYleOsVAfmnEgS3XmwJLrM/Z3kHOIJUpM
    5+zA3bJtqp0uSdxO1KgwkeojQQEBxJnqtg2GqfHtQc+U7qpYO4ejNX5oomUoRv1XEqugFP
    Lv0luHj88B6zo+rCCZvzIOUniSLQRL3ra1LLYQ/i/1RmW/dLvPc1wfhSo2nh0lnJecyffB
    pgODSi+jzRs4nYeUbEHmgmnXH3b/fufoFdl/hcoQ6CcoRwoSDJwhXJwybouSvxVxA3zOrv
    fyF2YwAYT3YQSyopA34B5JfBXsFMgx0M2jDPf209xPrH097NrNVsl0Ns34RTUI1yp4hiqH
    n0fl2t0KRiyPRwnn7Vkyb44OePTmrmPN5SGUs18qYiojQAWmgDa+DDwvYAi4FV6ylkQRXf
    c5bm2Eh0GkegawCm9g/SXOuBjEvPzfeF6xIElleYhtChO24izz/HiASSKI0Q
X-ME-Proxy: <xmx:7D2Daj5q29beGjnbsbtA93utKnpj9jmj2wsgLPILJ8Cyuy4WuNVhCA>
    <xmx:7D2Daplet-CiwwBZf6VZIRWLwcDLoDccMe7H2E08akQqO74c4x7fpQ>
    <xmx:7D2DaoqR0ZcLFyx5S2nxSP0eUbVjvcFiyk6hgmnWPYLugRXHbo7NDg>
    <xmx:7D2DaotTgha0tXeupLxmjBoNAs4--vN6aS7WieJPHzMFJ5mJTYSlSQ>
    <xmx:7D2DatHPiq5B-tvkrlgYrlZ6-RrGWxOM-WUeyM0ssjBfIP7Vu-5t0RKY>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id C4C4EF80071; Mon, 17 Aug 2026 12:59:22 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 17 Aug 2026 19:59:02 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Leif Lindholm" <leif.lindholm@oss.qualcomm.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 "Huacai Chen" <chenhuacai@kernel.org>, "WANG Xuerui" <kernel@xen0n.name>,
 loongarch@lists.linux.dev
Message-Id: <c3cd6952-87fd-442b-8d54-13c814b8d5f2@app.fastmail.com>
In-Reply-To: <aoMV3TX0hgTsj3_m@leviathan>
References: <20260813074506.643472-5-ardb@kernel.org>
 <20260813074506.643472-7-ardb@kernel.org> <an8xTBiCy_PEuwZi@leviathan>
 <a0d10b63-bf9a-4ad7-a9d8-ab748a9c0c2c@app.fastmail.com>
 <aoLR9BPGt4Kzbr3y@leviathan>
 <92baff04-d30b-4174-b5f5-87b24e6a1cc0@app.fastmail.com>
 <aoMV3TX0hgTsj3_m@leviathan>
Subject: Re: [PATCH 2/3] efi: Pass EFI boot memmap struct address to core kernel
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 17 Aug 2026, at 17:08, Leif Lindholm wrote:
> On Mon, Aug 17, 2026 at 14:00:16 +0300, Ard Biesheuvel wrote:
>> >> > Is it time to update the boot ABI to say x0 will hold the physical
>> >> > address of "device tree blob (dtb) or EFI System Table in system RAM"?
>> >> > They can be distinguished by 0xd00dfeed / "IBI SYST".
>> >> 
>> >> Let's avoid 'boot ABI' here, given that we are talking about an internal
>> >> interface between the EFI stub and the kernel proper.
>> >
>> > It's an internal business in the topic under discussion, but if we
>> > were to change it, that would mean updating booting.rst, which I
>> > consider an ABI.
>> >
>> 
>> But not an external ABI. It documents specifically how the EFI stub
>> interfaces with the kernel proper. This might change at any point,
>> without any obligation whatsoever to remain compatible with the
>> previous method.
>
> So you're saying if the kernel proper decides to use x1 for something
> else, we'll move to x2?
>
> I agree that in the context of how the stub calls the kernel proper,
> this is not ABI, but x1 is one of the registers currently marked as
> "reserved for future use" in booting.rst. So it feels weird for me to
> allocate one of those registers for this internal use then not mention
> it.
>

Whether we mention it or not is irrelevant: the only thing that matters
is that this allocation is not something that OS loaders other than the
EFI stub are able to rely upon, given that EFI boot on arm64 requires
booting via the stub (except for Xen dom0).

> In that case, couldn't we instead pick a register outside of the
> reserved ones?
>

It has to be a reserved one, given that the state of other registers is
unspecified at boot. Otherwise, we'd have to reason about whether a non-zero
value is accidental, or represents a physical address that we can map and
dereference, which is needed even to check the system table's magin

>> ...
>> >> > Minor bikeshedding below.
>> >> >
>> >> >> @@ -123,8 +134,24 @@ u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
>> >> >>  			pr_err("Can't find property '%s' in DT!\n", pname);
>> >> >>  			return 0;
>> >> >>  		}
>> >> >> -		if (dt_params[i].paravirt)
>> >> >> +		if (IS_ENABLED(CONFIG_XEN) && dt_params[i].paravirt) {
>> >> >>  			set_bit(EFI_PARAVIRT, &efi.flags);
>> >> >> +		} else {
>> >> >
>> >> > This condition branch doesn't in fact have anything to do with the fdt.
>> >> > Should it still live in fdtparams.c?
>> >> >
>> >> 
>> >> I don't follow. The EFI_PARAVIRT flag is set based on whether we are 
>> >> using the generic or the Xen-specific set of DT properties. What would
>> >> be a better place to decide this?
>> >
>> > Apologies, I may have commented confusingly - my comment was about the
>> > else branch:
>> >
>> > +
>> > +                       bm = early_memremap_ro(memmap, sizeof(*bm));
>> > +                       if (!bm) {
>> > +                               pr_err("Cannot remap EFI boot memory map\n");
>> > +                               return 0;
>> > +                       }
>> > +
>> > +                       mm->phys_map            = memmap + sizeof(*bm);
>> > +                       mm->size                = bm->map_size;
>> > +                       mm->desc_size           = bm->desc_size;
>> > +                       mm->desc_version        = bm->desc_ver;
>> > +
>> > +                       early_memunmap(bm, sizeof(*bm));
>> >
>> > So to restate - this function is called from efi_init():
>> > ---
>> >         /* Grab UEFI information placed in FDT by stub */
>> >         efi_system_table = efi_get_fdt_params(&data);
>> >         if (!efi_system_table)
>> >                 return;
>> > ---
>> >
>> > Before this set, this function called get_fdt_params() indeed gets
>> > "params" from a device tree. After this set, this function gets params
>> > from a device tree in some instances, and not in others.
>> > Which feels suboptimal.
>> >
>> > We could rename the function, but then there's still DT-unrelated
>> > code held in fdtparams.c.
>> >
>> > If we go down the route of passing the system table in x1 on boot,
>> > then I guess the effect of assigning efi_system_table will already be
>> > broken out. But should we then split the mm struct initialisation into
>> > separate DT and config table helper functions?
>> >
>> 
>> Not disagreeing but I think it is fine to leave it as I suggested at this
>> point.
>> 
>> Some additional work is needed to get rid of linux,uefi-boot-memmap
>> entirely, and until that happens, passing the EFI system table via
>> X1 and linux,uefi-boot-memmap via DT is not a huge improvement.
>> 
>> linux,uefi-boot-memmap is needed when SetVirtualAddressMap() is called
>> [with a non-1:1 mapping], as the EFI system table contains a remapped
>> address of the config table array in that case.
>
> Of course, the devil on my shoulder suggests the stub could always
> add an address fixup handler for the config table too...
>

What is an address fixup handler? We cannot change this value back,
as that might break the runtime services.
