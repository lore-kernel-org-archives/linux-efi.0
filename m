From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [tip:x86/mm] x86/boot/32: Defer resyncing initial_page_table
 until per-cpu is set up
Date: Mon, 8 May 2017 12:32:46 +0300
Message-ID: <CAHp75VdX-kUqW0MKOSTz9zByU-eipBMnKpdUbTt2SVOJ8Kvrig@mail.gmail.com>
References: <a553264a5972c6a86f9b5caac237470a0c74a720.1490218061.git.luto@kernel.org>
 <tip-23b2a4ddebdd17fad265b4bb77256c2e4ec37dee@git.kernel.org> <0c4d6d04-7038-fb82-87b3-343784550d0a@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0c4d6d04-7038-fb82-87b3-343784550d0a-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, May 8, 2017 at 9:31 AM, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
> On 2017-03-23 10:14, tip-bot for Andy Lutomirski wrote:
>> The x86 smpboot trampoline expects initial_page_table to have the
>> GDT mapped.  If the GDT ends up in a virtually mapped per-cpu page,
>> then it won't be in the page tables at all until perc-pu areas are
>> set up.  The result will be a triple fault the first time that the
>> CPU attempts to access the GDT after LGDT loads the perc-pu GDT.
>>
>> This appears to be an old bug, but somehow the GDT fixmap rework
>> is triggering it.  This seems to have something to do with the
>> memory layout.

> This breaks the boot on our Intel Quark platform (IOT2000, similar to
> Galileo Gen2). Reverting it over master makes it work again. Any idea
> what goes wrong? Let me know how I can help debugging this.

JFYI: As of today linux-next when _kexec:ed_ works fine to me

Perhaps I can test this later with direct boot from SD card.

-- 
With Best Regards,
Andy Shevchenko
