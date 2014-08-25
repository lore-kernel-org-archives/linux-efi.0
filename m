From: "Zheng, Lv" <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: kernel boot fail with efi earlyprintk (bisected)
Date: Mon, 25 Aug 2014 06:34:02 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880265F57B@SHSMSX101.ccr.corp.intel.com>
References: <20140819081658.GA1795@darkstar.nay.redhat.com>
 <20140821205224.GJ29733@console-pimps.org>
 <20140822100258.GA1877@darkstar.nay.redhat.com>
 <20140825060713.GA4011@darkstar.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140825060713.GA4011-4/PLUo9XfK+sDdueE5tM26fLeoKvNuZc@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org" <devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org>, "lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Wysocki, Rafael J" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Moore, Robert" <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi,

> From: Dave Young [mailto:dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Monday, August 25, 2014 2:07 PM
> To: Matt Fleming
> Cc: Zheng, Lv; Fleming, Matt; linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org;
> lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Wysocki, Rafael J; Moore, Robert
> Subject: Re: kernel boot fail with efi earlyprintk (bisected)
> 
> On 08/22/14 at 06:02pm, Dave Young wrote:
> > On 08/21/14 at 09:52pm, Matt Fleming wrote:
> > > On Tue, 19 Aug, at 04:16:58PM, Dave Young wrote:
> > > > Hi,
> > > >
> > > > 3.16 kernel boot fail with earlyprintk=efi on my laptop.
> > > > It keeps scrolling at the bottom line of screen.
> > > >
> > > > Bisected, the first bad commit is below:
> > > > commit 86dfc6f339886559d80ee0d4bd20fe5ee90450f0
> > > > Author: Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Date:   Fri Apr 4 12:38:57 2014 +0800
> > > >
> > > >     ACPICA: Tables: Fix table checksums verification before installation.
> > > >
> > > >
> > > > I did some debugging by enabling both serial and efi earlyprintk, below is
> > > > some debug dmesg, seems early_ioremap fails in scroll up function due to
> > > > no free slot, but I'm still not sure if the debug info is right or not.
> > >
> > > Thanks Dave, your callstack seems to make sense.
> > >
> > > Can you also enable early_ioremap_debug so that we can figure out where
> > > all the FIXMAP slots are going?
> >
> > With early_ioremap_debug enabled, there will be a lot of "dropped printk", so
> > I can not get any useful information.
> >
> > Will try to do more debug.
> 
> early_ioremap_debug does not work because we are debugging early_printk but
> early_ioremap_debug itself will print warning message at the same time.
> 
> Tried what Lv mentioned, increasing the early ioremap slots does help.

Could you send a tested patch to linux-acpi-u79uwXL29TY6noJ6QQ2T4w@public.gmane.org for this?
I think the number of early mapping slots need to be increased by 1 because of this case.

Thanks and best regards
-Lv
