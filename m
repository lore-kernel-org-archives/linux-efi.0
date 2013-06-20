From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Thu, 20 Jun 2013 17:53:11 +0100
Message-ID: <20130620165311.GA26214@srcf.ucam.org>
References: <20130619130434.GB24957@gmail.com>
 <20130619160804.GB27832@srcf.ucam.org>
 <20130620091321.GB6811@gmail.com>
 <20130620091537.GA17159@srcf.ucam.org>
 <20130620092237.GA6943@gmail.com>
 <20130620093337.GI32694@pd.tnic>
 <20130620094446.GA17882@srcf.ucam.org>
 <1371740019.2372.3.camel@dabdike>
 <20130620162916.GA25727@srcf.ucam.org>
 <alpine.LRH.2.00.1306201843430.3478@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1306201843430.3478-1ReQVI26iDCaZKY3DrU6dA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 20, 2013 at 06:44:46PM +0200, Jiri Kosina wrote:

> So if we properly detect those (and only those), we mimic Windows 
> completely, right?

No. Windows passes addresses above the phys/virt split to 
SetVirtualAddressMap().

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
