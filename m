From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 4/4] x86, efi: Map runtime services 1:1
Date: Thu, 6 Jun 2013 14:14:39 +0100
Message-ID: <20130606131439.GI30420@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-5-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370177770-26661-5-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 02 Jun, at 02:56:10PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> 
> Due to the braindead design of EFI, we cannot map runtime services more
> than once for the duration of a booted system. Thus, if we want to use
> EFI runtime services in a kexec'ed kernel, maybe the only possible and
> sensible approach would be to map them 1:1 so that when the kexec kernel
> loads, it can simply call those addresses without the need for remapping
> (which doesn't work anyway).
> 
> Furthermore, this mapping approach could be of help with b0rked EFI
> implementations for a different set of reasons.
> 
> This implementation is 64-bit only for now and it boots fine in kvm with
> OVMF BIOS.
> 
> Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h          |   2 +
>  arch/x86/platform/efi/efi.c         | 161 +++++++++++++++++++++++++++++-------
>  arch/x86/platform/efi/efi_stub_64.S |  48 +++++++++++
>  3 files changed, 180 insertions(+), 31 deletions(-)
 
This patch makes my TunnelMountain machine spin in handle_pte_fault()
when triggering one of the "firmware makes references to physical
addresses" code paths.

I'll try and dig into this tomorrow to figure out what's going on.

-- 
Matt Fleming, Intel Open Source Technology Center
