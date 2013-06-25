From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 3/4] arm: Add [U]EFI runtime services support
Date: Tue, 25 Jun 2013 19:20:21 +0100
Message-ID: <20130625182021.GA29955@srcf.ucam.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-4-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1372183863-11333-4-git-send-email-leif.lindholm@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, hpa@linux.intel.com, tglx@linutronix.de, matt.fleming@intel.com
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 25, 2013 at 07:11:02PM +0100, Leif Lindholm wrote:
> This patch implements basic support for UEFI runtime services in the
> ARM architecture - a requirement for using efibootmgr to read and update
> the system boot configuration.
> 
> It also locates any presented SMBIOS configuration table and stores it
> for potential later use by DMI.

This appears to duplicate code that's already duplicated between x86 and 
ia64. We made a mistake there originally - let's not do it again. Having 
this code in three places is inevitably going to lead to skew and missed 
bugfixes.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
