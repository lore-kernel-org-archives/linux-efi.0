From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 02/10] acpi: install SSDT tables from initrd
Date: Mon, 4 Apr 2016 16:07:31 +0300
Message-ID: <CAE1zotLX8L=jpJRYtUddtpYmgc0NxqmtdDjcQPWWg8KTO8PH5A@mail.gmail.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
	<1459417026-6697-3-git-send-email-octavian.purdila@intel.com>
	<1AE640813FDE7649BE1B193DEA596E883BB66258@SHSMSX101.ccr.corp.intel.com>
	<CAE1zotJ1fa4m-_FO3PUQK8_p0vHcfWD5TmuMdxOSHDjku421pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE1zotJ1fa4m-_FO3PUQK8_p0vHcfWD5TmuMdxOSHDjku421pA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zheng, Lv" <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Tirdea, Irina" <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 1, 2016 at 1:11 PM, Octavian Purdila
<octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, Apr 1, 2016 at 8:05 AM, Zheng, Lv <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> Hi,
>>
>> IMO, there is already a similar function upstreamed:
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=c85cc81
>> Could it work for your use case?
>
> Yes, it is basically the same.
>
> The only difference is on how we handle taint. I think we should use a
> new taint for overlays and that we don't need to disable lockdep.
>
> BTW, why is lockdep disabled when we override?

The other thing I forgot to mention is that I think we should allow
installing new tables even if CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not
selected. IMO the override and overlay functionality is different,
with the latter being more then a debug option.

I will prepare a patch for the next version of the series to decouple
installing new tables from CONFIG_ACPI_INITRD_TABLE_OVERRIDE.
