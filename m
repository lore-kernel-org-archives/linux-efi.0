From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH V7 04/10] arm64: exception: handle Synchronous External
 Abort
Date: Tue, 17 Jan 2017 10:27:53 +0000
Message-ID: <20170117102753.GA27328@arm.com>
References: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org>
 <1484244924-24786-5-git-send-email-tbaicar@codeaurora.org>
 <20170116115309.GE1510@arm.com>
 <0ca6c70e-6033-4cca-8833-15cb8573a939@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <0ca6c70e-6033-4cca-8833-15cb8573a939@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Baicar, Tyler" <tbaicar@codeaurora.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 16, 2017 at 01:09:22PM -0700, Baicar, Tyler wrote:
> On 1/16/2017 4:53 AM, Will Deacon wrote:
> >On Thu, Jan 12, 2017 at 11:15:18AM -0700, Tyler Baicar wrote:
> >>SEA exceptions are often caused by an uncorrected hardware
> >>error, and are handled when data abort and instruction abort
> >>exception classes have specific values for their Fault Status
> >>Code.
> >>When SEA occurs, before killing the process, go through
> >>the handlers registered in the notification list.
> >>Update fault_info[] with specific SEA faults so that the
> >>new SEA handler is used.
> >>
> >>Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> >>Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> >>Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
> >>---
> >>  arch/arm64/include/asm/system_misc.h | 13 ++++++++
> >>  arch/arm64/mm/fault.c                | 58 +++++++++++++++++++++++++++++-------
> >>  2 files changed, 61 insertions(+), 10 deletions(-)
> >>
> >>diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
> >>index 57f110b..e7f3440 100644
> >>--- a/arch/arm64/include/asm/system_misc.h
> >>+++ b/arch/arm64/include/asm/system_misc.h
> >>@@ -64,4 +64,17 @@ extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
> >>  #endif	/* __ASSEMBLY__ */
> >>+/*
> >>+ * The functions below are used to register and unregister callbacks
> >>+ * that are to be invoked when a Synchronous External Abort (SEA)
> >>+ * occurs. An SEA is raised by certain fault status codes that have
> >>+ * either data or instruction abort as the exception class, and
> >>+ * callbacks may be registered to parse or handle such hardware errors.
> >>+ *
> >>+ * Registered callbacks are run in an interrupt/atomic context. They
> >>+ * are not allowed to block or sleep.
> >>+ */
> >>+int register_sea_notifier(struct notifier_block *nb);
> >>+void unregister_sea_notifier(struct notifier_block *nb);
> >I still don't understand why you need notifiers for this. You register
> >precisely one hook in the series.
> I didn't see a response to my last comment on the previous series so I just
> left it in for this series.
> The notifier usage is consistent with the GHES code for SCI errors which are
> also only used a single
> time in the code. If you think making the call directly is a better option I
> will remove the notifiers.

Yes, please. It's easy to add the notifier infrastructure back if/when it's
actually needed and I don't see why the low-level fault dispatching needs to
be consistent with the GHES/SCI code.

Will
