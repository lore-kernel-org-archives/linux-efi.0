From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 5/7] x86, kaslr: Consolidate mem_avoid array filling
Date: Mon, 9 Mar 2015 18:26:10 -0700
Message-ID: <CAGXu5jKbCE2r06iTH3P4HT_if_DPr_kPdz6_5C5Yr4-SEYbwSQ@mail.gmail.com>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
	<1425766041-6551-6-git-send-email-yinghai@kernel.org>
	<CAGXu5j+exWabf=LdpkBtipcRYDVW=sH4LZf01P3RoSaKK7iYYA@mail.gmail.com>
	<CAE9FiQX2Ee0gWhtDrQxi=NfwC3Vu9ZS_YLPC9qvR92htZfBcJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE9FiQX2Ee0gWhtDrQxi=NfwC3Vu9ZS_YLPC9qvR92htZfBcJg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 9, 2015 at 6:10 PM, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Mar 9, 2015 at 6:00 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> On Sat, Mar 7, 2015 at 2:07 PM, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>
>> This may be a stupid question, but are boot_params being used outside
>> of the compressed loader? If so, it might make sense to split that
>> change into a separate patch to go to stable, if it's causing
>> problems. (And document what problem is getting solved.)
>
> boot_params will keep the same and until it is passed
> x86_64_start_kernel in vmlinux.
> and there it will be copied, same as cmdline.
>
> but current kaslr only support random the base high, and it does not
> support kexec
> and current boot loader (grub2) put it really low. (under 1M). the
> real real_mode. :).

Oh right! Of course, thanks for the details. Yes, it was implicitly
ignored before, but now it needs to be explicitly ignored. Great,
thanks!

-Kees

>
> Thanks
>
> Yinghai



-- 
Kees Cook
Chrome OS Security
