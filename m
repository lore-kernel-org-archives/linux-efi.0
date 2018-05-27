From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH V4 0/3] Use efi_rts_wq to invoke EFI Runtime Services
Date: Sun, 27 May 2018 10:19:46 +0200
Message-ID: <CAKv+Gu96gURHioy7hRLW2reyUwYMQDSLHhGE=m_TOz9CYF_Tjw@mail.gmail.com>
References: <1527285903-31799-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu_oNUmOwTgM9sAsfMn4WgY+grC2f12vRC4HH9CgxxkfXQ@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F39481456@ORSMSX114.amr.corp.intel.com>
 <CAKv+Gu_eShqmjkDSXnFs-_Hcay67+JTMdb6TatNZpV2v5_MoaQ@mail.gmail.com> <FFF73D592F13FD46B8700F0A279B802F3952F0CF@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F3952F0CF@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Naresh Bhat <naresh.bhat@linaro.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Williams, Dan J" <dan.j.williams@intel.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

On 27 May 2018 at 07:32, Prakhya, Sai Praneeth
<sai.praneeth.prakhya@intel.com> wrote:
>> > Assume some user requested to execute some non-blocking variant of
>> > efi_rts and the kernel hasn't called efi_call_virt() yet, but was
>> > scheduled out. IOW, even though user requests for non-blocking efi call, we
>> might still block. Am I right?
>> >
>>
>> No, that is the whole point. These functions may be called from atomic context,
>> which is why they trylock() and give up rather than block on the semaphore if a rt
>> services call is already in progress. E.g.,
>>
>> /*
>>  * efivar_entry_set_nonblocking - call set_variable_nonblocking()
>>  *
>>  * This function is guaranteed to not block and is suitable for calling
>>  * from crash/panic handlers.
>>  *
>>  * Crucially, this function will not block if it cannot acquire
>>  * efivars_lock. Instead, it returns -EBUSY.
>>  */
>>
>
> One more question again, if we are sure that non-blocking variants will
> _always_ be called in atomic context, then, we got it covered. Because, in
> set_variable() and query_variable_info() (both blocking and non-blocking) we check
> for in_atomic() and if so, we don't use efi_rts_wq (please refer to patch 3).
>
> If you think, there might be a probability of calling non-blocking efi_rts out of atomic
> context, then, sure! Let's make them never use efi_rts_wq.
>

This is not about what happens to be the current situation. It is about the API.

The non-blocking functions should never block, period. They either
fail gracefully or perform their duties without sleeping.

In this particular case, I think it is useful to have a guaranteed
non-blocking version, not only to delete the dummy EFI variable, but
potentially in other future cases as well, given that they can be
called much earlier in the boot (when the perf/%cr3 issue is not a
concern to begin with)
