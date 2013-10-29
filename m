From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Date: Tue, 29 Oct 2013 10:40:34 +0100
Message-ID: <20131029094033.GA10972@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
 <20131029064720.GA16009@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131029064720.GA16009-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fwts-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 29, 2013 at 02:47:20PM +0800, Dave Young wrote:
> Boris, could you update the comment? it says below: update that memory
> descriptor with the virtual address obtained from ioremap().
>
> Logiclly your patch should update it, then my patch update it again
> with the case of mapping to fixed address for kexec.

Thanks for catching this, I ended up doing the following:

/*
 * This function will switch the EFI runtime services to virtual mode.
 * Essentially, we look through the EFI memmap and map every region that
 * has the runtime attribute bit set in its memory descriptor into the
 * ->trampoline_pgd page table using a top-down VA allocation scheme.
 *
 * The old method which used to update that memory descriptor with the
 * virtual address obtained from ioremap() is still supported when the
 * kernel is booted with efi=old_map on its command line. Same old
 * method enabled the runtime services to be called without having to
 * thunk back into physical mode for every invocation.
 *
 * The new method does a pagetable switch in a preemption-safe manner
 * so that we're in a different address space when calling a runtime
 * function. For function arguments passing we do copy the PGDs of the
 * kernel page table into ->trampoline_pgd prior to each call.
 */

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
