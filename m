From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v3 3/7] x86, boot: Don't overlap VO with ZO data
Date: Tue, 10 Mar 2015 16:48:28 +0100
Message-ID: <20150310154828.GJ3535@pd.tnic>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
 <1425766041-6551-4-git-send-email-yinghai@kernel.org>
 <20150310093430.GC3535@pd.tnic>
 <CAE9FiQWauOdsZ=CBcVHfqTik1ePvW51uH7yy29MSvafOABTWZA@mail.gmail.com>
 <20150310151035.GG3535@pd.tnic>
 <CAE9FiQVy47PnXdd=c_st7OSatFQcvwfzk8XWej=9KUTnRyxKPw@mail.gmail.com>
 <20150310152137.GI3535@pd.tnic>
 <CAE9FiQUQn0vdU_MNf79=oE=DSkUG4U54-taVfgPro1JqUA7BTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQUQn0vdU_MNf79=oE=DSkUG4U54-taVfgPro1JqUA7BTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 10, 2015 at 08:42:40AM -0700, Yinghai Lu wrote:
> In arch/x86/boot/header.S, we already use VO and ZO.
> So please keep on using them, and don't introduce "kernel proper" etc.

So you're suggesting commit messages should use variable names and
prefixes from the code instead of being human-readable?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
