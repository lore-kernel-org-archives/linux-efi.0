From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [tip:x86/mm] x86/boot/32: Defer resyncing initial_page_table
 until per-cpu is set up
Date: Mon, 8 May 2017 14:34:13 +0200
Message-ID: <7f5916b5-01c0-52d5-9f44-dee4bf355212@siemens.com>
References: <a553264a5972c6a86f9b5caac237470a0c74a720.1490218061.git.luto@kernel.org>
 <tip-23b2a4ddebdd17fad265b4bb77256c2e4ec37dee@git.kernel.org>
 <0c4d6d04-7038-fb82-87b3-343784550d0a@siemens.com>
 <CAHp75VdX-kUqW0MKOSTz9zByU-eipBMnKpdUbTt2SVOJ8Kvrig@mail.gmail.com>
 <CALCETrXzzhoyzyqp5s7sSOkAtsR2Cor6j+x16OLv=+G30Y6+WQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXzzhoyzyqp5s7sSOkAtsR2Cor6j+x16OLv=+G30Y6+WQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Brian Gerst <brgerst@gmail.com>, Thomas Garnier <thgarnie@google.com>, Denys Vlasenko <dvlasenk@redhat.com>, Juergen Gross <jgross@suse.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On 2017-05-08 13:21, Andy Lutomirski wrote:
> On Mon, May 8, 2017 at 2:32 AM, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
>> On Mon, May 8, 2017 at 9:31 AM, Jan Kiszka <jan.kiszka@siemens.com> wrote:
>>> On 2017-03-23 10:14, tip-bot for Andy Lutomirski wrote:
>>>> The x86 smpboot trampoline expects initial_page_table to have the
>>>> GDT mapped.  If the GDT ends up in a virtually mapped per-cpu page,
>>>> then it won't be in the page tables at all until perc-pu areas are
>>>> set up.  The result will be a triple fault the first time that the
>>>> CPU attempts to access the GDT after LGDT loads the perc-pu GDT.
>>>>
>>>> This appears to be an old bug, but somehow the GDT fixmap rework
>>>> is triggering it.  This seems to have something to do with the
>>>> memory layout.
>>
>>> This breaks the boot on our Intel Quark platform (IOT2000, similar to
>>> Galileo Gen2). Reverting it over master makes it work again. Any idea
>>> what goes wrong? Let me know how I can help debugging this.
>>
>> JFYI: As of today linux-next when _kexec:ed_ works fine to me
>>
>> Perhaps I can test this later with direct boot from SD card.
>>
> 
> The most likely explanation is that there's some code that needs the
> page table synced and runs before setup_per_cpu_areas().  The relevant
> init code is:
> 
>     setup_arch(&command_line);
>     mm_init_cpumask(&init_mm);
>     setup_command_line(command_line);
>     setup_nr_cpu_ids();
>     setup_per_cpu_areas();
> 
> so I didn't move it very far.  It would be awesome if we could get a
> backtrace when the failure happens, but it's likely to be a triple
> fault.  Is this an EFI boot?  I bet the failure is in efi_init().

Yes, it's an EFI thing. Unfortunately, I didn't make
earlycon/earlyprintk work yet.

> 
> Could you try reverting just the deletions in the patch?  I.e. try a
> kernel with both the old and the new copies of the code I moved.

Let me try that later. I can also move the new code around to nail down
the dependency.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux
