From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 08/14] efi: export efi runtime memory mapping to sysfs
Date: Mon, 16 Dec 2013 14:02:02 +0800
Message-ID: <20131216060202.GA10271@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-9-git-send-email-dyoung@redhat.com>
 <20131211185520.GG23793@pd.tnic>
 <20131212023617.GF3751@dhcp-16-126.nay.redhat.com>
 <20131212205346.GA30162@pd.tnic>
 <20131213072600.GB11164@dhcp-16-126.nay.redhat.com>
 <20131213123028.GB18640@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131213123028.GB18640-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 12/13/13 at 12:30pm, Matt Fleming wrote:
> I agree with Borislav that this should be invoked from efisubsys_init().
> Also Dave, there's nothing inherently x86-specific about runtime-map.c -
> we've been trying not to dump arch-specific code in
> drivers/firmware/efi/.
> 
> How about something like this, just to give you an idea? This would
> allow the ARM/ia64 folks to enable this code if they want at some later
> date. But more than that, it makes the code more self-contained and uses
> some real interfaces instead of relying on global variables,
> 
> (not compile tested)
> 
> ---
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 94a1cbcf6e2e..f45ea41deae0 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -76,8 +76,8 @@ static __initdata efi_config_table_type_t arch_tables[] = {
>  	{NULL_GUID, NULL, NULL},
>  };
>  
> -void *efi_runtime_map;
> -int nr_efi_runtime_map;
> +static void *efi_runtime_map;
> +static int nr_efi_runtime_map;
>  static u64 efi_setup; /* efi setup_data physical address */
>  
>  /*
> @@ -1084,6 +1084,9 @@ void __init efi_enter_virtual_mode(void)
>  		}
>  	}
>  
> +	efi_runtime_map_setup(efi_runtime_map, nr_efi_runtime_map,
> +			      boot_params.efi_info.efi_memdesc_size);
> +
>  	BUG_ON(!efi.systab);

After this change, nr_efi_runtime_map become static, but since I'm moving
the parse_efi_setup to efi_64.c and nr_efi_runtime_map is set there for
kexec kernel use..

So I will just save the setup_data paddr as efi_setup in efi_64.c, and
move other code from parse_efi_setup() to below function which is called
in efi_init();

+static void __init efi_setup_init(void)
+{
+	struct setup_data *sd;
+
+	if (!efi_setup)
+		return;
+
+	sd = early_memremap(efi_setup, sizeof(struct setup_data));
+	if (!sd) {
+		pr_warn("early_memremap setup_data failed\n");
+		efi_setup = 0;
+		return;
+	}
+	efi_setup += sizeof(struct setup_data);
+	nr_efi_runtime_map = (sd->len - sizeof(struct efi_setup_data)) /
+			     sizeof(efi_memory_desc_t);
+	early_memunmap(sd, sizeof(struct setup_data));
+}
