From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Subject: Re: [RFT PATCH] efi/x86: move x86 back to libstub
Date: Thu, 16 Oct 2014 11:29:32 -0400
Message-ID: <CA+5PVA6p1bjhhrbK9WAS4F6mhh8UzaugzhkVK4ddCcXq7TPp_g@mail.gmail.com>
References: <1412593603-6945-1-git-send-email-ard.biesheuvel@linaro.org>
	<20141016144206.GH14343@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141016144206.GH14343-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 16, 2014 at 10:42 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Mon, 06 Oct, at 01:06:43PM, Ard Biesheuvel wrote:
>> This reverts commit 84be880560fb, which itself reverted my original
>> attempt to move x86 from #include'ing .c files from across the tree
>> to using the EFI stub built as a static library.
>>
>> The issue that affected the original approach was that splitting
>> the implementation into several .o files resulted in the variable
>> 'efi_early' becoming a global with external linkage, which under
>> -fPIC implies that references to it must go through the GOT. However,
>> dealing with this additional GOT entry turned out to be troublesome
>> on some EFI implementations. (GCC's visibility=hidden attribute is
>> supposed to lift this requirement, but it turned out not to work on
>> the 32-bit build.)
>>
>> Instead, use a pure getter function to get a reference to efi_early.
>> This approach results in no additional GOT entries being generated,
>> so there is no need for any changes in the early GOT handling.
>>
>> Cc: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
>> Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>
>> Gents,
>>
>> This is a request for testing: I would like to find out if this patch
>> fixes Maarten's issue without breaking anything like it did for Josh
>> and Linus the first time around.
>>
>>
>>  arch/x86/boot/compressed/Makefile |  3 ++-
>>  arch/x86/boot/compressed/eboot.c  |  8 ++++----
>>  arch/x86/boot/compressed/eboot.h  | 16 ----------------
>>  arch/x86/include/asm/efi.h        | 24 ++++++++++++++++++++++++
>>  drivers/firmware/efi/Makefile     |  2 +-
>>  5 files changed, 31 insertions(+), 22 deletions(-)
>
> Ard, this is a very neat trick.
>
> Thanks for taking the time to reimplement this, it's much appreciated.
>
> Things work fine on my end, and I do have a Fedora 20/grub box in my
> testing farm now, so I'm confident this is a good patch.
>
> But if other people want to test it out, I'd be grateful of some more
> Tested-by tags (I've already picked up Maarten's).

I applied this (with minor massaging) on top if Linus' tree as of
commit 0429fbc0bdc297d64188483ba029a23773ae07b0 this morning.  It
built and booted on the macbook machine I originally reported the
problem with, so it does appear to be fixed in that case.  I'll try it
on some other machines likely tomorrow.

Sorry for the delay on this.  The merge window is particularly busy for me.

josh
