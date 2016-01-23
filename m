From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/4] x86/efi: use binary units when printing
Date: Sat, 23 Jan 2016 19:20:48 +0200
Message-ID: <CAHp75Vcq3tqFMhLqPr7Do5OC9aEqMikP8SpCf=WQ8CJZ_+C6rA@mail.gmail.com>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1453566877.2470.15.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453566877.2470.15.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Jan 23, 2016 at 6:34 PM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Sat, 2016-01-23 at 16:55 +0200, Andy Shevchenko wrote:
>> The patch series exports the arrays of binary and decimal units as
>> it's
>> described by IEC.
>>
>> First user of it is EFI code which would print sizes and other values
>> using
>> binary prefix.
>>
>> James, is this now okay to you?
>
> Patch 2 is still pointless. I happen to like the <tab><space>label:
> convention.

Even there it's just <space>label:

>  I realise others don't but an entire patch simply to
> change my convention to your convention is a bit overkill.

Main point of that patch is to bring snprintf() to one line. Is it
also your style?

-- 
With Best Regards,
Andy Shevchenko
