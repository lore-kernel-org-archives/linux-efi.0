From: Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH 08/44] kernel: Move pm_power_off to common code
Date: Thu, 9 Oct 2014 12:38:47 +0200
Message-ID: <20141009103847.GC6787@amd>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
 <1412659726-29957-9-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1412659726-29957-9-git-send-email-linux@roeck-us.net>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-m32r-ja@ml.linux-m32r.org, linux-mips@linux-mips.org, linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org, Steven Miao <realmz6@gmail.com>, linux-xtensa@linux-xtensa.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, David Howells <dhowells@redhat.com>, Max Filippov <jcmvbkbc@gmail.com>, Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>, "H. Peter Anvin" <hpa@zytor.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>, Thomas Gleixner <tglx@linutronix.de>, Lennox Wu <lennox.wu@gmail.com>, Hans-Christian Egtvedt <egtvedt@samfundet.no>, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, Jesper Nilsson <jesper.nilsson@axis.com>, lguest@lists.ozlabs.org, Russell King <linux@arm.linux.org.uk>, linux-c6x-dev@linux-c6x.org, Len Brown <len.brown@intel.com>, "David S. Miller" <davem@d>
List-Id: linux-efi@vger.kernel.org

Hi!

> @@ -184,6 +179,8 @@ machine_halt(void)
>  void
>  machine_power_off(void)
>  {
> +	do_kernel_poweroff();
> +

poweroff -> power_off for consistency.


> index c4f50a3..1da27d1 100644
> --- a/arch/blackfin/kernel/reboot.c
> +++ b/arch/blackfin/kernel/reboot.c
> @@ -106,6 +107,7 @@ void machine_halt(void)
>  __attribute__((weak))
>  void native_machine_power_off(void)
>  {
> +	do_kernel_poweroff();
>  	idle_with_irq_disabled();
>  }
>

So here we handle do_kernel_poweroff() returning,

> diff --git a/arch/cris/kernel/process.c b/arch/cris/kernel/process.c
> index b78498e..eaafad0 100644
> --- a/arch/cris/kernel/process.c
> +++ b/arch/cris/kernel/process.c
> @@ -60,6 +57,7 @@ void machine_halt(void)
>  
>  void machine_power_off(void)
>  {
> +	do_kernel_poweroff();
>  }
>


Here we don't.

> diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
> index 5d40aeb77..a673725 100644
> --- a/arch/frv/kernel/process.c
> +++ b/arch/frv/kernel/process.c
> @@ -107,6 +104,8 @@ void machine_power_off(void)
>  	gdbstub_exit(0);
>  #endif
>  
> +	do_kernel_poweroff();
> +
>  	for (;;);
>  }
>  

And here we do.

What is right?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
