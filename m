From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 08/44] kernel: Move pm_power_off to common code
Date: Thu, 9 Oct 2014 11:28:55 +0100
Message-ID: <20141009102855.GE17836@e104818-lin.cambridge.arm.com>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
 <1412659726-29957-9-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <1412659726-29957-9-git-send-email-linux@roeck-us.net>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "adi-buildroot-devel@lists.sourceforge.net" <adi-buildroot-devel@lists.sourceforge.net>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "lguest@lists.ozlabs.org" <lguest@lists.ozlabs.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>, "linux-am33-list@redhat.com" <linux-am33-list@redhat.com>, "linux-cris-kernel@axis.com" <linux-cris-kernel@axis.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-hexagon@vger.kernel.org" <linux-hexagon@vger.kernel.org>, "linux-m32r-ja@ml.linux-m32r.org" <linux-m32r-ja@ml.linux-m32r.org>, "linuxppc-dev@lists.ozlabs.org" <linuxp>
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 07, 2014 at 06:28:10AM +0100, Guenter Roeck wrote:
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index e0ef8ba..db396bb 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -94,8 +94,6 @@ void soft_restart(unsigned long addr)
>  /*
>   * Function pointers to optional machine specific functions
>   */
> -void (*pm_power_off)(void);
> -EXPORT_SYMBOL_GPL(pm_power_off);
> 
>  void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
> 
> @@ -155,8 +153,7 @@ void machine_power_off(void)
>  {
>         local_irq_disable();
>         smp_send_stop();
> -       if (pm_power_off)
> -               pm_power_off();
> +       do_kernel_poweroff();
>  }

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
