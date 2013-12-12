From: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Subject: Re: EFI tree kernel panic in phys_efi_set_virtual_address_map()
Date: Thu, 12 Dec 2013 13:44:14 -0700
Message-ID: <1386881054.1791.316.camel@misato.fc.hp.com>
References: <1386806463.1791.295.camel@misato.fc.hp.com>
	 <20131212002946.GF8863@pd.tnic>
	 <1386808323.1791.299.camel@misato.fc.hp.com>
	 <1386810484.1791.306.camel@misato.fc.hp.com>
	 <1386810620.1791.307.camel@misato.fc.hp.com>
	 <20131212162351.GA26927@pd.tnic>
	 <1386866583.1791.310.camel@misato.fc.hp.com>
	 <1386869221.1791.311.camel@misato.fc.hp.com>
	 <1386869777.1791.314.camel@misato.fc.hp.com>
	 <20131212203533.GB26927@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131212203533.GB26927-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-12-12 at 21:35 +0100, Borislav Petkov wrote:
> On Thu, Dec 12, 2013 at 10:36:17AM -0700, Toshi Kani wrote:
> > BTW, the test system is shared and will be used by other test for a
> > couple of hours or so. So, please take your time. :-)
> 
> Yeah, ok :-)
> 
> I went and polished the debugging patch a bit more - it seems we're
> going to need it more often now, should probably send it up too :)
> 
> Right, so the pagetable dump shows that the new_memmap is not mapped in
> it, thus the #PF.
> 
> Ok, so next try: let's dump the pagetable after we've copied the pgd
> containing new_memmap. Same exercise as before, please.

Will do.

Thanks,
-Toshi
