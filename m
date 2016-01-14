From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v1 1/2] lib/string_helpers: export string_units_{2,10}
 for others
Date: Thu, 14 Jan 2016 15:44:06 +0000
Message-ID: <20160114154406.GC3602@codeblueprint.co.uk>
References: <1452604386-13673-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1452764705.2521.29.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452764705.2521.29.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 14 Jan, at 11:45:05AM, Andy Shevchenko wrote:
> On Tue, 2016-01-12 at 15:13 +0200, Andy Shevchenko wrote:
> > There is one user coming which would like to use those string arrays.
> > It might
> > be useful for any other user in the future.
> 
> Please, comment on the idea, but discard both patches, I'm cooking
> better approach.

I like this idea. I'm all for reusing existing code where possible.
