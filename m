From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Tue, 29 Sep 2015 12:41:23 +0200
Message-ID: <CAKv+Gu8GpaHRL8EZxJCs8dw8ngFVoYNP1Q=hqhZ=LOF+3vXPLw@mail.gmail.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
	<1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk>
	<20150926055643.GA25877@gmail.com>
	<20150926134329.GA3144@codeblueprint.co.uk>
	<20150927070355.GB26125@gmail.com>
	<CAKv+Gu8M2pmzfeA=NT4c44E6-PQvRKHZjEJt78mryGcp6bBD8w@mail.gmail.com>
	<20150928082245.GA28796@gmail.com>
	<CAKv+Gu-e5CRrJ1S7phXyWCUZ10ptukn0zr0wDGyX14H_SpEp1Q@mail.gmail.com>
	<20150929091230.GA2023@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150929091230.GA2023@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt.fleming@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Dave Young <dyoung@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

On 29 September 2015 at 11:12, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
>> > except that I don't think
>> > the condition on 64-bit makes any sense:
>> >
>> > +       if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {
>> >
>> > I can see us being nervous wrt. backported patches, but is there any strong reason
>> > to not follow this up with a third (non-backported) patch that changes this to:
>> >
>> > +       if (!efi_enabled(EFI_OLD_MEMMAP)) {
>> >
>> > for v4.4?
>> >
>>
>> The 32-bit side essentially implements the old memmap only, which is the the
>> bottom-up version. So old memmap will be implied by 32-bit but not set in the
>> EFI flags, resulting in the reverse enumeration being used with the bottom-up
>> mapping logic. The net result of that is that we create the same problem for
>> 32-bit that we are trying to solve for 64-bit, i.e., the regions will end up in
>> reverse order in the VA mapping.
>>
>> To deobfuscate this particular conditional, we could set EFI_OLD_MEMMAP
>> unconditionally on 32-bit x86. Or we could reshuffle variables and conditionals
>> in various other way.
>
> Setting EFI_OLD_MEMMAP would be fine, if doing that has no bad side effects.
>
>> [...] I am not convinced that the overall end result will be any better though.
>
> That's not true, we change an obscure, implicit dependency on 32-bit detail to an
> explicit EFI_OLD_MEMMAP flag that shows exactly what's happening. That's a clear
> improvement.
>

OK, fair enough. I agree that setting the flag for 32-bit would be
semantically correct. I will leave it to Matt to comment whether it is
reasonable in terms of changes to other parts of the code.

Thanks,
Ard.
