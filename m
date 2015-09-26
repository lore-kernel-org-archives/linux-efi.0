From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Sat, 26 Sep 2015 11:15:57 -0700
Message-ID: <CAKv+Gu8i4KuXYQZA5noTomj6-chZcuuDEQubOJznyP1DR=+VTw@mail.gmail.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
	<1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk>
	<20150926055643.GA25877@gmail.com>
	<CALCETrUeGAedCKcSCvedyooamr6-tyfb3-b3uYDZG+k3Q_v9rw@mail.gmail.com>
	<E40EBF14-FD9E-49C0-A7FB-951958F72F79@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E40EBF14-FD9E-49C0-A7FB-951958F72F79-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-wo1vFcy6AUs@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26 September 2015 at 10:20, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
> I think it "works" because the affected BIOSes don't put spaces between the chunks.  I have discussed this with Matt.
>

Forgive the ASCII art but perhaps an illustration might help:

before the 2.5 feature, PE/COFF runtime images were remapped as
illustrated here:

                                PA                        VA
+---------------+         +---------------+
|               |         |               |
| PE/COFF .text |         |    EFI        |
|               |         |    Runtime    |
+- - - - - - - -+    =>   |    Services   |----+
|               |         |    Code       |    |    :               :
| PE/COFF .data |         |               |    |    :               :
|               |         |               |    |    +---------------+
+---------------+         +---------------+    |    |               |
|               |         |               |    |    |    EFI        |
:               :         :               :    |    |    Runtime    |
:               :         :               :    +--->|    Services   |
|               |         |               |         |    Code       |
+---------------+         +---------------+         |               |
|               |         |               |         |               |
| PE/COFF .text |         |    EFI        |         +---------------+
|               |         |    Runtime    |         :      gap      :
+- - - - - - - -+    =>   |    Services   |---+     +---------------+
|               |         |    Code       |   |     |               |
| PE/COFF .data |         |               |   |     |    EFI        |
|               |         |               |   |     |    Runtime    |
+---------------+         +---------------+   +---->|    Services   |
|               |         |               |         |    Code       |
:               :         :               :         |               |
:               :         :               :         |               |
:               :         :               :         +---------------+
:               :         :               :         :               :

Since the affected symbol references only exist between PE/COFF .text
and PE/COFF .data, there is never a problem since each is PE/COFF
image is mapped as a single region.
However, with the new feature enabled, this no longer holds:
                                PA                        VA
+---------------+         +---------------+
|               |         |               |
| PE/COFF .text |         |    RtServices |----+
|               |         |    Code       |    |
+- - - - - - - -+    =>   +---------------+    |    +---------------+
|               |         |    RtServices |    +--->|    RtServices |
| PE/COFF .data |         |    Data       |         |    Code       |
|               |         |               |----+    +---------------+
+---------------+         +---------------+    |    :     gap       :
|               |         |               |    |    +---------------+
:               :         :               :    +--->|    RtServices |
:               :         :               :         |    Data       |
|               |         |               |         +---------------+
+---------------+         +---------------+         :     gap       :
|               |         |               |         +---------------+
| PE/COFF .text |         |    RtServices |-------->|    RtServices |
|               |         |    Code       |         |    Code       |
+- - - - - - - -+    =>   +---------------+         +---------------+
|               |         |    RtServices |         :     gap       :
| PE/COFF .data |         |    Data       |---+     +---------------+
|               |         |               |   |     |    RtServices |
+---------------+         +---------------+   +---->|    Data       |
|               |         |               |         |               |
:               :         :               :         +---------------+
:               :         :               :         :               :
:               :         :               :         :               :

The illustration uses gaps, but obviously, this applies equally to
inverting the mapping order, since the PE/COFF .text and .data
sections will end up out of order.

-- 
Ard.


> On September 26, 2015 10:01:14 AM PDT, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>On Fri, Sep 25, 2015 at 10:56 PM, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>>
>>> So this commit worries me.
>>>
>>> This bug is a good find, and the fix is obviously needed and urgent,
>>but I'm not
>>> sure about the implementation at all. (I've Cc:-ed a few more x86 low
>>level
>>> gents.)
>>>
>>> * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>>>> +             /*
>>>> +              * Starting in UEFI v2.5 the EFI_PROPERTIES_TABLE
>>>> +              * config table feature requires us to map all entries
>>>> +              * in the same order as they appear in the EFI memory
>>>> +              * map. That is to say, entry N must have a lower
>>>> +              * virtual address than entry N+1. This is because the
>>>> +              * firmware toolchain leaves relative references in
>>>> +              * the code/data sections, which are split and become
>>>> +              * separate EFI memory regions. Mapping things
>>>> +              * out-of-order leads to the firmware accessing
>>>> +              * unmapped addresses.
>>>> +              *
>>
>>I'm clearly missing something.  What is EFI doing that it doesn't care
>>how big the gap between sections is but it still requires them to be
>>in order?  It's not as though x86_64 has an addressing mode that
>>allows only non-negative offsets.
>>
>>--Andy
>
> --
> Sent from my Android device with K-9 Mail. Please excuse my brevity.
