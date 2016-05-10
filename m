From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [RFC PATCH v1 10/18] x86/efi: Access EFI related tables in the
 clear
Date: Tue, 10 May 2016 14:43:58 +0100
Message-ID: <20160510134358.GR2839@codeblueprint.co.uk>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
 <20160426225740.13567.85438.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160426225740.13567.85438.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 26 Apr, at 05:57:40PM, Tom Lendacky wrote:
> The EFI tables are not encrypted and need to be accessed as such. Be sure
> to memmap them without the encryption attribute set. For EFI support that
> lives outside of the arch/x86 tree, create a routine that uses the __weak
> attribute so that it can be overridden by an architecture specific routine.
> 
> When freeing boot services related memory, since it has been mapped as
> un-encrypted, be sure to change the mapping to encrypted for future use.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> ---
>  arch/x86/include/asm/cacheflush.h  |    3 +
>  arch/x86/include/asm/mem_encrypt.h |   22 +++++++++++
>  arch/x86/kernel/setup.c            |    6 +--
>  arch/x86/mm/mem_encrypt.c          |   56 +++++++++++++++++++++++++++
>  arch/x86/mm/pageattr.c             |   75 ++++++++++++++++++++++++++++++++++++
>  arch/x86/platform/efi/efi.c        |   26 +++++++-----
>  arch/x86/platform/efi/efi_64.c     |    9 +++-
>  arch/x86/platform/efi/quirks.c     |   12 +++++-
>  drivers/firmware/efi/efi.c         |   18 +++++++--
>  drivers/firmware/efi/esrt.c        |   12 +++---
>  include/linux/efi.h                |    3 +
>  11 files changed, 212 insertions(+), 30 deletions(-)

The size of this change is completely unexpected. Why is there so much
churn to workaround this new feature?

Is it not possible to maintain some kind of kernel virtual address
mapping so memremap*() and friends can figure out when to twiddle the
mapping attributes and map with/without encryption?

These API changes place an undue burden on developers that don't even
care about SME.
