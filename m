From: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 3/5] xen: Put EFI machinery in place
Date: Tue, 20 May 2014 13:10:16 +0100
Message-ID: <537B4628.7020008@citrix.com>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com> <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com> <537B2494.2080702@citrix.com> <20140520112933.GF3529@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140520112933.GF3529-fJNZiO034lp9pOct4yEdx/3oZC3j2Omk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 20/05/14 12:29, Daniel Kiper wrote:
> 
>>> +	if (!xen_initial_domain() || HYPERVISOR_dom0_op(&op))
>>> +		return NULL;
>>
>> 	if (!xen_initial_domain())
>> 		return NULL;
>>
>> 	if (HYPERVISOR_dom0_op(&op) < 0)
>> 		return NULL;
> 
> What is wrong with my if?

Style.  The function returns -ve on error not a boolean success/fail.

>>> +
>>> +	/* Here we know that Xen runs on EFI platform. */
>>> +
>>> +	efi = efi_xen;
>>> +
>>> +	op.cmd = XENPF_firmware_info;
>>> +	op.u.firmware_info.type = XEN_FW_EFI_INFO;
>>> +	op.u.firmware_info.index = XEN_FW_EFI_VENDOR;
>>> +	info->vendor.bufsz = sizeof(vendor);
>>> +	set_xen_guest_handle(info->vendor.name, vendor);
>>> +
>>> +	if (!HYPERVISOR_dom0_op(&op)) {
>>
>> if (HYPERVISOR_dom0_op(&op) == 0)
> 
> Ditto?

Again, style.

David
