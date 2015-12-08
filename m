From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] x86: Fix kernel panic when booting with XD disabled in uEFI firmware
Date: Tue, 08 Dec 2015 12:39:14 -0800
Message-ID: <19122B57-8052-4A92-801E-03CC84E66F06@zytor.com>
References: <20151204164057.GE2514@codeblueprint.co.uk> <17EC94B0A072C34B8DCF0D30AD16044A0288EFC7@BPXM09GP.gisp.nec.co.jp> <20151208122557.GA2518@codeblueprint.co.uk> <20151208141946.GD27180@pd.tnic> <CAGXu5jKF3fVc5rsU=+jRcoBGB+ZkeHjF6mmSeJN0SoP-MpFGow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jKF3fVc5rsU=+jRcoBGB+ZkeHjF6mmSeJN0SoP-MpFGow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Kosuke Tatsukawa <tatsu-zZGIbrA41Td8UrSeD/g0lQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On December 8, 2015 12:30:06 PM PST, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>On Tue, Dec 8, 2015 at 6:19 AM, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
>> On Tue, Dec 08, 2015 at 12:25:57PM +0000, Matt Fleming wrote:
>>> On Mon, 07 Dec, at 11:10:43PM, Kosuke Tatsukawa wrote:
>>> >
>>> > Thank you pointing that out.
>>> >
>>> > linux-4.4-rc3 booted without a problem on a real server even with
>XD
>>> > turned off by the firmware.  I didn't notice this before because I
>was
>>
>> The aforementioned patch reenables NX.
>>
>>> Borislav, what do you think about stripping PAGE_NX from
>'page_flags'
>>> in kernel_map_pages_in_pgd() if NX isn't supported, rather than
>>> returning EINVAL? At least that way EFI runtime services would still
>>> work.
>>
>> I guess we can - I mean, I don't see what can go wrong more when
>> allowing the kernel to execute even NX UEFI regions. Maybe easier
>> generation of "gadgets" in the ROP sense ...
>>
>> On a related node, I'm very sceptical of the existence of this
>"noexec"
>> chicken bit, if you ask me. It is a really bad idea, security-wise,
>to
>> disable NX. Is there even a valid use case to disable NX?
>>
>> Because if not, I'd vote for removing that chicken bit or at least
>> taining the kernel with
>>
>>         add_taint(TAINT_USER_MORON, ... );
>
>If we add this for not-nx, I would like to add it for not-rodata too.
>
>> Kees, has this NX disabling practice come up in the past, per
>chance... ?
>
>I've never seen anyone actually use it. I was asked to include it out
>of fear of some kind of rogue imagined CPU configuration that mixed NX
>and non-NX capable CPUs in a single machine where the forced NX
>re-enablement code would cause problems. As you might imagine, I'm not
>aware of this case ever being an issue. ;)
>
>-Kees

Actually I think of it much more as a debug option - being able to mimic NX-unaware hardware and to track down problems in the field.
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
