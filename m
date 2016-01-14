From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 1/2] lib/string_helpers: export string_units_{2,10} for others
Date: Fri, 15 Jan 2016 00:35:20 +0200
Message-ID: <CAHp75Ve9RK9wwwZ+XLtCPe9wzJXMWXkkcjDue4AoP5kwaZz=2A@mail.gmail.com>
References: <1452604386-13673-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1452764705.2521.29.camel@linux.intel.com>
	<20160114154406.GC3602@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160114154406.GC3602-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jan 14, 2016 at 5:44 PM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Thu, 14 Jan, at 11:45:05AM, Andy Shevchenko wrote:
>> On Tue, 2016-01-12 at 15:13 +0200, Andy Shevchenko wrote:
>> > There is one user coming which would like to use those string arrays.
>> > It might
>> > be useful for any other user in the future.
>>
>> Please, comment on the idea, but discard both patches, I'm cooking
>> better approach.
>
> I like this idea. I'm all for reusing existing code where possible.

Just sent v2.

-- 
With Best Regards,
Andy Shevchenko
