From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an
 arbitrary pagetable
Date: Sat, 11 Jan 2014 12:59:42 -0800
Message-ID: <1389473982.2537.84.camel@joe-AO722>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
	 <1389473370-1940-2-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389473370-1940-2-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 2014-01-11 at 21:49 +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> 
> With reusing the ->trampoline_pgd page table for mapping EFI regions in
> order to use them after having switched to EFI virtual mode, it is very
> useful to be able to dump aforementioned page table in dmesg. This adds
> that functionality through the walk_pgd_level() interface which can be
> called from somewhere else.
[]
> diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
[]
> @@ -306,6 +326,11 @@ static void walk_pgd_level(struct seq_file *m)
>  	int i;
>  	struct pg_state st;
>  
> +	if (pgd) {
> +		start = pgd;
> +		dump_to_dmesg = true;
> +	}

	else
		dump_to_dmesg = false;

?
