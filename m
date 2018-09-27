From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v4 3/6] ima: refactor ima_init_policy()
Date: Thu, 27 Sep 2018 08:16:48 -0400
Message-ID: <1538050608.3459.83.camel@linux.ibm.com>
References: <20180926122210.14642-1-nayna@linux.vnet.ibm.com>
         <20180926122210.14642-4-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180926122210.14642-4-nayna@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>, linux-integrity@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Wed, 2018-09-26 at 17:52 +0530, Nayna Jain wrote:
> This patch removes the code duplication in ima_init_policy() by defining
> a new function named add_rules().

Thanks!  The patch looks good, but let's expand on this just a bit.

Rules can be added to the initial IMA policy, the custom policy or
both, based on a mask (IMA_DEFAULT_POLICY, IMA_CUSTOM_POLICY).

Mimi

> 
> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> ---
>  security/integrity/ima/ima_policy.c | 98 +++++++++++++++++++++----------------
>  1 file changed, 57 insertions(+), 41 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 8c9499867c91..d5b327320d3a 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -58,6 +58,8 @@ enum lsm_rule_types { LSM_OBJ_USER, LSM_OBJ_ROLE, LSM_OBJ_TYPE,
>  
>  enum policy_types { ORIGINAL_TCB = 1, DEFAULT_TCB };
>  
> +enum policy_rule_list { IMA_DEFAULT_POLICY = 1, IMA_CUSTOM_POLICY };
> +
>  struct ima_rule_entry {
>  	struct list_head list;
>  	int action;
> @@ -473,6 +475,33 @@ static int ima_appraise_flag(enum ima_hooks func)
>  	return 0;
>  }
>  
> +static void add_rules(struct ima_rule_entry *entries, int count,
> +		      enum policy_rule_list file)
> +{
> +	int i = 0;
> +
> +	for (i = 0; i < count; i++) {
> +		struct ima_rule_entry *entry;
> +
> +		if (file & IMA_DEFAULT_POLICY)
> +			list_add_tail(&entries[i].list, &ima_default_rules);
> +
> +		if (file & IMA_CUSTOM_POLICY) {
> +			entry = kmemdup(&entries[i], sizeof(*entry),
> +					GFP_KERNEL);
> +			if (!entry)
> +				continue;
> +
> +			INIT_LIST_HEAD(&entry->list);
> +			list_add_tail(&entry->list, &ima_policy_rules);
> +		}
> +		if (entries[i].action == APPRAISE)
> +			temp_ima_appraise |= ima_appraise_flag(entries[i].func);
> +		if (entries[i].func == POLICY_CHECK)
> +			temp_ima_appraise |= IMA_APPRAISE_POLICY;
> +	}
> +}
> +
>  /**
>   * ima_init_policy - initialize the default measure rules.
>   *
> @@ -481,28 +510,23 @@ static int ima_appraise_flag(enum ima_hooks func)
>   */
>  void __init ima_init_policy(void)
>  {
> -	int i, measure_entries, appraise_entries, secure_boot_entries;
> -
> -	/* if !ima_policy set entries = 0 so we load NO default rules */
> -	measure_entries = ima_policy ? ARRAY_SIZE(dont_measure_rules) : 0;
> -	appraise_entries = ima_use_appraise_tcb ?
> -			 ARRAY_SIZE(default_appraise_rules) : 0;
> -	secure_boot_entries = ima_use_secure_boot ?
> -			ARRAY_SIZE(secure_boot_rules) : 0;
> +	int build_appraise_entries;
>  
> -	for (i = 0; i < measure_entries; i++)
> -		list_add_tail(&dont_measure_rules[i].list, &ima_default_rules);
> +	/* if !ima_policy, we load NO default rules */
> +	if (ima_policy)
> +		add_rules(dont_measure_rules, ARRAY_SIZE(dont_measure_rules),
> +			  IMA_DEFAULT_POLICY);
>  
>  	switch (ima_policy) {
>  	case ORIGINAL_TCB:
> -		for (i = 0; i < ARRAY_SIZE(original_measurement_rules); i++)
> -			list_add_tail(&original_measurement_rules[i].list,
> -				      &ima_default_rules);
> +		add_rules(original_measurement_rules,
> +			  ARRAY_SIZE(original_measurement_rules),
> +			  IMA_DEFAULT_POLICY);
>  		break;
>  	case DEFAULT_TCB:
> -		for (i = 0; i < ARRAY_SIZE(default_measurement_rules); i++)
> -			list_add_tail(&default_measurement_rules[i].list,
> -				      &ima_default_rules);
> +		add_rules(default_measurement_rules,
> +			  ARRAY_SIZE(default_measurement_rules),
> +			  IMA_DEFAULT_POLICY);
>  	default:
>  		break;
>  	}
> @@ -511,38 +535,30 @@ void __init ima_init_policy(void)
>  	 * Insert the builtin "secure_boot" policy rules requiring file
>  	 * signatures, prior to any other appraise rules.
>  	 */
> -	for (i = 0; i < secure_boot_entries; i++) {
> -		list_add_tail(&secure_boot_rules[i].list, &ima_default_rules);
> -		temp_ima_appraise |=
> -		    ima_appraise_flag(secure_boot_rules[i].func);
> -	}
> +	if (ima_use_secure_boot)
> +		add_rules(secure_boot_rules, ARRAY_SIZE(secure_boot_rules),
> +			  IMA_DEFAULT_POLICY);
>  
>  	/*
>  	 * Insert the build time appraise rules requiring file signatures
>  	 * for both the initial and custom policies, prior to other appraise
> -	 * rules.
> +	 * rules. As the secure boot rules includes all of the build time
> +	 * rules, include either one or the other set of rules, but not both.
>  	 */
> -	for (i = 0; i < ARRAY_SIZE(build_appraise_rules); i++) {
> -		struct ima_rule_entry *entry;
> -
> -		if (!secure_boot_entries)
> -			list_add_tail(&build_appraise_rules[i].list,
> -				      &ima_default_rules);
> -
> -		entry = kmemdup(&build_appraise_rules[i], sizeof(*entry),
> -				GFP_KERNEL);
> -		if (entry)
> -			list_add_tail(&entry->list, &ima_policy_rules);
> -		build_ima_appraise |=
> -			ima_appraise_flag(build_appraise_rules[i].func);
> +	build_appraise_entries = ARRAY_SIZE(build_appraise_rules);
> +	if (build_appraise_entries) {
> +		if (ima_use_secure_boot)
> +			add_rules(build_appraise_rules, build_appraise_entries,
> +				  IMA_CUSTOM_POLICY);
> +		else
> +			add_rules(build_appraise_rules, build_appraise_entries,
> +				  IMA_DEFAULT_POLICY | IMA_CUSTOM_POLICY);
>  	}
>  
> -	for (i = 0; i < appraise_entries; i++) {
> -		list_add_tail(&default_appraise_rules[i].list,
> -			      &ima_default_rules);
> -		if (default_appraise_rules[i].func == POLICY_CHECK)
> -			temp_ima_appraise |= IMA_APPRAISE_POLICY;
> -	}
> +	if (ima_use_appraise_tcb)
> +		add_rules(default_appraise_rules,
> +			  ARRAY_SIZE(default_appraise_rules),
> +			  IMA_DEFAULT_POLICY);
>  
>  	ima_rules = &ima_default_rules;
>  	ima_update_policy_flag();
