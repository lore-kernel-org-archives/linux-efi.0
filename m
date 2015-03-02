From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/8] x86, kaslr: get kaslr_enabled back correctly
Date: Mon, 2 Mar 2015 13:13:58 +0000
Message-ID: <20150302131358.GD24476@codeblueprint.co.uk>
References: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
 <1425176259-30087-2-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1425176259-30087-2-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, 28 Feb, at 06:17:32PM, Yinghai Lu wrote:
> We should access variable with referrence instead of using physical
> address as value.
> 
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/kernel/setup.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 98dc931..05d444f 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -429,7 +429,13 @@ static void __init reserve_initrd(void)
>  
>  static void __init parse_kaslr_setup(u64 pa_data, u32 data_len)
>  {
> -	kaslr_enabled = (bool)(pa_data + sizeof(struct setup_data));
> +	/* kaslr_setup_data is defined in aslr.c */
> +	unsigned char *data;
> +	unsigned long offset = sizeof(struct setup_data);
> +
> +	data = early_memremap(pa_data, offset + 1);
> +	kaslr_enabled = *(data + offset);
> +	early_memunmap(data, offset + 1);
>  }

ACK in principle, but could we change 'offset' to 'size' or 'len' along
with the commit log updates people have suggested?

-- 
Matt Fleming, Intel Open Source Technology Center
