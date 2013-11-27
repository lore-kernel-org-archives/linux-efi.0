From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v4 08/12] efi: only print saved efi runtime maps instead
 of all memmap ranges for kexec
Date: Wed, 27 Nov 2013 15:27:26 +0100
Message-ID: <20131127142726.GE32267@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-9-git-send-email-dyoung@redhat.com>
 <20131127102701.GD18170@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131127102701.GD18170-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 27, 2013 at 10:27:01AM +0000, Matt Fleming wrote:
> Heh, you can probably already guess what I'm going to say here...

I guessed :-)

> How about using a single function to dump the memory ranges irrespective
> of whether the memory map comes from 'memmap' or 'esdata'? e.g.
> something along the lines of,
> 
> 	if (esdata)
> 		print_efi_memmap(esdata->map, nr_efi_runtime_map,
> 				 sizeof(esdata->map[0]));
> 	else
> 		print_efi_memmap(memmap.map, memmap.nr_map,
> 				 memmap.desc_size);

And while you're at it:

WARNING: quoted string split across lines
#19: FILE: arch/x86/platform/efi/efi.c:443:
+               pr_info("mem%02u: type=%u, attr=0x%llx, "
+                       "range=[0x%016llx-0x%016llx) (%lluMB)\n",


Btw, do we really want to dump the same map again in the second kernel?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
