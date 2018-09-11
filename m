From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v1 3/4] ACPI / LPSS: Get rid of custom ICPU() macro
Date: Tue, 11 Sep 2018 13:02:50 +0200
Message-ID: <2988878.r6y5agHKkI@aspire.rjw.lan>
References: <20180831091018.17543-1-andriy.shevchenko@linux.intel.com> <20180831091018.17543-3-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180831091018.17543-3-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Friday, August 31, 2018 11:10:17 AM CEST Andy Shevchenko wrote:
> Replace custom grown macro with generic INTEL_CPU_FAM6_NODATA() one.
> 
> No functional change intended.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/acpi/acpi_lpss.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 9706613eecf9..c363e2a40f13 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -289,11 +289,9 @@ static const struct lpss_device_desc bsw_spi_dev_desc = {
>  	.setup = lpss_deassert_reset,
>  };
>  
> -#define ICPU(model)	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_ANY, }
> -
>  static const struct x86_cpu_id lpss_cpu_ids[] = {
> -	ICPU(INTEL_FAM6_ATOM_SILVERMONT1),	/* Valleyview, Bay Trail */
> -	ICPU(INTEL_FAM6_ATOM_AIRMONT),	/* Braswell, Cherry Trail */
> +	INTEL_CPU_FAM6_NODATA(ATOM_SILVERMONT1),	/* Valleyview, Bay Trail */
> +	INTEL_CPU_FAM6_NODATA(ATOM_AIRMONT),		/* Braswell, Cherry Trail */
>  	{}
>  };
>  
> 

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
