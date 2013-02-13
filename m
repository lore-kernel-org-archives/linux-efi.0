From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Wed, 13 Feb 2013 14:24:04 -0800
Message-ID: <511C1284.6080304@zytor.com>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>    <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>    <1360355671.18083.18.camel@x230.lan>    <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>    <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>    <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>    <1360373383.18083.23.camel@x230.lan>    <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>    <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>   <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>  <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan> <511B33BC.9080307@zytor.com> <511B4E61.1040604@redhat.com> <511BCBD6.6020907@zytor.com> <511B
 EFAD.1050206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511BEFAD.1050206-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/13/2013 11:55 AM, Paolo Bonzini wrote:
> Il 13/02/2013 18:22, H. Peter Anvin ha scritto:
>>>
>>> On non-x86 machines CAP_SYS_RAWIO is much less dangerous, especially
>>> when coupled with file DAC.
>
> Discretionary Access Control.
>
>> Either way, I think you are at best deluded and more like you just
>> completely wrong about CAP_SYS_RAWIO being "less dangerous on non-x86
>> machines".  With the possible exception of s390 I suspect it is, in
>> fact, more dangerous.
>
> I may well be wrong, but as a quick data point CAP_SYS_RAWIO has no
> occurrences in arch/ except arch/x86.  Of course a lot of driver
> functionality will be limited to CAP_SYS_RAWIO, but usually this
> requires having a file descriptor for some file.
>

Well, yes, although that could include /dev/mem.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
