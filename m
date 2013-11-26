From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [GIT PULL] EFI runtime mapping work for v3.14
Date: Tue, 26 Nov 2013 12:56:30 +0100
Message-ID: <20131126115630.GA21146@pd.tnic>
References: <20131125162854.GK11521@console-pimps.org>
 <20131126112650.GD2410@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131126112650.GD2410-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 26, 2013 at 12:26:50PM +0100, Ingo Molnar wrote:
> Just a side note, for future reference, this title lacks a verb and is 
> thus not self-describing:
> 
>    x86/efi: Runtime services virtual mapping
> 
> It should probably have been something like:
> 
>    x86/efi: Implement and enable separate, stable virtual mapping for runtime services
> 
> ?

My bad: it should've been "Reimplement runtime services virtual mapping"
or sth like that.

> Chances are that it will be a popular bisection target ;-)

I *so* hope your clairvoyant skills fail you this time :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
