From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: [PATCH V2 2/3] efi: Introduce efi_rts_workqueue and some
 infrastructure to invoke all efi_runtime_services()
Date: Thu, 8 Mar 2018 10:12:27 +0100
Message-ID: <CANiq72krjVviT0mPqpK5jbLWEbDx_OhG6+eUmyT8thZPEjkJKg@mail.gmail.com>
References: <1520292190-5027-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1520292190-5027-3-git-send-email-sai.praneeth.prakhya@intel.com>
 <CANiq72m6_WCXSrBPesgvO1rsF1_AT5Jod_rY-y1f4JjO-SMCDg@mail.gmail.com> <FFF73D592F13FD46B8700F0A279B802F2E5817F2@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F2E5817F2@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Lee@vger.kernel.org" <Lee@vger.kernel.org>, Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Zijlstra, Peter" <peter.zijlstra@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 8, 2018 at 5:22 AM, Prakhya, Sai Praneeth
<sai.praneeth.prakhya@intel.com> wrote:
>> > +struct workqueue_struct *efi_rts_wq;
>> > +
>> >  static bool disable_runtime;
>> >  static int __init setup_noefi(char *arg)  { @@ -329,6 +331,19 @@
>> > static int __init efisubsys_init(void)
>> >                 return 0;
>> >
>> >         /*
>> > +        * Since we process only one efi_runtime_service() at a time, an
>> > +        * ordered workqueue (which creates only one execution context)
>> > +        * should suffice all our needs.
>> > +        */
>> > +       efi_rts_wq = alloc_ordered_workqueue("efi_rts_workqueue", 0);
>>
>> efi_rts_wq or efi_rts_workqueue?
>>
>> > +       if (!efi_rts_wq) {
>> > +               pr_err("Failed to create efi_rts_workqueue, EFI runtime services "
>>
>> Same here.
>
> Sure! I will make it consistent with "efi_rts_wq". Just tried to be more verbose
> with names :)
>

It is not a big deal, but using the exact same name is better for the
purposes of grepping and things like that :-) By the way, check the
commit title/message, there are some others there too.

> [...]
>
>> > +#define efi_queue_work(_rts, _arg1, _arg2, _arg3, _arg4, _arg5)                \
>> > +({                                                                     \
>> > +       struct efi_runtime_work efi_rts_work;                           \
>> > +                                                                       \
>> > +       INIT_WORK_ONSTACK(&efi_rts_work.work, efi_call_rts);            \
>> > +       efi_rts_work.func = _rts;                                       \
>> > +       efi_rts_work.arg1 = _arg1;                                      \
>> > +       efi_rts_work.arg2 = _arg2;                                      \
>> > +       efi_rts_work.arg3 = _arg3;                                      \
>> > +       efi_rts_work.arg4 = _arg4;                                      \
>> > +       efi_rts_work.arg5 = _arg5;                                      \
>> > +       /*                                                              \
>> > +        * queue_work() returns 0 if work was already on queue,         \
>> > +        * _ideally_ this should never happen.                          \
>> > +        */                                                             \
>> > +       if (queue_work(efi_rts_wq, &efi_rts_work.work))                 \
>> > +               flush_work(&efi_rts_work.work);                         \
>> > +       else                                                            \
>> > +               BUG();                                                  \
>>
>> Thanks for the change! One remark, I would just do:
>
> Sorry! but I am planning to remove BUG(). Looks like it could defeat the purpose
> of patch. Please see Boris comments on the other thread.

No problem. Let's see how it looks in v3 :-)

>
> [...]
>
>> > +/*
>> > + * efi_runtime_work:   Details of EFI Runtime Service work
>> > + * @func:              EFI Runtime Service function identifier
>> > + * @arg<1-5>:          EFI Runtime Service function arguments
>> > + * @status:            Status of executing EFI Runtime Service
>> > + */
>> > +struct efi_runtime_work {
>> > +       u8 func;
>> > +       void *arg1;
>> > +       void *arg2;
>> > +       void *arg3;
>> > +       void *arg4;
>> > +       void *arg5;
>> > +       efi_status_t status;
>> > +       struct work_struct work;
>> > +};
>>
>> Why is efi_runtime_work in the .h at all?
>>
>
> Thanks for the catch. I will move it to runtime-wrappers.c file and will make it
> static too. It isn't being used in any other place.
>
>> Please CC me for the next version! :-)
>
> Sure! Sorry for that. I should have done in V2.

Thanks!

Cheers,
Miguel

>
> Regards,
> Sai
