From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] efi/capsule: Make efi_capsule_pending() lockless
Date: Thu, 5 May 2016 15:36:43 +0100
Message-ID: <20160505143643.GN2839@codeblueprint.co.uk>
References: <1462054407-9735-1-git-send-email-matt@codeblueprint.co.uk>
 <20160503090229.GC27540@pd.tnic>
 <20160503141201.GW2839@codeblueprint.co.uk>
 <20160504093031.GA4074@pd.tnic>
 <20160504114605.GH2839@codeblueprint.co.uk>
 <20160504122042.GB4074@pd.tnic>
 <20160504143531.GK2839@codeblueprint.co.uk>
 <F54AEECA5E2B9541821D670476DAE19C4A914755@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A914755@PGSMSX102.gar.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Bryan O'Donoghue <pure.logic@nexus-software.ie>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, joeyli <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, "Ong, Kean Chai" <kean.chai.ong@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 05 May, at 02:27:16PM, Kweh, Hock Leong wrote:
> 
> If not mistaken, the EFI firmware will not update a partially uploaded binary due to checksum error.
> User is required to re-update the efi capsule again on the next boot up.

Ah, so the capsule is only processed by the firmware after rebooting?
That makes sense and alleviates my concerns about rebooting while in
the middle of efi_capsule_update().

Thanks Wilson!
