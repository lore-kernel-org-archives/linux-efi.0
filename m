From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v4 4/6] ima: add support for arch specific policies
Date: Thu, 27 Sep 2018 09:27:49 -0400
Message-ID: <1538054869.3459.109.camel@linux.ibm.com>
References: <20180926122210.14642-1-nayna@linux.vnet.ibm.com>
         <20180926122210.14642-5-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180926122210.14642-5-nayna@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>, linux-integrity@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Wed, 2018-09-26 at 17:52 +0530, Nayna Jain wrote:
> Builtin IMA policies can be enabled on the boot command line, and replaced
> with a custom policy, normally during early boot in the initramfs. Build
> time IMA policy rules were recently added. These rules are automatically
> enabled on boot and persist after loading a custom policy.
> 
> There is a need for yet another type of policy, an architecture specific
> policy, which is derived at runtime during kernel boot, based on the
> runtime secure boot flags.  Like the build time policy rules, these rules
> persist after loading a custom policy.
> 
> This patch adds support for loading an architecture specific IMA policy.

Thanks!  Just a couple of minor comments/changes.

> 
> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> - Defined function to convert the arch policy strings to an array of
> ima_entry_rules.  The memory can then be freed after loading a custom
> policy.
> - Rename ima_get_arch_policy to arch_get_ima_policy.
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> - Modified ima_init_arch_policy() and ima_init_policy() to use add_rules()
> from previous patch.
> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> ---
>  include/linux/ima.h                 |  5 +++
>  security/integrity/ima/ima_policy.c | 70 +++++++++++++++++++++++++++++++++++--
>  2 files changed, 73 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ima.h b/include/linux/ima.h
> index 4852255aa4f4..350fa957f8a6 100644
> --- a/include/linux/ima.h
> +++ b/include/linux/ima.h
> @@ -39,6 +39,11 @@ static inline bool arch_ima_get_secureboot(void)
>  }
>  #endif
>  
> +static inline const char * const *arch_get_ima_policy(void)
> +{
> +	return NULL;
> +}
> +
>  #else
>  static inline int ima_bprm_check(struct linux_binprm *bprm)
>  {
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index d5b327320d3a..5fb4b0c123a3 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -20,6 +20,7 @@
>  #include <linux/rculist.h>
>  #include <linux/genhd.h>
>  #include <linux/seq_file.h>
> +#include <linux/ima.h>
>  
>  #include "ima.h"
>  
> @@ -195,6 +196,9 @@ static struct ima_rule_entry secure_boot_rules[] __ro_after_init = {
>  	 .flags = IMA_FUNC | IMA_DIGSIG_REQUIRED},
>  };
>  
> +/* An array of architecture specific rules */
> +struct ima_rule_entry *arch_policy_entry __ro_after_init;
> +
>  static LIST_HEAD(ima_default_rules);
>  static LIST_HEAD(ima_policy_rules);
>  static LIST_HEAD(ima_temp_rules);
> @@ -492,7 +496,6 @@ static void add_rules(struct ima_rule_entry *entries, int count,
>  			if (!entry)
>  				continue;
>  
> -			INIT_LIST_HEAD(&entry->list);
>  			list_add_tail(&entry->list, &ima_policy_rules);

Assuming that INIT_LIST_HEAD isn't needed, removing it belongs in
"[PATCH v4 3/6] ima: refactor ima_init_policy()".

>  		}
>  		if (entries[i].action == APPRAISE)
> @@ -502,6 +505,48 @@ static void add_rules(struct ima_rule_entry *entries, int count,
>  	}
>  }
>  
> +static int ima_parse_rule(char *rule, struct ima_rule_entry *entry);
> +
> +static int __init ima_init_arch_policy(void)
> +{
> +	const char * const *arch_rules;
> +	const char * const *rules;
> +	int arch_entries = 0;
> +	int i = 0;
> +
> +	arch_rules = arch_get_ima_policy();
> +	if (!arch_rules)
> +		return arch_entries;
> +
> +	/* Get number of rules */
> +	for (rules = arch_rules; *rules != NULL; rules++)
> +		arch_entries++;
> +
> +	arch_policy_entry = kcalloc(arch_entries + 1,
> +				    sizeof(*arch_policy_entry), GFP_KERNEL);
> +	if (!arch_policy_entry)
> +		return 0;
> +
> +	/* Convert each policy string rules to struct ima_rule_entry format */
> +	for (rules = arch_rules, i = 0; *rules != NULL; rules++) {
> +		char rule[255];
> +		int result;
> +
> +		result = strlcpy(rule, *rules, sizeof(rule));
> +
> +		INIT_LIST_HEAD(&arch_policy_entry[i].list);
> +		result = ima_parse_rule(rule, &arch_policy_entry[i]);
> +		if (result) {
> +			pr_warn("Skipping unknown architecture policy rule: %s\n", rule);
> +			memset(&arch_policy_entry[i], 0,
> +			       sizeof(*arch_policy_entry));
> +			continue;
> +		}
> +		i++;
> +	}
> +	return i;
> +}
> +
>  /**
>   * ima_init_policy - initialize the default measure rules.
>   *
> @@ -510,7 +555,7 @@ static void add_rules(struct ima_rule_entry *entries, int count,
>   */
>  void __init ima_init_policy(void)
>  {
> -	int build_appraise_entries;
> +	int build_appraise_entries, arch_entries;
>  
>  	/* if !ima_policy, we load NO default rules */
>  	if (ima_policy)
> @@ -532,6 +577,19 @@ void __init ima_init_policy(void)
>  	}
>  
>  	/*
> +	 * Based on runtime secure boot flags, insert arch specific measurement
> +	 * and appraise rules requiring file signatures for both the initial
> +	 * and custom policies, prior to other appraise rules.
> +	 * (Highest priority)
> +	 */
> +	arch_entries = ima_init_arch_policy();
> +	if (!arch_entries)
> +		pr_info("No architecture policies found\n");
> +	else
> +		add_rules(arch_policy_entry, arch_entries,
> +			  IMA_DEFAULT_POLICY | IMA_CUSTOM_POLICY);
> +
> +	/*
>  	 * Insert the builtin "secure_boot" policy rules requiring file
>  	 * signatures, prior to any other appraise rules.
>  	 */

The architecture specific policy is higher priority, please remove
"any" in the above sentence.

> @@ -592,6 +650,14 @@ void ima_update_policy(void)
>  	if (ima_rules != policy) {
>  		ima_policy_flag = 0;
>  		ima_rules = policy;
> +
> +		/*
> +		 * IMA architecture specific policy rules are specified
> +		 * as strings and converted to an array of ima_entry_rules
> +		 * on boot.  After loading a custom policy, free the
> +		 * architecture specific rules stored as an array.
> +		 */
> +		kfree(arch_policy_entry);
>  	}
>  	ima_update_policy_flag();
>  }
