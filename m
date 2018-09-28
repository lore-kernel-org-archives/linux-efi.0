From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v4 3/6] ima: refactor ima_init_policy()
Date: Thu, 27 Sep 2018 20:51:38 -0400
Message-ID: <1538095898.3459.140.camel@linux.ibm.com>
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

Hi Nayna,

On Wed, 2018-09-26 at 17:52 +0530, Nayna Jain wrote:

> +static void add_rules(struct ima_rule_entry *entries, int count,
> +		      enum policy_rule_list file)

Using "file" to refer to the policy_rule_list enumeration is unusual.
 Please change the variable name to something more appropriate.

Mimi

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
