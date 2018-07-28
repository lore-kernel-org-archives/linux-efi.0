From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 4/4] x86/ima: define arch_get_ima_policy() for x86
Date: Sat, 28 Jul 2018 20:22:27 +0800
Message-ID: <201807282011.jTLIG5hy%fengguang.wu@intel.com>
References: <20180725233200.761-5-erichte@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180725233200.761-5-erichte@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, Justin Forbes <jforbes@redhat.com>, Eric Richter <erichte@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

Hi Eric,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on integrity/next-integrity]
[also build test WARNING on next-20180727]
[cannot apply to v4.18-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Eric-Richter/ima-add-support-for-arch-specific-policies/20180728-072442
base:   https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git next-integrity

smatch warnings:
security/integrity/ima/ima_policy.c:522 ima_init_arch_policy() error: potential null dereference 'arch_policy_entry'.  (kcalloc returns null)

vim +/arch_policy_entry +522 security/integrity/ima/ima_policy.c

b4c0791e Nayna Jain 2018-07-25  484  
b4c0791e Nayna Jain 2018-07-25  485  /*
b4c0791e Nayna Jain 2018-07-25  486   * ima_init_arch_policy - convert arch policy strings to rules
b4c0791e Nayna Jain 2018-07-25  487   *
b4c0791e Nayna Jain 2018-07-25  488   * Return number of arch specific rules.
b4c0791e Nayna Jain 2018-07-25  489   */
b4c0791e Nayna Jain 2018-07-25  490  static int __init ima_init_arch_policy(void)
b4c0791e Nayna Jain 2018-07-25  491  {
b4c0791e Nayna Jain 2018-07-25  492  	const char * const *arch_rules;
b4c0791e Nayna Jain 2018-07-25  493  	const char * const *rules;
b4c0791e Nayna Jain 2018-07-25  494  	int arch_entries = 0;
b4c0791e Nayna Jain 2018-07-25  495  	int i = 0;
b4c0791e Nayna Jain 2018-07-25  496  
b4c0791e Nayna Jain 2018-07-25  497  	arch_rules = arch_get_ima_policy();
b4c0791e Nayna Jain 2018-07-25  498  	if (!arch_rules) {
b4c0791e Nayna Jain 2018-07-25  499  		pr_info("No architecture policy rules.\n");
b4c0791e Nayna Jain 2018-07-25  500  		return arch_entries;
b4c0791e Nayna Jain 2018-07-25  501  	}
b4c0791e Nayna Jain 2018-07-25  502  
b4c0791e Nayna Jain 2018-07-25  503  	/* Get number of rules */
b4c0791e Nayna Jain 2018-07-25  504  	for (rules = arch_rules; *rules != NULL; rules++)
b4c0791e Nayna Jain 2018-07-25  505  		arch_entries++;
b4c0791e Nayna Jain 2018-07-25  506  
b4c0791e Nayna Jain 2018-07-25  507  	arch_policy_rules = kcalloc(arch_entries + 1,
b4c0791e Nayna Jain 2018-07-25  508  				    sizeof(*arch_policy_rules), GFP_KERNEL);
b4c0791e Nayna Jain 2018-07-25  509  	if (!arch_policy_rules)
b4c0791e Nayna Jain 2018-07-25  510  		return 0;
b4c0791e Nayna Jain 2018-07-25  511  
b4c0791e Nayna Jain 2018-07-25  512  	arch_policy_entry = kcalloc(arch_entries + 1,
b4c0791e Nayna Jain 2018-07-25  513  				    sizeof(*arch_policy_entry), GFP_KERNEL);
b4c0791e Nayna Jain 2018-07-25  514  
b4c0791e Nayna Jain 2018-07-25  515  	/* Convert arch policy string rules to struct ima_rule_entry format */
b4c0791e Nayna Jain 2018-07-25  516  	for (rules = arch_rules, i = 0; *rules != NULL; rules++) {
b4c0791e Nayna Jain 2018-07-25  517  		char rule[255];
b4c0791e Nayna Jain 2018-07-25  518  		int result;
b4c0791e Nayna Jain 2018-07-25  519  
b4c0791e Nayna Jain 2018-07-25  520  		result = strlcpy(rule, *rules, sizeof(rule));
b4c0791e Nayna Jain 2018-07-25  521  
b4c0791e Nayna Jain 2018-07-25 @522  		INIT_LIST_HEAD(&arch_policy_entry[i].list);
b4c0791e Nayna Jain 2018-07-25  523  		result = ima_parse_rule(rule, &arch_policy_entry[i]);
b4c0791e Nayna Jain 2018-07-25  524  		if (result) {
b4c0791e Nayna Jain 2018-07-25  525  			pr_warn("Skipping unknown architecture policy rule: %s\n", rule);
b4c0791e Nayna Jain 2018-07-25  526  			memset(&arch_policy_entry[i], 0,
b4c0791e Nayna Jain 2018-07-25  527  			       sizeof(*arch_policy_entry));
b4c0791e Nayna Jain 2018-07-25  528  			continue;
b4c0791e Nayna Jain 2018-07-25  529  		}
b4c0791e Nayna Jain 2018-07-25  530  		arch_policy_rules[i] = &arch_policy_entry[i];
b4c0791e Nayna Jain 2018-07-25  531  		i++;
b4c0791e Nayna Jain 2018-07-25  532  	}
b4c0791e Nayna Jain 2018-07-25  533  	return i;
b4c0791e Nayna Jain 2018-07-25  534  }
b4c0791e Nayna Jain 2018-07-25  535  

:::::: The code at line 522 was first introduced by commit
:::::: b4c0791e0facd968a3e0502a8a544390025a9a38 ima: add support for arch specific policies

:::::: TO: Nayna Jain <nayna@linux.vnet.ibm.com>
:::::: CC: 0day robot <lkp@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
