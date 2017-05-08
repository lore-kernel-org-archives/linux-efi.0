From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [tip:x86/mm] x86/boot/32: Defer resyncing initial_page_table
 until per-cpu is set up
Date: Mon, 8 May 2017 17:45:20 +0300
Message-ID: <CAHp75Ve3nAyy1KxwUGz74Xt3cz-=Mc=7QqWAjwvrLQUrJsEH8Q@mail.gmail.com>
References: <a553264a5972c6a86f9b5caac237470a0c74a720.1490218061.git.luto@kernel.org>
 <tip-23b2a4ddebdd17fad265b4bb77256c2e4ec37dee@git.kernel.org>
 <0c4d6d04-7038-fb82-87b3-343784550d0a@siemens.com> <CAHp75VdX-kUqW0MKOSTz9zByU-eipBMnKpdUbTt2SVOJ8Kvrig@mail.gmail.com>
 <CALCETrXzzhoyzyqp5s7sSOkAtsR2Cor6j+x16OLv=+G30Y6+WQ@mail.gmail.com> <7f5916b5-01c0-52d5-9f44-dee4bf355212@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7f5916b5-01c0-52d5-9f44-dee4bf355212-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, May 8, 2017 at 3:34 PM, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
> On 2017-05-08 13:21, Andy Lutomirski wrote:

> Yes, it's an EFI thing. Unfortunately, I didn't make
> earlycon/earlyprintk work yet.

Quark does use HS UART for the console and we have no support for such
in x86/earlyprintk. earlycon should work if you add proper parameters
to the command line (including port base address, no ttySx), though I
don't remember if it makes really "early".

-- 
With Best Regards,
Andy Shevchenko
