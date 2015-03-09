From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/7] x86, kaslr: Use init_size instead of run_size
Date: Mon, 9 Mar 2015 13:06:00 -0700
Message-ID: <CAE9FiQVEaeWZ2oggks8_jbS+dObZJLq7aEo9cFEqJNtOhWTNRw@mail.gmail.com>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
	<1425766041-6551-2-git-send-email-yinghai@kernel.org>
	<20150309124935.GA12732@pd.tnic>
	<CAE9FiQWc+mnepaqr8RvRXkyhyaOY_C=KvE_A0Ojf_jda3KmFBA@mail.gmail.com>
	<20150309200035.GK12732@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150309200035.GK12732-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 9, 2015 at 1:00 PM, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org> wrote:
> On Mon, Mar 09, 2015 at 12:35:25PM -0700, Yinghai Lu wrote:
>> Can you put back:
>> "
>> So need to make sure [z_extra_offset, init_size) will fit ZO, that means
>> init_size need to be adjusted according to ZO size.
>> That make init_size is always >= run_size.
>
> Why?
>
> We don't adjust init_size. We assign INIT_SIZE to it. Or do you want to
> say that we indirectly adjust init_size through INIT_SIZE?

Yes. Just to emphasize that  " We need to make sure [z_extra_offset,
init_size) will fit ZO"
