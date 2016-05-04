From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] efi/capsule: Make efi_capsule_pending() lockless
Date: Wed, 4 May 2016 14:36:56 +0100
Message-ID: <20160504133656.GJ2839@codeblueprint.co.uk>
References: <1462054407-9735-1-git-send-email-matt@codeblueprint.co.uk>
 <20160503090229.GC27540@pd.tnic>
 <20160503141201.GW2839@codeblueprint.co.uk>
 <20160504093031.GA4074@pd.tnic>
 <20160504114605.GH2839@codeblueprint.co.uk>
 <20160504122042.GB4074@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160504122042.GB4074@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kweh Hock Leong <hock.leong.kweh@intel.com>, Bryan O'Donoghue <pure.logic@nexus-software.ie>, joeyli <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 04 May, at 02:20:42PM, Borislav Petkov wrote:
> On Wed, May 04, 2016 at 12:46:05PM +0100, Matt Fleming wrote:
> > But emergency_restart() is called after bust_spinlocks(0) which can
> > reset oops_in_progress, so can't even use that to solve the panic
> > case.
> 
> Blergh.
> 
> So I guess you need an explicit call efi_stop_capsules() somewhere in
> the reboot path and be done with it. No reboot notifiers, no bla bla.
> Just one big hammer which STFU the EFI.

But you can't block in the reboot path and you can't guarantee you'll
interrupt an in-progress EFI capsule update call that started before
you entered the reboot path.
