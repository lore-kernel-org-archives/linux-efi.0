From: Hedi Berriche <hedi.berriche@hpe.com>
Subject: Re: [Patch v2 1/4] efi/x86: turn EFI runtime semaphore into a global
 lock
Date: Tue, 12 Feb 2019 17:25:00 +0000
Message-ID: <20190212172500.GB6398@sarge.linuxathome.me>
References: <20190207042234.25109-1-hedi.berriche@hpe.com>
 <20190207042234.25109-2-hedi.berriche@hpe.com>
 <CAKv+Gu_7yb2tf86G1f-kA3g5TVb4imQFTeL9S5qwGhJHVsmgQw@mail.gmail.com>
 <20190207173808.GE6398@sarge.linuxathome.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190207173808.GE6398@sarge.linuxathome.me>
Sender: stable-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Bhupesh Sharma <bhsharma@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, linux-efi <linux-efi@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Russ Anderson <rja@hpe.com>, Mike Travis <mike.travis@hpe.com>, Dimitri Sivanich <sivanich@hpe.com>, Steve Wahl <steve.wahl@hpe.com>, stable <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 07, 2019 at 17:38 Hedi Berriche wrote:
>On Thu, Feb 07, 2019 at 16:05 Ard Biesheuvel wrote:
>>On Thu, 7 Feb 2019 at 05:23, Hedi Berriche <hedi.berriche@hpe.com> wrote:
>>>
>>>Make efi_runtime_lock semaphore global so that it can be used by EFI
>>>runtime callers that may be defined outside efi/runtime-wrappers.c.
>>>
>>>Also now that efi_runtime_lock semaphore is no longer static, rename it
>>>to efi_runtime_sem so it doesn't clash with the efi_runtime_lock spinlock
>>>defined in arch/x86/platform/efi/efi_64.c when CONFIG_EFI_MIXED is
>>>enabled.
>>>
>>>The immediate motivation of this change is to serialise UV platform BIOS
>>>calls using the efi_runtime_sem semaphore.
>>>
>>>No functional changes.
>>>
>>>Cc: Russ Anderson <rja@hpe.com>
>>>Cc: Mike Travis <mike.travis@hpe.com>
>>>Cc: Dimitri Sivanich <sivanich@hpe.com>
>>>Cc: Steve Wahl <steve.wahl@hpe.com>
>>>Cc: stable@vger.kernel.org
>>>Signed-off-by: Hedi Berriche <hedi.berriche@hpe.com>
>>
>>Hello Hedi,
>
>Hi Ard,
>
>>Same feedback as on v1: please don't rename the lock.
>
>With the efi_runtime_lock semaphore being no longer static, not renaming it
>will cause a compile failure as it will clash with the declaration of the
>efi_runtime_lock *spinlock* in arch/x86/platform/efi/efi_64.c in the
>CONFIG_EFI_MIXED case.

Ard,

Any comments on whether resolving the conflict between

	{efi_runtime_lock, drivers/firmware/efi/runtime-wrappers.c}

and
	{efi_runtime_lock, arch/x86/platform/efi/efi_64.c}

provides the required justification for renaming the efi_runtime_lock semaphore?

Cheers,
Hedi.

>>>---
>>> drivers/firmware/efi/runtime-wrappers.c | 60 ++++++++++++-------------
>>> include/linux/efi.h                     |  3 ++
>>> 2 files changed, 33 insertions(+), 30 deletions(-)
>>>
>>>diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
>>>index 8903b9ccfc2b..ec60d6227925 100644
>>>--- a/drivers/firmware/efi/runtime-wrappers.c
>>>+++ b/drivers/firmware/efi/runtime-wrappers.c
>>>@@ -53,7 +53,7 @@ struct efi_runtime_work efi_rts_work;
>>>  * @rts_arg<1-5>:      efi_runtime_service() function arguments
>>>  *
>>>  * Accesses to efi_runtime_services() are serialized by a binary
>>>- * semaphore (efi_runtime_lock) and caller waits until the work is
>>>+ * semaphore (efi_runtime_sem) and caller waits until the work is
>>>  * finished, hence _only_ one work is queued at a time and the caller
>>>  * thread waits for completion.
>>>  */
>>>@@ -144,7 +144,7 @@ void efi_call_virt_check_flags(unsigned long flags, const char *call)
>>>  * none of the remaining functions are actually ever called at runtime.
>>>  * So let's just use a single lock to serialize all Runtime Services calls.
>>>  */
>>>-static DEFINE_SEMAPHORE(efi_runtime_lock);
>>>+DEFINE_SEMAPHORE(efi_runtime_sem);
>>>
>>> /*
>>>  * Calls the appropriate efi_runtime_service() with the appropriate
>>>@@ -233,10 +233,10 @@ static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
>>> {
>>>        efi_status_t status;
>>>
>>>-       if (down_interruptible(&efi_runtime_lock))
>>>+       if (down_interruptible(&efi_runtime_sem))
>>>                return EFI_ABORTED;
>>>        status = efi_queue_work(GET_TIME, tm, tc, NULL, NULL, NULL);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>>        return status;
>>> }
>>>
>>>@@ -244,10 +244,10 @@ static efi_status_t virt_efi_set_time(efi_time_t *tm)
>>> {
>>>        efi_status_t status;
>>>
>>>-       if (down_interruptible(&efi_runtime_lock))
>>>+       if (down_interruptible(&efi_runtime_sem))
>>>                return EFI_ABORTED;
>>>        status = efi_queue_work(SET_TIME, tm, NULL, NULL, NULL, NULL);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>>        return status;
>>> }
>>>
>>>@@ -257,11 +257,11 @@ static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
>>> {
>>>        efi_status_t status;
>>>
>>>-       if (down_interruptible(&efi_runtime_lock))
>>>+       if (down_interruptible(&efi_runtime_sem))
>>>                return EFI_ABORTED;
>>>        status = efi_queue_work(GET_WAKEUP_TIME, enabled, pending, tm, NULL,
>>>                                NULL);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>>        return status;
>>> }
>>>
>>>@@ -269,11 +269,11 @@ static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
>>> {
>>>        efi_status_t status;
>>>
>>>-       if (down_interruptible(&efi_runtime_lock))
>>>+       if (down_interruptible(&efi_runtime_sem))
>>>                return EFI_ABORTED;
>>>        status = efi_queue_work(SET_WAKEUP_TIME, &enabled, tm, NULL, NULL,
>>>                                NULL);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>>        return status;
>>> }
>>>
>>>@@ -285,11 +285,11 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
>>> {
>>>        efi_status_t status;
>>>
>>>-       if (down_interruptible(&efi_runtime_lock))
>>>+       if (down_interruptible(&efi_runtime_sem))
>>>                return EFI_ABORTED;
>>>        status = efi_queue_work(GET_VARIABLE, name, vendor, attr, data_size,
>>>                                data);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>>        return status;
>>> }
>>>
>>>@@ -299,11 +299,11 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
>>> {
>>>        efi_status_t status;
>>>
>>>-       if (down_interruptible(&efi_runtime_lock))
>>>+       if (down_interruptible(&efi_runtime_sem))
>>>                return EFI_ABORTED;
>>>        status = efi_queue_work(GET_NEXT_VARIABLE, name_size, name, vendor,
>>>                                NULL, NULL);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>>        return status;
>>> }
>>>
>>>@@ -315,11 +315,11 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
>>> {
>>>        efi_status_t status;
>>>
>>>-       if (down_interruptible(&efi_runtime_lock))
>>>+       if (down_interruptible(&efi_runtime_sem))
>>>                return EFI_ABORTED;
>>>        status = efi_queue_work(SET_VARIABLE, name, vendor, &attr, &data_size,
>>>                                data);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>>        return status;
>>> }
>>>
>>>@@ -330,12 +330,12 @@ virt_efi_set_variable_nonblocking(efi_char16_t *name, efi_guid_t *vendor,
>>> {
>>>        efi_status_t status;
>>>
>>>-       if (down_trylock(&efi_runtime_lock))
>>>+       if (down_trylock(&efi_runtime_sem))
>>>                return EFI_NOT_READY;
>>>
>>>        status = efi_call_virt(set_variable, name, vendor, attr, data_size,
>>>                               data);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>>        return status;
>>> }
>>>
>>>@@ -350,11 +350,11 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
>>>        if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
>>>                return EFI_UNSUPPORTED;
>>>
>>>-       if (down_interruptible(&efi_runtime_lock))
>>>+       if (down_interruptible(&efi_runtime_sem))
>>>                return EFI_ABORTED;
>>>        status = efi_queue_work(QUERY_VARIABLE_INFO, &attr, storage_space,
>>>                                remaining_space, max_variable_size, NULL);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>>        return status;
>>> }
>>>
>>>@@ -369,12 +369,12 @@ virt_efi_query_variable_info_nonblocking(u32 attr,
>>>        if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
>>>                return EFI_UNSUPPORTED;
>>>
>>>-       if (down_trylock(&efi_runtime_lock))
>>>+       if (down_trylock(&efi_runtime_sem))
>>>                return EFI_NOT_READY;
>>>
>>>        status = efi_call_virt(query_variable_info, attr, storage_space,
>>>                               remaining_space, max_variable_size);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>>        return status;
>>> }
>>>
>>>@@ -382,11 +382,11 @@ static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
>>> {
>>>        efi_status_t status;
>>>
>>>-       if (down_interruptible(&efi_runtime_lock))
>>>+       if (down_interruptible(&efi_runtime_sem))
>>>                return EFI_ABORTED;
>>>        status = efi_queue_work(GET_NEXT_HIGH_MONO_COUNT, count, NULL, NULL,
>>>                                NULL, NULL);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>>        return status;
>>> }
>>>
>>>@@ -395,14 +395,14 @@ static void virt_efi_reset_system(int reset_type,
>>>                                  unsigned long data_size,
>>>                                  efi_char16_t *data)
>>> {
>>>-       if (down_interruptible(&efi_runtime_lock)) {
>>>+       if (down_interruptible(&efi_runtime_sem)) {
>>>                pr_warn("failed to invoke the reset_system() runtime service:\n"
>>>                        "could not get exclusive access to the firmware\n");
>>>                return;
>>>        }
>>>        efi_rts_work.efi_rts_id = RESET_SYSTEM;
>>>        __efi_call_virt(reset_system, reset_type, status, data_size, data);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>> }
>>>
>>> static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
>>>@@ -414,11 +414,11 @@ static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
>>>        if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
>>>                return EFI_UNSUPPORTED;
>>>
>>>-       if (down_interruptible(&efi_runtime_lock))
>>>+       if (down_interruptible(&efi_runtime_sem))
>>>                return EFI_ABORTED;
>>>        status = efi_queue_work(UPDATE_CAPSULE, capsules, &count, &sg_list,
>>>                                NULL, NULL);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>>        return status;
>>> }
>>>
>>>@@ -432,11 +432,11 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
>>>        if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
>>>                return EFI_UNSUPPORTED;
>>>
>>>-       if (down_interruptible(&efi_runtime_lock))
>>>+       if (down_interruptible(&efi_runtime_sem))
>>>                return EFI_ABORTED;
>>>        status = efi_queue_work(QUERY_CAPSULE_CAPS, capsules, &count,
>>>                                max_size, reset_type, NULL);
>>>-       up(&efi_runtime_lock);
>>>+       up(&efi_runtime_sem);
>>>        return status;
>>> }
>>>
>>>diff --git a/include/linux/efi.h b/include/linux/efi.h
>>>index 45ff763fba76..930cd20842b8 100644
>>>--- a/include/linux/efi.h
>>>+++ b/include/linux/efi.h
>>>@@ -1745,6 +1745,9 @@ extern struct efi_runtime_work efi_rts_work;
>>> /* Workqueue to queue EFI Runtime Services */
>>> extern struct workqueue_struct *efi_rts_wq;
>>>
>>>+/* EFI runtime semaphore */
>>>+extern struct semaphore efi_runtime_sem;
>>>+
>>> struct linux_efi_memreserve {
>>>        int             size;                   // allocated size of the array
>>>        atomic_t        count;                  // number of entries used
>>>--
>>>2.20.1
>>>
>
>-- 
>Be careful of reading health books, you might die of a misprint.
>	-- Mark Twain

-- 
Be careful of reading health books, you might die of a misprint.
	-- Mark Twain
