From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 3/3] x86/efi: Use efi_switch_mm() rather than manually
 twiddling with cr3
Date: Fri, 25 Aug 2017 08:13:46 -0700
Message-ID: <CALCETrUxBDpszWcPG9_s2aFW5Wkt6iKUXOsYFvwD19Y58uu6MQ@mail.gmail.com>
References: <1502824706-30762-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1502824706-30762-4-git-send-email-sai.praneeth.prakhya@intel.com>
 <CALCETrUnT0YL_F3mXyJzi=NE5jvFUUQbwjdK5224zDKkTts-UQ@mail.gmail.com> <1503628588.30475.61.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503628588.30475.61.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, joeyli <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Michael S. Tsirkin" <mst@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Aug 24, 2017 at 7:36 PM, Sai Praneeth Prakhya
<sai.praneeth.prakhya@intel.com> wrote:
> On Tue, 2017-08-15 at 14:46 -0700, Andy Lutomirski wrote:
>> On Tue, Aug 15, 2017 at 12:18 PM, Sai Praneeth Prakhya
>> <sai.praneeth.prakhya@intel.com> wrote:
>> > +/*
>> > + * Makes the calling kernel thread switch to/from efi_mm context
>> > + * Can be used from SetVirtualAddressMap() or during efi runtime calls
>> > + * (Note: This routine is heavily inspired from use_mm)
>> > + */
>> > +void efi_switch_mm(struct mm_struct *mm)
>> > +{
>> > +       struct task_struct *tsk = current;
>> > +
>> > +       task_lock(tsk);
>> > +       efi_scratch.prev_mm = tsk->active_mm;
>> > +       if (efi_scratch.prev_mm != mm) {
>> > +               mmgrab(mm);
>> > +               tsk->active_mm = mm;
>> > +       }
>> > +       switch_mm(efi_scratch.prev_mm, mm, NULL);
>> > +       task_unlock(tsk);
>> > +
>> > +       if (efi_scratch.prev_mm != mm)
>> > +               mmdrop(efi_scratch.prev_mm);
>>
>> I'm confused.  You're mmdropping an mm that you are still keeping a
>> pointer to.  This is also a bit confusing in the case where you do
>> efi_switch_mm(efi_scratch.prev_mm).
>>
>> This whole manipulation seems fairly dangerous to me for another
>> reason -- you're taking a user thread (I think) and swapping out its
>> mm to something that the user in question should *not* have access to.
>> What if a perf interrupt happens while you're in the alternate mm?
>> What if you segfault and dump core?  Should we maybe just have a flag
>> that says "this cpu is using a funny mm", assert that the flag is
>> clear when scheduling, and teach perf, coredumps, etc not to touch
>> user memory when the flag is set?
>>
>> Admittedly, the latter problem may well have existed even before these patches.
>
> Hi All,
>
> Could we please decouple the above issue from this patch set, so that we
> could have common efi_mm between x86 and ARM and also improve
> readability and maintainability for x86/efi.

I don't see why not.

>
> As it seems that "Everything EFI as kthread" might solve the above issue
> for real (which might take quite some time to implement, taking into
> consideration the complexity involved and some special case with
> pstore), do you think this patch set seems OK?
>
> If so, I will send out a V2 addressing the mmdropping issue.
>
> Regards,
> Sai
>
