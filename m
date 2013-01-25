From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] efivars write(2) races
Date: Fri, 25 Jan 2013 11:50:56 +0800
Message-ID: <51020120.5000500@redhat.com>
References: <20130125002552.GC4503@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130125002552.GC4503-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/25/2013 08:25 AM, Al Viro wrote:
> 	1) process A does write() on efivars file, reaches ->get_variable(),
> gets newdatasize set, drops efivars->lock and loses CPU before an attempt to
> grab ->i_mutex.  process B comes and does the same thing, replacing the
> variable contents.  Then it grabs ->i_mutex, updates size, drops ->i_mutex
> and buggers off.  At which point A gets CPU back and proceeds to set size
> to whatever would be valid for its write.  Only the value is bogus now...

There are a few other things that makes size bogus now.

1. truncate() never touches nvram but pretends to be changing size.

2. Empty files come back with non-zero size after remount. They are imported
   from sysfs when mounting.

3. Arguably reading empty files could just return empty instead of returning
   EIO/EFI_NOT_FOUND from firmware. 

4. EFI_VARIABLE_APPEND_WRITE with EFI_OUT_OF_RESOURCES truncates size but you
   can still read its content.
