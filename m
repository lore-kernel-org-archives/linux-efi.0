From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Mon, 12 Oct 2015 18:43:44 +0200
Message-ID: <CAKv+Gu82bVMqded+GGHA2AUHCcfTjY_ZRscsVObTibnFici8=A@mail.gmail.com>
References: <5612CBE8.2010504@tycho.nsa.gov>
	<20151006073205.GA11115@gmail.com>
	<5613EAD5.2070405@tycho.nsa.gov>
	<20151012113605.GB7384@pd.tnic>
	<20151012124113.GD2579@codeblueprint.co.uk>
	<20151012124936.GA6260@gmail.com>
	<20151012125548.GE2579@codeblueprint.co.uk>
	<20151012141754.GA6621@gmail.com>
	<20151012144928.GF2579@codeblueprint.co.uk>
	<CAKv+Gu95NoB5cPqZMeBLn7i0JWDDPKX63FuiMVD94HpbGhKrhA@mail.gmail.com>
	<20151012155028.GH2579@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151012155028.GH2579-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12 October 2015 at 17:50, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Mon, 12 Oct, at 05:34:53PM, Ard Biesheuvel wrote:
>>
>> On arm64, we only map in all of the UEFI runtime services regions
>> during the time any of these services are being invoked. I think this
>> should be mostly feasible on x86 as well, although it would involve
>> yet another rewrite of the EFI region mapping code, and most likely a
>> long list of quirks for platforms that are not able to deal with it
>> correctly for one reason or the other (but that all come down to: 'if
>> you are not doing it like Windows does it, you must be doing it
>> wrong').
>
> Actually, we use separate page tables for mapping the EFI runtime
> services on x86 right now. These tables are only used when making
> runtime calls, just like on arm64.
>
> So we've got a little bit of isolation right now.
>

Ah ok. I thought that only applied to the duplicate 1:1 mapping, not
to the high mapping.

But that does reduce the attack surface considerably. Combined with
strict w^x once the UEFI 2.5 feature is fully supported, I am a lot
less nervous about RWX EFI runtime regions being used to subvert the
system.

-- 
Ard.
