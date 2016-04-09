From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Date: Sat, 9 Apr 2016 13:00:55 +0100
Message-ID: <20160409120055.GR2701@codeblueprint.co.uk>
References: <811539524df8b5ed7e2817c1c3e3e08560c97964.1459275517.git.lukas@wunner.de>
 <20160405194015.GC15353@localhost>
 <20160406213029.GA12421@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160406213029.GA12421@wunner.de>
Sender: linux-pci-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org, zajec5@gmail.com, b43-dev@lists.infradead.org, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, 06 Apr, at 11:30:29PM, Lukas Wunner wrote:
> 
> More specifically, arch/x86/platform/efi/quirks.c:efi_free_boot_services()
> makes EFI boot services memory available to the page allocator and this
> is called near the end of init/main.c:start_kernel(). *Afterwards*, the
> initcalls are executed via rest_init() -> kernel_init() ->
> kernel_init_freeable() -> do_basic_setup() -> do_initcalls(). In particular,
> PCI header fixups are executed in the subsys_initcall acpi_init().
> 
> Some of the possible solutions are:
> 
> (1) Delay efi_free_boot_services() further, e.g. until late_initcall.
 
I'd prefer not to do this because boot services regions can account
for a large amount of memory (multiple gigabytes).

> (2) Find out exactly which EFI boot services area is used for DMA and
>     amend arch/x86/platform/efi/quirks.c:efi_apply_memmap_quirks() to
>     assign that area a different type if dmi_match(DMI_SYS_VENDOR,
>     "Apple Inc."). That way it's not freed by efi_free_boot_services().
>     Add a late_initcall which calls free_bootmem() for that area.
 
If it is possible to find out which boot services region is the
problematic one, this would be the best solution. If there's any way
to tie it into the PCI quirk, that would be even better so we don't
need to maintain the blacklist in two places.
