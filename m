From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes for v3.16
Date: Tue, 20 May 2014 01:10:12 +0200
Message-ID: <20140519231012.GF6311@pd.tnic>
References: <20140503130447.GW26088@console-pimps.org>
 <20140519105129.GF4798@console-pimps.org>
 <537A8A03.8060604@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <537A8A03.8060604-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, May 19, 2014 at 03:47:31PM -0700, H. Peter Anvin wrote:
> >     efi_call can happen in an irq context (pstore) and there we really need
> >     to make sure we're not scribbling over FPU state while we've interrupted
> >     a thread or kernel mode with a live FPU state. Therefore, use the
> >     kernel_fpu_begin/end() variants which do that check.
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
> 
> 2. Drop the pstore on the floor if !irq_fpu_usable().
> 
> 3. Allow the pstore, then die (on the assumption that we're dead
>    anyway.)
> 
> Comments?

The question is, why can't that pstore mumbo jumbo go and do its dance
in !irq context?

And how useful is the whole deal really, btw? I wanted to use it for
saving oopses into it, for example, but Tony said its write speed is
horribly low for that.

So why do we even bother with this thing and do the dance in irq context
for it? Is it worth it at all?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
