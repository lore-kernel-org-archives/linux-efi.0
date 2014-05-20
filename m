From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes for v3.16
Date: Tue, 20 May 2014 21:27:55 +0100
Message-ID: <20140520202755.GI4798@console-pimps.org>
References: <20140503130447.GW26088@console-pimps.org>
 <20140519105129.GF4798@console-pimps.org>
 <537A8A03.8060604@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <537A8A03.8060604-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 19 May, at 03:47:31PM, H. Peter Anvin wrote:
> 
> How on earth does this solve anything?  The only thing we add here is a
> WARN_ON_ONCE()... but the above text already tells us we have a problem.
> 
> It seems, rather, that we need to figure out how to deal with a pstore
> in this case.  There are a few possibilities:
> 
> 1. We could keep an XSAVE buffer area around for this particular use.
>    I am *assuming* we don't let more than one CPU into EFI, because I
>    cannot for my life imagine that this is safe in typical CPUs.
 
Correct. This is actually prohibited by the spec, so we have a lock to
enforce it.

> 2. Drop the pstore on the floor if !irq_fpu_usable().
> 
> 3. Allow the pstore, then die (on the assumption that we're dead
>    anyway.)

Personally, I'd prefer 2, but I'm open to suggestions.

-- 
Matt Fleming, Intel Open Source Technology Center
