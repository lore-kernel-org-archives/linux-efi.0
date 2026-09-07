Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097E71C5F1B
	for <linux-efi@vger.kernel.org>; Mon,  7 Sep 2026 01:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788745692; cv=none; b=TtbNQc3IqW7vc4KA2vuczbb25wbvj72u9NzPfYqFP3NIjgF5+mIPEyejVbmmH9tJgfvkxz+QQC+/G2GMeuoZkX7kt+Iu0ywqyBfqunFjT6tsvL9nNb3Up2b287KH7cETVT77fG3mVjX8rAO2ATQD0F4WgMHqf+6HfPAqcjk108Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788745692; c=relaxed/simple;
	bh=oRl2Ig0sqb2lbu8LjCTCNBnNy0/sezGLFVcQX5GWk8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WHervQ51ScadJZmmciTm+i5RjTmu3o4Oi7yF1gZgRW+lCnSMCCdJ7uanY2CVUqhXPScgpVjcvc0/Fc0/OlXYmiSvP5l1KdxFeq76DqELPKGJceYN2Cw2zb3n6EX/IT8R8D3KCqqpFYrEqpRDO6bJ9+tgBdr/z2Ms98JsQ+K5tCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uQaIqU8I; arc=none smtp.client-ip=91.218.175.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uQaIqU8I"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oRl2Ig0sqb2lbu8LjCTCNBnNy0/sezGLFVcQX5GWk8Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788745687; v=1; x=1789350487;
 b=uQaIqU8IAu7/Pz8O6I7cWNsO6/NVaQ5777HdUUrnawCe8tOS5P6nQYOhcuBJaVN0SIbdm/1d
 WhLdAouzjuqqLiVM5JW08qOu25OoyddWp603dzr2f52dQKh5dg6y4nIH0aPVG6Q822CDfDtQ99B
 IGncpnO78havMpSsuR4qVZiE=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 2cb00b0d8266826f;
	Mon, 07 Sep 2026 01:48:06 +0000
X-Mizu-Trace-ID: 2cb00b0d8266826f
X-Migadu-Flow: FLOW_OUT
Date: Mon, 7 Sep 2026 09:47:58 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org,
	chenhuacai@kernel.org, ardb@kernel.org, shuah@kernel.org,
	ilias.apalodimas@linaro.org, akpm@linux-foundation.org,
	ruirui.yang@linux.dev, guodongtai@kylinos.cn, kernel@xen0n.name,
	graf@amazon.com, liukexin@kylinos.cn, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v5 0/5] LoongArch: add KHO support and selftests
Message-ID: <ap4XzvnM3WUn5ard@fedora>
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904100852.26006-1-dongtai.guo@linux.dev>

On 09/04/26 at 06:08pm, George Guo wrote:
> This series enables Kexec HandOver (KHO) on 64-bit LoongArch and adds
> LoongArch coverage to the KHO QEMU selftest.  KHO is the remaining
> architecture gate needed by Live Update (LUO) on LoongArch.
> 
> The transport is the central problem.  Arm64 and riscv can pass the KHO
> state FDT and scratch area through properties under /chosen in a boot
> FDT.  LoongArch boots through EFI without a boot FDT, so that path is not
> available.

I didn't look into your patchset very carefully, but I doubt you
are reinventing the wheel. X86 didn't have FDT, seems it introduces FDT
for KHO support. LoongArch doesn't have FDT, so you reworks the EFI
transport. Is there a reason you don't want to follow the standard KHO
way using FDT too?

Please correct me if I am wrong.

> 
> EFI KHO channel:
> 
> v5 reworks the EFI transport following Pratyush's and Huacai's reviews
> [1, 2].  Instead of rebuilding the EFI configuration table in
> LoongArch code and switching st->tables before kexec, the common EFI stub
> allocates and installs a persistent table under
> LINUX_EFI_KEXEC_HANDOVER_GUID.  This follows the model used by
> LINUX_EFI_MEMRESERVE_TABLE_GUID.

> 
> The common EFI table parser reserves the stub-allocated table, reads it
> during early boot, and calls kho_populate().  An early initcall keeps the
> table persistently mapped so it can also be updated on the crash kexec
> path.  The implementation is architecture-independent; LoongArch only
> selects EFI_KHO when KEXEC_HANDOVER is enabled.
> 
> The EFI table is global, but kexec can keep separate normal and crash
> images and can replace a loaded candidate.  Updating the table while a
> candidate image is being loaded could therefore leave it pointing at a
> failed candidate while the previously installed image remains the one
> that will be executed.  v5 records the KHO data in struct kimage and
> synchronizes the channel from the image selected for execution.  Images
> without KHO data, including legacy and crash images, clear the channel so
> the next kernel boots cold rather than reviving stale state.
> 
> The GUID name is changed to LINUX_EFI_KEXEC_HANDOVER_GUID as suggested by
> Huacai and Pratyush [3].  Existing x86 KHO support continues to use its
> setup_data transport.  Besides supporting non-UEFI boot, that entry is
> consumed by the x86 decompressor before normal EFI table parsing, so KASLR
> only uses KHO scratch areas and does not overwrite preserved memory.  The
> new channel is installed by the generic EFI-stub entry path and relies on
> EFI_GENERIC_STUB, which x86 does not select.  Moving x86 would therefore
> require installing the table from the x86-specific EFI stub and scanning it
> in the decompressor, not just selecting EFI_KHO.
> 
> LoongArch enablement and build fix:
> 
> The architecture patch now only enables ARCH_SUPPORTS_KEXEC_HANDOVER and
> selects the generic EFI channel.  No LoongArch setup reader, kexec writer,
> or EFI system-table replacement remains.
> 
> The linux/mm.h build fix is moved from luo_session.c to kho_block.c, where
> the virt_to_phys() and phys_to_virt() calls reside after the liveupdate
> refactoring.  This addresses Pratyush's review [4].  Adding linux/mm.h to
> asm/io.h was previously attempted, but creates an include cycle under
> CONFIG_KFENCE [5].  The fix precedes LoongArch enablement so every
> intermediate commit builds with CONFIG_KFENCE=y.
> 
> Selftest:
> 
> The LoongArch vmtest boots vmlinux.efi through EDK2 because the initial
> EFI stub invocation installs the channel being tested.  QEMU_EFI can
> override the firmware filename for distributions that install it under a
> different name or path.
> 
> CONFIG_ACPI_SPCR_TABLE lets the bare earlycon parameter obtain the UART
> description from EDK2's SPCR table.  CONFIG_PCI_HOST_GENERIC keeps i8042
> enabled while ensuring that the QEMU virt machine's PCI I/O space is
> mapped before the legacy fallback probe, addressing Huacai's concern that
> the same kernel configuration should remain usable for hosts and guests.
> 
> With EFI runtime reset services available, panic=-1 and QEMU's existing
> -no-reboot option terminate the test normally.  The generic QEMU runner
> therefore remains unchanged and does not mask failures by forcibly
> terminating QEMU after a timeout.
> 
> The LoongArch vmtest uses the default KHO scratch-sizing path.  This
> series is based on the generic fix that calculates per-node scratch sizes
> before scratch allocation [6].
> 
> The KHO vmtest passes on:
> 
>   * LoongArch with KVM using QEMU_EFI.fd from edk2-loongarch64.
>   * x86_64 with KVM, as regression coverage for the generic kexec/KHO
>     changes.
> 
> Patch layout:
> 
>   1. Add the generic EFI KHO channel and its ABI.
>   2. Synchronize the channel from the selected image at execution.
>   3. Fix the kho_block.c header dependency exposed by LoongArch/KFENCE.
>   4. Enable KHO on 64-bit LoongArch through the generic EFI channel.
>   5. Add LoongArch to the KHO QEMU selftest.
> 
> Changes since v4:
> 
>   * Allocate and install the KHO table from the common EFI stub, following
>     the EFI memreserve-table model (Pratyush).
>   * Parse, reserve, map, and update the channel in generic EFI code; remove
>     the LoongArch-specific reader, writer, and st->tables replacement
>     (Pratyush, Huacai).
>   * Synchronize the global channel at execution rather than image load;
>     clear it for cold and crash images and use the scratch payload size.
>   * Rename the GUID to LINUX_EFI_KEXEC_HANDOVER_GUID (Huacai, Pratyush).
>   * Move the linux/mm.h include from luo_session.c to the actual caller,
>     kho_block.c, and place the fix before architecture enablement
>     (Pratyush, Huacai).
>   * Boot the vmtest through EDK2, allow QEMU_EFI to override the firmware,
>     and use vmlinux.efi to exercise the EFI stub and channel.
>   * Keep i8042 enabled and select PCI_HOST_GENERIC instead of disabling
>     the host configuration in the selftest (Huacai).
>   * Enable ACPI_SPCR_TABLE and use the SPCR-provided early console.
>   * Exercise the default KHO scratch-sizing path in the LoongArch vmtest;
>     depend on the separately posted generic sizing fix [6].
>   * Drop the generic QEMU timeout now that EFI runtime reset services make
>     the LoongArch guest terminate normally.
>   * Rebase onto Linux 7.3-rc1.
> 
> [1] Pratyush Yadav:
>     https://lore.kernel.org/r/2vxzo6f96fmn.fsf@kernel.org/
> [2] Huacai Chen:
>     https://lore.kernel.org/r/CAAhV-H4PKRNCa4g=6TGepP+trtM82JiMoWgVr3O7PqbZYP9uGw@mail.gmail.com/
> [3] https://lore.kernel.org/r/2vxzse4m54nz.fsf@kernel.org/
> [4] https://lore.kernel.org/r/2vxzfr0l6fam.fsf@kernel.org/
> [5] https://lore.kernel.org/r/202605211925.DbDvQ6ii-lkp@intel.com/
> [6] https://lore.kernel.org/loongarch/20260904025101.9959-1-dongtai.guo@linux.dev/
> 
> Previous version:
> 
> v4: https://lore.kernel.org/loongarch/20260807103714.33074-1-dongtai.guo@linux.dev/
> 
> George Guo (5):
>   efi: add a KHO configuration table channel
>   liveupdate: synchronize EFI KHO channel at execution
>   liveupdate: kho_block: include linux/mm.h for virt/phys translation
>   LoongArch: enable kexec handover (KHO)
>   selftests/kho: add LoongArch vmtest support
> 
>  arch/loongarch/Kconfig                     |  4 ++
>  drivers/firmware/efi/Kconfig               | 12 ++++
>  drivers/firmware/efi/efi.c                 | 78 ++++++++++++++++++++++
>  drivers/firmware/efi/libstub/efi-stub.c    | 25 +++++++
>  include/linux/efi.h                        | 36 ++++++++++
>  kernel/crash_core.c                        |  7 ++
>  kernel/kexec_core.c                        |  5 ++
>  kernel/kexec_internal.h                    |  3 +
>  kernel/liveupdate/kexec_handover.c         | 33 +++++++++
>  kernel/liveupdate/kho_block.c              |  1 +
>  tools/testing/selftests/kho/loongarch.conf | 11 +++
>  tools/testing/selftests/kho/vmtest.sh      |  3 +-
>  12 files changed, 217 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kho/loongarch.conf
> 
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> prerequisite-patch-id: a2f06addb17cc379b9f98674f087a1642588dc6e
> -- 
> 2.53.0
