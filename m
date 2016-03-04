From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v5 01/17] Xen: ACPI: Hide UART used by Xen
Date: Fri, 04 Mar 2016 23:56:51 +0800
Message-ID: <56D9B043.1090301@linaro.org>
References: <1457073455-11516-1-git-send-email-zhaoshenglong@huawei.com>
 <1457073455-11516-2-git-send-email-zhaoshenglong@huawei.com>
 <alpine.DEB.2.02.1603041213400.17938@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <alpine.DEB.2.02.1603041213400.17938@kaball.uk.xensource.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, hangaohuai@huawei.com, linux-efi@vger.kernel.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, ACPI <linux-acpi@vger.kernel.org>, stefano.stabellini@citrix.com, david.vrabel@citrix.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: linux-efi@vger.kernel.org



On 2016/3/4 20:24, Stefano Stabellini wrote:
> On Fri, 4 Mar 2016, Shannon Zhao wrote:
>> >From: Shannon Zhao<shannon.zhao@linaro.org>
>> >
>> >ACPI 6.0 introduces a new table STAO to list the devices which are used
>> >by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
>> >UART is used by Xen. So here it hides UART from Dom0.
>> >
>> >Signed-off-by: Shannon Zhao<shannon.zhao@linaro.org>
>> >---
>> >CC: "Rafael J. Wysocki"<rjw@rjwysocki.net>  (supporter:ACPI)
>> >CC: Len Brown<lenb@kernel.org>  (supporter:ACPI)
>> >CC:linux-acpi@vger.kernel.org  (open list:ACPI)
>> >---
>> >  drivers/acpi/scan.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 68 insertions(+)
>> >
>> >diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
>> >index 407a376..31d794c 100644
>> >--- a/drivers/acpi/scan.c
>> >+++ b/drivers/acpi/scan.c
>> >@@ -45,6 +45,7 @@ static LIST_HEAD(acpi_scan_handlers_list);
>> >  DEFINE_MUTEX(acpi_device_lock);
>> >  LIST_HEAD(acpi_wakeup_device_list);
>> >  static DEFINE_MUTEX(acpi_hp_context_lock);
>> >+static u64 spcr_uart_addr;
>> >
>> >  struct acpi_dep_data {
>> >  	struct list_head node;
>> >@@ -1453,6 +1454,47 @@ static int acpi_add_single_object(struct acpi_device **child,
>> >  	return 0;
>> >  }
>> >
>> >+static acpi_status acpi_get_resource_fixed_memory32(struct acpi_resource *res,
>> >+						    void *context)
>> >+{
>> >+	struct acpi_resource_fixed_memory32 *fixed_memory32;
>> >+
>> >+	if (res->type != ACPI_RESOURCE_TYPE_FIXED_MEMORY32)
>> >+		return AE_OK;
>> >+
>> >+	fixed_memory32 = &res->data.fixed_memory32;
> Should we call acpi_resource_to_address64 instead?
> Aside from this the rest looks good.
>
You mean the resource type could be other types? like 
ACPI_RESOURCE_TYPE_ADDRESS64 or ACPI_RESOURCE_TYPE_ADDRESS32? So it 
needs to convert them to ACPI_RESOURCE_TYPE_ADDRESS64 firstly?

Thanks,
-- 
Shannon
