From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] efi: Check for null efi kernel parameters
Date: Tue, 21 Jul 2015 17:22:17 +0800
Message-ID: <20150721092217.GA7361@dhcp-129-220.nay.redhat.com>
References: <1437014163-4652-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437014163-4652-1-git-send-email-ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Glenn P. Williamson" <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 07/15/15 at 07:36pm, Ricardo Neri wrote:
> Even though it is documented how to specifiy efi parameters, it is
> possible to cause a kernel panic due to a derreference of a NULL pointer when
> parsing such parameters if "efi" alone is given:
> 
> PANIC: early exception 0e rip 10:ffffffff812fb361 error 0 cr2 0
> [ 0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.2.0-rc1+ #450
> [ 0.000000]  ffffffff81fe20a9 ffffffff81e03d50 ffffffff8184bb0f 00000000000003f8
> [ 0.000000]  0000000000000000 ffffffff81e03e08 ffffffff81f371a1 64656c62616e6520
> [ 0.000000]  0000000000000069 000000000000005f 0000000000000000 0000000000000000
> [ 0.000000] Call Trace:
> [ 0.000000]  [<ffffffff8184bb0f>] dump_stack+0x45/0x57
> [ 0.000000]  [<ffffffff81f371a1>] early_idt_handler_common+0x81/0xae
> [ 0.000000]  [<ffffffff812fb361>] ? parse_option_str+0x11/0x90
> [ 0.000000]  [<ffffffff81f4dd69>] arch_parse_efi_cmdline+0x15/0x42
> [ 0.000000]  [<ffffffff81f376e1>] do_early_param+0x50/0x8a
> [ 0.000000]  [<ffffffff8106b1b3>] parse_args+0x1e3/0x400
> [ 0.000000]  [<ffffffff81f37a43>] parse_early_options+0x24/0x28
> [ 0.000000]  [<ffffffff81f37691>] ? loglevel+0x31/0x31
> [ 0.000000]  [<ffffffff81f37a78>] parse_early_param+0x31/0x3d
> [ 0.000000]  [<ffffffff81f3ae98>] setup_arch+0x2de/0xc08
> [ 0.000000]  [<ffffffff8109629a>] ? vprintk_default+0x1a/0x20
> [ 0.000000]  [<ffffffff81f37b20>] start_kernel+0x90/0x423
> [ 0.000000]  [<ffffffff81f37495>] x86_64_start_reservations+0x2a/0x2c
> [ 0.000000]  [<ffffffff81f37582>] x86_64_start_kernel+0xeb/0xef
> [ 0.000000] RIP 0xffffffff81ba2efc
> 
> This panic is not reproducible with "efi=" as this will result in a non-NULL
> zero-lenght string.
> 
> Thus, verify that the pointer to the parameter string is not NULL. This is
> consistent with other parameter-parsing functions which check for NULL pointers.
> 
> Signed-off-by: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
> 
> Changes since v1:
> 
>  - Include a stackdump showing the code path to the panic
>  - Describe further in which scenarios the panic can be reproduced
>  - Describe more accurately the fix.

Ricardo, any reason not change in parse_option_str general function? 
I prefer to fix it in parse_option_str, because it is for checking
if str contains an option string, if str is NULL then it should 
return false.

But since it is only used in efi code for now so I have no strong opinion.

> 
>  arch/x86/platform/efi/efi.c | 4 ++++
>  drivers/firmware/efi/efi.c  | 4 ++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index cfba30f..d323e3a 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -972,6 +972,10 @@ u64 efi_mem_attributes(unsigned long phys_addr)
>  
>  static int __init arch_parse_efi_cmdline(char *str)
>  {
> +	if (!str) {
> +		pr_warn("need at least one option\n");
> +		return -EINVAL;
> +	}
>  	if (parse_option_str(str, "old_map"))
>  		set_bit(EFI_OLD_MEMMAP, &efi.flags);
>  	if (parse_option_str(str, "debug"))
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 46eb8a6..9816e3d 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -58,6 +58,10 @@ bool efi_runtime_disabled(void)
>  
>  static int __init parse_efi_cmdline(char *str)
>  {
> +	if (!str) {
> +		pr_warn("need at least one option\n");
> +		return -EINVAL;
> +	}
>  	if (parse_option_str(str, "noruntime"))
>  		disable_runtime = true;
>  
Thanks
Dave
