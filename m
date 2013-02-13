From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Wed, 13 Feb 2013 09:27:13 +0100
Message-ID: <511B4E61.1040604@redhat.com>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>    <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>    <1360355671.18083.18.camel@x230.lan>    <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>    <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>    <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>    <1360373383.18083.23.camel@x230.lan>    <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>    <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>   <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>  <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan> <511B33BC.9080307@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <511B33BC.9080307@zytor.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Il 13/02/2013 07:33, H. Peter Anvin ha scritto:
>>
>>> Sounds like you are thinking of CAP_SYS_ADMIN, but I don't really see a
>>> huge difference between MSRs and I/O control registers... just different
>>> address spaces.
>>
>> Not having CAP_SYS_RAWIO blocks various SCSI commands, for instance.
>> These might result in the ability to write individual blocks or destroy
>> the device firmware, but do any of them permit modifying the running
>> kernel?

No, they cannot.

> That is just batshit crazy.  If you have CAP_SYS_RAWIO you can do iopl()
> which means you can reprogram your northbridge, at which point you most
> definitely *can* modify the running kernel.
> 
> And some SCSI driver requires this??!

No, and that's why there is a patchset floating that lets you toggle
this ability with a sysfs control.  This way you do not need
CAP_SYS_RAWIO anymore.

On non-x86 machines CAP_SYS_RAWIO is much less dangerous, especially
when coupled with file DAC.

Paolo
