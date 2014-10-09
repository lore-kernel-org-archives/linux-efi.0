From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH 08/44] kernel: Move pm_power_off to common code
Date: Thu, 9 Oct 2014 10:35:34 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230753C5E5304@IN01WEMBXA.internal.synopsys.com>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
 <1412659726-29957-9-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Guenter Roeck <linux@roeck-us.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-m32r-ja@ml.linux-m32r.org" <linux-m32r-ja@ml.linux-m32r.org>, "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, Steven Miao <realmz6@gmail.com>, "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Jeff Dike <jdike@addtoit.com>, David Howells <dhowells@redhat.com>, Max Filippov <jcmvbkbc@gmail.com>, Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>, Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>, Thomas Gleixner <tglx@linutronix.de>, Lennox Wu <lennox.wu@gmail.com>, Hans-Christian Egtvedt <egtvedt@samfundet.no>, devel@driverdev.osuosl.org
List-Id: linux-efi@vger.kernel.org

On Tuesday 07 October 2014 11:01 AM, Guenter Roeck wrote:

diff --git a/arch/arc/kernel/reset.c b/arch/arc/kernel/reset.c
index 2768fa1..8a4fc47 100644
--- a/arch/arc/kernel/reset.c
+++ b/arch/arc/kernel/reset.c
@@ -26,9 +26,6 @@ void machine_restart(char *__unused)

 void machine_power_off(void)
 {
-       /* FIXME ::  power off ??? */
+       do_kernel_poweroff();
        machine_halt();
 }
-
-void (*pm_power_off) (void) = NULL;
-EXPORT_SYMBOL(pm_power_off);

Acked-by: Vineet Gupta <vgupta@synopsys.com><mailto:vgupta@synopsys.com>

Thx,
-Vineet
