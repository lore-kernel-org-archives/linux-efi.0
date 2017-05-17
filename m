From: Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: Indicate clang the relocation mode for arm64
Date: Wed, 17 May 2017 16:24:34 -0700
Message-ID: <a5692a7a-0140-2e61-497f-6d3bf92b5d11@google.com>
References: <20170509193612.64105-1-mka@chromium.org>
 <25d94b46-765e-f12f-a287-853c76782143@google.com>
 <20170509214905.GH128305@google.com>
 <CAKv+Gu_6my-rCc3E1V1n23dHY5OH97qpZ672ST8AZGLjedquAg@mail.gmail.com>
 <20170510183848.GI128305@google.com>
 <69A18345-6933-4C6A-8FAC-DBD4D7EF30DE@linaro.org>
 <20170510194734.GJ128305@google.com>
 <CAKv+Gu8H9H=Rax4iiKaZ2z2GikXTjseCAyKrYgQPQWkekjsN8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu8H9H=Rax4iiKaZ2z2GikXTjseCAyKrYgQPQWkekjsN8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Grant Grundler <grundler-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Bernhard_Rosenkr=c3=a4nzer?= <Bernhard.Rosenkranzer-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 05/11/2017 06:51 AM, Ard Biesheuvel wrote:
[snip]
>>>>> In my opinion, the correct fix would be to make -fpie (as opposed to
>>>>> -fpic) imply hidden visibility, given that PIE executables don't
>>>>> export symbols in the first place, and so the preemption rules do not
>>>>> apply. It is worth a try whether -fpie works as expected in this case
>>>>> on Clang, but the last time I tried it on GCC, it behaved exactly like
>>>>> -fpic.
>>>>
>>>> Thanks a lot for the detailed description and your suggestions!
>>>>
>>>> A clang build with -fpie for the EFI stub succeeds without complaints
>>>> about GOT entries. I will send out an updated patch (with -fpie only
>>>> for clang) later.
>>>>
>>>
>>> Good! I never liked the visibility hack, which is why I never upstreamed it.
>>>
>>> Could you please check how recent GCC behaves?
>>
>> I tried GCC v4.9.4 and v6.3.1, both build the EFI stub with -fpie
>> without errors.
>>
>> Are you suggesting to use -fpie for both clang and GCC? Do you know
>> what the minimum required GCC version is for building an arm64 kernel?
> 
> Yes. Up until now, we have been relying on the position independent
> nature of small model code, but it would be better to specify it
> explicitly, so if -fpie gives us mostly identical code and does not
> need visibility hacks, I would prefer to add it for all compilers and
> not have an exception only for Clang. Note that the same applies to
> the entire kernel when built in KASLR mode, so it would also be good
> to know our options here.
> 
> Arnd, Will, what is the oldest GCC version we claim to support for arm64?
> 

Unfortunately, after looking into this a bit more, -fpie by itself 
doesn't force clang to disable symbol preeemption.  For example when 
building the EFI stub from 4.9 with clang, -fpie gives me a stub that 
crashes with a synchronous exception inside handle_kernel_image().  The 
faulting instruction is a read from __nokaslr that still goes through 
the GOT.

Right now you'll get a usable EFI stub with -fpie anyway, since 
60f38de7a8d4 ("efi/libstub: Unify command line param parsing") masked 
the problem when it moved __nokaslr behind a helper function.  But AIUI 
there's nothing really preventing a similar problem in the future.

You *can* force clang to disable symbol preemption using "-fpie 
-mpie-copy-relocations".  That said, I don't know enough about EFI to 
say whether this is actually appropriate for building the EFI stub.
