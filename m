From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Fix multiple GOP device support
Date: Wed, 14 Oct 2015 17:04:26 +0200
Message-ID: <20151014150426.GC21330@gmail.com>
References: <1444659236-24837-1-git-send-email-matt@codeblueprint.co.uk>
 <1444659236-24837-2-git-send-email-matt@codeblueprint.co.uk>
 <20151014144715.GA17890@gmail.com>
 <20151014145103.GB17890@gmail.com>
 <20151014150215.GC2782@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151014150215.GC2782-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, =?utf-8?B?S8WRdsOhZ8OzLCBab2x0w6Fu?= <dirty.ice.hu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> > So the fix patch is fine as-is for v4.3, but needs a conflict resolution for 
> > the pending v4.4 commit.
> > 
> > I've applied it that way.
> 
> Do you need me to send a patch on top or have you taken care of the
> semantic conflict for v4.4? (the change you originally proposed,
> s/u32/u64/, looked fine)

So to not break bisection in hard to debug ways, I made this fixup in the merge 
commit of your changes, and documented it all in the merge commit message:

commit 790a2ee2427852cff50993c98f15ed88511e9af0
Merge: c7d77a7980e4 0f96a99dab36
Author: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date:   Wed Oct 14 16:05:40 2015 +0200

    Merge tag 'efi-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi into core/efi
    
    Pull v4.4 EFI updates from Matt Fleming:
    
      - Make the EFI System Resource Table (ESRT) driver explicitly
        non-modular by ripping out the module_* code since Kconfig doesn't
        allow it to be built as a module anyway. (Paul Gortmaker)
    
      - Make the x86 efi=debug kernel parameter, which enables EFI debug
        code and output, generic and usable by arm64. (Leif Lindholm)
    
      - Add support to the x86 EFI boot stub for 64-bit Graphics Output
        Protocol frame buffer addresses. (Matt Fleming)
    
      - Detect when the UEFI v2.5 EFI_PROPERTIES_TABLE feature is enabled
        in the firmware and set an efi.flags bit so the kernel knows when
        it can apply more strict runtime mapping attributes - Ard Biesheuvel
    
      - Auto-load the efi-pstore module on EFI systems, just like we
        currently do for the efivars module. (Ben Hutchings)
    
      - Add "efi_fake_mem" kernel parameter which allows the system's EFI
        memory map to be updated with additional attributes for specific
        memory ranges. This is useful for testing the kernel code that handles
        the EFI_MEMORY_MORE_RELIABLE memmap bit even if your firmware
        doesn't include support. (Taku Izumi)
    
    Note: there is a semantic conflict between the following two commits:
    
      8a53554e12e9 ("x86/efi: Fix multiple GOP device support")
      ae2ee627dc87 ("efifb: Add support for 64-bit frame buffer addresses")
    
    I fixed up the interaction in the merge commit, changing the type of
    current_fb_base from u32 to u64.
    
    Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks,

	Ingo
