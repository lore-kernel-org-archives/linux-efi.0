From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH] x86, efi: remove attribute check from setup_efi_pci
Date: Tue, 29 Jan 2013 17:54:53 +0000
Message-ID: <1359482093.8282.94.camel@mfleming-mobl1.ger.corp.intel.com>
References: <5107FE48.7080402@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5107FE48.7080402@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-01-29 at 17:52 +0100, Maarten Lankhorst wrote:
> It looks like the original commit that copied the rom contents from efi always copied
> the rom, and the fixup in setup_efi_pci from commit 886d751a2ea99a160
> ("x86, efi: correct precedence of operators in setup_efi_pci") broke that.
> 
> This resulted in macbook pro's no longer finding the rom images, and thus not being able to use the radeon card any more.
> 
> The solution is to just remove the check for now, and always copy the rom if available.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Applied, thanks!
