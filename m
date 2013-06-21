From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH -v2 4/4] x86, efi: Map runtime services 1:1
Date: Fri, 21 Jun 2013 12:56:28 +0100
Message-ID: <20130621115628.GF5386@console-pimps.org>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <1371491416-11037-5-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1371491416-11037-5-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 17 Jun, at 07:50:16PM, Borislav Petkov wrote:
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
> This implementation is 64-bit only for now.
> 
> Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h          |  67 +++++++++++----
>  arch/x86/platform/efi/efi.c         | 165 +++++++++++++++++++++++++++++-------
>  arch/x86/platform/efi/efi_stub_64.S |  56 ++++++++++++
>  3 files changed, 240 insertions(+), 48 deletions(-)

[...]

> +	.macro SWITCH_PGT
> +	cmpb $0, efi_use_11_map
> +	je 1f;

Actually, this needs to be,

	cmpb $0, efi_use_11_map(%rip)

because this code is built into the EFI boot stub which isn't loaded at
a fixed address and needs to be position independent.

-- 
Matt Fleming, Intel Open Source Technology Center
