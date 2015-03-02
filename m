From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/8] x86, kaslr: get kaslr_enabled back correctly
Date: Mon, 2 Mar 2015 10:39:33 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1503021038401.9089@pobox.suse.cz>
References: <1425176259-30087-1-git-send-email-yinghai@kernel.org> <1425176259-30087-2-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1425176259-30087-2-git-send-email-yinghai@kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sat, 28 Feb 2015, Yinghai Lu wrote:

> We should access variable with referrence instead of using physical
> address as value.
> 
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Borislav Petkov <bp@suse.de>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

	Acked-by: Jiri Kosina <jkosina@suse.cz>


Thanks for fixing my brainfart. This is not fixing the problem with the 
later variable overwrite, but definitely needs to go in as well.

Thanks.

> ---
>  arch/x86/kernel/setup.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 98dc931..05d444f 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -429,7 +429,13 @@ static void __init reserve_initrd(void)
>  
>  static void __init parse_kaslr_setup(u64 pa_data, u32 data_len)
>  {
> -	kaslr_enabled = (bool)(pa_data + sizeof(struct setup_data));
> +	/* kaslr_setup_data is defined in aslr.c */
> +	unsigned char *data;
> +	unsigned long offset = sizeof(struct setup_data);
> +
> +	data = early_memremap(pa_data, offset + 1);
> +	kaslr_enabled = *(data + offset);
> +	early_memunmap(data, offset + 1);
>  }
>  
>  static void __init parse_setup_data(void)

-- 
Jiri Kosina
SUSE Labs
