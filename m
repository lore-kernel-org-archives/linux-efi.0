From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: Re: [PATCH v7 00/10] xen: Add EFI support
Date: Tue, 1 Jul 2014 15:24:57 +0200
Message-ID: <20140701132457.GQ14729@olila.local.net-space.pl>
References: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
 <53B2B3E6.1080203@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ia64-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53B2B3E6.1080203@citrix.com>
Sender: linux-ia64-owner@vger.kernel.org
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com, eshelton@pobox.com, fenghua.yu@intel.com, hpa@zytor.com, ian.campbell@citrix.com, jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org, stefano.stabellini@eu.citrix.com, tglx@linutronix.de, tony.luck@intel.com
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 01, 2014 at 02:13:10PM +0100, David Vrabel wrote:
> On 30/06/14 18:52, Daniel Kiper wrote:
> > Hey,
> >
> > This patch series adds EFI support for Xen dom0 guests.
> > It is based on Jan Beulich and Tang Liang work. I was
> > trying to take into account all previous comments,
> > however, if I missed something sorry for that.
>
> What's changed in this version?

I have added "arch/ia64: Define early_memunmap()" patch, moved
xen_efi_probe() declaration to include/xen/xen-ops.h as Stefano
asked, added yours Reviewed-by to Xen stuff and did more tests.

Daniel
