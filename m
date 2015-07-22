From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] x86_64/efi: Use all 64 bit of efi_memmap in setup_e820()
Date: Wed, 22 Jul 2015 17:22:35 +0200
Message-ID: <20150722152235.GC28766@nazgul.tnic>
References: <1437577570-13038-1-git-send-email-sdmitry@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437577570-13038-1-git-send-email-sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Skorodumov <sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Denis V. Lunev" <den-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 22, 2015 at 07:06:10PM +0400, Dmitry Skorodumov wrote:
> The efi_info structure stores low 32 bits of memory map
> in efi_memmap and high 32 bits in efi_memmap_hi.
> 
> While constructing pointer in the setup_e820(), need
> to take into account all 64 bit of the pointer.
> 
> It is because on 64bit machine the function
> efi_get_memory_map() may return full 64bit pointer and before
> the patch that pointer was truncated.
> 
> Signed-off-by: Dmitry Skorodumov <sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Denis V. Lunev <den-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> 
> tested in Parallles virtual machine, kernel 3.10.0
> ---
>  arch/x86/boot/compressed/eboot.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 2c82bd1..908a81f 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -1184,6 +1184,12 @@ static efi_status_t setup_e820(struct boot_params *params,
>  	u32 nr_entries;
>  	u32 nr_desc;
>  	int i;
> +	unsigned long m

Did you even build-test it before sending?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
