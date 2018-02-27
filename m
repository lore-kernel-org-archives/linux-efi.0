From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 4/8] efi: Decode UEFI-defined IA32/X64 Error Structure
 GUIDs
Date: Tue, 27 Feb 2018 15:30:20 +0100
Message-ID: <20180227143020.GG26382@pd.tnic>
References: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
 <20180226193904.20532-5-Yazen.Ghannam@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180226193904.20532-5-Yazen.Ghannam@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yazen Ghannam <Yazen.Ghannam@amd.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 26, 2018 at 01:39:00PM -0600, Yazen Ghannam wrote:
> @@ -45,6 +81,11 @@ void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
>  		printk("%sError Structure Type: %pUl\n", newpfx,
>  		       &err_info->err_type);
>  
> +		err_type = cper_get_err_type(&err_info->err_type);
> +		printk("%sError Structure Type: %s\n", newpfx,
> +		       err_type < ARRAY_SIZE(cper_proc_error_type_strs) ?
> +		       cper_proc_error_type_strs[err_type] : "unknown");

Ah, there it is, much better. Now this tells us what component it is.

So cper-arm.c does the same thing and there's a similar thing in cper.c -
cper_print_proc_generic().

Let's not tri-plicate that code pls and have a generic function instead.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
