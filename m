From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/7] efi: run UEFI services with interrupts enabled
Date: Fri, 18 Dec 2015 14:20:40 +0100
Message-ID: <CAKv+Gu8Hu4JTMU0Tp18T=hqEkwSAO7V0PU9oDRrMsy2Vx-a=kg@mail.gmail.com>
References: <1450089631-26791-1-git-send-email-ard.biesheuvel@linaro.org>
	<20151218131543.GC2638@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151218131543.GC2638-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 December 2015 at 14:15, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Mon, 14 Dec, at 11:40:24AM, Ard Biesheuvel wrote:
>> The UEFI spec does not require interrupts to be disabled when invoking
>> runtime services. The reason we have been doing so is because EFI pstore
>> may call SetVariable() from interrupt context, which may result in deadlock
>> if another runtime services call was in progress on the same cpu.
>
>> The EFI pstore has already been updated to use a non-blocking path and fail
>> gracefully rather than spin forever, so we can update the ordinary blocking
>> wrappers to run with interrupts enabled instead. This aims to prevent excessive
>> interrupt latencies on uniprocessor platforms with slow variable stores.
>>
>> Changes since v2:
>> - folded Matt's suggestion for patch #4, to bail rather than try to trigger a
>>   garbage collection in the nonblocking case when there is insufficient space
>> - rebased onto v4.4-rc5
>>
>> Changes since v1:
>> - added nonblocking QueryVariableInfo() wrapper variant, and updated
>>   efi_query_variable_store() to use it when called in nonblocking context
>> - add patch to drop the rtc_lock spinlock
>> - add patch to drop redundant efi_set_variable_nonblocking_t typedef
>> - drop BUG_ONs in patch #7
>>
>> Ard Biesheuvel (7):
>>   efi: expose non-blocking set_variable() wrapper to efivars
>>   efi: remove redundant efi_set_variable_nonblocking prototype
>>   efi: runtime-wrappers: add a nonblocking version of QueryVariableInfo
>>   efi: add nonblocking option to efi_query_variable_store()
>>   efi: runtime-wrappers: remove out of date comment regarding in_nmi()
>>   efi: runtime-wrapper: get rid of the rtc_lock spinlock
>>   efi: runtime-wrappers: run UEFI Runtime Services with interrupts
>>     enabled
>>
>>  arch/x86/platform/efi/quirks.c          |  33 +++++-
>>  drivers/firmware/efi/efi.c              |   1 +
>>  drivers/firmware/efi/runtime-wrappers.c | 115 +++++++-------------
>>  drivers/firmware/efi/vars.c             |  16 ++-
>>  include/linux/efi.h                     |  21 ++--
>>  5 files changed, 100 insertions(+), 86 deletions(-)
>
> Thanks Ard, this all looks good to me. I've queued this up. It's a
> little late for v4.5 now, so this will probably be targeting v4.6.

Either is fine by me, as long as it is in the pipeline.

Thanks,
Ard.
