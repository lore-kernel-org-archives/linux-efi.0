From: hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Subject: Re: [RFC PATCH] x86: Config options to assign versions in the PE-COFF header
Date: Thu, 13 Apr 2017 22:17:40 -0700
Message-ID: <AB30E497-A973-4303-9C85-C44BB3CDD9A7@zytor.com>
References: <20170411102041.19771-1-glin@suse.com> <8E544119-66B8-4482-BBE9-68B6C7A3AAE9@zytor.com> <20170414035119.v2kjxcsuauj3bdj2@GaryWorkstation>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170414035119.v2kjxcsuauj3bdj2@GaryWorkstation>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gary Lin <glin-IBi9RG/b67k@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Michal Marek <mmarek-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Joey Lee <jlee-IBi9RG/b67k@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On April 13, 2017 8:51:19 PM PDT, Gary Lin <glin-IBi9RG/b67k@public.gmane.org> wrote:
>On Thu, Apr 13, 2017 at 03:21:20PM -0700, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org wrote:
>> On April 11, 2017 3:20:41 AM PDT, Gary Lin <glin-IBi9RG/b67k@public.gmane.org> wrote:
>> >This commit adds the new config options to allow the user to modify
>the
>> >following fields in the PE-COFF header.
>> >
>> >UINT16 MajorOperatingSystemVersion
>> >UINT16 MinorOperatingSystemVersion
>> >UINT16 MajorImageVersion
>> >UINT16 MinorImageVersion
>> >
>> >Those fields are mainly for the executables or libraries in Windows
>NT
>> >or higher to specify the minimum supported Windows version and the
>> >version of the image itself.
>> >
>> >Given the fact that those fields are ignored in UEFI, we can safely
>> >reuse
>> >those fields for other purposes, e.g. Security Version(*).
>> >
>> >(*) https://github.com/lcp/shim/wiki/Security-Version
>> >
>> >Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>> >Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
>> >Cc: Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>
>> >Cc: Michal Marek <mmarek-IBi9RG/b67k@public.gmane.org>
>> >Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>> >Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> >Cc: Joey Lee <jlee-IBi9RG/b67k@public.gmane.org>
>> >Cc: Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>
>> >Signed-off-by: Gary Lin <glin-IBi9RG/b67k@public.gmane.org>
>> >Tested-by: Joey Lee <jlee-IBi9RG/b67k@public.gmane.org>
>> >---
>[snip]
>> 
>> Reusing PECOFF fields seems doubleplusunsafe: we don't own those
>fields, the UEFI forum does.  It would make a lot more sense to add
>these fields to the bzImage header directly or indirectly (via a
>pointer), the latter would be more economical since the bzImage header
>size is bounded.
>> 
>> We could even define it as a pointer to a "security information
>header" with its own size field, so it can be grown in the future as
>needed.
>Reusing PE-COFF simplifies the implementation since shim can parse the
>header directly. I can raise the issue to the UEFI forum to clarify the
>usage of those fields.
>
>Meanwhile, I'll also look into the bzImage header in case the PE-COFF
>header is really a NO-GO.
>
>Thanks,
>
>Gary Lin

If we are going to use the PE-COFF hear then you need to write a proposal and get the UEFI forum to sign off on it.
-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
