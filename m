From: joeyli <jlee@suse.com>
Subject: Re: [PATCH v2 09/16] PM / hibernate: Reserve hibernation key and
 erase footprints
Date: Thu, 13 Aug 2015 22:33:37 +0800
Message-ID: <20150813143337.GA31748@linux-rxt1.site>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-10-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439273796-25359-10-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Aug 11, 2015 at 02:16:29PM +0800, Lee, Chun-Yi wrote:
> Add handler to parse the setup data that carrying hibernation key, it
> reserves hibernation key by memblock then copies key to a allocated page
> in later initcall stage.
>
[...snip] 
> diff --git a/arch/x86/power/hibernate_keys.c b/arch/x86/power/hibernate_keys.c
> new file mode 100644
> index 0000000..357dc0e
> --- /dev/null
> +++ b/arch/x86/power/hibernate_keys.c
> @@ -0,0 +1,78 @@
> +/* Hibernation keys handler
> + *
[...snip]
> +static int __init init_hibernation_keys(void)
> +{
> +	struct hibernation_keys *keys;
> +	int ret = 0;
> +
> +	if (!keys_phys_addr)
> +		return -ENODEV;
> +
> +	keys = early_memremap(keys_phys_addr, sizeof(struct hibernation_keys));
> +
> +	/* Copy hibernation keys to a allocated page */
> +	hibernation_keys = (struct hibernation_keys *)get_zeroed_page(GFP_KERNEL);
> +	if (hibernation_keys) {
> +		*hibernation_keys = *keys;
> +	} else {
> +		pr_err("PM: Allocate hibernation keys page failed\n");
> +		ret = -ENOMEM;
> +	}
> +
> +	/* Erase keys data no matter copy success or failed */
> +	memset(keys, 0, sizeof(struct hibernation_keys));
> +	early_memunmap(keys, sizeof(struct hibernation_keys));
> +	memblock_free(keys_phys_addr, sizeof(struct hibernation_keys));
> +	keys_phys_addr = 0;
> +
> +	return ret;
> +}
> +
> +late_initcall(init_hibernation_keys);

Yu's reviewing triggered me rethinking...

I afraid that's too late in late_initcall stage for copying key data that
reserved by memblock. I will try to move this copy action to setup_arch().


Regards
Joey Lee
