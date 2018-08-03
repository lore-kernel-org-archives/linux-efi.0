From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] ima: add support for arch specific policies
Date: Fri, 3 Aug 2018 15:38:36 +0530
Message-ID: <b47cddd8-44ea-1175-a6ee-25f06ad4a185@linux.vnet.ibm.com>
References: <20180725233200.761-2-erichte@linux.vnet.ibm.com>
 <201807281011.3IfKWpyx%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201807281011.3IfKWpyx%fengguang.wu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>, Eric Richter <erichte@linux.vnet.ibm.com>
Cc: kbuild-all@01.org, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, Justin Forbes <jforbes@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org



On 07/28/2018 07:54 AM, kbuild test robot wrote:
> Hi Nayna,
>
> Thank you for the patch! Perhaps something to improve:

Thanks for the report. I will address or squash the changes with the 
existing PATCH 1/4 in the next version.
The warning about NULL dereference in PATCH 4/4 is related to changes in 
PATCH 1/4, so will fix in PATCH 1/4 itself.

Thanks & Regards,
     - Nayna


>
> [auto build test WARNING on integrity/next-integrity]
> [also build test WARNING on next-20180727]
> [cannot apply to v4.18-rc6]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Eric-Richter/ima-add-support-for-arch-specific-policies/20180728-072442
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git next-integrity
> reproduce:
>          # apt-get install sparse
>          make ARCH=x86_64 allmodconfig
>          make C=1 CF=-D__CHECK_ENDIAN__
>
>
> sparse warnings: (new ones prefixed by >>)
>
>>> security/integrity/ima/ima_policy.c:198:23: sparse: symbol 'arch_policy_rules' was not declared. Should it be static?
>>> security/integrity/ima/ima_policy.c:199:23: sparse: symbol 'arch_policy_entry' was not declared. Should it be static?
>     include/linux/slab.h:631:13: sparse: undefined identifier '__builtin_mul_overflow'
>     include/linux/slab.h:631:13: sparse: not a function <noident>
>     include/linux/slab.h:631:13: sparse: call with no type!
>
> Please review and possibly fold the followup patch.
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
