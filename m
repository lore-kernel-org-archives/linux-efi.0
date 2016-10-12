From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH V3 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Wed, 12 Oct 2016 19:00:00 +0100
Message-ID: <87shs1sb1b.fsf@e105922-lin.cambridge.arm.com>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
 <1475875882-2604-6-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1475875882-2604-6-git-send-email-tbaicar@codeaurora.org> (Tyler
 Baicar's message of "Fri, 7 Oct 2016 15:31:17 -0600")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: linux-efi@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, shijie.huang@arm.com, lenb@kernel.org, marc.zyngier@arm.com, tomasz.nowicki@linaro.org, Naveen Kaje <nkaje@codeaurora.org>, rostedt@goodmis.org, sandeepa.s.prabhu@gmail.com, Dkvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com
List-Id: linux-efi@vger.kernel.org

Tyler Baicar <tbaicar@codeaurora.org> writes:

> ARM APEI extension proposal added SEA (Synchrounous External
> Abort) notification type for ARMv8.
> Add a new GHES error source handling function for SEA. If an error
> source's notification type is SEA, then this function can be registered
> into the SEA exception handler. That way GHES will parse and report
> SEA exceptions when they occur.
>
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>

This patch fails to apply for me on v4.8. Is there a different tree this
is based on?

One comment below.

[...]

> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index c8488f1..28d5a09 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -50,6 +50,10 @@
>  #include <acpi/apei.h>
>  #include <asm/tlbflush.h>
>  
> +#ifdef CONFIG_HAVE_ACPI_APEI_SEA
> +#include <asm/system_misc.h>
> +#endif
> +
>  #include "apei-internal.h"
>  
>  #define GHES_PFX	"GHES: "
> @@ -779,6 +783,62 @@ static struct notifier_block ghes_notifier_sci = {
>  	.notifier_call = ghes_notify_sci,
>  };
>  
> +#ifdef CONFIG_HAVE_ACPI_APEI_SEA
> +static LIST_HEAD(ghes_sea);
> +
> +static int ghes_notify_sea(struct notifier_block *this,
> +				  unsigned long event, void *data)
> +{
> +	struct ghes *ghes;
> +	int ret = NOTIFY_DONE;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
> +		if (!ghes_proc(ghes))
> +			ret = NOTIFY_OK;

Not something you've introduced but it looks like ghes_proc erroneously
never returns anything other than 0. I plan to post the below fix to
address it.

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 60746ef..caea575 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -662,7 +662,7 @@ static int ghes_proc(struct ghes *ghes)
        ghes_do_proc(ghes, ghes->estatus);
 out:
        ghes_clear_estatus(ghes);
-   return 0;
+ return rc;
 }

> +	}
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +

[...]
