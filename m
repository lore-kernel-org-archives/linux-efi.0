From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: Fix debugobjects warning on efi_rts_work
Date: Mon, 5 Nov 2018 14:01:50 +0100
Message-ID: <CAKv+Gu-JrZ+7VMbFt0u5_QWGJPJ=Dm+9FjbsKFEeHwfAwj_2wQ@mail.gmail.com>
References: <1540304307-2806-1-git-send-email-longman@redhat.com> <FFF73D592F13FD46B8700F0A279B802F485D622C@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F485D622C@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: Waiman Long <longman@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 23 October 2018 at 18:43, Prakhya, Sai Praneeth
<sai.praneeth.prakhya@intel.com> wrote:
>
>
>> -----Original Message-----
>> From: Waiman Long [mailto:longman@redhat.com]
>> Sent: Tuesday, October 23, 2018 7:18 AM
>> To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Cc: linux-efi@vger.kernel.org; linux-kernel@vger.kernel.org; Prakhya, Sai
>> Praneeth <sai.praneeth.prakhya@intel.com>; Waiman Long
>> <longman@redhat.com>
>> Subject: [PATCH] efi: Fix debugobjects warning on efi_rts_work
>>
>> The commit 9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault
>> handler") converted efi_rts_work from an auto variable to a global variable.
>> However, when submitting the work, INIT_WORK_ONSTACK() was still used
>> causing the following complaint from debugobjects:
>>
>> ODEBUG: object 00000000ed27b500 is NOT on stack 00000000c7d38760, but
>> annotated.
>>
>> Change the macro to just INIT_WORK() to eliminate the warning.
>>
>> Fixes: 9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault
>> handler")
>
> Thanks for fixing this :)
> Looks good to me.
>
> Regards,
> Sai

Thanks

Queued in efi/urgent (with Sai's ack)
