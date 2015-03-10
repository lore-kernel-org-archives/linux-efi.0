From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 3/7] x86, boot: Don't overlap VO with ZO data
Date: Tue, 10 Mar 2015 08:05:52 -0700
Message-ID: <CAE9FiQWauOdsZ=CBcVHfqTik1ePvW51uH7yy29MSvafOABTWZA@mail.gmail.com>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
	<1425766041-6551-4-git-send-email-yinghai@kernel.org>
	<20150310093430.GC3535@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150310093430.GC3535-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 10, 2015 at 2:34 AM, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org> wrote:
> Final patch:
>
> ---
> From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Sat, 7 Mar 2015 14:07:17 -0800
> Subject: [PATCH] x86/setup: Don't overlap vmlinux's brk with compressed kernel's data

We need to keep VO and ZO here...

Should use ZO to replace "compressed kernel"

compressed kernel is compressed VO (vmlinux) actually.

ZO is arch/x86/boot/compressed/vmlinux

Thanks

Yinghai
