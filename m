From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 14/14] x86/efi: Print size in binary units in efi_print_memmap
Date: Wed, 3 Feb 2016 14:36:22 +0200
Message-ID: <CAHp75VexzDnXocGCwqv3ii_7_9UqspZEWCnMyyXMtwErD5Hd5A@mail.gmail.com>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
	<1454364428-494-15-git-send-email-matt@codeblueprint.co.uk>
	<56B0756E.9010603@redhat.com>
	<20160203104045.GB7310@gmail.com>
	<20160203112829.GC2597@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160203112829.GC2597@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>, Laszlo Ersek <lersek@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Robert Elliott <elliott@hpe.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 3, 2016 at 1:28 PM, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> On Wed, 03 Feb, at 11:40:45AM, Ingo Molnar wrote:
>>
>> So I kind of agree. Memory is almost never measured in marketing bytes, we should
>> simply output KB/MB/GB/TB/PB/EB like the rest of the memory management code does
>> and ignore all the 'i' silliness that infests storage sizes ...
>
> Thanks guys.
>
> OK, this patch has caused enough headaches. Let's drop it from this
> series.
>
> Robert, Andy, feel free to resubmit it after you've addressed
> everyone's concerns and we can discuss it in isolation.

Personally I gave up to promote standards. I have started with KB, MB,
etc, but I like that eventually we have a distinct standard for binary
vs. decimal units.

-- 
With Best Regards,
Andy Shevchenko
