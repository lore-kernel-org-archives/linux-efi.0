From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/13] EFI mixed mode
Date: Fri, 7 Mar 2014 02:11:50 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1403070211280.31668@chino.kir.corp.google.com>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org> <alpine.DEB.2.02.1403061325250.25499@chino.kir.corp.google.com> <20140306214014.GA8942@console-pimps.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140306214014.GA8942-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 6 Mar 2014, Matt Fleming wrote:

> Thanks for the report David.
> 
> I sent a pull request that fixes these errors up. Looks like it got
> pulled into tip:x86/efi,
> 
> commit 617b3c37da78
> Merge: 994448f1afa6 3db4cafdfd05
> Author: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Date:   Wed Mar 5 18:18:50 2014 +0000
> 
>     Merge branch 'mixed-mode' into efi-for-mingo
> 
> So everything should be working in tip:x86/efi which includes
> tip:x86/efi-mixed.
> 

You're absolutely right, x86/efi looks good!  Thanks Matt.
