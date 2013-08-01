From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/4] Make commonly useful UEFI functions common
Date: Thu, 01 Aug 2013 13:26:41 -0700
Message-ID: <51FAC481.2050905@zytor.com>
References: <1375202858-28470-1-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375202858-28470-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 07/30/2013 09:47 AM, Leif Lindholm wrote:
> This set breaks out some common code from x86/ia64 EFI support
> code and puts it into drivers/firmware/efi.
> 
> First it takes the definition of the global "efi" data structure
> and moves it into global efi.c. Then it implements a common version
> of efi_config_init().
> 
> Secondly it breaks the efi_lookup_mapped_addr() function out of x86
> and places it in global efi.c, for shared use with future ARM
> patches.
> 
> IA64 code compile tested only.
> 
> Pardon the delay in getting this out - back to back conferences
> followed by a bad case of the man flu.
> 
> Leif Lindholm (4):
>   efi: provide a generic efi_config_init()
>   efi: x86: use common code for (U)EFI configuration scanning
>   efi: ia64: use common code for (U)EFI configuration scanning
>   efi: x86: make efi_lookup_mapped_addr() a common function
> 
>  arch/ia64/include/asm/io.h  |    1 +
>  arch/ia64/kernel/efi.c      |   54 ++++-------------
>  arch/x86/platform/efi/efi.c |  124 +++------------------------------------
>  drivers/firmware/efi/efi.c  |  136 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h         |    7 +++
>  5 files changed, 163 insertions(+), 159 deletions(-)
> 

Matt, I assume you're picking this up once the missing bits are plugged
in, right?

	-hpa
