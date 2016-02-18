From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/2] ACPICA: Tables: Add function to remove ACPI tables
Date: Thu, 18 Feb 2016 20:41:23 +0000
Message-ID: <20160218204123.GA17042@codeblueprint.co.uk>
References: <1455723910-16710-1-git-send-email-matt@codeblueprint.co.uk>
 <1455723910-16710-2-git-send-email-matt@codeblueprint.co.uk>
 <1AE640813FDE7649BE1B193DEA596E883BB4D2A6@SHSMSX101.ccr.corp.intel.com>
 <CAJZ5v0hAmCKc8Qn7sKQhdGhoAXH=zmXubx295K_Nbm9npOYzBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJZ5v0hAmCKc8Qn7sKQhdGhoAXH=zmXubx295K_Nbm9npOYzBw@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: "Zheng, Lv" <lv.zheng@intel.com>, Dave Young <dyoung@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "kexec@lists.infradead.org" <kexec@lists.infradead.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, Josh Triplett <josh@joshtriplett.org>, Borislav Petkov <bp@alien8.de>, Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 18 Feb, at 09:15:28PM, Rafael J. Wysocki wrote:
> 
> Actually, the reason is that, as a rule, the process for ACPICA
> patches is that they first go to upstream ACPICA and they are acquired
> by Linux from there.
> 
> While there are some exceptions from that process, there also are good
> reasons for that process to be followed, including the licensing one
> mentioned by Lv.
> 
> All that said, Matt, if you agree that the patch can be applied under
> the BSD license, I think we can offer help with converting it to the
> upstream ACPICA coding conventions and applying it there.  Lv, would
> you be able to take care of that?

I don't have any problem with that, but can we hold off on this patch
for now? There's another approach to fixing the BGRT issue with kexec
that's being discussed which would supersede this,

  https://lkml.kernel.org/r/20160218141544.GH2651@codeblueprint.co.uk

Assuming this patch does get picked up again, I'm happy to respin it
against upstream ACPICA, but how do I go about getting dependent
patches merged, PATCH 2/2 in this case?
