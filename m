From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH V2 1/2] efi: print unrecognized CPER section
Date: Tue, 08 Sep 2015 16:56:57 -0500
Message-ID: <55EF59A9.2010905@codeaurora.org>
References: <1441747761-12012-1-git-send-email-zjzhang@codeaurora.org> <1441747761-12012-2-git-send-email-zjzhang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1441747761-12012-2-git-send-email-zjzhang@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, Matt Fleming <matt.fleming@intel.com>, tony.luck@intel.com, fu.wei@linaro.org, al.stone@linaro.org, rjw@rjwysocki.net, mchehab@osg.samsung.com, mingo@redhat.com, bp@alien8.de, gong.chen@linux.intel.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org, vgandhi@codeaurora.org, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 09/08/2015 04:29 PM, Jonathan (Zhixiong) Zhang wrote:

> Change-Id: I663a6e3ae6dcf68e4e389f76d555e9106ffee165

You need to strip out the Change-Id's before posting the patch.

> +#define cper_print_hex(pfx, buf, len)				\
> +	print_hex_dump(pfx, "",					\
> +		DUMP_PREFIX_OFFSET, ROW_SIZE, GROUP_SIZE,	\
> +		buf, len, 0)

		(buf), (len), 0)

is safer

> +	} else {
> +		const void *raw_err = gdata + 1;
> +		printk("%ssection type: %pUl\n", pfx, sec_type);
> +		printk("%ssection length: %d\n", pfx, len);
> +		cper_print_hex(newpfx, raw_err, len);

You don't need raw_err.  This should work fine:

		cper_print_hex(newpfx, gdata + 1, len);

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
