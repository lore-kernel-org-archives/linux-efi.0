From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 8 Feb 2013 12:28:00 -0800
Message-ID: <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
References: <20130208191213.GA25081@www.outflux.net>
	<00780235-deac-4f80-b936-867834e05661@email.android.com>
	<CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
	<5115553A.5000708@zytor.com>
	<CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>
	<dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <matthew.garrett@nebula.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 8, 2013 at 12:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Analogy fail.  The /dev/mem lockout applies to system RAM, not MMIO.

Well, that's what I meant by it being "stronger".

> I fear COMPROMISE_KERNEL is becoming the new SYS_ADMIN, which in turn is the new root.  Why?  Because it is inhebtly about a usage model, not about a specific resource.

I can see where you're coming from, but I don't agree. Roughly
speaking, uids should be about organization and filesystem DAC (uid 0
shouldn't be special). SYS_ADMIN is about broad-ranging
configuration/resource access (generally still all in userspace).
There hasn't been a strong distinction between user/kernel space for
uid-0 just because it didn't seem valuable. But now it's clearer, and
COMPROMISE_KERNEL can mark where these lines need to be drawn.

Maybe a capability isn't the right way to go, I'm not sure. I'll leave
that to Matthew. Whatever the flag, it should be an immutable state of
the boot. Though, it probably makes sense as a cap just so that
non-secure-boot systems can still remove it from containers, etc.

-Kees

> Kees Cook <keescook@chromium.org> wrote:
>
>>On Fri, Feb 8, 2013 at 11:42 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 02/08/2013 11:18 AM, Kees Cook wrote:
>>>>
>>>> No. CAP_RAWIO is for reading. Writing needs a much stronger check.
>>>
>>> If so, I suspect we need to do this for *all* raw I/O... but I keep
>>> wondering how much more sensitive writing really is than reading.
>>
>>Well, I think there's a reasonable distinction between systems that
>>expect to strictly enforce user-space/kernel-space separation
>>(CAP_COMPROMISE_KERNEL) and things that are fiddling with hardware
>>(CAP_SYS_RAWIO).
>>
>>For example, even things like /dev/mem already have this separation
>>(although it is stronger). You can't open /dev/mem without
>>CAP_SYS_RAWIO, but if you do, you still can't write to RAM in
>>/dev/mem. This might be one of the earliest examples of this
>>distinction, actually.
>>
>>I think it's likely that after a while, we can convert some of these
>>proposed CAP_COMPROMISE_KERNEL checks in always-deny once we figure
>>out how to deal with those areas more safely.
>>
>>-Kees
>>
>>--
>>Kees Cook
>>Chrome OS Security
>
> --
> Sent from my mobile phone. Please excuse brevity and lack of formatting.



--
Kees Cook
Chrome OS Security
