From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] efi/capsule: Make efi_capsule_pending() lockless
Date: Wed, 4 May 2016 15:35:31 +0100
Message-ID: <20160504143531.GK2839@codeblueprint.co.uk>
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
To: Kweh Hock Leong <hock.leong.kweh@intel.com>, Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, joeyli <jlee@suse.com>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

On Wed, 04 May, at 02:20:42PM, Borislav Petkov wrote:
> 
> Blergh.

Wilson, Bryan, what kind of rollback support does the Intel Quark have
if its firmware update is interrupted?

The interruption could be for a number of reasons including power
loss, or the example in this case, rebooting due to panic().
