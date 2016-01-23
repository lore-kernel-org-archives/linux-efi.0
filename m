From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/4] lib/string_helpers: export string_units_{2,10} for others
Date: Sat, 23 Jan 2016 13:50:57 +0200
Message-ID: <CAHp75VccqJa5YYQLbd2bow962Nw+Z410SVDiv3mkc+WqcsmOrQ@mail.gmail.com>
References: <1453389752-68175-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1453525999.2339.56.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453525999.2339.56.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Jan 23, 2016 at 7:13 AM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Thu, 2016-01-21 at 17:22 +0200, Andy Shevchenko wrote:
>> There is one user coming which would like to use those string arrays.
>> It might
>> be useful for any other user in the future.
>
> Well, let's not do it until we have an actual consumer because that
> will help us get the interface correct.

First consumer is in patch 3.

>> +#define STRING_UNITS_10_NUM  9
>> +#define STRING_UNITS_2_NUM   9
>> +
>> +extern const char *const string_units_10[STRING_UNITS_10_NUM];
>> +extern const char *const string_units_2[STRING_UNITS_2_NUM];
>> +

>> --- a/lib/string_helpers.c
>> +++ b/lib/string_helpers.c
>> @@ -13,6 +13,15 @@
>>  #include <linux/string.h>
>>  #include <linux/string_helpers.h>
>>
>> +const char * const string_units_10[STRING_UNITS_10_NUM] = {
>> +     "B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB",
>> +};
>> +EXPORT_SYMBOL(string_units_10);
>> +const char * const string_units_2[STRING_UNITS_2_NUM] = {
>> +     "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB",
>> +};
>> +EXPORT_SYMBOL(string_units_2);
>> +
>
> This is a pretty silly thing to do; how does someone who adds a unit to
> one of the string_units know to increment STRING_UNITS_X_NUM?  Even if
> you add a comment admonishing them to do it, it's far better to have
> this calculated at compile time like it was before this patch.

Okay, I will think how to do that.

-- 
With Best Regards,
Andy Shevchenko
