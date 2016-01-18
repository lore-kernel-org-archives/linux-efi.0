From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 16/16] ARM64: XEN: Initialize Xen specific UEFI
 runtime services
Date: Mon, 18 Jan 2016 18:27:48 +0000
Message-ID: <20160118182747.GR21067@leverpostej>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-17-git-send-email-zhaoshenglong@huawei.com>
 <20160118110854.GG21067@leverpostej>
 <alpine.DEB.2.02.1601181736090.9400@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1601181736090.9400-7Z66fg9igcxYtxbxJUhB2Dgeux46jI+i@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Cc: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Jan Beulich <JBeulich-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>, Ian Campbell <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 18, 2016 at 05:45:24PM +0000, Stefano Stabellini wrote:
> On Mon, 18 Jan 2016, Mark Rutland wrote:
> > On Fri, Jan 15, 2016 at 02:55:29PM +0800, Shannon Zhao wrote:
> > > +void __init xen_efi_runtime_setup(void)
> > > +{
> > > +	efi.get_time                 = xen_efi_get_time;
> > > +	efi.set_time                 = xen_efi_set_time;
> > > +	efi.get_wakeup_time          = xen_efi_get_wakeup_time;
> > > +	efi.set_wakeup_time          = xen_efi_set_wakeup_time;
> > > +	efi.get_variable             = xen_efi_get_variable;
> > > +	efi.get_next_variable        = xen_efi_get_next_variable;
> > > +	efi.set_variable             = xen_efi_set_variable;
> > > +	efi.query_variable_info      = xen_efi_query_variable_info;
> > > +	efi.update_capsule           = xen_efi_update_capsule;
> > > +	efi.query_capsule_caps       = xen_efi_query_capsule_caps;
> > > +	efi.get_next_high_mono_count = xen_efi_get_next_high_mono_count;
> > > +	efi.reset_system             = NULL;
> > > +}
> > 
> > How do capsules work in the absence of an EFI system reset?
> 
> Actually I don't think that capsules are available in Xen on ARM64 yet,
> see "TODO - disabled until implemented on ARM" in
> xen/common/efi/runtime.c.
> 
> FYI system reset is available, but it is provided via a different
> mechanism (HYPERVISOR_sched_op(xen_restart...)

Will that trigger Xen to do the right thing to trigger capsule updates
when implemented in Xen? Or do we need a xen_efi_reset_system?

Does that override PSCI?

In machine_restart we try efi_reboot first specifically to allow for
capsule updates. Similarly drivers/firmware/efi/reboot.c registers
efi_power_off late in order to override anything else, though that's
best-effort at present.

Thanks,
Mark.
