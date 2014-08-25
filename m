From: Dave Young <dyoung@redhat.com>
Subject: Re: kernel boot fail with efi earlyprintk (bisected)
Date: Mon, 25 Aug 2014 17:06:19 +0800
Message-ID: <20140825090619.GA3202@darkstar.nay.redhat.com>
References: <20140819081658.GA1795@darkstar.nay.redhat.com>
 <20140821205224.GJ29733@console-pimps.org>
 <20140822100258.GA1877@darkstar.nay.redhat.com>
 <20140825060713.GA4011@darkstar.nay.redhat.com>
 <1AE640813FDE7649BE1B193DEA596E880265F57B@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E880265F57B@SHSMSX101.ccr.corp.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, "Fleming, Matt" <matt.fleming@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@acpica.org" <devel@acpica.org>, "lenb@kernel.org" <lenb@kernel.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Moore, Robert" <robert.moore@intel.com>
List-Id: linux-efi@vger.kernel.org

On 08/25/14 at 06:34am, Zheng, Lv wrote:
> Hi,
> 
> > From: Dave Young [mailto:dyoung@redhat.com]
> > Sent: Monday, August 25, 2014 2:07 PM
> > To: Matt Fleming
> > Cc: Zheng, Lv; Fleming, Matt; linux-efi@vger.kernel.org; linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org; devel@acpica.org;
> > lenb@kernel.org; Wysocki, Rafael J; Moore, Robert
> > Subject: Re: kernel boot fail with efi earlyprintk (bisected)
> > 
> > On 08/22/14 at 06:02pm, Dave Young wrote:
> > > On 08/21/14 at 09:52pm, Matt Fleming wrote:
> > > > On Tue, 19 Aug, at 04:16:58PM, Dave Young wrote:
> > > > > Hi,
> > > > >
> > > > > 3.16 kernel boot fail with earlyprintk=efi on my laptop.
> > > > > It keeps scrolling at the bottom line of screen.
> > > > >
> > > > > Bisected, the first bad commit is below:
> > > > > commit 86dfc6f339886559d80ee0d4bd20fe5ee90450f0
> > > > > Author: Lv Zheng <lv.zheng@intel.com>
> > > > > Date:   Fri Apr 4 12:38:57 2014 +0800
> > > > >
> > > > >     ACPICA: Tables: Fix table checksums verification before installation.
> > > > >
> > > > >
> > > > > I did some debugging by enabling both serial and efi earlyprintk, below is
> > > > > some debug dmesg, seems early_ioremap fails in scroll up function due to
> > > > > no free slot, but I'm still not sure if the debug info is right or not.
> > > >
> > > > Thanks Dave, your callstack seems to make sense.
> > > >
> > > > Can you also enable early_ioremap_debug so that we can figure out where
> > > > all the FIXMAP slots are going?
> > >
> > > With early_ioremap_debug enabled, there will be a lot of "dropped printk", so
> > > I can not get any useful information.
> > >
> > > Will try to do more debug.
> > 
> > early_ioremap_debug does not work because we are debugging early_printk but
> > early_ioremap_debug itself will print warning message at the same time.
> > 
> > Tried what Lv mentioned, increasing the early ioremap slots does help.
> 
> Could you send a tested patch to linux-acpi@vger.kermel.org for this?
> I think the number of early mapping slots need to be increased by 1 because of this case.

Problem is I do not understand the implementation detail yet.

I did below changes:

Original values:
#define NR_FIX_BTMAPS           64
#define FIX_BTMAPS_SLOTS        4

-> new values tested:
#define NR_FIX_BTMAPS           32
#define FIX_BTMAPS_SLOTS        8


There's below comments
        /*
         * 256 temporary boot-time mappings, used by early_ioremap(),
         * before ioremap() is functional.
         *
         * If necessary we round it up to the next 256 pages boundary so
         * that we can have a single pgd entry and a single pte table:
         */

So seems increase it to 64 * 8 = 512 should be ok. If it's fine I can test again
and post a patch.


Thanks
Dave
