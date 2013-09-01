From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH 08/10] kexec: Disable at runtime if the kernel enforces
 module loading restrictions
Date: Sun, 1 Sep 2013 10:52:45 +0200
Message-ID: <CAMuHMdVPAEQn8wmNnagPpy45OSSzvjX-LUDx8G8eWiOFh=4sSw@mail.gmail.com>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
	<1376928619-3775-8-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376928619-3775-8-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 19, 2013 at 6:10 PM, Matthew Garrett
<matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:
> kexec permits the loading and execution of arbitrary code in ring 0, which
> is something that module signing enforcement is meant to prevent. It makes
> sense to disable kexec in this situation.

Any plans for signed kexec code?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
