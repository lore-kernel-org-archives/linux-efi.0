From: Steven Noonan <steven-Cunn4gMjHvbm+q05EWxUEA@public.gmane.org>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Date: Tue, 29 Jul 2014 20:25:41 -0700
Message-ID: <CAKbGBLi-6koxxQUDsn+KyO47nfCbOwFSnPgbDZGZ1Bnt=c5qKA@mail.gmail.com>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com>
	<20140729222932.GA17481@pd.tnic>
	<53D82118.6090202@redhat.com>
	<20140729223603.GC17241@pd.tnic>
	<53D82623.4080903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53D82623.4080903-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux Kernel mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linux-X86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 29, 2014 at 3:54 PM, Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>
> On 07/29/2014 06:36 PM, Borislav Petkov wrote:
>> On Tue, Jul 29, 2014 at 06:32:56PM -0400, Prarit Bhargava wrote:
>>> and it was best to keep the code simple with a KiB.
>>
>> You're missing the point - the output doesn't get simple with KiB. Read
>> the example I just gave you!
>>
>> (13893632kiB) is actively *not* helping when one looks at it!
>
> I did get your point and I'm (politely) disagreeing with it.  Your case ONLY
> works if the number is _exactly_ 13GB.  What if it is 13.5?  Then we're still
> rounding off and reporting 14GB.  Which, if this code is meant for debug, makes
> no sense to me.  Why round it off?
>

I think if it was being represented in procfs or sysfs, we'd need to
be extremely specific to make it machine-readable, but for a
human-readable printk, it makes sense to me to print it in the smaller
unit size until the value is in tens of the next higher unit size
(e.g. print in KiB until 10+MiB, print in MiB until 10+GiB).
