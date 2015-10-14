From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Wed, 14 Oct 2015 08:30:48 -0700
Message-ID: <CALCETrU-_dJ3=+1nHN82mE==YpXGB8USWdrXDc=BVk_J5UdN3A@mail.gmail.com>
References: <20151003112701.GA4531@gmail.com> <5612CBE8.2010504@tycho.nsa.gov>
 <20151006073205.GA11115@gmail.com> <5613EAD5.2070405@tycho.nsa.gov>
 <20151012113605.GB7384@pd.tnic> <20151012124113.GD2579@codeblueprint.co.uk>
 <20151012124936.GA6260@gmail.com> <20151012125548.GE2579@codeblueprint.co.uk>
 <20151012141754.GA6621@gmail.com> <20151012144928.GF2579@codeblueprint.co.uk> <20151014151807.GA27013@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151014151807.GA27013@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@alien8.de>, Stephen Smalley <sds@tycho.nsa.gov>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 14, 2015 at 8:18 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Matt Fleming <matt@codeblueprint.co.uk> wrote:
>
>> On Mon, 12 Oct, at 04:17:54PM, Ingo Molnar wrote:
>> >
>> > * Matt Fleming <matt@codeblueprint.co.uk> wrote:
>> >
>> > > On Mon, 12 Oct, at 02:49:36PM, Ingo Molnar wrote:
>> > > >
>> > > >
>> > > > So why not unmap them after bootup? Is there any reason to call into EFI code
>> > > > while the system is up and running?
>> > >
>> > > That's where the runtime services code lives. So if you want things like EFI
>> > > variables (used by the distro installer, among other things) you need to map the
>> > > runtime regions.
>> >
>> > So EFI variables could be queried during bootup and saved on the Linux side.
>>
>> Right, we could do that, but then we wouldn't be able to support
>> creation/updating variables at runtime, such as when you install a
>> distribution for the first time, or want to boot a new kernel filename
>> directly from the firmware without a boot loader (and need to modify
>> the BootXXXX variables).
>
> Do we know the precise position and address range of these variables?
>
> We could map them writable (but not executable), and the rest executable (but not
> writable).
>
> That raises the question whether the same physical page ever mixes variables and
> actual code - but the hope would be that it's suffiently page granular for this to
> work.

Can we just unmap these things until someone tries to do an EFI call,
and then unmap them again after the call returns?  We already switch
pgds for EFI IIRC.

--Andy
