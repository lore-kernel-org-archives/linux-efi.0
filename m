From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v5 01/17] Xen: ACPI: Hide UART used by Xen
Date: Fri, 4 Mar 2016 16:28:10 +0000
Message-ID: <alpine.DEB.2.02.1603041615200.17938@kaball.uk.xensource.com>
References: <1457073455-11516-1-git-send-email-zhaoshenglong@huawei.com>
 <1457073455-11516-2-git-send-email-zhaoshenglong@huawei.com>
 <alpine.DEB.2.02.1603041213400.17938@kaball.uk.xensource.com>
 <56D9B043.1090301@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <56D9B043.1090301@linaro.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Shannon Zhao <shannon.zhao@linaro.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Shannon Zhao <zhaoshenglong@huawei.com>, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, hangaohuai@huawei.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 4 Mar 2016, Shannon Zhao wrote:
> On 2016/3/4 20:24, Stefano Stabellini wrote:
> > On Fri, 4 Mar 2016, Shannon Zhao wrote:
> > > >From: Shannon Zhao<shannon.zhao@linaro.org>
> > > >
> > > >ACPI 6.0 introduces a new table STAO to list the devices which are used
> > > >by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
> > > >UART is used by Xen. So here it hides UART from Dom0.
> > > >
> > > >Signed-off-by: Shannon Zhao<shannon.zhao@linaro.org>
> > > >---
> > > >CC: "Rafael J. Wysocki"<rjw@rjwysocki.net>  (supporter:ACPI)
> > > >CC: Len Brown<lenb@kernel.org>  (supporter:ACPI)
> > > >CC:linux-acpi@vger.kernel.org  (open list:ACPI)
> > > >---
> > > >  drivers/acpi/scan.c | 68
> > > +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 68 insertions(+)
> > > >
> > > >diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > > >index 407a376..31d794c 100644
> > > >--- a/drivers/acpi/scan.c
> > > >+++ b/drivers/acpi/scan.c
> > > >@@ -45,6 +45,7 @@ static LIST_HEAD(acpi_scan_handlers_list);
> > > >  DEFINE_MUTEX(acpi_device_lock);
> > > >  LIST_HEAD(acpi_wakeup_device_list);
> > > >  static DEFINE_MUTEX(acpi_hp_context_lock);
> > > >+static u64 spcr_uart_addr;
> > > >
> > > >  struct acpi_dep_data {
> > > >  	struct list_head node;
> > > >@@ -1453,6 +1454,47 @@ static int acpi_add_single_object(struct
> > > acpi_device **child,
> > > >  	return 0;
> > > >  }
> > > >
> > > >+static acpi_status acpi_get_resource_fixed_memory32(struct acpi_resource
> > > *res,
> > > >+						    void *context)
> > > >+{
> > > >+	struct acpi_resource_fixed_memory32 *fixed_memory32;
> > > >+
> > > >+	if (res->type != ACPI_RESOURCE_TYPE_FIXED_MEMORY32)
> > > >+		return AE_OK;
> > > >+
> > > >+	fixed_memory32 = &res->data.fixed_memory32;
> > Should we call acpi_resource_to_address64 instead?
> > Aside from this the rest looks good.
> > 
> You mean the resource type could be other types? like
> ACPI_RESOURCE_TYPE_ADDRESS64 or ACPI_RESOURCE_TYPE_ADDRESS32? So it needs to
> convert them to ACPI_RESOURCE_TYPE_ADDRESS64 firstly?

I meant to ask whether we need to check for other types of resources, in
addition to ACPI_RESOURCE_TYPE_FIXED_MEMORY32.  So maybe call an
existing function that already does the check for us.
acpi_dev_resource_memory is actually what I meant to suggest.
