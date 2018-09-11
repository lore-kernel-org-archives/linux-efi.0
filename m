From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v1 4/4] ACPI / x86: utils: Get rid of custom ICPU() macro
Date: Tue, 11 Sep 2018 13:03:03 +0200
Message-ID: <6995683.CujeQXBDt3@aspire.rjw.lan>
References: <20180831091018.17543-1-andriy.shevchenko@linux.intel.com> <20180831091018.17543-4-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180831091018.17543-4-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Friday, August 31, 2018 11:10:18 AM CEST Andy Shevchenko wrote:
> Replace custom grown macro with generic INTEL_CPU_FAM6_NODATA() one.
> 
> No functional change intended.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/acpi/x86/utils.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
> index 06c31ec3cc70..6bb2a4565386 100644
> --- a/drivers/acpi/x86/utils.c
> +++ b/drivers/acpi/x86/utils.c
> @@ -40,8 +40,6 @@ struct always_present_id {
>  	const char *uid;
>  };
>  
> -#define ICPU(model)	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_ANY, }
> -
>  #define ENTRY(hid, uid, cpu_models, dmi...) {				\
>  	{ { hid, }, {} },						\
>  	{ cpu_models, {} },						\
> @@ -54,24 +52,24 @@ static const struct always_present_id always_present_ids[] = {
>  	 * Bay / Cherry Trail PWM directly poked by GPU driver in win10,
>  	 * but Linux uses a separate PWM driver, harmless if not used.
>  	 */
> -	ENTRY("80860F09", "1", ICPU(INTEL_FAM6_ATOM_SILVERMONT1), {}),
> -	ENTRY("80862288", "1", ICPU(INTEL_FAM6_ATOM_AIRMONT), {}),
> +	ENTRY("80860F09", "1", INTEL_CPU_FAM6_NODATA(ATOM_SILVERMONT1), {}),
> +	ENTRY("80862288", "1", INTEL_CPU_FAM6_NODATA(ATOM_AIRMONT), {}),
>  	/*
>  	 * The INT0002 device is necessary to clear wakeup interrupt sources
>  	 * on Cherry Trail devices, without it we get nobody cared IRQ msgs.
>  	 */
> -	ENTRY("INT0002", "1", ICPU(INTEL_FAM6_ATOM_AIRMONT), {}),
> +	ENTRY("INT0002", "1", INTEL_CPU_FAM6_NODATA(ATOM_AIRMONT), {}),
>  	/*
>  	 * On the Dell Venue 11 Pro 7130 and 7139, the DSDT hides
>  	 * the touchscreen ACPI device until a certain time
>  	 * after _SB.PCI0.GFX0.LCD.LCD1._ON gets called has passed
>  	 * *and* _STA has been called at least 3 times since.
>  	 */
> -	ENTRY("SYNA7500", "1", ICPU(INTEL_FAM6_HASWELL_ULT), {
> +	ENTRY("SYNA7500", "1", INTEL_CPU_FAM6_NODATA(HASWELL_ULT), {
>  		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
>  		DMI_MATCH(DMI_PRODUCT_NAME, "Venue 11 Pro 7130"),
>  	      }),
> -	ENTRY("SYNA7500", "1", ICPU(INTEL_FAM6_HASWELL_ULT), {
> +	ENTRY("SYNA7500", "1", INTEL_CPU_FAM6_NODATA(HASWELL_ULT), {
>  		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
>  		DMI_MATCH(DMI_PRODUCT_NAME, "Venue 11 Pro 7139"),
>  	      }),
> @@ -87,19 +85,19 @@ static const struct always_present_id always_present_ids[] = {
>  	 * was copy-pasted from the GPD win, so it has a disabled KIOX000A
>  	 * node which we should not enable, thus we also check the BIOS date.
>  	 */
> -	ENTRY("KIOX000A", "1", ICPU(INTEL_FAM6_ATOM_AIRMONT), {
> +	ENTRY("KIOX000A", "1", INTEL_CPU_FAM6_NODATA(ATOM_AIRMONT), {
>  		DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
>  		DMI_MATCH(DMI_BOARD_NAME, "Default string"),
>  		DMI_MATCH(DMI_PRODUCT_NAME, "Default string"),
>  		DMI_MATCH(DMI_BIOS_DATE, "02/21/2017")
>  	      }),
> -	ENTRY("KIOX000A", "1", ICPU(INTEL_FAM6_ATOM_AIRMONT), {
> +	ENTRY("KIOX000A", "1", INTEL_CPU_FAM6_NODATA(ATOM_AIRMONT), {
>  		DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
>  		DMI_MATCH(DMI_BOARD_NAME, "Default string"),
>  		DMI_MATCH(DMI_PRODUCT_NAME, "Default string"),
>  		DMI_MATCH(DMI_BIOS_DATE, "03/20/2017")
>  	      }),
> -	ENTRY("KIOX000A", "1", ICPU(INTEL_FAM6_ATOM_AIRMONT), {
> +	ENTRY("KIOX000A", "1", INTEL_CPU_FAM6_NODATA(ATOM_AIRMONT), {
>  		DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
>  		DMI_MATCH(DMI_BOARD_NAME, "Default string"),
>  		DMI_MATCH(DMI_PRODUCT_NAME, "Default string"),
> 

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
