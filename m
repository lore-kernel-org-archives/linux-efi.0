From: Matt Fleming <matt@console-pimps.org>
Subject: Re: kernel boot fail with efi earlyprintk (bisected)
Date: Mon, 25 Aug 2014 12:16:53 +0100
Message-ID: <20140825111653.GR29733@console-pimps.org>
References: <20140819081658.GA1795@darkstar.nay.redhat.com>
 <20140821205224.GJ29733@console-pimps.org>
 <20140822100258.GA1877@darkstar.nay.redhat.com>
 <20140825060713.GA4011@darkstar.nay.redhat.com>
 <1AE640813FDE7649BE1B193DEA596E880265F57B@SHSMSX101.ccr.corp.intel.com>
 <20140825090619.GA3202@darkstar.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140825090619.GA3202@darkstar.nay.redhat.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: "Zheng, Lv" <lv.zheng@intel.com>, "Fleming, Matt" <matt.fleming@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@acpica.org" <devel@acpica.org>, "lenb@kernel.org" <lenb@kernel.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Moore, Robert" <robert.moore@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 25 Aug, at 05:06:19PM, Dave Young wrote:
> 
> Problem is I do not understand the implementation detail yet.
> 
> I did below changes:
> 
> Original values:
> #define NR_FIX_BTMAPS           64
> #define FIX_BTMAPS_SLOTS        4
> 
> -> new values tested:
> #define NR_FIX_BTMAPS           32
> #define FIX_BTMAPS_SLOTS        8
> 
> 
> There's below comments
>         /*
>          * 256 temporary boot-time mappings, used by early_ioremap(),
>          * before ioremap() is functional.
>          *
>          * If necessary we round it up to the next 256 pages boundary so
>          * that we can have a single pgd entry and a single pte table:
>          */
> 
> So seems increase it to 64 * 8 = 512 should be ok. If it's fine I can test again
> and post a patch.

Make sure you include the x86 maintainers on Cc if you change these
values.

-- 
Matt Fleming, Intel Open Source Technology Center
