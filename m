From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2 16/20] efivarfs: Return an error if we fail to read a
 variable
Date: Fri, 11 Jan 2013 13:24:12 +0000
Message-ID: <1357910652.8203.314.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	  <1351237923-10313-17-git-send-email-matt@console-pimps.org>
	 <1351846434.14888.157.camel@mfleming-mobl1.ger.corp.intel.com>
	 <50D40ADF.4050700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50D40ADF.4050700-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2012-12-21 at 15:08 +0800, Lingzhu Xiang wrote:
> On 11/02/2012 04:53 PM, Matt Fleming wrote:
> > Instead of always returning 0 in efivarfs_file_read(), even when we
> > fail to successfully read the variable, convert the EFI status to
> > something meaningful and return that to the caller. This way the user
> > will have some hint as to why the read failed.
> > ...
> >
> > +	case EFI_NOT_FOUND:
> > +		err = -ENOENT;
> 
> This will be ambiguous for userspace. Is it file not being found by
> efivarfs or by firmware?
> 
> Actually I've been confused during testing like this:
> 
> # ll test-12341234-1234-1234-1234-123412341234
> ls: cannot access test-12341234-1234-1234-1234-123412341234: No such 
> file or directory
> # echo -en "\0\0\0\0a" >test-12341234-1234-1234-1234-123412341234
> -bash: echo: write error: No such file or directory
> # ll test-12341234-1234-1234-1234-123412341234
> -rw-r--r--. 1 root root 0 Dec 21 06:19 
> test-12341234-1234-1234-1234-123412341234

Yeah, this file shouldn't exist. I'm working on a patch. Thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
