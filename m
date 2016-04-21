From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH][v6] ACPI / PM: Introduce efi poweroff for HW-full platforms without _S5
Date: Thu, 21 Apr 2016 02:17:27 +0200
Message-ID: <1562468.HF88ABVP4x@vostro.rjw.lan>
References: <1458607870-22522-1-git-send-email-yu.c.chen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458607870-22522-1-git-send-email-yu.c.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chen Yu <yu.c.chen@intel.com>
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tuesday, March 22, 2016 08:51:10 AM Chen Yu wrote:
> The problem is Linux registers pm_power_off = efi_power_off only if
> we are in hardware reduced mode. Actually, what we also want is to do
> this when ACPI S5 is simply not supported on non-legacy platforms.
> Since some future Intel platforms are HW-full mode where the DSDT
> fails to supply an _S5 object(without SLP_TYP), we should let such
> kind of platform to leverage efi runtime service to poweroff.
> 
> This patch uses efi power off as first choice when S5 is unavailable,
> even if there is a customized poweroff(driver provided, eg).
> Meanwhile, the legacy platforms will not be affected because there is
> no path for them to overwrite the pm_power_off to efi power off.
> 
> Suggested-by: Len Brown <len.brown@intel.com>
> Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
> Signed-off-by: Chen Yu <yu.c.chen@intel.com>

Applied, thanks!
