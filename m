From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3 2/2] efi: efi_mem_reserve(): don't reserve through
 memblock after mm_init()
Date: Mon, 9 Jan 2017 13:00:33 +0000
Message-ID: <20170109130033.GH16838@codeblueprint.co.uk>
References: <20170105125130.2815-1-nicstange@gmail.com>
 <20170105125130.2815-2-nicstange@gmail.com>
 <CAKv+Gu8RHsMKmEHBqNv=q4SB-spCtuydbCshs2ut1+Kk8vraOQ@mail.gmail.com>
 <87wpe8mjdk.fsf@gmail.com>
 <CAKv+Gu_BnSf_LMsWHTeFaTak8iV1Cwex7WBEsufwYRrBzY8KzQ@mail.gmail.com>
 <87showm682.fsf@gmail.com>
 <CAKv+Gu9B_amUwKuQCfMj6d96EpcLdeBDm732E0iqKSkRp11Z4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9B_amUwKuQCfMj6d96EpcLdeBDm732E0iqKSkRp11Z4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 06 Jan, at 07:28:40PM, Ard Biesheuvel wrote:
> 
> This is my point exactly. But it appears efi_free_boot_services()
> occurs much later than I thought, and so there is a sizabe time window
> where SLAB is up but reservations can still be made. But we don't
> check whether efi_free_boot_services() has been called.

True. This has only been correct thus far because all code has been
audited, but adding a check to catch future offenders is a good idea.

> Another problem is that we never check that the reservation is
> covered by a BootServicesData region, which are the only ones that
> are guaranteed to be retained up to this point.

The runtime regions are guaranteed to be retained too.

Again, this shouldn't actually be a problem today, but the potential
for breakage here warrants some kind of check and loud warning. 
