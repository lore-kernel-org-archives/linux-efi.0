From: Scott Ashcroft <scott.ashcroft-qw6QB7/foO7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Always map boot service regions into new EFI
 page tables
Date: Mon, 14 Mar 2016 01:09:12 +0000
Message-ID: <1457917752.10465.6.camel@talk21.com>
References: <1457695163-29632-1-git-send-email-matt@codeblueprint.co.uk>
	 <1457695163-29632-2-git-send-email-matt@codeblueprint.co.uk>
	 <1457888975.3884.9.camel@talk21.com>
	 <20160313215847.GA2619@codeblueprint.co.uk>
	 <20160313230736.GB2619@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160313230736.GB2619-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Raphael Hertzog <hertzog-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Roger Shimizu <rogershimizu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexis Murzeau <amurzeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 2016-03-13 at 23:07 +0000, Matt Fleming wrote:
> Assuming the answer to this question is "no", can you try out this
> patch?
>=20
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 8fee5b6f8f66..af74849e8c0f 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -1055,7 +1055,7 @@ static int populate_pud(struct cpa_data *cpa,
> unsigned long start, pgd_t *pgd,
> =C2=A0	/*
> =C2=A0	=C2=A0* Map everything starting from the Gb boundary, possibly
> with 1G pages
> =C2=A0	=C2=A0*/
> -	while (end - start >=3D PUD_SIZE) {
> +	while (cpu_has_gbpages && end - start >=3D PUD_SIZE) {
> =C2=A0		set_pud(pud, __pud(cpa->pfn << PAGE_SHIFT |
> _PAGE_PSE |
> =C2=A0				=C2=A0=C2=A0=C2=A0massage_pgprot(pud_pgprot)));
>=20

Yes, that does fix it.

Cheers,
Scott
