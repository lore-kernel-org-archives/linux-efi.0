From: James Morse <james.morse@arm.com>
Subject: Re: [RFC PATCH V1 v4.10-rc3 1/1] acpi: apei: handle GSIV notification
 type
Date: Tue, 28 Feb 2017 13:22:41 +0000
Message-ID: <58B579A1.90109@arm.com>
References: <86258A5CC0A3704780874CF6004BA8A62DCAB57E@lhreml502-mbs>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <86258A5CC0A3704780874CF6004BA8A62DCAB57E@lhreml502-mbs>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shiju Jose <shiju.jose@huawei.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "fu.wei@linaro.org" <fu.wei@linaro.org>, Gabriele Paoloni <gabriele.paoloni@huawei.com>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "wangxiongfeng (C)" <wangxiongfeng2@huawei.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, eun.taik.lee@s
List-Id: linux-efi@vger.kernel.org

Hi Shiju,

On 27/02/17 18:19, Shiju Jose wrote:
> Add a new GHES error source handling function for
> GSIV(Global System Interrupt Vector).
> If an error source's notification type is GSIV,
> then this handling function can be registered
> into the GSIV handler and it can parse
> and report error information when they occur.

I'm missing some of the story here, but how is GSIV different from 'External
Interrupt'? I'm guessing something other than the CPU takes this 'interrupt'...


The GHES GSIV code below is identical to the behaviour of the SCI Notification
type... are these two names for the same thing? (I'm confused!)


Thanks,

James


> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index e53bef6..e1611d2 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -721,6 +721,58 @@ static struct notifier_block ghes_notifier_sci = {
>  	.notifier_call = ghes_notify_sci,
>  };
>  
> +#ifdef CONFIG_HAVE_ACPI_APEI_GSIV
> +static LIST_HEAD(ghes_gsiv);
> +
> +static int ghes_notify_gsiv(struct notifier_block *this,
> +				unsigned long event, void *data)
> +{
> +	struct ghes *ghes;
> +	int ret = NOTIFY_DONE;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(ghes, &ghes_gsiv, list) {
> +	if (!ghes_proc(ghes))
> +		ret = NOTIFY_OK;
> +	}
> +	rcu_read_unlock();
> +	return ret;
> +}
> +static struct notifier_block ghes_notifier_gsiv = {
> +	.notifier_call = ghes_notify_gsiv,
> +};
> +
> +static void ghes_gsiv_add(struct ghes *ghes)
> +{
> +	mutex_lock(&ghes_list_mutex);
> +	if (list_empty(&ghes_gsiv))
> +		register_acpi_hed_notifier(&ghes_notifier_gsiv);
> +	list_add_rcu(&ghes->list, &ghes_gsiv);
> +	mutex_unlock(&ghes_list_mutex);
> +}
> +
> +static void ghes_gsiv_remove(struct ghes *ghes)
> +{
> +	mutex_lock(&ghes_list_mutex);
> +	list_del_rcu(&ghes->list);
> +	if (list_empty(&ghes_gsiv))
> +		unregister_acpi_hed_notifier(&ghes_notifier_gsiv);
> +	mutex_unlock(&ghes_list_mutex);
> +}
> +#else /* CONFIG_HAVE_ACPI_APEI_GSIV */
> +static inline void ghes_gsiv_add(struct ghes *ghes)
> +{
> +	pr_err(GHES_PFX "ID: %d, trying to add GSIV notification which is not supported\n",
> +	       ghes->generic->header.source_id);
> +}
> +
> +static inline void ghes_gsiv_remove(struct ghes *ghes)
> +{
> +	pr_err(GHES_PFX "ID: %d, trying to remove GSIV notification which is not supported\n",
> +	       ghes->generic->header.source_id);
> +}
> +#endif /* CONFIG_HAVE_ACPI_APEI_GSIV */
> +
>  #ifdef CONFIG_HAVE_ACPI_APEI_NMI
>  /*
>   * printk is not safe in NMI context.  So in NMI handler, we allocate
> @@ -973,6 +1025,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  			goto err;
>  		}
>  		break;
> +	case ACPI_HEST_NOTIFY_GSIV:
> +		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_GSIV)) {
> +			pr_warn(GHES_PFX "Generic hardware error source: %d notified via notification GSIV is not supported\n",
> +				generic->header.source_id);
> +			rc = -ENOTSUPP;
> +			goto err;
> +		}
> +		break;
>  	case ACPI_HEST_NOTIFY_LOCAL:
>  		pr_warning(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
>  			   generic->header.source_id);
> @@ -1034,6 +1094,9 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  	case ACPI_HEST_NOTIFY_NMI:
>  		ghes_nmi_add(ghes);
>  		break;
> +	case ACPI_HEST_NOTIFY_GSIV:
> +		ghes_gsiv_add(ghes);
> +		break;
>  	default:
>  		BUG();
>  	}
> @@ -1076,6 +1139,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
>  	case ACPI_HEST_NOTIFY_NMI:
>  		ghes_nmi_remove(ghes);
>  		break;
> +	case ACPI_HEST_NOTIFY_GSIV:
> +		ghes_gsiv_remove(ghes);
> +		break;
>  	default:
>  		BUG();
>  		break;
> 
