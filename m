From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: Use LocateHandleBuffer instead of LocateHandle
Date: Wed, 5 Oct 2016 17:25:44 +0100
Message-ID: <CAKv+Gu-6yB_ZVC38S8yFZtB7vPfDZe1wp47bT+WxwpSSUN4OgA@mail.gmail.com>
References: <1d7915dc0dd328ca04088f6b8b3fcfad5cec55a0.1473275006.git.lukas@wunner.de>
 <CAKv+Gu_kfnHfiBH__Wnvh39KMPj_-s39YyY=pT3roNv7iPPzrA@mail.gmail.com>
 <20160909115951.GA29385@wunner.de> <20161003193220.GI16071@codeblueprint.co.uk>
 <CAKv+Gu-UKr0bPjy_0tO0ThB6F4E1q-uKtktg+z5CRP=gX-oewg@mail.gmail.com> <20161004165349.GA5019@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161004165349.GA5019-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 4 October 2016 at 17:53, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> On Tue, Oct 04, 2016 at 01:56:42PM +0100, Ard Biesheuvel wrote:
>> On 3 October 2016 at 12:32, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>> > On Fri, 09 Sep, at 01:59:51PM, Lukas Wunner wrote:
>> >>
>> >> I vaguely recall that Apple was among the first vendors adopting EFI
>> >> for x86 in 2005, but I could be wrong.
>> >
>> > I'm fairly sure my old Macbook 2.1 is EFI 1.10, yeah.
>>
>> Indeed. But the Macs are a little weird in this respect, it does not
>> necessarily mean they don't implement LocateHandleBuffer(). Since
>> Lukas uses a Mac himself (IIRC), I'd assume it works on his system and
>> so their UEFI does implement this boot service. That does not
>> necessarily tell us anything about other Macs, though.
>
> I have a 2012 MacBook Pro, but there's a simple trick to find out if
> even the earliest Intel Macs of 2006 supported LocateHandleBuffer:
> By disassembling the bootloader that shipped with OS X 10.6 (2009).
> This release still officially supported the very first Intel Macs.
> If it unconditionally calls LocateHandleBuffer, then it must have
> been supported from the very beginning.
>
> Did a quick search for instruction FF 90 38 01 00 00, which means
> "call qword [ds:rax+0x138]", where 138 is the LocateHandleBuffer
> offset in the 64-bit boot services table.  And sure enough:
>
> 5147         lea        rdi, qword [ds:0x278d0]         ; boot services table
> 514e         lea        rdx, qword [ss:rbp+0xffffffffffffffa8]
> 5152         xor        r8d, r8d                        ; SearchKey
> 5155         lea        r9, qword [ss:rbp+0xffffffffffffff98] ; NoHandles
> 5159         mov        ecx, 0x2                        ; ByProtocol
> 515e         mov        rax, qword [ds:rdi]
> 5161         mov        qword [ss:rsp-0x8+arg_10], rdx  ; Buffer
> 5166         lea        rdx, qword [ds:0x27a00]         ; GUID
> 516d         call       qword [ds:rax+0x138]            ; LocateHandleBuffer
>
> The 32-bit version looks the same except for the offset (rax+0xa8) and
> calling convention.
>
> So I'm pretty confident this patch works on all Macs, the question is
> were there any non-Mac x86 machines which might lack LocateHandleBuffer?
>
> The EFI 1.10 spec merely says "The LocateHandleBuffer() is a new version
> of LocateHandle() that allocates the required buffer for the caller."
>
> But new since when?  Was this added with 1.10 or did it already exist
> in earlier versions?  The 1.10 spec dates back to 2002 and according
> to Wikipedia, only Itaniums used EFI back then.
>
> If LocateHandleBuffer was indeed missing in earlier specs, was the
> layout of the boot services table the same as in 1.10 and the function
> pointer was just marked reserved, or was the layout completely different?
> If the latter, then we don't support earlier versions anyway.
>
> The Graphics Output Protocol was added post 1.10, so it should be safe
> to use LocateHandleBuffer at least for GOP.  The two other protocols,
> UGA and EFI_PCI_IO_PROTOCOL, were already present in 1.10.
>
> I tried to find the 1.02 spec using the Wayback Machine:
> https://web.archive.org/web/20021218163928/http://developer.intel.com/technology/efi/download.htm
>
> The download required entering an e-mail address and the user was then
> redirected to an URL which is missing in the Wayback Machine:
> https://web.archive.org/web/http://developer.intel.com/technology/efi/EFISpec_v102.htm
>
> I couldn't find older specs than 1.10 with Google either, so it looks
> like it's gone from today's web.  Thus, on September 12 I reached out
> by e-mail to Vincent Zimmer who had been working on EFI since its early
> days (see his blog at http://vzimmer.blogspot.com).  Unfortunately I
> never got a reply.
>

Thanks for the archeological background :-) Matt and I deal with
Vincent on a regular basis in the USST and other UEFI forum calls, so
we could simply ask him. However, we've had our share of breakage with
the stub code, which is difficult to debug on anything except
development hardware, and so I think we should not take this change
(and Matt appears to agree). I do like the cleanup, but since there is
no functional change, I'd rather stick with the existing code.

> My guess is that pre-1.10 versions were only ever shipped with Itanium
> and that using LocateHandleBuffer is therefore safe on x86.  But to know
> for sure it would be necessary to find someone who still is in possession
> of earlier specs and knows what shipped when.
>

Regards,
Ard.
