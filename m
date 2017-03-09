From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [Xen-devel] [PATCH v5 2/3] x86: Remap GDT tables in the Fixmap section
Date: Thu, 9 Mar 2017 13:54:16 -0800
Message-ID: <CAJcbSZExVWA0jvAoxLLc+58Ag9cHchifrHP=fFfzU_onHo2PyA@mail.gmail.com>
References: <20170306220348.79702-1-thgarnie@google.com> <20170306220348.79702-2-thgarnie@google.com>
 <CALCETrVXHc-EAhBtdhL9FXSW1G2VbohRY4UJuOtpRG1K0Q-Ogg@mail.gmail.com>
 <17ffcc5b-1c9a-51b6-272a-5eaecf1bc0c4@citrix.com> <CALCETrWv-u7OdjWDY+5eF7p-ngPun-yYf0QegMzYc6MGVQd-4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CALCETrWv-u7OdjWDY+5eF7p-ngPun-yYf0QegMzYc6MGVQd-4w@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Michal Hocko <mhocko@suse.com>, Stanislaw Gruszka <sgruszka@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, Fenghua Yu <fenghua.yu@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Alexander Potapenko <glider@google.com>, Pavel Machek <pavel@ucw.cz>, "H . Peter Anvin" <hpa@zytor.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jiri Olsa <jolsa@redhat.com>, zijun_hu <zijun_hu@htc.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 9, 2017 at 1:46 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Mar 9, 2017 at 1:43 PM, Andrew Cooper <andrew.cooper3@citrix.com> wrote:
>> On 09/03/2017 21:32, Andy Lutomirski wrote:
>>> On Mon, Mar 6, 2017 at 2:03 PM, Thomas Garnier <thgarnie@google.com> wrote:
>>>
>>>> --- a/arch/x86/xen/enlighten.c
>>>> +++ b/arch/x86/xen/enlighten.c
>>>> @@ -710,7 +710,7 @@ static void load_TLS_descriptor(struct thread_struct *t,
>>>>
>>>>         *shadow = t->tls_array[i];
>>>>
>>>> -       gdt = get_cpu_gdt_table(cpu);
>>>> +       gdt = get_cpu_gdt_rw(cpu);
>>>>         maddr = arbitrary_virt_to_machine(&gdt[GDT_ENTRY_TLS_MIN+i]);
>>>>         mc = __xen_mc_entry(0);
>>> Boris, is this right?  I don't see why it wouldn't be, but Xen is special.
>>
>> Under Xen PV, the GDT is already read-only at this point.  (It is not
>> safe to let the guest have writeable access to system tables, so the
>> guest must relinquish write access to the frames wishing to be used as
>> LDTs or GDTs.)
>>
>> The hypercall acts on the frame, not a virtual address, so either alias
>> should be fine here.
>>
>> Under this new scheme, there will be two read-only aliases.  I guess
>> this is easier to maintain the split consistently across Linux, than to
>> special case Xen PV because it doesn't need the second alias.
>>
>
> I think we would gain nothing at all by special-casing Xen PV -- Linux
> allocates the fixmap vaddrs at compile time, so we'd still allocate
> them even if we rejigger all the helpers to avoid using them.
>

I don't have any experience with Xen so it would be great if virtme can test it.

I can remove the unused functions, I just thought they were useful
shortcuts given some of them are already used.

> --Andy



-- 
Thomas

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
