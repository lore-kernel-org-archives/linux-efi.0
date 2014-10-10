From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFT PATCH] efi/x86: move x86 back to libstub
Date: Fri, 10 Oct 2014 10:37:19 +0200
Message-ID: <CAKv+Gu_5tHNB=YOS0Kz2i2ap2n8PvzmvGD6-J7MzxptoG_zHQw@mail.gmail.com>
References: <1412593603-6945-1-git-send-email-ard.biesheuvel@linaro.org>
	<CAKv+Gu9rdPujXqfWhJt=76V8Lemf2FuVoa75KH-TWh+2_a=Ghg@mail.gmail.com>
	<5437990C.7050402@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5437990C.7050402-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10 October 2014 10:30, Maarten Lankhorst
<maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> Hey,
>
> On 10-10-14 08:35, Ard Biesheuvel wrote:
>> On 6 October 2014 13:06, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>> This reverts commit 84be880560fb, which itself reverted my original
>>> attempt to move x86 from #include'ing .c files from across the tree
>>> to using the EFI stub built as a static library.
>>>
>>> The issue that affected the original approach was that splitting
>>> the implementation into several .o files resulted in the variable
>>> 'efi_early' becoming a global with external linkage, which under
>>> -fPIC implies that references to it must go through the GOT. However,
>>> dealing with this additional GOT entry turned out to be troublesome
>>> on some EFI implementations. (GCC's visibility=hidden attribute is
>>> supposed to lift this requirement, but it turned out not to work on
>>> the 32-bit build.)
>>>
>>> Instead, use a pure getter function to get a reference to efi_early.
>>> This approach results in no additional GOT entries being generated,
>>> so there is no need for any changes in the early GOT handling.
>>>
>>> Cc: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>>> Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
>>> Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> ---
>>>
>>> Gents,
>>>
>>> This is a request for testing: I would like to find out if this patch
>>> fixes Maarten's issue without breaking anything like it did for Josh
>>> and Linus the first time around.
>>>
>>
>> Any takers?
> Sorry it was on my todo list but I lost access to my laptop for a while.
> Normal EFI boot through refind works at least, but I think netboot may use a slightly
> different codepath which I can't test right now.
>
> Tested-By: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Thanks! So I suppose the code path you did test is the code path that
produced the failure last time?
