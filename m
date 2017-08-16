From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 3/3] x86/efi: Use efi_switch_mm() rather than manually
 twiddling with cr3
Date: Wed, 16 Aug 2017 10:31:12 +0100
Message-ID: <CAKv+Gu8AySQSXtRWfHA4y5DbH-DQ7jpqkp=tS+snSTar_sKBJw@mail.gmail.com>
References: <1502824706-30762-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1502824706-30762-4-git-send-email-sai.praneeth.prakhya@intel.com> <CALCETrUnT0YL_F3mXyJzi=NE5jvFUUQbwjdK5224zDKkTts-UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUnT0YL_F3mXyJzi=NE5jvFUUQbwjdK5224zDKkTts-UQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Peter Zijlstra <peterz@infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, joeyli <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Michael S. Tsirkin" <mst@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Ravi V. Shankar" <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

(+ Mark, Will)

On 15 August 2017 at 22:46, Andy Lutomirski <luto@kernel.org> wrote:
> On Tue, Aug 15, 2017 at 12:18 PM, Sai Praneeth Prakhya
> <sai.praneeth.prakhya@intel.com> wrote:
>> +/*
>> + * Makes the calling kernel thread switch to/from efi_mm context
>> + * Can be used from SetVirtualAddressMap() or during efi runtime calls
>> + * (Note: This routine is heavily inspired from use_mm)
>> + */
>> +void efi_switch_mm(struct mm_struct *mm)
>> +{
>> +       struct task_struct *tsk = current;
>> +
>> +       task_lock(tsk);
>> +       efi_scratch.prev_mm = tsk->active_mm;
>> +       if (efi_scratch.prev_mm != mm) {
>> +               mmgrab(mm);
>> +               tsk->active_mm = mm;
>> +       }
>> +       switch_mm(efi_scratch.prev_mm, mm, NULL);
>> +       task_unlock(tsk);
>> +
>> +       if (efi_scratch.prev_mm != mm)
>> +               mmdrop(efi_scratch.prev_mm);
>
> I'm confused.  You're mmdropping an mm that you are still keeping a
> pointer to.  This is also a bit confusing in the case where you do
> efi_switch_mm(efi_scratch.prev_mm).
>
> This whole manipulation seems fairly dangerous to me for another
> reason -- you're taking a user thread (I think) and swapping out its
> mm to something that the user in question should *not* have access to.
> What if a perf interrupt happens while you're in the alternate mm?
> What if you segfault and dump core?  Should we maybe just have a flag
> that says "this cpu is using a funny mm", assert that the flag is
> clear when scheduling, and teach perf, coredumps, etc not to touch
> user memory when the flag is set?
>

It appears we may have introduced this exact issue on arm64 and ARM by
starting to run the UEFI runtime services with interrupts enabled.
(perf does not use NMI on ARM, so the issue did not exist beforehand)

Mark, Will, any thoughts?
