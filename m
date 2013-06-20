From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Thu, 20 Jun 2013 16:33:50 +0200 (CEST)
Message-ID: <alpine.LRH.2.00.1306201632490.3478@twin.jikos.cz>
References: <1371491416-11037-1-git-send-email-bp@alien8.de> <20130619125243.GD11209@gmail.com> <20130619130225.GA28311@pd.tnic> <20130619130434.GB24957@gmail.com> <20130619160804.GB27832@srcf.ucam.org> <20130620091321.GB6811@gmail.com> <20130620091537.GA17159@srcf.ucam.org>
 <20130620092237.GA6943@gmail.com> <20130620093337.GI32694@pd.tnic> <20130620094446.GA17882@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130620094446.GA17882-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 20 Jun 2013, Matthew Garrett wrote:

> > This will break the Macs so maybe we can do
> > 
> > efi=no_11_map
> > 
> > so the Macs can still boot but use the 1:1 map by default.
> 
> I'm going to guess that there are more people running unmodified Linux 
> kernels on Macs than there are people using kexec, 

I'd be careful in order not to underestimate how much kexec is being used. 
[At least some] distros are using it during installation process.

-- 
Jiri Kosina
SUSE Labs
