From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 08 Feb 2013 12:18:27 -0800
Message-ID: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
References: <20130208191213.GA25081@www.outflux.net> <00780235-deac-4f80-b936-867834e05661@email.android.com> <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com> <5115553A.5000708@zytor.com> <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Analogy fail.  The /dev/mem lockout applies to system RAM, not MMIO.

I fear COMPROMISE_KERNEL is becoming the new SYS_ADMIN, which in turn is the new root.  Why?  Because it is inhebtly about a usage model, not about a specific resource.

Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:

>On Fri, Feb 8, 2013 at 11:42 AM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
>> On 02/08/2013 11:18 AM, Kees Cook wrote:
>>>
>>> No. CAP_RAWIO is for reading. Writing needs a much stronger check.
>>
>> If so, I suspect we need to do this for *all* raw I/O... but I keep
>> wondering how much more sensitive writing really is than reading.
>
>Well, I think there's a reasonable distinction between systems that
>expect to strictly enforce user-space/kernel-space separation
>(CAP_COMPROMISE_KERNEL) and things that are fiddling with hardware
>(CAP_SYS_RAWIO).
>
>For example, even things like /dev/mem already have this separation
>(although it is stronger). You can't open /dev/mem without
>CAP_SYS_RAWIO, but if you do, you still can't write to RAM in
>/dev/mem. This might be one of the earliest examples of this
>distinction, actually.
>
>I think it's likely that after a while, we can convert some of these
>proposed CAP_COMPROMISE_KERNEL checks in always-deny once we figure
>out how to deal with those areas more safely.
>
>-Kees
>
>--
>Kees Cook
>Chrome OS Security

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
