From: Vincent Legoll <vincent.legoll-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: make EFI a menuconfig to ease disabling it all
Date: Fri, 15 Dec 2017 18:24:59 +0100
Message-ID: <CAEwRq=qeVDDCY+TFcbF0aeYWLzx0f-256=kwXTZbyEAkNRgUHA@mail.gmail.com>
References: <20171209155252.6403-1-vincent.legoll@gmail.com>
 <20171215151910.GC3204@codeblueprint.co.uk> <CAKv+Gu8Jd8Z78_1SrcLvX7DKSxf9BjkJtJ+UXYi7ak_zpA3fKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu8Jd8Z78_1SrcLvX7DKSxf9BjkJtJ+UXYi7ak_zpA3fKQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hello,

>> This looks fine to me. Ard?
>
> Doesn't this break existing configs?

Would adding a "default yes" on the new menuconfig be OK.

If yes, I'd respin it for a v2

-- 
Vincent Legoll
