From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 03/19] x86, boot: Simplify run_size calculation
Date: Mon, 23 Mar 2015 00:12:13 -0700
Message-ID: <CAE9FiQUc_Os9ZpYxT1ai4Crbqk85t-09t47re9Yy0Om_TUw6tQ@mail.gmail.com>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
	<1426663706-23979-4-git-send-email-yinghai@kernel.org>
	<20150323032522.GC2068@dhcp-16-105.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150323032522.GC2068-je1gSBvt1TeLcxizHhUEZR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Mar 22, 2015 at 8:25 PM, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> This may not be correct. In commit e602336
> runsize = offset(.bss) + size(.bss) + size(.brk), why this formula comes
> out can be checked from discussion between Kees and Junjie:
> https://lkml.org/lkml/2014/10/30/612
>
> And in my one kernel build the related values are:
> -) objdump -h vmlinux
> vmlinux:     file format elf64-x86-64
>
> Sections:
> Idx Name          Size      VMA               LMA               File off
> Algn
>  27 .bss          00167000  ffffffff81e92000  0000000001e92000  01292000
> 2**12
>                   ALLOC
>  28 .brk          00027000  ffffffff81ff9000  0000000001ff9000  01292000
> 2**0
>                   ALLOC
>
> run_size on old calculation is
> 0x01292000+0x00167000+0x00027000=0x1420000
>
> -) nm vmlinux
> ffffffff81000000 T _text
> ffffffff82020000 B _end
>
> run_size on your method is 0x82020000 - 0x81000000 = 0x1020000
>
> So if output_len which is the length of vmlinux.bin + vmlinux.relocs is
> between the old run_size and your new run_size, the problem Junjie tried
> to fix will happen again.

no. We should not use file offset in the elf for run_size.
when the section can not fill 2M, use file offset will get not needed
extra size.

parse_elf will move sections forward according to program headers.

Thanks

Yinghai
