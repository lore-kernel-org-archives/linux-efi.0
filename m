From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH V7 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Thu, 19 Jan 2017 17:57:16 +0000
Message-ID: <5880FDFC.7060304@arm.com>
References: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org>
 <1484244924-24786-6-git-send-email-tbaicar@codeaurora.org>
 <587F80A7.10008@arm.com>
 <3de443d7-2c68-f179-daae-bc8f851470b7@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <3de443d7-2c68-f179-daae-bc8f851470b7@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Baicar, Tyler" <tbaicar@codeaurora.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

On 18/01/17 23:51, Baicar, Tyler wrote:
> On 1/18/2017 7:50 AM, James Morse wrote:
>> On 12/01/17 18:15, Tyler Baicar wrote:
>>> ARM APEI extension proposal added SEA (Synchrounous External
>>> Abort) notification type for ARMv8.
>>> Add a new GHES error source handling function for SEA. If an error
>>> source's notification type is SEA, then this function can be registered
>>> into the SEA exception handler. That way GHES will parse and report
>>> SEA exceptions when they occur.
>>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>>> index 2acbc60..87efe26 100644
>>> --- a/drivers/acpi/apei/ghes.c
>>> +++ b/drivers/acpi/apei/ghes.c
>>> @@ -767,6 +772,62 @@ static struct notifier_block ghes_notifier_sci = {
>>>       .notifier_call = ghes_notify_sci,
>>>   };
>>>   +#ifdef CONFIG_HAVE_ACPI_APEI_SEA
>>> +static LIST_HEAD(ghes_sea);
>>> +
>>> +static int ghes_notify_sea(struct notifier_block *this,
>>> +                  unsigned long event, void *data)
>>> +{
>>> +    struct ghes *ghes;
>>> +    int ret = NOTIFY_DONE;
>>> +
>>> +    nmi_enter();

>> Can we move this into the arch code? Its because we got here from a
>> synchronous-exception that makes this nmi-like, I think it only makes sense for
>> it be called from under /arch/.

> So move the nmi_enter/exit calls into do_sea of the previous patch? I can do
> that in the next patchset.

>> Where did the rcu_read_lock() go? I can see its missing from ghes_notify_nmi()
>> too, but I don't know enough about RCU to know if that's safe!
>>
>> The second paragraph in the comment above rcu_read_lock() describes it as
>> preventing call_rcu() during a read-side critical section that was running
>> concurrently. Doesn't this mean we can race with ghes_sea_remove() on another
>> CPU because we wait for the wrong grace period?
>>
>> The same comment talks about how these read-side critical sections can nest, so
>> I think its quite safe to make these 'lock' calls here.

> Sorry, I thought we wanted nmi_enter/exit instead of the rcu_read_lock/unlock. I
> guess the rcu locks
> will not cause the deadlock scenario you described in the previous patchset if
> we have the
> nmi_enter/exit wrapped around the rcu critical section.

Ah, not instead of, (well, not initially!).
The nmi_enter()/nmi_exit() thing was to fix the APEI interrupting APEI problem.
This is only a problem for notification types which can interrupt
interrupts-masked code, of which SEA is one. (and x86's NMI is the other).

I think I've found the answer to why the rcu_read_lock() isn't needed.
synchronize_sched() has:
> * This means that all preempt_disable code sequences, including NMI and
> * non-threaded hardware-interrupt handlers, in progress on entry will
> * have completed before this primitive returns.

synchronize_rcu() has the same innards, so I'm convinced this its safe not to
have those calls in here. Could we have a comment along the lines of:
> synchronize_rcu() will wait for nmi_exit(), so no need to rcu_read_lock().

(The more I learn about RCU the scarier it becomes!)


There are two other things that need changing to make the in_nmi() code path
work on arm64.
Always reserve the virtual-address-space forcing GHES_IOREMAP_PAGES to be 2
regardless of CONFIG_HAVE_ACPI_APEI_NMI. This is almost revert of
594c7255dce7a13cac50cf2470cc56e2c3b0494e (but that did a few other things too).

We also need to fix ghes_ioremap_pfn_nmi() to use arch_apei_get_mem_attribute()
and not assume PAGE_KERNEL.


Thanks,

James
