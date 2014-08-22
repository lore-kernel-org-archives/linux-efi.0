From: "Zheng, Lv" <lv.zheng@intel.com>
Subject: RE: kernel boot fail with efi earlyprintk (bisected)
Date: Fri, 22 Aug 2014 01:43:15 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880265EF49@SHSMSX101.ccr.corp.intel.com>
References: <20140819081658.GA1795@darkstar.nay.redhat.com>
 <20140821205224.GJ29733@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20140821205224.GJ29733@console-pimps.org>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>, Dave Young <dyoung@redhat.com>
Cc: "Fleming, Matt" <matt.fleming@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@acpica.org" <devel@acpica.org>, "lenb@kernel.org" <lenb@kernel.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Moore, Robert" <robert.moore@intel.com>
List-Id: linux-efi@vger.kernel.org

Hi,

There is only limited entries in the x86 early mapping which is implemented by the FIXMAP.
So this means for all __init call invoked for x86, if there was a early mapping in it, it should be unmapped before exiting the __init call.

Using this rule, all __init call implementers can make sure that before entering the __init call, the limited number of FIXMAP entries is enough.

The following bisected commit just increase early mapping times from 1 to 2 in ACPICA early table handling code.
The number of 2 is less than the number of available FIXMAP entries.
And ACPICA code has ensured that all mappings are correctly unmapped after the table initialization.
So we didn't break the rule.

We can offer a workaround in ACPICA to reduce mapping count from 2 to 1 using a global option.
But since this report sounds like that the root cause is earlyprintk=efi has broken the above rule and the existing issue is triggered by this cleanup.
So could someone check the earlyprintk=efi code first?
I think earlyprintk=efi should either unmap the increased mapping or increase the number of FIXMAP entries in case earlyprintk=efi need additional early mappings.
Otherwise it will always be chances for earlyprintk=efi to break future code.

Thanks and best regards
-Lv

> From: Matt Fleming [mailto:matt@console-pimps.org]
> Sent: Friday, August 22, 2014 4:52 AM
> 
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
> 
> --
> Matt Fleming, Intel Open Source Technology Center
