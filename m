From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V7 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Wed, 18 Jan 2017 16:51:05 -0700
Message-ID: <3de443d7-2c68-f179-daae-bc8f851470b7@codeaurora.org>
References: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org>
 <1484244924-24786-6-git-send-email-tbaicar@codeaurora.org>
 <587F80A7.10008@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <587F80A7.10008@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

Hello James,


On 1/18/2017 7:50 AM, James Morse wrote:
> Hi Tyler,
>
> On 12/01/17 18:15, Tyler Baicar wrote:
>> ARM APEI extension proposal added SEA (Synchrounous External
> Nit: Synchronous
I'll fix that :)
>> Abort) notification type for ARMv8.
>> Add a new GHES error source handling function for SEA. If an error
>> source's notification type is SEA, then this function can be registered
>> into the SEA exception handler. That way GHES will parse and report
>> SEA exceptions when they occur.
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index 2acbc60..87efe26 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -767,6 +772,62 @@ static struct notifier_block ghes_notifier_sci = {
>>   	.notifier_call = ghes_notify_sci,
>>   };
>>   
>> +#ifdef CONFIG_HAVE_ACPI_APEI_SEA
>> +static LIST_HEAD(ghes_sea);
>> +
>> +static int ghes_notify_sea(struct notifier_block *this,
>> +				  unsigned long event, void *data)
>> +{
>> +	struct ghes *ghes;
>> +	int ret = NOTIFY_DONE;
>> +
>> +	nmi_enter();
> Can we move this into the arch code? Its because we got here from a
> synchronous-exception that makes this nmi-like, I think it only makes sense for
> it be called from under /arch/.
So move the nmi_enter/exit calls into do_sea of the previous patch? I 
can do that in the next patchset.
> Where did the rcu_read_lock() go? I can see its missing from ghes_notify_nmi()
> too, but I don't know enough about RCU to know if that's safe!
>
> The second paragraph in the comment above rcu_read_lock() describes it as
> preventing call_rcu() during a read-side critical section that was running
> concurrently. Doesn't this mean we can race with ghes_sea_remove() on another
> CPU because we wait for the wrong grace period?
>
> The same comment talks about how these read-side critical sections can nest, so
> I think its quite safe to make these 'lock' calls here.
Sorry, I thought we wanted nmi_enter/exit instead of the 
rcu_read_lock/unlock. I guess the rcu locks
will not cause the deadlock scenario you described in the previous 
patchset if we have the
nmi_enter/exit wrapped around the rcu critical section.
>> +	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
>> +		if (!ghes_proc(ghes))
>> +			ret = NOTIFY_OK;
>> +	}
>> +	nmi_exit();
>> +
>> +	return ret;
>> +}
>> +
>> +static struct notifier_block ghes_notifier_sea = {
>> +	.notifier_call = ghes_notify_sea,
>> +};
>> +
>> +static int ghes_sea_add(struct ghes *ghes)
>> +{
>> +	mutex_lock(&ghes_list_mutex);
>> +	if (list_empty(&ghes_sea))
>> +		register_sea_notifier(&ghes_notifier_sea);
>> +	list_add_rcu(&ghes->list, &ghes_sea);
>> +	mutex_unlock(&ghes_list_mutex);
>> +	return 0;
>> +}
>> +
>> +static void ghes_sea_remove(struct ghes *ghes)
>> +{
>> +	mutex_lock(&ghes_list_mutex);
>> +	list_del_rcu(&ghes->list);
>> +	if (list_empty(&ghes_sea))
>> +		unregister_sea_notifier(&ghes_notifier_sea);
>> +	mutex_unlock(&ghes_list_mutex);
> ghes_nmi_remove() has:
>> 	/*
>>   	* To synchronize with NMI handler, ghes can only be
>>   	* freed after NMI handler finishes.
>> 	*/
>> 	synchronize_rcu()
> This 'waits until a grace period has elapsed'. This is because ghes_remove()
> goes and kfree()s the ghes object while another CPU may be holding that entry in
> the list in ghes_notify_sea().
I will add synchronize_rcu() in the next patchset.
>> +}
>> +#else /* CONFIG_HAVE_ACPI_APEI_SEA */
>> +static inline int ghes_sea_add(struct ghes *ghes)
>> +{
>> +	pr_err(GHES_PFX "ID: %d, trying to add SEA notification which is not supported\n",
>> +	       ghes->generic->header.source_id);
>> +	return -ENOTSUPP;
>> +}
>> +
>> +static inline void ghes_sea_remove(struct ghes *ghes)
>> +{
>> +	pr_err(GHES_PFX "ID: %d, trying to remove SEA notification which is not supported\n",
>> +	       ghes->generic->header.source_id);
>> +}
>> +#endif /* CONFIG_HAVE_ACPI_APEI_SEA */
>> +
>>   #ifdef CONFIG_HAVE_ACPI_APEI_NMI
>>   /*
>>    * printk is not safe in NMI context.  So in NMI handler, we allocate
>> @@ -1011,6 +1072,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
>>   	case ACPI_HEST_NOTIFY_EXTERNAL:
>>   	case ACPI_HEST_NOTIFY_SCI:
>>   		break;
>> +	case ACPI_HEST_NOTIFY_SEA:
>> +		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_SEA)) {
>> +			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SEA is not supported\n",
>> +				generic->header.source_id);
>> +			rc = -ENOTSUPP;
>> +			goto err;
>> +		}
>> +		break;
>>   	case ACPI_HEST_NOTIFY_NMI:
>>   		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_NMI)) {
>>   			pr_warn(GHES_PFX "Generic hardware error source: %d notified via NMI interrupt is not supported!\n",
>> @@ -1022,6 +1091,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
>>   		pr_warning(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
>>   			   generic->header.source_id);
>>   		goto err;
>
>> +	case ACPI_HEST_NOTIFY_GPIO:
>> +	case ACPI_HEST_NOTIFY_SEI:
>> +	case ACPI_HEST_NOTIFY_GSIV:
> These three weren't mentioned in the commit message. I guess they are drive-by
> cleanup?
SEI and GSIV were also added in the ACPI 6.1 spec (18.3.2.9 Hardware 
Error Notification) and GPIO was missing, so I added all three.

Thanks,
Tyler
>> +		pr_warn(GHES_PFX "Generic hardware error source: %d notified via notification type %u is not supported\n",
>> +			generic->header.source_id, generic->header.source_id);
>> +		rc = -ENOTSUPP;
>> +		goto err;
>>   	default:
>>   		pr_warning(FW_WARN GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
>>   			   generic->notify.type, generic->header.source_id);
>
> Thanks,
>
> James
>
>

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
