From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [GIT PULL 0/1] EFI mixed mode fix for v4.18
Date: Wed, 11 Jul 2018 15:44:03 +0200
Message-ID: <CAKv+Gu_LJEu11NV5CVTPV9ieZ=XKkgW2qdkFJ+1iWk+F2jNPww@mail.gmail.com>
References: <20180711090235.9327-1-ard.biesheuvel@linaro.org>
 <20180711101303.GA8574@gmail.com> <CAKv+Gu8m4UgL0GyYDuu5z+dzEF=N--H4PkqoO_xqwyW2_A+RMA@mail.gmail.com>
 <20180711111427.GA27216@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711111427.GA27216@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>, Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>
List-Id: linux-efi@vger.kernel.org

On 11 July 2018 at 13:14, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
>> On 11 July 2018 at 12:13, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> >
>> >> The following changes since commit 1e4b044d22517cae7047c99038abb444423243ca:
>> >>
>> >>   Linux 4.18-rc4 (2018-07-08 16:34:02 -0700)
>> >>
>> >> are available in the Git repository at:
>> >>
>> >>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent
>> >>
>> >> for you to fetch changes up to d7f2e972e702d329fe11d6956df99dfc31211c25:
>> >>
>> >>   efi/x86: remove pointless call to PciIo->Attributes() (2018-07-11 10:52:46 +0200)
>> >>
>> >> ----------------------------------------------------------------
>> >> A single fix for the x86 PCI I/O protocol handling code that got
>> >> broken for mixed mode (64-bit Linux/x86 on 32-bit UEFI) after a
>> >> fix was applied in -rc2 to fix it for ordinary 64-bit Linux/x86.
>> >
>> > Just curious, because it's unclear from the changelog, what was the symptom, a
>> > boot hang, instant reboot, or some other misbehavior?
>>
>> Hans reported that his mixed mode tablet would not boot at all any
>> more, but enter a reboot loop without any logs printed by the kernel.
>>
>> > Also, what's the scope of
>> > the fix: were all 64-bit on 32-bit UEFI mixed-mode bootups affected, or only a
>> > certain subset?
>> >
>>
>> Any mixed mode system with PCI is likely to be affected. I have added
>> a QEMU mixed mode config to my boot test environment to catch errors
>> like this one.
>
> Ok, I've added this information to the commit - will be useful to backporters,
> to judge the severity of the bug fixed.
>

Perhaps it wasn't clear from the commit log that only v4.18-rc2 and
later is affected by the mixed mode issue, since that is when a fix
for ordinary 64-bit x86 was applied that affected v4.18-rc1.

>> The unfortunate thing here is that this uncovered a fundamental issue with mixed
>> mode, i.e., that any UEFI protocol prototype involving 64-bit by-value
>> parameters needs to be special cased in the stub code, which is rather tedious.
>> There is one other call that is potentially affected, a file open call in the
>> initrd handling code, but that specific occurrence happens to work unmodified.
>> This patch removes the other one. Going forward, we will have to carefully
>> review UEFI protocol invocations for mixed mode compatibility.
>
> Yeah. Is there any, more systematic way to detect such problems perhaps at an
> earlier stage, other than careful review which will often fail to find such bugs?
> Also, testing is good, but could we perhaps do something on a deeper level -
> automate the casting, generate a warning on suspicious patterns, etc. etc?
>

The main problem is the assumption is that we can convert any call
using the SysV/x86_64 calling convention to the IA32 calling
convention by pushing a 32-bit word for each argument passed in a
register. This assumption holds most of the time, but not all of the
time, and any argument passed by register that takes up more than a
single 32-bit slot is problematic. Note that EFI_PHYSICAL_ADDRESS is
always defined as 64 bits wide, and is widely used in UEFI.
Fortunately, it is mostly passed by reference, and pointers are 32-bit
in mixed mode, so there we dodge the issue.

To me, it is a bit surprising that GCC cannot do this for us, i.e., we
set some __attribute__(()) on a function declaration to inform the
compiler that it should use the 32-bit calling convention. But I guess
there are issues that complicate this in ways that my limited
understanding of low level x86 does not cover.

In any case, the only way to automate this would be to find *some* way
to instantiate the thunking code specifically for each prototype that
we invoke at runtime. The most naive approach would be to classify
functions as

(u32, u32, u32, u32, u32, ...)
(u64, u32, u32, u32, u32, ...)
(u32, u64, u32, u32, u32, ...)
(u64, u64, u32, u32, u32, ...)

etc etc

and have a static library containing the thunking routine for each
one, and wire them up as appropriate. Of course, there is no point in
exhaustively generating each one if we know that only the file open()
call deviates from the first entry.

However, the EFI stub code is not expected to expand that much, and so
for the time being, I'm fine with a combination of review and rigorous
testing
