From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in efi_print_memmap
Date: Mon, 25 Jan 2016 22:01:11 +0200
Message-ID: <CAHp75VeXHoyOgFSb4vzWBmELH_yJx1mSN+quxue=tSZCh5sTXw@mail.gmail.com>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1453560913-134672-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<1453567445.2470.24.camel@HansenPartnership.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BF3B840@G9W0745.americas.hpqcorp.net>
	<1453748172.2363.36.camel@HansenPartnership.com>
	<CAHp75VdYRzC9TcDpKxq=xddA0zgVk=5_25uXaimn1tOMZVeK4Q@mail.gmail.com>
	<1453751131.2363.54.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453751131.2363.54.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 25, 2016 at 9:45 PM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Mon, 2016-01-25 at 21:28 +0200, Andy Shevchenko wrote:
>> On Mon, Jan 25, 2016 at 8:56 PM, James Bottomley
>> <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>> > On Mon, 2016-01-25 at 18:02 +0000, Elliott, Robert (Persistent
>> > Memory)
>> > wrote:
>>
>> >  Using ffs leads to precision runaway
>>
>> How exactly?!
>
> Off by one.  A size of 0xffffffffffffffff prints 18446744073709551615=
 B
> rather than 20 GiB.

Because it's not a 20 GiB. It's exactly 20 GiB - 1 B.

AFAIU, the intention was to show _exact_ size.

>> It's good you are doing this better, but I still vote for __ffs64(),
>> since it would be faster on binary units.
>
> Is speed of a start of day print a particular concern?

If it's cheap to do, why not to do?

>> Also, in one version I tried to convert couple of other users which
>> are using only KM (in general whatever range it would be) units. Any
>> ideas how to modify to support them?
>
> You mean units in odd increments of 6 digits (so K, M, T ...)? no.  T=
he
> logarithmic reduction is done to the base of the unit increment (1000
> or 1024) so it doesn't really fit this case and it would be hard to
> adjust because we don't have enough precision in the remainder.
>  However, unless there's a huge need to keep it, I'd just fit to the
> closest 3 digit increment and then everything would work.

KM case:
K) if 1 MiB > value >=3D 0 =E2=80=94 prints in KiB
M) if =E2=88=9E > value >=3D 1 MiB =E2=80=94 prints in MiB.

--=20
With Best Regards,
Andy Shevchenko
