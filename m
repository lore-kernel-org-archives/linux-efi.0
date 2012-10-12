From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] efivarfs: efivarfs_create() ensure we drop our
 reference on inode on error
Date: Fri, 12 Oct 2012 20:21:33 +0100
Message-ID: <1350069693.15966.591.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1349416496.810727.310563927016.1.gpush@pecola>
	 <1349951541-20498-1-git-send-email-apw@canonical.com>
	 <1349951541-20498-3-git-send-email-apw@canonical.com>
	 <1350068629.7065.58.camel@rhapsody>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350068629.7065.58.camel@rhapsody>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Khalid Aziz <khalid-21RPF02GE+GXwddmVfQv5g@public.gmane.org>
Cc: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 2012-10-12 at 13:03 -0600, Khalid Aziz wrote:
> This does not read right. If kzalloc() fails, var will be a NULL
> pointer. This code will set err to -ENOMEM and jump to out: where since
> err is non-zero, this code will call kfree(Var) but var is a NULL
> pointer at this point. Now kfree() does check for NULL pointer and this
> will not cause any serious problems but why call kfree for a NULL
> pointer?

This is a common idiom used throughout the kernel to simply error paths.
As you noted, calling kfree(NULL) is harmless and there's certainly no
need to worry about the overhead of calling kfree() without doing any
freeing since the error path is also the slow path.

--
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
