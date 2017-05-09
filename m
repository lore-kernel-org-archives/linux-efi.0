From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [tip:x86/mm] x86/boot/32: Defer resyncing initial_page_table
 until per-cpu is set up
Date: Mon, 8 May 2017 17:03:44 -0700
Message-ID: <CALCETrUpXnfDEPTnhYppUemV3+Np-DE6ZNdv9QBHq9WB0ac3hw@mail.gmail.com>
References: <a553264a5972c6a86f9b5caac237470a0c74a720.1490218061.git.luto@kernel.org>
 <tip-23b2a4ddebdd17fad265b4bb77256c2e4ec37dee@git.kernel.org>
 <0c4d6d04-7038-fb82-87b3-343784550d0a@siemens.com> <CAHp75VdX-kUqW0MKOSTz9zByU-eipBMnKpdUbTt2SVOJ8Kvrig@mail.gmail.com>
 <CALCETrXzzhoyzyqp5s7sSOkAtsR2Cor6j+x16OLv=+G30Y6+WQ@mail.gmail.com>
 <7f5916b5-01c0-52d5-9f44-dee4bf355212@siemens.com> <7ce941e5-5a9b-acd7-c7b6-7be464572de5@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7ce941e5-5a9b-acd7-c7b6-7be464572de5-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, x86 <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, May 8, 2017 at 10:53 AM, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
> On 2017-05-08 14:34, Jan Kiszka wrote:
>> On 2017-05-08 13:21, Andy Lutomirski wrote:
>>> On Mon, May 8, 2017 at 2:32 AM, Andy Shevchenko
>>> <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> On Mon, May 8, 2017 at 9:31 AM, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
>>>>> On 2017-03-23 10:14, tip-bot for Andy Lutomirski wrote:
>>>>>> The x86 smpboot trampoline expects initial_page_table to have the
>>>>>> GDT mapped.  If the GDT ends up in a virtually mapped per-cpu page,
>>>>>> then it won't be in the page tables at all until perc-pu areas are
>>>>>> set up.  The result will be a triple fault the first time that the
>>>>>> CPU attempts to access the GDT after LGDT loads the perc-pu GDT.
>>>>>>
>>>>>> This appears to be an old bug, but somehow the GDT fixmap rework
>>>>>> is triggering it.  This seems to have something to do with the
>>>>>> memory layout.
>>>>
>>>>> This breaks the boot on our Intel Quark platform (IOT2000, similar to
>>>>> Galileo Gen2). Reverting it over master makes it work again. Any idea
>>>>> what goes wrong? Let me know how I can help debugging this.
>>>>
>>>> JFYI: As of today linux-next when _kexec:ed_ works fine to me
>>>>
>>>> Perhaps I can test this later with direct boot from SD card.
>>>>
>>>
>>> The most likely explanation is that there's some code that needs the
>>> page table synced and runs before setup_per_cpu_areas().  The relevant
>>> init code is:
>>>
>>>     setup_arch(&command_line);
>>>     mm_init_cpumask(&init_mm);
>>>     setup_command_line(command_line);
>>>     setup_nr_cpu_ids();
>>>     setup_per_cpu_areas();
>>>
>>> so I didn't move it very far.  It would be awesome if we could get a
>>> backtrace when the failure happens, but it's likely to be a triple
>>> fault.  Is this an EFI boot?  I bet the failure is in efi_init().
>>
>> Yes, it's an EFI thing. Unfortunately, I didn't make
>> earlycon/earlyprintk work yet.
>>
>>>
>>> Could you try reverting just the deletions in the patch?  I.e. try a
>>> kernel with both the old and the new copies of the code I moved.
>>
>> Let me try that later. I can also move the new code around to nail down
>> the dependency.
>>
>
> I found the reason: your patch is very discriminating! Not the whole
> world is multicore yet. ;)
>
> setup_per_cpu_areas() is taken from mm/percpu.c in case of !CONFIG_SMP.
> So the new home for the resync is not even built.

D'oh!

>
> Any suggestions how to refactor things instead?

efi_init() seems okay, but it makes me nervous.  I think the partial
revert is the right fix.  Patch coming.

>
> Jan
>
> --
> Siemens AG, Corporate Technology, CT RDA ITP SES-DE
> Corporate Competence Center Embedded Linux
