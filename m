Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FD33F8882
	for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 11:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786964446; cv=none; b=VxCRDmElj3ioBPnLFUnCFFUWV0jDVp6sUZBHgWMfuid5yiEh/Yq0P4oseEEg8RWw5Lqn1+Pf7cEBwYsL6pz15uVlehZKpQjomkoYsVMe6L50JwrcVoj4i8k/0vTjDaiFNIilMghpE6BTYfSo3BaDKQNY+SwFfmc7ZxKsYgkbBmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786964446; c=relaxed/simple;
	bh=B15gJpb3+H8eGsq83CJ0lHjT9B+9QWiZs8zZvcYJqOI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=cZng1BXvjXVjp8I8GF45RzcAWh3CJPf4Fw/VY7GhHqJHxHTCED+B/7bgQw90j2DuGzt2RPl6Ra1z6z2REZSlnUdzxPBhq/j4MAn/Kd3xIdnyhsDxNL2zLo2qgQ9WtS9viyiDUilkvMdkXYbk2YgkCVKGvX5c/3HkGMZbdH6jbbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jE5+qBco; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jE5+qBco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5064F1F00A3D;
	Mon, 17 Aug 2026 11:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786964442;
	bh=WgZek3MLzFeMHdXhhGCcqInoE60fl4kfr+VHKyEfYgE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=jE5+qBcofa3iaptC/r1s6otVm61yiia6EbeDF8M6J3bdhI6AuC1AO+51CA8/Le0Q+
	 Jq+BdJpzpvH5p8kv/c+Wc4d9TImQhXtP4P3hw8ylQ5qvq1DheTOwXLm0Z/z69nr8S9
	 zGU7YuniCI6kaUMqD9YkstStFnq336Ae6H+ZasTwLDg5u8gY7otxTF0gACJHTh5eyN
	 FXPYp8g80g+Wo6hFs59vii5q9SPs18mUwvmkIY9+GkiI+6ZDGelTNFD6qvEwbr3q48
	 KcrgBSpXrpXr0BlJqr6vFEtvI/Q4ApeXcYAWnOf82szAjcfSAx0KI5hdZeSK0hYjr2
	 ZkIENq2bha4tQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id CFF901980043;
	Mon, 17 Aug 2026 07:00:39 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 17 Aug 2026 07:00:39 -0400
X-ME-Sender: <xms:1emCalKArvwvNmgaCKkLWBp44spTDS3Hj_8MpmN0uCk-0VSsycv0vQ>
    <xme:1emCar8ivaBcTUFp-HIf0TgyWS8tAIuNW7FLrAu3KJhhOEK03kpUNRhIDDTyH89wC
    7rI39k6Y5deLX_iRHOPV1XMVJcFdHO9uisq0y8DncYYr93VQVLI5QQ>
X-ME-Proxy-Cause: dmFkZTGFUvGG64XM3aHdY4FfNtEGYmsaFPVJruv7HVb5v2o0qqPbtO0YoGtvtHfKaZwnBk
    FOCn0qDvT5Xa8xaNUroCWfk1bYePNbxbkjOQUJxN3I3p0GnWn8s38tGqeST352hSjzEpRo
    N+yYmchntE7ydUKwsED2FXXb12tjG5U3f4/Ea5fBtHOwqpGreH6W2QeJmUyEoxRVuJ2i96
    pDu6xgg1EXMEncKmCSAzhEmFlVzHDFn5bQRx/7mNV6zC/Y2GuiI2F79Lr0WzfbwTiG2RkC
    39uYQF3Eh6Cwb3bIwgWeobWy/vvhhvuykwjYMqqqdKexO11WlidV+Dyv+bZrWPIa8QhzR7
    6ujRA7KxhSM5SCZr00yX183SRl1VIme2lwWQ1Wvy00IThid8mModNmch4OWd5GtA3p28VY
    oxwIKAjJMPUceqFfHgjX+PO61zIvRfflljqRlOKSWcsh05T4EtTm3uqNpjq/Aadv9n5Arl
    UR0cWqT08UdZa4oKpf81Ow4WFAc9N/SrIJqzQtAnstCR0r8wIc6mCgLDksmfUaMcNBb1tk
    oKZKCuoywLbFHBtlfeN5lZXbI+YhNR4o9sE7tkjIqxFOXZS3kYAKujzicFnkKQlg281CJy
    oTDrg7a7j2UaaWibCxknjjpwxB0APOVjWVUu8AZB/H4cG6xq2nbw07ry35Gg
X-ME-Proxy: <xmx:1-mCapCHMpiJFeBG91Wj6Z9230jpPvZIjo9F-ajbTvOBKcuvBsjsrQ>
    <xmx:1-mCaoOGvpqY5tzn1TlysnWF8iXqLWyAS_8fFBrey8f7S_IyD36dsg>
    <xmx:1-mCaizMcfK9bCNNsS-cQTDPekbH4ErMeAXQ8gQRugLUsar53maiFA>
    <xmx:1-mCaoXWwCpEqq7ERIiXJY07Xf7g55tWYrVjlhDFEc76SklptaE3Bg>
    <xmx:1-mCakMwTQEF5PJ3TvZH1ZlK32efmBGjxaV7aJmRkXQ8m-9qzLp3xw91>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 63442F8006E; Mon, 17 Aug 2026 07:00:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 17 Aug 2026 14:00:16 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Leif Lindholm" <leif.lindholm@oss.qualcomm.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 "Huacai Chen" <chenhuacai@kernel.org>, "WANG Xuerui" <kernel@xen0n.name>,
 loongarch@lists.linux.dev
Message-Id: <92baff04-d30b-4174-b5f5-87b24e6a1cc0@app.fastmail.com>
In-Reply-To: <aoLR9BPGt4Kzbr3y@leviathan>
References: <20260813074506.643472-5-ardb@kernel.org>
 <20260813074506.643472-7-ardb@kernel.org> <an8xTBiCy_PEuwZi@leviathan>
 <a0d10b63-bf9a-4ad7-a9d8-ab748a9c0c2c@app.fastmail.com>
 <aoLR9BPGt4Kzbr3y@leviathan>
Subject: Re: [PATCH 2/3] efi: Pass EFI boot memmap struct address to core kernel
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 17 Aug 2026, at 12:18, Leif Lindholm wrote:
> On Mon, Aug 17, 2026 at 11:41:51 +0300, Ard Biesheuvel wrote:
>> On Fri, 14 Aug 2026, at 18:16, Leif Lindholm wrote:
>> > On Thu, Aug 13, 2026 at 09:45:09 +0200, Ard Biesheuvel wrote:
>> >> The EFI stub already passes a struct efi_boot_memmap populated with the
>> >> information of the EFI memory map as a configuration table, and so
>> >> passing the physical address, size, descriptor size and descriptor
>> >> version via 4 different DT properties is kind of redundant.
>> >> 
>> >> Instead, pass the physical address of this struct in memory so that the
>> >> kernel can just retrieve the values directly.
>> >> 
>> >> Unfortunately, the scheme with four separate properties is boot ABI for
>> >> Xen, and so this needs to remain supported.
>> >
>> > To clarify, you mean boot ABI when running under Xen?
>> >
>> 
>> Yes. We've allowed Xen dom0 to omit the EFI stub entirely, and boot the
>> kernel proper in EFI mode, passing the EFI system table and memory map
>> addresses via these special DT properties.
>> 
>> >> But for the EFI stub itself,
>> >> this is just an internal ABI that can be modified.
>> >
>> > Hmm...
>> >
>> > So this leaves only three properties that cannot be derived from the
>> > System Table:
>> > - The System Table address itself
>> > - kaslr-seed
>> > - bootargs
>> >
>> > The latter two could also be given the config table treatment.
>> >
>> 
>> The latter two are generic boot ABI for the arm64 kernel, and there
>> is no need to treat them differently for EFI boot. Note that we also
>> support passing the initrd directly via DT when doing EFI boot, rather
>> than via the EFI specific device path.
>
> Ah, yes, noted.
>
>> > Is it time to update the boot ABI to say x0 will hold the physical
>> > address of "device tree blob (dtb) or EFI System Table in system RAM"?
>> > They can be distinguished by 0xd00dfeed / "IBI SYST".
>> 
>> Let's avoid 'boot ABI' here, given that we are talking about an internal
>> interface between the EFI stub and the kernel proper.
>
> It's an internal business in the topic under discussion, but if we
> were to change it, that would mean updating booting.rst, which I
> consider an ABI.
>

But not an external ABI. It documents specifically how the EFI stub
interfaces with the kernel proper. This might change at any point,
without any obligation whatsoever to remain compatible with the
previous method.

>> This internal interface uses DT under the hood, even on ACPI platforms,
>> because it simplifies the early boot code. I don't think we should change
>> this.
>> 
>> Also, the DT provided by the bootloader (if any) may differ from the one
>> passed by the EFI stub, and so discovering the DT from the EFI system
>> table is not straight-forward - they are not the same, and making them
>> the same may have unintended side effects.
>
> Right, but this confusion exists precisely because of the two ways the
> device tree can be accessed with the curreent design.
>

Both the EFI stub and the kernel have precisely one way to access the
platform provided device tree each: the EFI stub uses the config table,
and the kernel proper uses what is passed via X0.

I don't think that should change, whatever we decide wrt passing the EFI
system table pointer. The whole point of the EFI stub is impedance
matching between the EFI loading/calling convention and the Linux/arm64
boot ABI, and so passing the DTB, iff received via a EFI config table, on
to the kernel in register X0 is literally its purpose in life.

It would be nice if the EFI stub could pass the pristine DT without
modifying it, so there is less ambiguity about where certain DT
properties came from, but I don't think it justifies deviating from the
above.

>> > The use of a generated DT when none was provided by firmware has led
>> > to both confusion and shenanigans, and might be nice to get rid of?
>> >
>> 
>> I don't disagree with that. But that would imply adding new code to the
>> early startup code doing command line parsing and KASLR randomization to
>> reason about whether these assets are passed via DT or via some other means.
>
> I take your point about the invasiveness, so won't pursue that further
> at this time. But I can't promise I won't bring it up again eventually :)
>

Happy to debate this further at any point in the future :-)

>> What would make sense imo is to pass the EFI system table address via X1
>> when doing EFI boot, so we don't have to get anything at all from the DT.
>
> That certainly sounds like a clear improvement.
>

Ack. I'll prototype that to see how it looks.

...
>> > Minor bikeshedding below.
>> >
>> >> @@ -123,8 +134,24 @@ u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
>> >>  			pr_err("Can't find property '%s' in DT!\n", pname);
>> >>  			return 0;
>> >>  		}
>> >> -		if (dt_params[i].paravirt)
>> >> +		if (IS_ENABLED(CONFIG_XEN) && dt_params[i].paravirt) {
>> >>  			set_bit(EFI_PARAVIRT, &efi.flags);
>> >> +		} else {
>> >
>> > This condition branch doesn't in fact have anything to do with the fdt.
>> > Should it still live in fdtparams.c?
>> >
>> 
>> I don't follow. The EFI_PARAVIRT flag is set based on whether we are 
>> using the generic or the Xen-specific set of DT properties. What would
>> be a better place to decide this?
>
> Apologies, I may have commented confusingly - my comment was about the
> else branch:
>
> +
> +                       bm = early_memremap_ro(memmap, sizeof(*bm));
> +                       if (!bm) {
> +                               pr_err("Cannot remap EFI boot memory map\n");
> +                               return 0;
> +                       }
> +
> +                       mm->phys_map            = memmap + sizeof(*bm);
> +                       mm->size                = bm->map_size;
> +                       mm->desc_size           = bm->desc_size;
> +                       mm->desc_version        = bm->desc_ver;
> +
> +                       early_memunmap(bm, sizeof(*bm));
>
> So to restate - this function is called from efi_init():
> ---
>         /* Grab UEFI information placed in FDT by stub */
>         efi_system_table = efi_get_fdt_params(&data);
>         if (!efi_system_table)
>                 return;
> ---
>
> Before this set, this function called get_fdt_params() indeed gets
> "params" from a device tree. After this set, this function gets params
> from a device tree in some instances, and not in others.
> Which feels suboptimal.
>
> We could rename the function, but then there's still DT-unrelated
> code held in fdtparams.c.
>
> If we go down the route of passing the system table in x1 on boot,
> then I guess the effect of assigning efi_system_table will already be
> broken out. But should we then split the mm struct initialisation into
> separate DT and config table helper functions?
>

Not disagreeing but I think it is fine to leave it as I suggested at this
point.

Some additional work is needed to get rid of linux,uefi-boot-memmap
entirely, and until that happens, passing the EFI system table via
X1 and linux,uefi-boot-memmap via DT is not a huge improvement.

linux,uefi-boot-memmap is needed when SetVirtualAddressMap() is called
[with a non-1:1 mapping], as the EFI system table contains a remapped
address of the config table array in that case.

There are currently two remaining reasons why calling
SetVirtualAddressMap() is required:
- some Ampere boxes crash otherwise (but these systems tolerate SVAM
being called with a 1:1 mapping)
- kernel configs with a VA space < 48 bits are not guaranteed to be
able to map the EFI runtime services 1:1, so there, SVAM is still
needed as well.

Both can be fixed, and I have been meaning to address the latter by
always making the EFI runtime map (which is essentially a 1:1 map)
use 48 bits of VA in all configs. (The ID map already does the same)

Then, the former can be addressed by installing a 1:1 mapping when
calling SVAM.

That would remove the need entirely to ever call SVAM() on arm64,
and therefore the need to pass the address of the EFI memory map
separately.

