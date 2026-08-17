Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890F23B6356
	for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 08:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786956139; cv=none; b=uFhhCnxcTCmpoq9lJqTm+GvuMIGitooD5zxvcdQ1qUek7GOHE12ZMDkdsgrNohTC/SuqMU/9P0OhrWFRrFAXd9p3FVoHWkLjgdz5M/y14aWtfs6B8Ee9NtrLQzPUuPY6q7LhtzvXRyUcsfYFtTiRH5IIjdaKAh5QXDYHStA2TRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786956139; c=relaxed/simple;
	bh=ItV4OzCRJMxPZyizd0dxik85ucTFHr0ZOTbd+3j+No4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=FktWAfR4NdbGYkbL0j3FjuFjGwgJi3dhMq/aPyGDNZFJqCpt1FmXZr75TjUFA+2ZGwryew92oV4XjMvw9JXAuX1AHaPpNjan7NkfoqEfBZ8Pfzu8ev1tf2jkX9j8vS4G61YEp8tZBtJO5LX/LZXJ30ElR0OJ/UHYRWvqueiSS8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIbWipfl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIbWipfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30971F00A3D;
	Mon, 17 Aug 2026 08:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786956138;
	bh=ri4gnJzdgtbwijutHFkiBovuKwGB55QNnr5MBC0/7fs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=WIbWipflzvqkALL8MHsg/pt9fGqGve5KsP3jw3A3TepgPImQzJ6Cj0FElbO3t08rX
	 Zq7AckRc1FcoSN7MCHHINL30iG0Ly7Hm5WZEJTAgverrowrEsg7y28q6YsykSKZIlI
	 W2iZ1SArcrsPaBeBUb2byLkomqvn0dp0i6ftykfPr6x44I+ybzW2zgEa0g0xpLf8/L
	 SnNoQobxAtMmsDAdU2xENo05Ozgnrnu+vxOKE7zBOHb1e7R8CFqE0gB8aBFelzYt4g
	 6KM0e3jVZV/b7fmTS8R3DftsOBUHWlfPVTeu1XCOdIqud6GS/4t/w9m405uyxukbd9
	 f0q5oG4knJIFw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 4BB9D1980052;
	Mon, 17 Aug 2026 04:42:16 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 17 Aug 2026 04:42:16 -0400
X-ME-Sender: <xms:ZcmCaqJRi71k3mjGH9Cla1A5sVb_PU_2-QKTuz8-9-qq9bvYi72Cfw>
    <xme:ZcmCas8hkHjvNlv0IFtaHd3tE67F-tCxxR82c2pWBhnx6J4PnZ6u2FsMIaIaKUjtv
    AUS73w0DXV-Jn5NFw3Rl6Hq37ZK-BSy-Qx7YxahcFCW6UQHdGj3hmXE>
X-ME-Proxy-Cause: dmFkZTGALACgPRXbsmw4UDAcAPrv/ildNadA/tMoTacndsXYRrCyKJ8GplQuvicmAIJHP1
    KTyoK2GFTmRqUMQPHAEpZpILciSEvLStMZbHw1VoQASIsR8rNVL4jFjE/LrK9oFRm+yKo7
    VLsyCV8F8waGLR+S/YqD9HET5YJUcgdzq91D8hbzA6S3UYcl3nAFOxEromznTJqx3FpX25
    vo6/Hd9Vc4N9gU7tNU+60lAAO6+rboZ8FOvcVd9PUgI+6XF1GsaOjxVrTvlMMyj2mF32yQ
    UtfsNEd10wrUUGwsbymE8heJbZEGOu8x4NvHNkHLzZND2dwv2ff5OYe96lBZ/XUYJZiIfG
    Zl6ep9iOi+H/Z9kDO/qlefIK9BOFpkNQhwlkWkSzcXbI2f+z21D0G4EAe9oWGFMFnt4TTL
    kSAS8QYKdKytUiE+3MX0GLi+wGZqLHr6Qfud3PIR4MRm8mFN7EKRZBW2qBPXteb0CBPSNb
    Loh/6sHnPDTd4bt1Q5OqqnRK65wnh2JlAwPg4czfP8/MwqRlk5adZ2BXXMjBAL5T7xCt/5
    Ucf2zsXGmKuDGzHrOW2fuHGkdAp4TlzBb4jdGhVjiLZ1jkgY76ASMOZeQX3Yne+DrWdC5M
    X9YD8neVbIlZQhgkHW79zmgs0+xYZ/HctkaZF9sh3/kBokn+fVcULw3+fvNw
X-ME-Proxy: <xmx:aMmCamAAgoERI3vtkAG_TzrKeeN0W3Tt_gTqc8S4hADpxIluul4rVQ>
    <xmx:aMmCahPX3xdiEuGusAEub_QuNcTn_0Z0iWJCQyQ86l_fNNSOIBoYTQ>
    <xmx:aMmCanx5wkx27wI-whqLTwatVZhs9cRwRimNeC2a0rIvUD3ZpsS0eA>
    <xmx:aMmCapWBkEA5Xg732XtTnA6YzS5_Gvczaz3bOGWWHcNI6Nx8-4JQVA>
    <xmx:aMmCahNmKXFUXCFLzbckPrbEh_rgqf1xjbRGac7CZaHR1gLXqIe8zjSS>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id DB124F80070; Mon, 17 Aug 2026 04:42:13 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 17 Aug 2026 11:41:51 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Leif Lindholm" <leif.lindholm@oss.qualcomm.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 "Huacai Chen" <chenhuacai@kernel.org>, "WANG Xuerui" <kernel@xen0n.name>,
 loongarch@lists.linux.dev
Message-Id: <a0d10b63-bf9a-4ad7-a9d8-ab748a9c0c2c@app.fastmail.com>
In-Reply-To: <an8xTBiCy_PEuwZi@leviathan>
References: <20260813074506.643472-5-ardb@kernel.org>
 <20260813074506.643472-7-ardb@kernel.org> <an8xTBiCy_PEuwZi@leviathan>
Subject: Re: [PATCH 2/3] efi: Pass EFI boot memmap struct address to core kernel
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 14 Aug 2026, at 18:16, Leif Lindholm wrote:
> On Thu, Aug 13, 2026 at 09:45:09 +0200, Ard Biesheuvel wrote:
>> The EFI stub already passes a struct efi_boot_memmap populated with the
>> information of the EFI memory map as a configuration table, and so
>> passing the physical address, size, descriptor size and descriptor
>> version via 4 different DT properties is kind of redundant.
>> 
>> Instead, pass the physical address of this struct in memory so that the
>> kernel can just retrieve the values directly.
>> 
>> Unfortunately, the scheme with four separate properties is boot ABI for
>> Xen, and so this needs to remain supported.
>
> To clarify, you mean boot ABI when running under Xen?
>

Yes. We've allowed Xen dom0 to omit the EFI stub entirely, and boot the
kernel proper in EFI mode, passing the EFI system table and memory map
addresses via these special DT properties.

>> But for the EFI stub itself,
>> this is just an internal ABI that can be modified.
>
> Hmm...
>
> So this leaves only three properties that cannot be derived from the
> System Table:
> - The System Table address itself
> - kaslr-seed
> - bootargs
>
> The latter two could also be given the config table treatment.
>

The latter two are generic boot ABI for the arm64 kernel, and there
is no need to treat them differently for EFI boot. Note that we also
support passing the initrd directly via DT when doing EFI boot, rather
than via the EFI specific device path.

> Is it time to update the boot ABI to say x0 will hold the physical
> address of "device tree blob (dtb) or EFI System Table in system RAM"?
> They can be distinguished by 0xd00dfeed / "IBI SYST".
>

Let's avoid 'boot ABI' here, given that we are talking about an internal
interface between the EFI stub and the kernel proper.

This internal interface uses DT under the hood, even on ACPI platforms,
because it simplifies the early boot code. I don't think we should change
this.

Also, the DT provided by the bootloader (if any) may differ from the one
passed by the EFI stub, and so discovering the DT from the EFI system
table is not straight-forward - they are not the same, and making them
the same may have unintended side effects.
 
> The use of a generated DT when none was provided by firmware has led
> to both confusion and shenanigans, and might be nice to get rid of?
>

I don't disagree with that. But that would imply adding new code to the
early startup code doing command line parsing and KASLR randomization to
reason about whether these assets are passed via DT or via some other means.

What would make sense imo is to pass the EFI system table address via X1
when doing EFI boot, so we don't have to get anything at all from the DT.

> Either way, it would be nice to get rid of all four of the
> linux,uefi-mmap nodes if they're now completely redundant.
>

Indeed.

> Minor bikeshedding below.
>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>  Documentation/arch/arm/uefi.rst    | 10 +----
>>  drivers/firmware/efi/fdtparams.c   | 39 ++++++++++++++++---
>>  drivers/firmware/efi/libstub/fdt.c | 40 ++------------------
>>  3 files changed, 37 insertions(+), 52 deletions(-)
>> 
>> diff --git a/Documentation/arch/arm/uefi.rst b/Documentation/arch/arm/uefi.rst
>> index 2b7ad9bd7cd2..c19cf3720f27 100644
>> --- a/Documentation/arch/arm/uefi.rst
>> +++ b/Documentation/arch/arm/uefi.rst
>> @@ -54,17 +54,9 @@ Name                        Type     Description
>>  ==========================  ======   ===========================================
>>  linux,uefi-system-table     64-bit   Physical address of the UEFI System Table.
>>  
>> -linux,uefi-mmap-start       64-bit   Physical address of the UEFI memory map,
>> +linux,uefi-boot-memmap      64-bit   Physical address of a struct efi_boot_memmap
>>                                       populated by the UEFI GetMemoryMap() call.
>>  
>> -linux,uefi-mmap-size        32-bit   Size in bytes of the UEFI memory map
>> -                                     pointed to in previous entry.
>> -
>> -linux,uefi-mmap-desc-size   32-bit   Size in bytes of each entry in the UEFI
>> -                                     memory map.
>> -
>> -linux,uefi-mmap-desc-ver    32-bit   Version of the mmap descriptor format.
>> -
>>  kaslr-seed                  64-bit   Entropy used to randomize the kernel image
>>                                       base address location.
>>  
>> diff --git a/drivers/firmware/efi/fdtparams.c b/drivers/firmware/efi/fdtparams.c
>> index b815d2a754ee..a54a76a6aaeb 100644
>> --- a/drivers/firmware/efi/fdtparams.c
>> +++ b/drivers/firmware/efi/fdtparams.c
>> @@ -10,22 +10,30 @@
>>  
>>  #include <linux/unaligned.h>
>>  
>> +#include <asm/early_ioremap.h>
>> +
>>  enum {
>>  	SYSTAB,
>> +	MEMMAP,
>> +#ifdef CONFIG_XEN
>>  	MMBASE,
>>  	MMSIZE,
>>  	DCSIZE,
>>  	DCVERS,
>> +#endif
>>  
>>  	PARAMCOUNT
>>  };
>>  
>>  static __initconst const char name[][22] = {
>>  	[SYSTAB] = "System Table         ",
>> +	[MEMMAP] = "Boot Memory Map      ",
>> +#ifdef CONFIG_XEN
>>  	[MMBASE] = "MemMap Address       ",
>>  	[MMSIZE] = "MemMap Size          ",
>>  	[DCSIZE] = "MemMap Desc. Size    ",
>>  	[DCVERS] = "MemMap Desc. Version ",
>> +#endif
>>  };
>>  
>>  static __initconst const struct {
>> @@ -49,10 +57,7 @@ static __initconst const struct {
>>  		.path = "/chosen",
>>  		.params = {	//  <-----------26----------->
>>  			[SYSTAB] = "linux,uefi-system-table",
>> -			[MMBASE] = "linux,uefi-mmap-start",
>> -			[MMSIZE] = "linux,uefi-mmap-size",
>> -			[DCSIZE] = "linux,uefi-mmap-desc-size",
>> -			[DCVERS] = "linux,uefi-mmap-desc-ver",
>> +			[MEMMAP] = "linux,uefi-boot-memmap",
>>  		}
>>  	}
>>  };
>> @@ -84,17 +89,20 @@ static int __init efi_get_fdt_prop(const void *fdt, int node, const char *pname,
>>  u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
>>  {
>>  	const void *fdt = initial_boot_params;
>> -	unsigned long systab;
>> +	unsigned long systab, memmap;
>>  	int i, j, node;
>>  	struct {
>>  		void	*var;
>>  		int	size;
>>  	} target[] = {
>>  		[SYSTAB] = { &systab,		sizeof(systab) },
>> +		[MEMMAP] = { &memmap,		sizeof(memmap) },
>> +#ifdef CONFIG_XEN
>>  		[MMBASE] = { &mm->phys_map,	sizeof(mm->phys_map) },
>>  		[MMSIZE] = { &mm->size,		sizeof(mm->size) },
>>  		[DCSIZE] = { &mm->desc_size,	sizeof(mm->desc_size) },
>>  		[DCVERS] = { &mm->desc_version,	sizeof(mm->desc_version) },
>> +#endif
>>  	};
>>  
>>  	BUILD_BUG_ON(ARRAY_SIZE(target) != ARRAY_SIZE(name));
>> @@ -115,6 +123,9 @@ u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
>>  		for (j = 0; j < ARRAY_SIZE(target); j++) {
>>  			const char *pname = dt_params[i].params[j];
>>  
>> +			if (pname[0] == '\0')
>> +				continue;
>> +
>>  			if (!efi_get_fdt_prop(fdt, node, pname, name[j],
>>  					      target[j].var, target[j].size))
>>  				continue;
>> @@ -123,8 +134,24 @@ u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
>>  			pr_err("Can't find property '%s' in DT!\n", pname);
>>  			return 0;
>>  		}
>> -		if (dt_params[i].paravirt)
>> +		if (IS_ENABLED(CONFIG_XEN) && dt_params[i].paravirt) {
>>  			set_bit(EFI_PARAVIRT, &efi.flags);
>> +		} else {
>
> This condition branch doesn't in fact have anything to do with the fdt.
> Should it still live in fdtparams.c?
>

I don't follow. The EFI_PARAVIRT flag is set based on whether we are 
using the generic or the Xen-specific set of DT properties. What would
be a better place to decide this?


