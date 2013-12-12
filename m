From: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Subject: Re: EFI tree kernel panic in phys_efi_set_virtual_address_map()
Date: Thu, 12 Dec 2013 10:36:17 -0700
Message-ID: <1386869777.1791.314.camel@misato.fc.hp.com>
References: <1386806463.1791.295.camel@misato.fc.hp.com>
	 <20131212002946.GF8863@pd.tnic>
	 <1386808323.1791.299.camel@misato.fc.hp.com>
	 <1386810484.1791.306.camel@misato.fc.hp.com>
	 <1386810620.1791.307.camel@misato.fc.hp.com>
	 <20131212162351.GA26927@pd.tnic>
	 <1386866583.1791.310.camel@misato.fc.hp.com>
	 <1386869221.1791.311.camel@misato.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386869221.1791.311.camel-RbGIw1UOYPVo/CpIj0byZw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-12-12 at 10:27 -0700, Toshi Kani wrote:
> On Thu, 2013-12-12 at 09:43 -0700, Toshi Kani wrote:
> > On Thu, 2013-12-12 at 17:23 +0100, Borislav Petkov wrote:
> > > On Wed, Dec 11, 2013 at 06:10:20PM -0700, Toshi Kani wrote:
> > > > > Unfortunately, it did not work.  Hit the same panic again.
> > > > 
> > > > dmesg output attached.
> > > 
> > > Ok, thanks.
> > > 
> > > Let's have a look at the EFI pagetable then. Please apply the attached
> > > patch, make sure CONFIG_X86_PTDUMP is enabled, build, boot and catch
> > > full dmesg again and send it to me.
> > 
> > Yes, I will test with the change, and send a full dmesg output to you.
> 
> Attached.

BTW, the test system is shared and will be used by other test for a
couple of hours or so.  So, please take your time. :-)

Thanks!
-Toshi
