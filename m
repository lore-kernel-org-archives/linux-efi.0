From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 4/4] x86/efi: print size and base in binary units in
 efi_print_memmap
Date: Fri, 8 Jan 2016 12:19:21 +0000
Message-ID: <20160108121921.GI2532@codeblueprint.co.uk>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
 <1450402114-3606-5-git-send-email-elliott@hpe.com>
 <20151221161629.GG4227@codeblueprint.co.uk>
 <CAHp75VffR6FO=s5JeVPUPepVRyn-mwXF=juf+y1j44J69i3RKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHp75VffR6FO=s5JeVPUPepVRyn-mwXF=juf+y1j44J69i3RKw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Robert Elliott <elliott@hpe.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, linux-efi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 27 Dec, at 04:35:12PM, Andy Shevchenko wrote:
> On Mon, Dec 21, 2015 at 6:16 PM, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> >> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> >> index 635a955..030ba91 100644
> >> --- a/arch/x86/platform/efi/efi.c
> >> +++ b/arch/x86/platform/efi/efi.c
> >> @@ -222,6 +222,25 @@ int __init efi_memblock_x86_reserve_range(void)
> >>       return 0;
> >>  }
> >>
> >> +char * __init efi_size_format(char *buf, size_t size, u64 bytes)
> >> +{
> >> +     if (!bytes || (bytes & 0x3ff))
> >> +             snprintf(buf, size, "%llu B", bytes);
> >> +     else if (bytes & 0xfffff)
> >> +             snprintf(buf, size, "%llu KiB", bytes >> 10);
> >> +     else if (bytes & 0x3fffffff)
> >> +             snprintf(buf, size, "%llu MiB", bytes >> 20);
> >> +     else if (bytes & 0xffffffffff)
> >> +             snprintf(buf, size, "%llu GiB", bytes >> 30);
> >> +     else if (bytes & 0x3ffffffffffff)
> >> +             snprintf(buf, size, "%llu TiB", bytes >> 40);
> >> +     else if (bytes & 0xfffffffffffffff)
> >> +             snprintf(buf, size, "%llu PiB", bytes >> 50);
> >> +     else
> >> +             snprintf(buf, size, "%llu EiB", bytes >> 60);
> >> +     return buf;
> 
> For me it looks like ffs with name in the table can be used.

Could you provide a patch?
