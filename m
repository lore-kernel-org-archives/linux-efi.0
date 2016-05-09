From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 07/10] efi: load SSTDs from EFI variables
Date: Mon, 9 May 2016 12:59:09 +0300
Message-ID: <CAE1zotKgmr30rsTZCQTXuSsUTZybt41m0TJqQqJgTaZ0auSrPw@mail.gmail.com>
References: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
	<1461105548-20618-8-git-send-email-octavian.purdila@intel.com>
	<da0e65ef-7c04-e274-2f15-a50daa8c4c8c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <da0e65ef-7c04-e274-2f15-a50daa8c4c8c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-spi <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Irina Tirdea <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vincent Zimmer <vincent.zimmer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, May 9, 2016 at 7:13 AM, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Octavian,
>
> Apologies for missing this earlier, just catching up on this thread...

Hi Jon,

>
> On 04/19/2016 06:39 PM, Octavian Purdila wrote:
>
>> This patch allows SSDTs to be loaded from EFI variables. It works by
>> specifying the EFI variable name containing the SSDT to be loaded. All
>> variables with the same name (regardless of the vendor GUID) will be
>> loaded.
>
> This sounds very useful during development. However, and using EFI
> variables isn't so terrible, but I am concerned that this should be
> standardized through ASWG and at least involve certain other OS vendors
> so that the variable (GUID) can be captured somewhere. If not in the
> spec itself, then it should be captured as an external ACPI resource on
> the UEFI website with a clear pointer to the exact IDs to be used.
>
> Can you confirm that's the intention? i.e. that you're allowing a
> command line option for specifying the ID now because you intend to go
> ensure that there is a standard one that everyone will use later?
>

Yes, that is the intention. As I mentioned in the commit the long term
plan is to do the loading at the FW level (before the OS boots) using
the same mechanisms. But since this is going to take some time, I
think its worth having the option to do the loading from software for
two reason:

a) to provide a way for using this mechanism on older boards that will
not have the option to do a firmware update to get this functionality

b) to implement the software support needed in advance and have a way to test it

> I should check (but maybe you know) if the kernel is automatically
> tainted by this codepath as well?

In this version of the patch the kernel is tainted. However, note that
in future versions I intend to remove it because it was already
removed part of the initrd ACPI table upgrade patch [1].

[1] http://lkml.iu.edu/hypermail/linux/kernel/1604.1/01488.html
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
