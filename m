From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Wed, 30 Sep 2015 09:43:05 -0700
Message-ID: <CALCETrWCwuj1hmbGqXGs1vHG2Dk3aoOWD9Ve4gmXJ9S7jPUt-g@mail.gmail.com>
References: <CALCETrUeGAedCKcSCvedyooamr6-tyfb3-b3uYDZG+k3Q_v9rw@mail.gmail.com>
 <E40EBF14-FD9E-49C0-A7FB-951958F72F79@zytor.com> <CAKv+Gu8i4KuXYQZA5noTomj6-chZcuuDEQubOJznyP1DR=+VTw@mail.gmail.com>
 <0568D1D7-B6AA-437C-ADCE-A86D7A2E4722@zytor.com> <20150926195755.GC3144@codeblueprint.co.uk>
 <BFDFFBC6-C6CA-4035-8E29-C7220533A787@linaro.org> <F1F37F57-7D03-4FC2-955E-7E8C82540A24@zytor.com>
 <CALCETrUA6k-oHzuWA54VzEA1v63b5--JPCCuBoOxLisOtjUn+g@mail.gmail.com>
 <20150927180633.GA29466@srcf.ucam.org> <20150928061646.GA21690@gmail.com>
 <20150928064143.GA7380@srcf.ucam.org> <560B096D.6000303@redhat.com> <CAKv+Gu-enULj-OMRufB3OPSUVueM1843bD1CdFybaAS7xMUKgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-enULj-OMRufB3OPSUVueM1843bD1CdFybaAS7xMUKgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <JBottomley-wo1vFcy6AUs@public.gmane.org>, "Jordan Justen (Intel address)" <jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Sep 30, 2015 at 2:30 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 29 September 2015 at 23:58, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On 09/28/15 08:41, Matthew Garrett wrote:
>>> On Mon, Sep 28, 2015 at 08:16:46AM +0200, Ingo Molnar wrote:
>>>
>>>> So the question is, what does Windows do?
>>>
>>> It's pretty trivial to hack OVMF to dump the SetVirtualAddressMap()
>>> arguments to the qemu debug port. Unfortunately I'm about to drop
>>> mostly  offline for a week, otherwise I'd give it a go...
> [...]
>> Then I booted my Windows Server 2012 R2, Windows 8.1, and Windows 10
>> guests, with the properties table feature enabled vs. disabled in the
>> firmware. (All three Windows guests were updated first though.)
>>
>> All three Windows OSes adapt their SetVirtualAddressMap() calls, when
>> the feature is enabled in the firmware. However, Windows 8.1 crashes
>> nonetheless (BSOD, I forget the fault details, sorry). Windows Server
>> 2012 R2 and Windows 10 boot fine.
>>
>
> Looking at the log, it seems the VA mapping strategy is actually the
> same (i.e., bottom-up for Win10), and the difference can be explained
> by the differences in the memory map provided by the firmware to the
> OS. And indeed, the Win8.1 log shows the following:
>
>  # MemType Phys 0x  Virt 0x  Size 0x Attributes
> -- ------- -------- -------- ------- -------------------------------
>  0 RtData  7EC21000 FFBFA000 0006000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
>  1 RtCode  7EC27000 FFBF3000 0007000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
>  2 RtData  7EC2E000 FFBEC000 0007000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
>  3 RtData  7EC35000 FFBEB000 0001000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
>  4 RtCode  7EC36000 FFBE6000 0005000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
>  5 RtData  7EC3B000 FFBE4000 0002000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
>  6 RtData  7EC60000 FFBDE000 0006000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
>  7 RtCode  7EC66000 FFBD5000 0009000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
>  8 RtData  7EC6F000 FFBD3000 0002000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
>  9 RtData  7EC9E000 FFAFA000 00D9000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
> 10 RtCode  7ED77000 FFA63000 0097000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
> 11 RtData  7EE0E000 FFA58000 000B000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
> 12 RtData  7FE99000 FFA52000 0006000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
> 13 RtCode  7FE9F000 FFA4C000 0006000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
> 14 RtData  7FEA5000 FFA49000 0003000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
> 15 RtCode  7FEA8000 FFA42000 0007000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
> 16 RtData  7FEAF000 FFA3F000 0003000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
> 17 RtCode  7FEB2000 FFA36000 0009000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
> 18 RtData  7FEBB000 FFA33000 0003000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
> 19 RtCode  7FEBE000 FFA2A000 0009000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
> 20 RtData  7FEC7000 FFA04000 0026000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
> 21 RtData  7FFD0000 FF9E4000 0020000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
> 22 RtData  FFE00000 FF7E4000 0200000 [UC|  |  |  |  |XP|  |  |  |RT]
>
> I.e., the physical addresses increase while the virtual addresses
> decrease, and since each consecutive RuntimeCode/RuntimeData pair
> constitutes a PE/COFF image (.text and .data, respectively), the
> PE/COFF images appear corrupted in the virtual space.

All of this garbage makes me want to ask a rhetorical question:

Why on Earth did anyone think it's a good idea to invoke EFI functions
at CPL0 once the OS is booted?

And a more practical question:

Do we actually have to invoke EFI functions at CPL0?

I really mean it.  Sure, for things like reboot where we give up
control and don't get it back, we need to do that.  But for things
like variable access, the EFI code should really only need access to
EFI memor (with a known PA -> VA map) and the ability to trigger an
SMI.  Doing it at CPL3 could require more fixups than would really
make sense, but could we virtualize it instead?

Actually, CPL3 + IOPL3 just might work.

Heck, on mixed-mode, we're already invoke EFI functions in compat
mode, and that seems okay, so those functions can't be poking at any
CPU state that varies between long and 32-bit modes.

--Andy
