From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/15] x86, kaslr: Use init_size instead of run_size
Date: Fri, 6 Mar 2015 16:52:29 -0800
Message-ID: <CAE9FiQXRyO1aej7_JOfUfG7h-qrFHfukEP+9JxYm5+e9s4-Zpg@mail.gmail.com>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
	<1425456048-16236-2-git-send-email-yinghai@kernel.org>
	<20150306135534.GD4259@pd.tnic>
	<CAE9FiQXzv7TPMRA+RqSdV0ERiW3KYA-2KOyDKBrZDn3Zd5RcrQ@mail.gmail.com>
	<CAGXu5jLf+=CMs0qj4nRG-kw1YiQ-eMFHFpAE8uVUitqmGOG7gA@mail.gmail.com>
	<CAE9FiQU3jKn260cce7Zvo0Qy0ksDKB=-o2m_drBmO4fpBv8Wow@mail.gmail.com>
	<CAGXu5jLk-qeHLqejR47TmT8wzrkjF9eQhfGPJYDoejD+AdkmOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jLk-qeHLqejR47TmT8wzrkjF9eQhfGPJYDoejD+AdkmOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 6, 2015 at 11:56 AM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Fri, Mar 6, 2015 at 11:28 AM, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Okay, I've proven this to myself now. :) I think it would be valuable
> to call out that brk and bss are included in the _end calculation. For
> others:
...
> So, _end - _text does equal _text + bss offset + bss size + brk size
>
> Thanks! It'll be nice to lose the run_size hack. Adding some
> documentation to the code here would help others in the future trying
> to find this value, I think. :)

in arch/x86/kernel/vmlinux.lds.S, we have

        /* BSS */
        . = ALIGN(PAGE_SIZE);
        .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
                __bss_start = .;
                *(.bss..page_aligned)
                *(.bss)
                . = ALIGN(PAGE_SIZE);
                __bss_stop = .;
        }

        . = ALIGN(PAGE_SIZE);
        .brk : AT(ADDR(.brk) - LOAD_OFFSET) {
                __brk_base = .;
                . += 64 * 1024;         /* 64k alignment slop space */
                *(.brk_reservation)     /* areas brk users have reserved */
                __brk_limit = .;
        }

        _end = .;

so _end already cover bss and brk.
