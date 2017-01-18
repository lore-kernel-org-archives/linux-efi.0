From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH V7 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Wed, 18 Jan 2017 14:50:15 +0000
Message-ID: <587F80A7.10008@arm.com>
References: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org>
 <1484244924-24786-6-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1484244924-24786-6-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, tn@semihalf.com, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, Suzuki.Poulose@arm.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.c
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

On 12/01/17 18:15, Tyler Baicar wrote:
> ARM APEI extension proposal added SEA (Synchrounous External

Nit: Synchronous

> Abort) notification type for ARMv8.
> Add a new GHES error source handling function for SEA. If an error
> source's notification type is SEA, then this function can be registered
> into the SEA exception handler. That way GHES will parse and report
> SEA exceptions when they occur.

> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 2acbc60..87efe26 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -767,6 +772,62 @@ static struct notifier_block ghes_notifier_sci = {
>  	.notifier_call = ghes_notify_sci,
>  };
>  
> +#ifdef CONFIG_HAVE_ACPI_APEI_SEA
> +static LIST_HEAD(ghes_sea);
> +
> +static int ghes_notify_sea(struct notifier_block *this,
> +				  unsigned long event, void *data)
> +{
> +	struct ghes *ghes;
> +	int ret = NOTIFY_DONE;
> +

> +	nmi_enter();

Can we move this into the arch code? Its because we got here from a
synchronous-exception that makes this nmi-like, I think it only makes sense for
it be called from under /arch/.


Where did the rcu_read_lock() go? I can see its missing from ghes_notify_nmi()
too, but I don't know enough about RCU to know if that's safe!

The second paragraph in the comment above rcu_read_lock() describes it as
preventing call_rcu() during a read-side critical section that was running
concurrently. Doesn't this mean we can race with ghes_sea_remove() on another
CPU because we wait for the wrong grace period?

The same comment talks about how these read-side critical sections can nest, so
I think its quite safe to make these 'lock' calls here.


> +	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
> +		if (!ghes_proc(ghes))
> +			ret = NOTIFY_OK;
> +	}
> +	nmi_exit();
> +
> +	return ret;
> +}
> +
> +static struct notifier_block ghes_notifier_sea = {
> +	.notifier_call = ghes_notify_sea,
> +};
> +
> +static int ghes_sea_add(struct ghes *ghes)
> +{
> +	mutex_lock(&ghes_list_mutex);
> +	if (list_empty(&ghes_sea))
> +		register_sea_notifier(&ghes_notifier_sea);
> +	list_add_rcu(&ghes->list, &ghes_sea);
> +	mutex_unlock(&ghes_list_mutex);
> +	return 0;
> +}
> +
> +static void ghes_sea_remove(struct ghes *ghes)
> +{
> +	mutex_lock(&ghes_list_mutex);
> +	list_del_rcu(&ghes->list);
> +	if (list_empty(&ghes_sea))
> +		unregister_sea_notifier(&ghes_notifier_sea);
> +	mutex_unlock(&ghes_list_mutex);

ghes_nmi_remove() has:
>	/*
>  	* To synchronize with NMI handler, ghes can only be
>  	* freed after NMI handler finishes.
> 	*/
> 	synchronize_rcu()

This 'waits until a grace period has elapsed'. This is because ghes_remove()
goes and kfree()s the ghes object while another CPU may be holding that entry in
the list in ghes_notify_sea().


> +}
> +#else /* CONFIG_HAVE_ACPI_APEI_SEA */
> +static inline int ghes_sea_add(struct ghes *ghes)
> +{
> +	pr_err(GHES_PFX "ID: %d, trying to add SEA notification which is not supported\n",
> +	       ghes->generic->header.source_id);
> +	return -ENOTSUPP;
> +}
> +
> +static inline void ghes_sea_remove(struct ghes *ghes)
> +{
> +	pr_err(GHES_PFX "ID: %d, trying to remove SEA notification which is not supported\n",
> +	       ghes->generic->header.source_id);
> +}
> +#endif /* CONFIG_HAVE_ACPI_APEI_SEA */
> +
>  #ifdef CONFIG_HAVE_ACPI_APEI_NMI
>  /*
>   * printk is not safe in NMI context.  So in NMI handler, we allocate
> @@ -1011,6 +1072,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  	case ACPI_HEST_NOTIFY_EXTERNAL:
>  	case ACPI_HEST_NOTIFY_SCI:
>  		break;
> +	case ACPI_HEST_NOTIFY_SEA:
> +		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_SEA)) {
> +			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SEA is not supported\n",
> +				generic->header.source_id);
> +			rc = -ENOTSUPP;
> +			goto err;
> +		}
> +		break;
>  	case ACPI_HEST_NOTIFY_NMI:
>  		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_NMI)) {
>  			pr_warn(GHES_PFX "Generic hardware error source: %d notified via NMI interrupt is not supported!\n",
> @@ -1022,6 +1091,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  		pr_warning(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
>  			   generic->header.source_id);
>  		goto err;


> +	case ACPI_HEST_NOTIFY_GPIO:
> +	case ACPI_HEST_NOTIFY_SEI:
> +	case ACPI_HEST_NOTIFY_GSIV:

These three weren't mentioned in the commit message. I guess they are drive-by
cleanup?


> +		pr_warn(GHES_PFX "Generic hardware error source: %d notified via notification type %u is not supported\n",
> +			generic->header.source_id, generic->header.source_id);
> +		rc = -ENOTSUPP;
> +		goto err;
>  	default:
>  		pr_warning(FW_WARN GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
>  			   generic->notify.type, generic->header.source_id);


Thanks,

James
