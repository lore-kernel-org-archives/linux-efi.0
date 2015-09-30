From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Wed, 30 Sep 2015 11:30:44 +0200
Message-ID: <CAKv+Gu-enULj-OMRufB3OPSUVueM1843bD1CdFybaAS7xMUKgw@mail.gmail.com>
References: <CALCETrUeGAedCKcSCvedyooamr6-tyfb3-b3uYDZG+k3Q_v9rw@mail.gmail.com>
	<E40EBF14-FD9E-49C0-A7FB-951958F72F79@zytor.com>
	<CAKv+Gu8i4KuXYQZA5noTomj6-chZcuuDEQubOJznyP1DR=+VTw@mail.gmail.com>
	<0568D1D7-B6AA-437C-ADCE-A86D7A2E4722@zytor.com>
	<20150926195755.GC3144@codeblueprint.co.uk>
	<BFDFFBC6-C6CA-4035-8E29-C7220533A787@linaro.org>
	<F1F37F57-7D03-4FC2-955E-7E8C82540A24@zytor.com>
	<CALCETrUA6k-oHzuWA54VzEA1v63b5--JPCCuBoOxLisOtjUn+g@mail.gmail.com>
	<20150927180633.GA29466@srcf.ucam.org>
	<20150928061646.GA21690@gmail.com>
	<20150928064143.GA7380@srcf.ucam.org>
	<560B096D.6000303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <560B096D.6000303@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Laszlo Ersek <lersek@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Denys Vlasenko <dvlasenk@redhat.com>, Leif Lindholm <leif.lindholm@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, stable <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Brian Gerst <brgerst@gmail.com>, Dave Young <dyoung@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>, "Lee, Chun-Yi" <jlee@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@odin.com>, "Jordan Justen (Intel address)" <jordan.l.justen@intel.com>
List-Id: linux-efi@vger.kernel.org

On 29 September 2015 at 23:58, Laszlo Ersek <lersek@redhat.com> wrote:
> On 09/28/15 08:41, Matthew Garrett wrote:
>> On Mon, Sep 28, 2015 at 08:16:46AM +0200, Ingo Molnar wrote:
>>
>>> So the question is, what does Windows do?
>>
>> It's pretty trivial to hack OVMF to dump the SetVirtualAddressMap()
>> arguments to the qemu debug port. Unfortunately I'm about to drop
>> mostly  offline for a week, otherwise I'd give it a go...
[...]
> Then I booted my Windows Server 2012 R2, Windows 8.1, and Windows 10
> guests, with the properties table feature enabled vs. disabled in the
> firmware. (All three Windows guests were updated first though.)
>
> All three Windows OSes adapt their SetVirtualAddressMap() calls, when
> the feature is enabled in the firmware. However, Windows 8.1 crashes
> nonetheless (BSOD, I forget the fault details, sorry). Windows Server
> 2012 R2 and Windows 10 boot fine.
>

Looking at the log, it seems the VA mapping strategy is actually the
same (i.e., bottom-up for Win10), and the difference can be explained
by the differences in the memory map provided by the firmware to the
OS. And indeed, the Win8.1 log shows the following:

 # MemType Phys 0x  Virt 0x  Size 0x Attributes
-- ------- -------- -------- ------- -------------------------------
 0 RtData  7EC21000 FFBFA000 0006000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
 1 RtCode  7EC27000 FFBF3000 0007000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
 2 RtData  7EC2E000 FFBEC000 0007000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
 3 RtData  7EC35000 FFBEB000 0001000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
 4 RtCode  7EC36000 FFBE6000 0005000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
 5 RtData  7EC3B000 FFBE4000 0002000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
 6 RtData  7EC60000 FFBDE000 0006000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
 7 RtCode  7EC66000 FFBD5000 0009000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
 8 RtData  7EC6F000 FFBD3000 0002000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
 9 RtData  7EC9E000 FFAFA000 00D9000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
10 RtCode  7ED77000 FFA63000 0097000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
11 RtData  7EE0E000 FFA58000 000B000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
12 RtData  7FE99000 FFA52000 0006000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
13 RtCode  7FE9F000 FFA4C000 0006000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
14 RtData  7FEA5000 FFA49000 0003000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
15 RtCode  7FEA8000 FFA42000 0007000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
16 RtData  7FEAF000 FFA3F000 0003000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
17 RtCode  7FEB2000 FFA36000 0009000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
18 RtData  7FEBB000 FFA33000 0003000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
19 RtCode  7FEBE000 FFA2A000 0009000 [UC|WC|WT|WB|  |  |RO|  |  |RT]
20 RtData  7FEC7000 FFA04000 0026000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
21 RtData  7FFD0000 FF9E4000 0020000 [UC|WC|WT|WB|  |XP|  |  |  |RT]
22 RtData  FFE00000 FF7E4000 0200000 [UC|  |  |  |  |XP|  |  |  |RT]

I.e., the physical addresses increase while the virtual addresses
decrease, and since each consecutive RuntimeCode/RuntimeData pair
constitutes a PE/COFF image (.text and .data, respectively), the
PE/COFF images appear corrupted in the virtual space.

> I uploaded the verbose OVMF log files from all six guest boots to [5].
> The tables you might be interested in are dumped at the ends of the log
> files.
>
> All three guests had 2GB of RAM. They had different VM configurations,
> but between disabling and enabling the properties table feature, no
> other knob was tweaked. Therefore the two log files of the same guest
> should be comparable against each other, for each guest. For example:
>
> $ colordiff -u ovmf.win10.prop.{disabled,enabled}.log
>
> Because stuff hosted on the web privately tends to go away, I'll quote
> that diff here, for posterity:
>
>> --- ovmf.win10.prop.disabled.log      2015-09-29 22:01:45.252126086 +0200
>> +++ ovmf.win10.prop.enabled.log       2015-09-29 21:50:54.579475078 +0200
[...]

Thanks a lot for taking the time, this is very useful info.

-- 
Ard.
