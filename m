From: Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: sysfs: cannot create duplicate filename
Date: Tue, 12 Mar 2013 14:20:34 +0100
Message-ID: <CAHsu+b_Yn-1FJnp+xH-RG9-KSZ+H93ffQOTtH26mmryM=fDAtg@mail.gmail.com>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>
	<5135BD66.1030005@redhat.com>
	<1362755479.15011.238.camel@mfleming-mobl1.ger.corp.intel.com>
	<513A2B29.8090705@redhat.com>
	<1363082900.15011.257.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363082900.15011.257.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 12, 2013 at 11:08 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Date: Thu, 7 Mar 2013 11:59:14 +0000
> Subject: [PATCH v2] efivars: Handle duplicate names from get_next_variable()
>
> Some firmware exhibits a bug where the same VariableName and
> VendorGuid values are returned on multiple invocations of
> GetNextVariableName(). See,
>
>     https://bugzilla.kernel.org/show_bug.cgi?id=47631
>
> As a consequence of such a bug, Andre reports hitting the following
> WARN_ON() in the sysfs code after updating the BIOS on his, "Gigabyte
> Technology Co., Ltd. To be filled by O.E.M./Z77X-UD3H, BIOS F19e
> 11/21/2012)" machine,

Thanks for working on this, Matt.

Unfortunately I cannot test this patch anymore... This BIOS seems
beyond buggy, and today I didn't get anything on screen, it didn't
boot anything nor could I even enter it.
The only thing to make this box usable again was to hit the CMOS reset
button, and since then I do not get the WARN_ON() anymore. Seems like
the duplicate entry was an artifact of a BIOS upgrade with old CMOS
settings.

Thanks,
Andre
