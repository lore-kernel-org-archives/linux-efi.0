From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH V1 6/6] acpi: apei: handle SEA notification type for ARMv8
Date: Fri, 12 Feb 2016 09:51:44 +0000
Message-ID: <20160212095143.GC25087@arm.com>
References: <1454699608-22760-1-git-send-email-tbaicar@codeaurora.org>
 <1454699608-22760-7-git-send-email-tbaicar@codeaurora.org>
 <20160210180332.GU1052@arm.com>
 <56BD0D43.4060901@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56BD0D43.4060901@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: "Baicar, Tyler" <tbaicar@codeaurora.org>
Cc: fu.wei@linaro.org, timur@codeaurora.org, harba@codeaurora.org, rruigrok@codeaurora.org, ahs3@redhat.com, Catalin Marinas <catalin.marinas@arm.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, Naveen Kaje <nkaje@codeaurora.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 11, 2016 at 03:37:55PM -0700, Baicar, Tyler wrote:
> On 2/10/2016 11:03 AM, Will Deacon wrote:
> >On Fri, Feb 05, 2016 at 12:13:28PM -0700, Tyler Baicar wrote:
> >>diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> >>index 6c68100..ed64b97 100644
> >>--- a/drivers/acpi/apei/ghes.c
> >>+++ b/drivers/acpi/apei/ghes.c
> >>@@ -50,6 +50,10 @@
> >>  #include <acpi/apei.h>
> >>  #include <asm/tlbflush.h>
> >>+#ifdef CONFIG_HAVE_ACPI_APEI_SEA
> >>+#include <asm/system_misc.h>
> >>+#endif
> >>+
> >>  #include "apei-internal.h"
> >>  #define GHES_PFX	"GHES: "
> >>@@ -784,6 +788,62 @@ static struct notifier_block ghes_notifier_sci = {
> >>  	.notifier_call = ghes_notify_sci,
> >>  };
> >>+#ifdef CONFIG_HAVE_ACPI_APEI_SEA
> >>+static LIST_HEAD(ghes_sea);
> >>+
> >>+static int ghes_notify_sea(struct notifier_block *this,
> >>+				  unsigned long event, void *data)
> >>+{
> >>+	struct ghes *ghes;
> >>+	int ret = NOTIFY_DONE;
> >>+
> >>+	rcu_read_lock();
> >>+	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
> >>+		if (!ghes_proc(ghes))
> >>+			ret = NOTIFY_OK;
> >>+	}
> >>+	rcu_read_unlock();
> >>+
> >>+	return ret;
> >>+}
> >>+
> >>+static struct notifier_block ghes_notifier_sea = {
> >>+	.notifier_call = ghes_notify_sea,
> >>+};
> >>+
> >>+static int ghes_sea_add(struct ghes *ghes)
> >>+{
> >>+	mutex_lock(&ghes_list_mutex);
> >Can you just use spin_lock, to be consistent with our other excception
> >hooks?
> This mutex is being used throughout ghes.c for editing the lists, so I think
> this is the proper (or at least consistent) implementation. This mutex was
> defined specifically for editing the lists according to the comment above
> the mutex definition:
> 
> "All error sources notified with SCI shares one notifier function, so they
> need to be linked and checked one by one. This is applied to NMI too. RCU is
> used for these lists, so ghes_list_mutex is only used for list changing, not
> for traversing."
> 
> The use of this mutex is identical to the way that SCI and NMI use it when
> adding or deleting from the lists. Should I add to this comment that this
> applies to SEA as well?

No, it's fine. I overlooked the fact that this was under drivers/acpi/,
so if you're consistent with other code under there then there's no need
to change anything.

Will
