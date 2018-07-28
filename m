From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/4] ima: add support for arch specific policies
Date: Sat, 28 Jul 2018 10:24:41 +0800
Message-ID: <201807281011.3IfKWpyx%fengguang.wu@intel.com>
References: <20180725233200.761-2-erichte@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180725233200.761-2-erichte@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Richter <erichte@linux.vnet.ibm.com>
Cc: kbuild-all@01.org, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, Justin Forbes <jforbes@redhat.com>, Nayna Jain <nayna@linux.vnet.ibm.com>, Mimi Zohar <zohar@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

Hi Nayna,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on integrity/next-integrity]
[also build test WARNING on next-20180727]
[cannot apply to v4.18-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Eric-Richter/ima-add-support-for-arch-specific-policies/20180728-072442
base:   https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git next-integrity
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> security/integrity/ima/ima_policy.c:198:23: sparse: symbol 'arch_policy_rules' was not declared. Should it be static?
>> security/integrity/ima/ima_policy.c:199:23: sparse: symbol 'arch_policy_entry' was not declared. Should it be static?
   include/linux/slab.h:631:13: sparse: undefined identifier '__builtin_mul_overflow'
   include/linux/slab.h:631:13: sparse: not a function <noident>
   include/linux/slab.h:631:13: sparse: call with no type!

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
