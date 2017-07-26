From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC Part1 PATCH v3 03/17] x86/mm: Secure Encrypted
 Virtualization (SEV) support
Date: Wed, 26 Jul 2017 06:28:40 +0200
Message-ID: <20170726042840.GB30702@nazgul.tnic>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-4-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170724190757.11278-4-brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Reza Arbab <arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 24, 2017 at 02:07:43PM -0500, Brijesh Singh wrote:
> From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> 
> Provide support for Secure Encyrpted Virtualization (SEV). This initial

Your subject misses a verb and patch subjects should have an active verb
denoting what the patch does. The sentence above is a good example.

> support defines a flag that is used by the kernel to determine if it is
> running with SEV active.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> Signed-off-by: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
> ---
>  arch/x86/include/asm/mem_encrypt.h | 2 ++
>  arch/x86/mm/mem_encrypt.c          | 3 +++
>  include/linux/mem_encrypt.h        | 8 +++++++-
>  3 files changed, 12 insertions(+), 1 deletion(-)

...

> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 0fbd092..1e4643e 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -40,6 +40,9 @@ static char sme_cmdline_off[] __initdata = "off";
>  unsigned long sme_me_mask __section(.data) = 0;
>  EXPORT_SYMBOL_GPL(sme_me_mask);
>  
> +unsigned int sev_enabled __section(.data) = 0;
> +EXPORT_SYMBOL_GPL(sev_enabled);

So sev_enabled is a pure bool used only in bool context, not like
sme_me_mask whose value is read too. Which means, you can make the
former static and query it only through accessor functions.

>  /* Buffer used for early in-place encryption by BSP, no locking needed */
>  static char sme_early_buffer[PAGE_SIZE] __aligned(PAGE_SIZE);
>  
> diff --git a/include/linux/mem_encrypt.h b/include/linux/mem_encrypt.h
> index 1255f09..ea0831a 100644
> --- a/include/linux/mem_encrypt.h
> +++ b/include/linux/mem_encrypt.h
> @@ -22,12 +22,18 @@
>  #else	/* !CONFIG_ARCH_HAS_MEM_ENCRYPT */
>  
>  #define sme_me_mask	0UL
> +#define sev_enabled	0
>  
>  #endif	/* CONFIG_ARCH_HAS_MEM_ENCRYPT */
>  
>  static inline bool sme_active(void)
>  {
> -	return !!sme_me_mask;
> +	return (sme_me_mask && !sev_enabled);

You don't need the brackets. Below too.

> +}
> +
> +static inline bool sev_active(void)
> +{
> +	return (sme_me_mask && sev_enabled);
>  }

So this is confusing, TBH. SME and SEV are not mutually exclusive and
yet the logic here says so. Why?

I mean, in the hypervisor context, sme_active() is still true.

/me is confused.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
