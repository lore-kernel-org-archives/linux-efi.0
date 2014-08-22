From: Dave Young <dyoung@redhat.com>
Subject: Re: kernel boot fail with efi earlyprintk (bisected)
Date: Fri, 22 Aug 2014 18:02:58 +0800
Message-ID: <20140822100258.GA1877@darkstar.nay.redhat.com>
References: <20140819081658.GA1795@darkstar.nay.redhat.com>
 <20140821205224.GJ29733@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140821205224.GJ29733@console-pimps.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: lv.zheng@intel.com, matt.fleming@intel.com, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, devel@acpica.org, lenb@kernel.org, rafael.j.wysocki@intel.com, robert.moore@intel.com
List-Id: linux-efi@vger.kernel.org

On 08/21/14 at 09:52pm, Matt Fleming wrote:
> On Tue, 19 Aug, at 04:16:58PM, Dave Young wrote:
> > Hi,
> > 
> > 3.16 kernel boot fail with earlyprintk=efi on my laptop.
> > It keeps scrolling at the bottom line of screen.
> > 
> > Bisected, the first bad commit is below:
> > commit 86dfc6f339886559d80ee0d4bd20fe5ee90450f0
> > Author: Lv Zheng <lv.zheng@intel.com>
> > Date:   Fri Apr 4 12:38:57 2014 +0800
> > 
> >     ACPICA: Tables: Fix table checksums verification before installation.
> > 
> > 
> > I did some debugging by enabling both serial and efi earlyprintk, below is
> > some debug dmesg, seems early_ioremap fails in scroll up function due to
> > no free slot, but I'm still not sure if the debug info is right or not.
> 
> Thanks Dave, your callstack seems to make sense.
> 
> Can you also enable early_ioremap_debug so that we can figure out where
> all the FIXMAP slots are going?

With early_ioremap_debug enabled, there will be a lot of "dropped printk", so
I can not get any useful information.

Will try to do more debug.

Thanks
Dave
