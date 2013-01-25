From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] efivars write(2) races
Date: Fri, 25 Jan 2013 13:18:03 +0000
Message-ID: <1359119883.2496.156.camel@mfleming-mobl1.ger.corp.intel.com>
References: <20130125002552.GC4503@ZenIV.linux.org.uk>
	 <51020120.5000500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51020120.5000500-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-01-25 at 11:50 +0800, Lingzhu Xiang wrote:
> On 01/25/2013 08:25 AM, Al Viro wrote:
> > 	1) process A does write() on efivars file, reaches ->get_variable(),
> > gets newdatasize set, drops efivars->lock and loses CPU before an attempt to
> > grab ->i_mutex.  process B comes and does the same thing, replacing the
> > variable contents.  Then it grabs ->i_mutex, updates size, drops ->i_mutex
> > and buggers off.  At which point A gets CPU back and proceeds to set size
> > to whatever would be valid for its write.  Only the value is bogus now...
> 
> There are a few other things that makes size bogus now.
> 
> 1. truncate() never touches nvram but pretends to be changing size.

Good catch. Looks like we need to provide an implementation for this.

> 2. Empty files come back with non-zero size after remount. They are imported
>    from sysfs when mounting.

Eeek. The return value of get_variable() isn't checked in
efivarfs_fill_super().

> 3. Arguably reading empty files could just return empty instead of returning
>    EIO/EFI_NOT_FOUND from firmware. 

Yeah, I think Jeremy has a patch to fix this.

> 4. EFI_VARIABLE_APPEND_WRITE with EFI_OUT_OF_RESOURCES truncates size but you
>    can still read its content.

I'm not sure what you mean by this. Could you please explain?

Thanks for the feedback.
