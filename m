From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 01/28] Include missing linux/slab.h inclusions [RFC]
Date: Tue, 16 Apr 2013 17:56:53 -0700
Message-ID: <20130417005653.GA11541@kroah.com>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
 <20130416182554.27773.86004.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130416182554.27773.86004.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 16, 2013 at 07:25:54PM +0100, David Howells wrote:
> Include missing linux/slab.h inclusions where the source file is currently
> expecting to get kmalloc() and co. through linux/proc_fs.h.
> 
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> cc: linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> cc: sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> cc: linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
> cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> ---
>

Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
