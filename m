From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] efi: esrt: use memremap not ioremap to access ESRT
 table in memory
Date: Wed, 18 May 2016 10:36:33 +0200
Message-ID: <CAKv+Gu_ekP+44FJjR7BY_MFqx2jQgc6Tk9W4SBL__ttdvQ55VQ@mail.gmail.com>
References: <20160218104407.GC2651@codeblueprint.co.uk>
	<CAKv+Gu_AW7PKJJOd2mbEu3LKJe+gNaPHnH=sgO=YXM_KWFyKxw@mail.gmail.com>
	<20160218132824.GE2651@codeblueprint.co.uk>
	<CAKv+Gu-s1pzYBzuDG-Z7s3gyo8dPOfeidZQ+rim-uAWZCBcKQQ@mail.gmail.com>
	<20160218134324.GG2651@codeblueprint.co.uk>
	<CAKv+Gu875r9RkDC723kNsG4XC0eSE9RPPmSFZrD0sx0QxS+V4g@mail.gmail.com>
	<20160218141544.GH2651@codeblueprint.co.uk>
	<20160218191624.GA1515@redhat.com>
	<20160226144114.GA7475@codeblueprint.co.uk>
	<20160301233040.GA31476@codeblueprint.co.uk>
	<20160304062524.GA19010@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160304062524.GA19010-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Prakhya, Sai Praneeth" <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 4 March 2016 at 07:25, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> I have a very rough draft of patches that implement this strategy on
>> the 'experiemntal/efi-memmap' branch in the EFI tree if anyone is
>> curious and wants to take a look. The series will be sent out soon.
>>
>> I wouldn't necessarily try running them or anything as there's a few
>> things that I know are broken; ia64 build, EFI mixed mode boot,
>> probably arm64 regressions.
>
> Matt, I tried :). I see a build warning about print phys_addr_t without
> %pa anotation and booting with ioremap error messages about slot not found
> , and ioremap region leak messages.
>
> Looking forward to your formal posts.
>

So what is the status here? I know Sai is working on x86 support for
the memory attributes table, so it would make sense settle this matter
as well.
