From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v8 1/3] x86/boot: Add acpitb.c to parse acpi tables
Date: Tue, 16 Oct 2018 10:48:44 +0800
Message-ID: <20181016024844.GA12871@localhost.localdomain>
References: <20181010084119.17539-1-fanc.fnst@cn.fujitsu.com>
 <20181010084119.17539-2-fanc.fnst@cn.fujitsu.com>
 <20181011105708.GB25435@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181011105708.GB25435@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 11, 2018 at 12:57:08PM +0200, Borislav Petkov wrote:
>On Wed, Oct 10, 2018 at 04:41:17PM +0800, Chao Fan wrote:
[...]
>> +#ifdef CONFIG_KEXEC
>> +static bool get_acpi_rsdp(acpi_physical_address *rsdp_addr)
>> +{
>> +	char *args = (char *)get_cmd_line_ptr();
>> +	size_t len = strlen((char *)args);
>> +	char *tmp_cmdline, *param, *val;
>> +	unsigned long long addr = 0;
>> +	char *endptr;
>> +
>> +	if (!strstr(args, "acpi_rsdp="))
>> +		return false;
>> +
>> +	tmp_cmdline = malloc(len+1);
>> +	if (!tmp_cmdline)
>> +		error("Failed to allocate space for tmp_cmdline");
>
>Why do you even need to allocate a tmp cmdline?
>
>Ah, I see what you've done - you've copied handle_mem_options() in
>kaslr.c. Well no, not really.
>
>That functionality needs to get extracted into a separate facility. Oh
>look, there's arch/x86/boot/compressed/cmdline.c which is begging to get
>extended.
>
>:-)
>

Hi Boris,

Sorry for disturbing you again, I want to make sure this detail with you.
You mean that I need splite this as a function and put it to
cmdline.c, right?
If my understand is wrong, please let me know.

Thanks,
Chao Fan
