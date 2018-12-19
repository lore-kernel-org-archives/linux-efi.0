From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/2] efi: efi_guid_t must be 64-bit aligned
Date: Wed, 19 Dec 2018 11:07:53 +0100
Message-ID: <CAKv+Gu8AZ6MemE5Z90L5nvrj51z3=rJ_tF=7Wknzs0_RKk_iOQ@mail.gmail.com>
References: <20181217180214.9436-3-ard.biesheuvel@linaro.org> <20181218204116.6D58A2184C@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181218204116.6D58A2184C@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-efi <linux-efi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 18 Dec 2018 at 21:41, Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v4.19.10, v4.14.89, v4.9.146, v4.4.168, v3.18.130,
>

Please disregard this patch for -stable until we decide how we are
going to fix the 32-bit array packing issue.


> v4.19.10: Build OK!
> v4.14.89: Build OK!
> v4.9.146: Failed to apply! Possible dependencies:
>     2f74f09bce4f ("efi: parse ARM processor error")
>     5b53696a30d5 ("ACPI / APEI: Switch to use new generic UUID API")
>     bbcc2e7b642e ("ras: acpi/apei: cper: add support for generic data v3 structure")
>     c0020756315e ("efi: switch to use new generic UUID API")
>
> v4.4.168: Failed to apply! Possible dependencies:
>     2c23b73c2d02 ("x86/efi: Prepare GOP handling code for reuse as generic code")
>     2f74f09bce4f ("efi: parse ARM processor error")
>     5b53696a30d5 ("ACPI / APEI: Switch to use new generic UUID API")
>     ba7e34b1bbd2 ("include/linux/efi.h: redefine type, constant, macro from generic code")
>     bbcc2e7b642e ("ras: acpi/apei: cper: add support for generic data v3 structure")
>     c0020756315e ("efi: switch to use new generic UUID API")
>
> v3.18.130: Failed to apply! Possible dependencies:
>     1bd0abb0c924 ("arm64/efi: set EFI_ALLOC_ALIGN to 64 KB")
>     23a0d4e8fa6d ("efi: Disable interrupts around EFI calls, not in the epilog/prolog calls")
>     2c23b73c2d02 ("x86/efi: Prepare GOP handling code for reuse as generic code")
>     2f74f09bce4f ("efi: parse ARM processor error")
>     4c62360d7562 ("efi: Handle memory error structures produced based on old versions of standard")
>     4ee20980812b ("arm64: fix data type for physical address")
>     5b53696a30d5 ("ACPI / APEI: Switch to use new generic UUID API")
>     60305db98845 ("arm64/efi: move virtmap init to early initcall")
>     744937b0b12a ("efi: Clean up the efi_call_phys_[prolog|epilog]() save/restore interaction")
>     790a2ee24278 ("Merge tag 'efi-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi into core/efi")
>     8a53554e12e9 ("x86/efi: Fix multiple GOP device support")
>     8ce837cee8f5 ("arm64/mm: add create_pgd_mapping() to create private page tables")
>     9679be103108 ("arm64/efi: remove idmap manipulations from UEFI code")
>     a352ea3e197b ("arm64/efi: set PE/COFF file alignment to 512 bytes")
>     b05b9f5f9dcf ("x86, mirror: x86 enabling - find mirrored memory ranges")
>     ba7e34b1bbd2 ("include/linux/efi.h: redefine type, constant, macro from generic code")
>     bbcc2e7b642e ("ras: acpi/apei: cper: add support for generic data v3 structure")
>     c0020756315e ("efi: switch to use new generic UUID API")
>     d1ae8c005792 ("arm64: dmi: Add SMBIOS/DMI support")
>     da141706aea5 ("arm64: add better page protections to arm64")
>     e1e1fddae74b ("arm64/mm: add explicit struct_mm argument to __create_mapping()")
>     ea6bc80d1819 ("arm64/efi: set PE/COFF section alignment to 4 KB")
>     f3cdfd239da5 ("arm64/efi: move SetVirtualAddressMap() to UEFI stub")
>
>
> How should we proceed with this patch?
>
> --
> Thanks,
> Sasha
