Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5871ABEDE
	for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 14:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789827334; cv=none; b=ctkETgmp2mFVW84/V1cx81mmfAQgXm+2f9drn/jmiCn5f9C1edMBwbEtNZma1Ff0kUKva+q4TebR2sGYy7VVm7Giq6nbRetinWFPoFJpanpWC+iTWPuY8KssEYCDYgAeoKNb7HKg4ISv471QTUvdYIzs02iup/8xhKIOKBeEpuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789827334; c=relaxed/simple;
	bh=NvqZnYl1UyZu8cy7Ss+evuGEzB4l+EKBFi5xjOacYI8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=faGuCjh8QZvpHAblnOB4mxUaoz4nG/Xx9a8zyk1Y8AKunwPkuypn9QXJObF0nUHIiNHHHoRfcBFwPunF9C1r2/5ZH3rLMtpVnTlX87roAnFT9U5K8EpzTzGrzhfrlf4Ld1cl6NXzdAndAwG4/QiCrNV/GosXn8zhV0z0tNo/yEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kfiff3v4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kfiff3v4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C411F00898
	for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 14:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789827332;
	bh=VnxoiB2YsjeyPgBJVLzNUBrWI8MXygpkuUqCzqaQk+A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Kfiff3v4QxBsewU7RmMwvCGwNG5LsLpXurH/+9MQf6SU1VO9aIStJpmjocctpvXR9
	 6H4HL5uk/rY2E14tZBYpL79wQm75yZVIQk6DBlR83n3GmkQwxekpQ7GelT7Pxblv+B
	 i8E0qKT9NxXk8gJjnxwPiNlk0XfiBc+q+zDO+vSINK+shsAF+VWw8rBwaGoSnfGog5
	 43xARo6itVr3p7Xyqe4TUZ2Nr9OUtzzHeVxMvlHFsFyqQwSZeYLZMeAosiLIIl/uzX
	 ruG5VCuslIrUMQboRg7N8jHeAYuy4x/WzOBtuKDm20C2jG79ZJLQPWJ1mtg7K42+fF
	 TU7peTsFz2c0Q==
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6aa053900f5so2865641a12.1
        for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 07:15:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxRZGgsfsBDehHc/UfLB03Su3Ul/aUj7hwhAQvUAWEZoM/eqtm2q+7gEi7UB6zb6qJWdXrBxYt3d2s=@vger.kernel.org
X-Gm-Message-State: AFuF++kKDxt3Qd/51AuY3kQKgkgKOOt8tbevcOxYqRidzsjypGAYpY9Y
	ql1aA7cnNoNNYreJBWQwCbRJ/r3uUNd1G4YsLQkvjAuJeEY+hR5KJtXg+tU4BTf6R4CrHxN2F5p
	Q35bXdwqaeMKhe4CUGVtE+VYGiPKdDk0=
X-Received: by 2002:a05:6402:46da:b0:6aa:486d:96f8 with SMTP id
 4fb4d7f45d1cf-6aa5798f026mr3635025a12.38.1789827330842; Sat, 19 Sep 2026
 07:15:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
In-Reply-To: <20260904100852.26006-1-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 19 Sep 2026 22:15:22 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7NpgPwQRs0u9gk4uJKZ8-OvJJfNQcaBA8R=LSd6CdS2g@mail.gmail.com>
X-Gm-Features: AcwNN1XtUrN1RH8CnRKNNkWXHjiR4TDIl36-0BqqerFi6hnTqZG-JdRKU2IGpQg
Message-ID: <CAAhV-H7NpgPwQRs0u9gk4uJKZ8-OvJJfNQcaBA8R=LSd6CdS2g@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] LoongArch: add KHO support and selftests
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org, 
	akpm@linux-foundation.org, baoquan.he@linux.dev, ruirui.yang@linux.dev, 
	guodongtai@kylinos.cn, kernel@xen0n.name, graf@amazon.com, 
	liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, George,

On Fri, Sep 4, 2026 at 6:10=E2=80=AFPM George Guo <dongtai.guo@linux.dev> w=
rote:
>
> This series enables Kexec HandOver (KHO) on 64-bit LoongArch and adds
> LoongArch coverage to the KHO QEMU selftest.  KHO is the remaining
> architecture gate needed by Live Update (LUO) on LoongArch.
>
> The transport is the central problem.  Arm64 and riscv can pass the KHO
> state FDT and scratch area through properties under /chosen in a boot
> FDT.  LoongArch boots through EFI without a boot FDT, so that path is not
> available.
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
> consumed by the x86 decompressor before normal EFI table parsing, so KASL=
R
> only uses KHO scratch areas and does not overwrite preserved memory.  The
> new channel is installed by the generic EFI-stub entry path and relies on
> EFI_GENERIC_STUB, which x86 does not select.  Moving x86 would therefore
> require installing the table from the x86-specific EFI stub and scanning =
it
> in the decompressor, not just selecting EFI_KHO.
>
> LoongArch enablement and build fix:
>
> The architecture patch now only enables ARCH_SUPPORTS_KEXEC_HANDOVER and
> selects the generic EFI channel.  No LoongArch setup reader, kexec writer=
,
> or EFI system-table replacement remains.
>
> The linux/mm.h build fix is moved from luo_session.c to kho_block.c, wher=
e
> the virt_to_phys() and phys_to_virt() calls reside after the liveupdate
> refactoring.  This addresses Pratyush's review [4].  Adding linux/mm.h to
> asm/io.h was previously attempted, but creates an include cycle under
> CONFIG_KFENCE [5].  The fix precedes LoongArch enablement so every
> intermediate commit builds with CONFIG_KFENCE=3Dy.
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
> With EFI runtime reset services available, panic=3D-1 and QEMU's existing
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
>   * Allocate and install the KHO table from the common EFI stub, followin=
g
>     the EFI memreserve-table model (Pratyush).
>   * Parse, reserve, map, and update the channel in generic EFI code; remo=
ve
>     the LoongArch-specific reader, writer, and st->tables replacement
>     (Pratyush, Huacai).
>   * Synchronize the global channel at execution rather than image load;
>     clear it for cold and crash images and use the scratch payload size.
>   * Rename the GUID to LINUX_EFI_KEXEC_HANDOVER_GUID (Huacai, Pratyush).
>   * Move the linux/mm.h include from luo_session.c to the actual caller,
>     kho_block.c, and place the fix before architecture enablement
>     (Pratyush, Huacai).
>   * Boot the vmtest through EDK2, allow QEMU_EFI to override the firmware=
,
>     and use vmlinux.efi to exercise the EFI stub and channel.
>   * Keep i8042 enabled and select PCI_HOST_GENERIC instead of disabling
>     the host configuration in the selftest (Huacai).
>   * Enable ACPI_SPCR_TABLE and use the SPCR-provided early console.
>   * Exercise the default KHO scratch-sizing path in the LoongArch vmtest;
>     depend on the separately posted generic sizing fix [6].
>   * Drop the generic QEMU timeout now that EFI runtime reset services mak=
e
>     the LoongArch guest terminate normally.
>   * Rebase onto Linux 7.3-rc1.
>
> [1] Pratyush Yadav:
>     https://lore.kernel.org/r/2vxzo6f96fmn.fsf@kernel.org/
> [2] Huacai Chen:
>     https://lore.kernel.org/r/CAAhV-H4PKRNCa4g=3D6TGepP+trtM82JiMoWgVr3O7=
PqbZYP9uGw@mail.gmail.com/
> [3] https://lore.kernel.org/r/2vxzse4m54nz.fsf@kernel.org/
> [4] https://lore.kernel.org/r/2vxzfr0l6fam.fsf@kernel.org/
> [5] https://lore.kernel.org/r/202605211925.DbDvQ6ii-lkp@intel.com/
> [6] https://lore.kernel.org/loongarch/20260904025101.9959-1-dongtai.guo@l=
inux.dev/
>
> Previous version:
>
> v4: https://lore.kernel.org/loongarch/20260807103714.33074-1-dongtai.guo@=
linux.dev/
>
> George Guo (5):
>   efi: add a KHO configuration table channel
Add....

>   liveupdate: synchronize EFI KHO channel at execution
Synchronize.....

>   liveupdate: kho_block: include linux/mm.h for virt/phys translation
Include..... (and I think kho_block can be removed)

>   LoongArch: enable kexec handover (KHO)
Enable.....

>   selftests/kho: add LoongArch vmtest support
Add.....


Huacai
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
