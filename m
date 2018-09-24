From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 3/6] ima: refactor ima_init_policy()
Date: Mon, 24 Sep 2018 16:40:39 +0530
Message-ID: <83d87b89-d1df-5e13-23d9-1ee2e8c9a75f@linux.vnet.ibm.com>
References: <20180921083429.c7sikis5bzxdifny@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921083429.c7sikis5bzxdifny@mwanda>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, kbuild@01.org
Cc: kbuild-all@01.org, linux-integrity@vger.kernel.org, zohar@linux.ibm.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org



On 09/21/2018 02:04 PM, Dan Carpenter wrote:
> Hi Nayna,
>
> Thank you for the patch! Perhaps something to improve:
>
> url:    https://github.com/0day-ci/linux/commits/Nayna-Jain/Add-support-for-architecture-specific-IMA-policies/20180920-035110
>
> smatch warnings:
> security/integrity/ima/ima_policy.c:489 add_rules() warn: should this be a bitwise op?
>
> # https://github.com/0day-ci/linux/commit/84a2e186f940ebc6c34e6d276e55f665167a5bb8
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout 84a2e186f940ebc6c34e6d276e55f665167a5bb8
> vim +489 security/integrity/ima/ima_policy.c
>
> 6f0911a6 Mimi Zohar 2018-04-12  477
> 84a2e186 Nayna Jain 2018-09-19  478  static void add_rules(struct ima_rule_entry *entries, int count,
> 84a2e186 Nayna Jain 2018-09-19  479  		      enum policy_rule_list file)
> 84a2e186 Nayna Jain 2018-09-19  480  {
> 84a2e186 Nayna Jain 2018-09-19  481  	int i = 0;
> 84a2e186 Nayna Jain 2018-09-19  482
> 84a2e186 Nayna Jain 2018-09-19  483  	for (i = 0; i < count; i++) {
> 84a2e186 Nayna Jain 2018-09-19  484  		struct ima_rule_entry *entry;
> 84a2e186 Nayna Jain 2018-09-19  485
> 84a2e186 Nayna Jain 2018-09-19  486  		if (file && IMA_DEFAULT_POLICY)
>                                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^
> 84a2e186 Nayna Jain 2018-09-19  487  			list_add_tail(&entries[i].list, &ima_default_rules);
> 84a2e186 Nayna Jain 2018-09-19  488
> 84a2e186 Nayna Jain 2018-09-19 @489  		if (file && IMA_CUSTOM_POLICY) {
>                                                      ^^^^^^^^^^^^^^^^^^^^^^^^^
>
> It does look like it should be "if (file & IMA_CUSTOM_POLICY) {" but I
> haven't looked at the context besides what's here in this email.
Thanks Dan for noticing this. Yes, I will fix it and post the v4 version.

Thanks & Regards,
     - Nayna


>
> 84a2e186 Nayna Jain 2018-09-19  490  			entry = kmemdup(&entries[i], sizeof(*entry),
> 84a2e186 Nayna Jain 2018-09-19  491  					GFP_KERNEL);
> 84a2e186 Nayna Jain 2018-09-19  492  			if (!entry)
> 84a2e186 Nayna Jain 2018-09-19  493  				continue;
> 84a2e186 Nayna Jain 2018-09-19  494
> 84a2e186 Nayna Jain 2018-09-19  495  			INIT_LIST_HEAD(&entry->list);
> 84a2e186 Nayna Jain 2018-09-19  496  			list_add_tail(&entry->list, &ima_policy_rules);
> 84a2e186 Nayna Jain 2018-09-19  497  		}
> 84a2e186 Nayna Jain 2018-09-19  498  		if (entries[i].action == APPRAISE)
> 84a2e186 Nayna Jain 2018-09-19  499  			temp_ima_appraise |= ima_appraise_flag(entries[i].func);
> 84a2e186 Nayna Jain 2018-09-19  500  		if (entries[i].func == POLICY_CHECK)
> 84a2e186 Nayna Jain 2018-09-19  501  			temp_ima_appraise |= IMA_APPRAISE_POLICY;
> 84a2e186 Nayna Jain 2018-09-19  502  	}
> 84a2e186 Nayna Jain 2018-09-19  503  }
> 84a2e186 Nayna Jain 2018-09-19  504
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
