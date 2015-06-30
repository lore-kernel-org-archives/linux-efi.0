From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi-bgrt: Switch pr_err() to pr_debug() for invalid
 BGRT
Date: Tue, 30 Jun 2015 11:00:46 +0100
Message-ID: <20150630100046.GI28334@codeblueprint.co.uk>
References: <1435579602-6612-1-git-send-email-matt@codeblueprint.co.uk>
 <CAGnHSEnO9BiCTgSOCJnJiwycpSMKtQzeYb1+S-2Cq7U_Xy+H1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGnHSEnO9BiCTgSOCJnJiwycpSMKtQzeYb1+S-2Cq7U_Xy+H1w@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Tue, 30 Jun, at 05:52:43AM, Tom Yan wrote:
> Hi Matt!
> 
> The patch works for me against linux 4.0.6. I no longer see the
> message in dmesg with the BIOS option set to "Auto". I assume this is
> expected? It will only be displayed if I build it with a debug flag,
> right?
> https://www.kernel.org/doc/local/pr_debug.txt

Right, that is the expected outcome but it's always good to check that I
didn't somehow goof up the patch.

Thanks for testing!

-- 
Matt Fleming, Intel Open Source Technology Center
