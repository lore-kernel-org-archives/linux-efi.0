From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH v2] fix setup_efi_pci()
Date: Fri, 25 Jan 2013 15:25:38 +0000
Message-ID: <20130125152538.GA30685@srcf.ucam.org>
References: <50F94F9202000078000B74EE@nat28.tlf.novell.com>
 <1359051621.2496.95.camel@mfleming-mobl1.ger.corp.intel.com>
 <5102452202000078000B9755@nat28.tlf.novell.com>
 <1359103537.2496.132.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1359103537.2496.132.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 25, 2013 at 08:45:37AM +0000, Matt Fleming wrote:

> Matthew, what guarantees do we have that the memory we've allocated for
> the PCI ROMs isn't going to be reused? I suspect what's needed is for
> parse_setup_data() to reserve the SETUP_PCI regions, just like you would
> for any other key data structure.

Yeah, I think that originally I had a copy and then failed to update 
this to handle just re-using the original allocation.

> It's the kernel's responsibility to protect any EFI_LOADER_DATA regions
> that it needs, we shouldn't have to trick ourselves by using the
> EFI_RUNTIME_SERVICES_DATA pool for allocations.

I guess the concern is that non-EFI systems may end up passing 
SETUP_PCI? EFI_RUNTIME_DATA would solve one case without handling that, 
so doing it in the data parsing code probably does make sense.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
