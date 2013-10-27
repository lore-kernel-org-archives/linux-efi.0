From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Add asm-generic/efi.h for non-x86
Date: Sun, 27 Oct 2013 20:42:12 +0000
Message-ID: <20131027204212.GF1982@console-pimps.org>
References: <1382012355-8846-1-git-send-email-matt@console-pimps.org>
 <1382012355-8846-2-git-send-email-matt@console-pimps.org>
 <20131017141653.GJ10834@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131017141653.GJ10834-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 17 Oct, at 03:16:53PM, Matt Fleming wrote:
> After reading Leif's arm runtime patches this patch obviously doesn't
> make much sense. I'll work on something better.

OK, since Leif's stuff needs to go through another revision, I'm gonna
leave these patches as-is and merge them into the 'next' branch. I'll
throw some patches at Leif to move efi_enabled() to common code to
include in his series.

-- 
Matt Fleming, Intel Open Source Technology Center
