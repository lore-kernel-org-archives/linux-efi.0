From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] efi: parse ARM error information value
Date: Tue, 17 Oct 2017 22:30:13 +0300
Message-ID: <1508268613.16112.487.camel@linux.intel.com>
References: <1508260992-18014-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508260992-18014-1-git-send-email-tbaicar@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, will.deacon@arm.com, james.morse@arm.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2017-10-17 at 11:23 -0600, Tyler Baicar wrote:
> ARM errors just print out the error information value, then the
> value needs to be manually decoded as per the UEFI spec. Add
> decoding of the ARM error information value so that the kernel
> logs capture all of the valid information at first glance.
> 
> ARM error information value decoding is captured in UEFI 2.7
> spec tables 263-265.

Could it be located in separate file?

> +			printk("%stransaction type: %s\n", pfx,
> +			       arm_err_trans_type_strs[trans_type]);

Plain printk():s?

> +#define CPER_ARM_ERR_VALID_TRANSACTION_TYPE	0x0001
> +#define CPER_ARM_ERR_VALID_OPERATION_TYPE	0x0002
> +#define CPER_ARM_ERR_VALID_LEVEL		0x0004
> +#define CPER_ARM_ERR_VALID_PROC_CONTEXT_CORRUPT	0x0008
> +#define CPER_ARM_ERR_VALID_CORRECTED		0x0010
> +#define CPER_ARM_ERR_VALID_PRECISE_PC		0x0020
> +#define CPER_ARM_ERR_VALID_RESTARTABLE_PC	0x0040
> +#define CPER_ARM_ERR_VALID_PARTICIPATION_TYPE	0x0080
> +#define CPER_ARM_ERR_VALID_TIME_OUT		0x0100
> +#define CPER_ARM_ERR_VALID_ADDRESS_SPACE	0x0200
> +#define CPER_ARM_ERR_VALID_MEM_ATTRIBUTES	0x0400
> +#define CPER_ARM_ERR_VALID_ACCESS_MODE		0x0800

BIT() is already being used in this file.

> +
> +#define CPER_ARM_ERR_TRANSACTION_SHIFT		16
> +#define CPER_ARM_ERR_TRANSACTION_MASK		0x3

Mask is mask, so GENMASK()

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
