From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] x86/efi: print size and base in binary units in efi_print_memmap
Date: Fri, 8 Jan 2016 18:39:28 +0200
Message-ID: <CAHp75VcJ_gDs-Y3SO2Z7BRqPCwKXntBiW6UDF38Di5m5_HszWQ@mail.gmail.com>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
	<1450402114-3606-5-git-send-email-elliott@hpe.com>
	<20151221161629.GG4227@codeblueprint.co.uk>
	<CAHp75VffR6FO=s5JeVPUPepVRyn-mwXF=juf+y1j44J69i3RKw@mail.gmail.com>
	<20160108121921.GI2532@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160108121921.GI2532-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 8, 2016 at 2:19 PM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Sun, 27 Dec, at 04:35:12PM, Andy Shevchenko wrote:
>> On Mon, Dec 21, 2015 at 6:16 PM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>> >> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
>> >> index 635a955..030ba91 100644
>> >> --- a/arch/x86/platform/efi/efi.c
>> >> +++ b/arch/x86/platform/efi/efi.c
>> >> @@ -222,6 +222,25 @@ int __init efi_memblock_x86_reserve_range(void)
>> >>       return 0;
>> >>  }
>> >>
>> >> +char * __init efi_size_format(char *buf, size_t size, u64 bytes)
>> >> +{
>> >> +     if (!bytes || (bytes & 0x3ff))
>> >> +             snprintf(buf, size, "%llu B", bytes);
>> >> +     else if (bytes & 0xfffff)
>> >> +             snprintf(buf, size, "%llu KiB", bytes >> 10);
>> >> +     else if (bytes & 0x3fffffff)
>> >> +             snprintf(buf, size, "%llu MiB", bytes >> 20);
>> >> +     else if (bytes & 0xffffffffff)
>> >> +             snprintf(buf, size, "%llu GiB", bytes >> 30);
>> >> +     else if (bytes & 0x3ffffffffffff)
>> >> +             snprintf(buf, size, "%llu TiB", bytes >> 40);
>> >> +     else if (bytes & 0xfffffffffffffff)
>> >> +             snprintf(buf, size, "%llu PiB", bytes >> 50);
>> >> +     else
>> >> +             snprintf(buf, size, "%llu EiB", bytes >> 60);
>> >> +     return buf;
>>
>> For me it looks like ffs with name in the table can be used.
>
> Could you provide a patch?

I will prepare something this weekend, or latest next week.

I suppose I can apply Robert's one on top of your efi/next and update it, right?

-- 
With Best Regards,
Andy Shevchenko
