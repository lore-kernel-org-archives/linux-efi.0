From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2 01/15] x86, kaslr: Use init_size instead of run_size
Date: Fri, 6 Mar 2015 11:56:49 -0800
Message-ID: <CAGXu5jLk-qeHLqejR47TmT8wzrkjF9eQhfGPJYDoejD+AdkmOQ@mail.gmail.com>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
	<1425456048-16236-2-git-send-email-yinghai@kernel.org>
	<20150306135534.GD4259@pd.tnic>
	<CAE9FiQXzv7TPMRA+RqSdV0ERiW3KYA-2KOyDKBrZDn3Zd5RcrQ@mail.gmail.com>
	<CAGXu5jLf+=CMs0qj4nRG-kw1YiQ-eMFHFpAE8uVUitqmGOG7gA@mail.gmail.com>
	<CAE9FiQU3jKn260cce7Zvo0Qy0ksDKB=-o2m_drBmO4fpBv8Wow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE9FiQU3jKn260cce7Zvo0Qy0ksDKB=-o2m_drBmO4fpBv8Wow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 6, 2015 at 11:28 AM, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Fri, Mar 6, 2015 at 10:55 AM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> On Fri, Mar 6, 2015 at 10:44 AM, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>>
>> I don't see how bss and brk are related to these sizes. Can you
>> explain how bss, brk, and initrd factor into these sizes? Those were
>> what run_size was created to represent. I don't want to accidentally
>> start stomping on bss and brk again. :)
>
> VO (vlinux) init size aka VO_INIT_SIZE already inlude that.
>
> Please check update version.
>
>
> commit e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
> introduced one run_size for kaslr.
> We should use real runtime size (include copy/decompress) aka init_size.
>
> run_size is VO (vmlinux) init size include bss and brk.
> init_size is the size needed for decompress and it is bigger than run_size
> when decompress need more buff.
>
> According to arch/x86/boot/header.S:
> | #define ZO_INIT_SIZE    (ZO__end - ZO_startup_32 + ZO_z_extract_offset)
> | #define VO_INIT_SIZE    (VO__end - VO__text)
> | #if ZO_INIT_SIZE > VO_INIT_SIZE
> | #define INIT_SIZE ZO_INIT_SIZE
> | #else
> | #define INIT_SIZE VO_INIT_SIZE
> | #endif
> | init_size:              .long INIT_SIZE         # kernel initialization size

Okay, I've proven this to myself now. :) I think it would be valuable
to call out that brk and bss are included in the _end calculation. For
others:

$ objdump -h vmlinux | egrep '\.(bss|brk)'
 25 .bss          00da7000  ffffffff82436000  0000000002436000  01836000  2**12
 26 .brk          00026000  ffffffff831dd000  00000000031dd000  01836000  2**0
$ nm vmlinux | egrep ' _(text|end)'
ffffffff83203000 B _end
ffffffff81000000 T _text
$ objdump -h vmlinux | bash arch/x86/tools/calc_run_size.sh
39858176
$ bc
obase=16
39858176
2603000
ibase=16
81000000 + 2603000
83603000

So, _end - _text does equal _text + bss offset + bss size + brk size

Thanks! It'll be nice to lose the run_size hack. Adding some
documentation to the code here would help others in the future trying
to find this value, I think. :)

-Kees

>
> Bootloader allocate buffer according to init_size in hdr, and load the
> ZO (arch/x86/boot/compressed/vmlinux) from start of that buffer.
> init_size first should come from VO (vmlinux) init size. That VO init size
> is from VO _end to VO _end and include VO bss and brk area.
>
> During running of ZO, ZO move itself to the middle of buffer at
> z_extract_offset to make sure that decompressor would not have output
> overwrite input data before input data get consumed.
> But z_extract_offset calculating is based on size of VO (vmlinux) and size
> of compressed VO only at first.
> So need to make sure [z_extra_offset, init_size) will fit ZO, that means
> init_size need to be adjusted according to ZO size.
> That make init_size is always >= run_size.
>
> During aslr buffer searching, we need to make sure the buffer is bigger
> enough for decompress at first. So use init_size instead, and kill not
> needed run_size related code.



-- 
Kees Cook
Chrome OS Security
