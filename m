From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: arm/arm64 UEFI boot protocol
Date: Tue, 12 Nov 2013 16:42:41 +0000
Message-ID: <20131112164241.GD25953@mudshark.cambridge.arm.com>
References: <20131111174321.GQ1557@rocoto.smurfnet.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131111174321.GQ1557-GZEopFhza0F985/tl1ce8aaDwS/vmuI7@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, Olivier Martin <Olivier.Martin-5wv7dgnIgG8@public.gmane.org>, "grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org" <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Leif,

On Mon, Nov 11, 2013 at 05:43:21PM +0000, Leif Lindholm wrote:
> We currently have a few sets of patches floating around, for UEFI
> runtime services, UEFI stub and GRUB support for Linux/UEFI on
> arm/arm64.
> 
> The last version of Documentation/arm/uefi.txt I sent out raised a few
> questions with regards to the boot protocol between UEFI and Linux, and
> there is also upcoming support for ACPI which could use a few
> clarifications in this area.
> 
> So, rather than sending out complete sets of patches for all these until
> consensus is reached, below is my proposed suggestion for a
> Documentation/arm/uefi.txt, to be shared for arm and arm64. If noone has
> strong objections to this, we can quickly send updated (and hopefully
> final-ish) versions of these sets.

In the absence of code, I'll play English teacher then :)

> UEFI, the Unified Extensible Firmware Interface is a specification

Interface, is

> governing the behaviours of compatible firmware interfaces.
> It is maintained by the UEFI Forum - http://www.uefi.org/.
> Support for the AArch32 (arm) architecture was added in version 2.3 of
> the specification, and support for AAaarch64 (arm64) was added in
> version 2.4.

AArch64

> UEFI is an evolution of its predecessor 'EFI', so the terms EFI and
> EFI are used somewhat interchangeably in this document and associated

UEFI

> source code. As a rule, anything new uses 'UEFI', whereas 'EFI' refers
> to legacy code or specifications.  
> 
> UEFI support in Linux                                                           
> =====================                                                           
> Booting on a platform with firmware compliant with the UEFI
> specification makes it possible for the kernel to support additional
> features:
> - UEFI Runtime Services
> - Retrieving various configuration information through the standardised
>   interface of UEFI configuration tables. (ACPI, SMBIOS, ...)
> 
> For actually enabling [U]EFI support, enable:
> - CONFIG_EFI=y
> - CONFIG_EFI_VARS=y or m
> 
> UEFI stub
> =========
> The "stub" is a feature that turns the Image/zImage/bzImage into a valid

We don't support bzImage for arm or arm64.

> UEFI PE/COFF executable, including a loader application that makes it
> possible to load the kernel directly from the UEFI shell, boot menu, or
> one of the lightweight bootloaders like Gummiboot or rEFInd. 
> The kernel image built with stub support remains a valid kernel image
> for booting in the legacy fashion.

By legacy, you mean non-UEFI rather than EFI? I consider UEFI as a choice
rather than the future ;p

> UEFI kernel support on ARM
> ==========================

Wait, isn't this all under Documentation/arm/? You could probably combine
some of these sections together, since the scope is really tied to ARM here.

> The implementation depends on receiving information about the UEFI
> environment in a Flattened Device Tree (FDT) - so is only available with
> CONFIG_OF.

You could mention this in your earlier list of dependencies.

> UEFI support also depends on early_memremap().

Why is that worthy of note? Can a user even turn that off?

> UEFI kernel support on the ARM architectures (arm and arm64) is only
> available when boot is performed through the stub.
> 
> When booting in UEFI mode, the kernel ignores any memory nodes in the
> DT, and instead reads the UEFI memory map. To prevent confusion, the
> stub deletes any memory nodes from a provided DT.
> 
> The stub populates the FDT /chosen node with, and the kernel scans for
> the following parameters:

Sentence doesn't read very well. Maybe stick some brackets around (and the
kernel scans for)?

> ______________________________________________________________________________
> Name                      | Size   | Description
> ================================================================================
> linux,uefi-system-table   | 64-bit | Physical address of the UEFI System Table.
> --------------------------------------------------------------------------------
> linux,uefi-mmap           | 64-bit | Physical address of the UEFI memory map,
>                           |        | populated by the UEFI GetMemoryMap() call.
> --------------------------------------------------------------------------------
> linux,uefi-mmap-size      | 32-bit | Size in bytes of the UEFI memory map
>                           |        | pointed to in previous entry.
> --------------------------------------------------------------------------------
> linux,uefi-mmap-desc-size | 32-bit | Size in bytes of each entry in the UEFI
>                           |        | memory map.

Do we actually need to define these sizes here, or can they be dealt with
using the usual #address-cells property? Also, I think you should describe
the binding in a separate document somewhere under Documentation/devicetree,
then cross-reference it from here.

> --------------------------------------------------------------------------------
> linux,uefi-stub-kern-ver  | string | Copy of linux_banner from build.
> --------------------------------------------------------------------------------

Are you sure you want to refer to kernel symbols here? If somebody renames
that variable, they're not going to fix this file.

Will
