From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH V4 0/3] Use efi_rts_wq to invoke EFI Runtime Services
Date: Sat, 26 May 2018 08:32:37 +0200
Message-ID: <CAKv+Gu_eShqmjkDSXnFs-_Hcay67+JTMdb6TatNZpV2v5_MoaQ@mail.gmail.com>
References: <1527285903-31799-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu_oNUmOwTgM9sAsfMn4WgY+grC2f12vRC4HH9CgxxkfXQ@mail.gmail.com> <FFF73D592F13FD46B8700F0A279B802F39481456@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F39481456@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Naresh Bhat <naresh.bhat@linaro.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Williams, Dan J" <dan.j.williams@intel.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

On 26 May 2018 at 01:08, Prakhya, Sai Praneeth
<sai.praneeth.prakhya@intel.com> wrote:
>> > Changes from V3 to V4:
>> > ----------------------
>> > 1. As suggested by Peter, use completions instead of flush_work() as the
>> >   former is cheaper
>> > 2. Call efi_delete_dummy_variable() from efisubsys_init(). Sorry! Ard,
>> >   wasn't able to find a better alternative to keep this change local to
>> >   arch/x86.
>> >
>>
>> Two questions:
>> - Should the non-blocking variants of the query and set_variable_store use the
>> work queue? Doesn't that make them blocking?
>
> That's a good question . I think you are right, calling non-blocking variants of efi_rts
> using work queues makes them blocking. But, I have a follow on question.
>
> Assume some user requested to execute some non-blocking variant of efi_rts and
> the kernel hasn't called efi_call_virt() yet, but was scheduled out. IOW, even though
> user requests for non-blocking efi call, we might still block. Am I right?
>

No, that is the whole point. These functions may be called from atomic
context, which is why they trylock() and give up rather than block on
the semaphore if a rt services call is already in progress. E.g.,

/*
 * efivar_entry_set_nonblocking - call set_variable_nonblocking()
 *
 * This function is guaranteed to not block and is suitable for calling
 * from crash/panic handlers.
 *
 * Crucially, this function will not block if it cannot acquire
 * efivars_lock. Instead, it returns -EBUSY.
 */

> With efi_rts_wq, I think, I have increased the window of getting blocked. With efi_rts_wq,
> kernel should explicitly call schedule() to run firmware and the chances of getting blocked
> are much more.
>
> Expect this increased window, I think firmware should be executed as before.
>
> So, can you please explain me the difference between blocking and non-blocking variants
> from kernel perspective?
> (the way we get locks are different down_interruptible() vs down_trylock())
>
>> - If the non-blocking set_variable() does not use the work queue, can we just call
>> it from efi_delete_dummy_variable(), and keep the calls where they are?
>
> Yes, I think we can do that (if we don't use efi_rts_wq for non-blocking variants).
>

OK, then please implement that change.

Thanks,
Ard.
