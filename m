From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Fix kernel panic when mapping BGRT data
Date: Mon, 14 Dec 2015 15:08:17 +0000
Message-ID: <20151214150817.GB2571@codeblueprint.co.uk>
References: <1449772021-983-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <20151210214258.GB9584@cloud>
 <FFF73D592F13FD46B8700F0A279B802F014F2335@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F014F2335-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, "Neri, Ricardo" <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Shankar, Ravi V" <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 11 Dec, at 05:58:09AM, Sai Praneeth Prakhya wrote:
> 
> >The original motivation for efi_lookup_mapped_addr came from
> >early_ioremap printing a warning if used on an address range
> >already mapped as RAM.  Does early_mem* handle that case correctly
> >without a warning?  
> 
> Thanks a lot Josh for letting me know that. I don't think
> early_memremap() does that because early_memremap() and
> early_ioremap() both use __early_ioremap() but with different page
> protections (and I am not sure how those protections effect warning,
> but I will check that). Waiting for comments from Matt and Boris.

Right, early_memremap() was introduced for the purpose of mapping RAM,
so we shouldn't be seeing any warning here.

> >Because not all firmware places the BGRT image in boot services
> >memory; some firmware places the BGRT image variously in BIOS
> >reserved memory, ACPI reclaim >space, or other strange places.
> >
> >- Josh Triplett
> 
> I think we should not support buggy firmware implementations because
> it's same as encouraging them, instead we could let user know that
> he has got a buggy firmware and we skip bgrt code as if bgrt was
> disabled and carry on with normal boot process. One way of detecting
> buggy implementation without doing page table switch in
> efi_bgrt_init() is to enable a chicken bit if we find bgrt header
> and image address in EFI_BOOT_SERVICES_DATA regions while we are
> switching efi runtime services to virtual mode in
> __efi_enter_virtual_mode() and check for the same bit in
> efi_bgrt_init().

Trying to inform firmware developers that we noticed some buggy
behaviour should definitely be discussed as a separate patch (because
it's debatable whether there's any value in that in this scenario).

The changes in this patch look OK to me, and I think all of Josh's
concerns have been addressed. So unless anyone complains soon, I'm
going to apply it and send it to tip.
